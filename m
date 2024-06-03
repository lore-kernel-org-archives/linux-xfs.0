Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFE2139597
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440927; cv=none; b=Dr8HabV48/g0y6Ry6lyVYO3MPSlXEAbhZdZrsobosW16iiIuLW9kczjEkOVmZkfD/mFd4R4TxOfcQEMKjO7f6oieBkNzILw8xAM9nEbppFybT5LHaH8NDYn9+Tt4vpuY+gp9fpTdwZC6xKRDALcw1z3ghbc3Cs28w1hRGkVt42I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440927; c=relaxed/simple;
	bh=70tqlQlqRnsxInw1Vq8dqPTdhBytH4OAgTtBKT/QEl0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YpKz0GAzWJQ9ZvAbHFQBzj21Ixn2gkOGTbDbRf45gbkOdddUtHKhIUJ0YCrgBnthV9aBZEDY+/bYhFCPS/w/2LaHtjiz1+nqvDX+K2zCgnoabHFi2JrHBhVAROdJDukJKgHUIL8WEeIb6SPhCaTHNUNlKT2oUjkmr3teB7DG074=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sRbGwjrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sRbGwjrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D10C2BD10;
	Mon,  3 Jun 2024 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440927;
	bh=70tqlQlqRnsxInw1Vq8dqPTdhBytH4OAgTtBKT/QEl0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sRbGwjrrI76iYaKWIpwvTTalvsD02GzEC4JiEYvTfG64OS+lPD59YWaMVWPZKU5yV
	 5UvVsSrl2JsPZGc00RfPnZqgxklh46Evy5gwNj8OIN4Jy73wF/uD6elWOVyL2FThMl
	 OpMpk9pUEGEumIdhJx6eFjKveaxMRbcXaTpBrT7Y8Lhi2co7Hkm9ugxvrNB3qaaHsA
	 9WRYFTaFE6PhuCYYNkStyevcWCEXWwSdGggRGgEviy/rsuHZe2cMbafXlyRxWEgt8A
	 aCEV+yGhsRCMHv0yEwEeQ4Sz90ZwO3Th0gWfi4WFJNfiq/K7mgb1XEjCCsNNiJgdm4
	 sbM0Bh7dxpHeg==
Date: Mon, 03 Jun 2024 11:55:26 -0700
Subject: [PATCH 013/111] xfs: implement live quotacheck inode scan
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039563.1443973.679912623062615258.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 48dd9117a34fe9a34a6be0b1dba5694e0f19cbd4

Create a new trio of scrub functions to check quota counters.  While the
dquots themselves are filesystem metadata and should be checked early,
the dquot counter values are computed from other metadata and are
therefore summary counters.  We don't plug these into the scrub dispatch
just yet, because we still need to be able to watch quota updates while
doing our scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 711e0fc7e..07acbed92 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -710,9 +710,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_GQUOTA	22	/* group quotas */
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
+#define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	25
+#define XFS_SCRUB_TYPE_NR	26
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)

