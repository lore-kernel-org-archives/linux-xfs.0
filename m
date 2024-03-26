Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDB1128381
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423940; cv=none; b=uoyw5ulXiTPKq8v0Ds/Mopb+yX4dAM4P7M6G2mUZz6Nulr/L8fttUx92XCK4PWZ8FbFrOxjFqvQpcHTP9COHGJopY2co5iX1cxbyQZQIfRKIzlZ/f6TB5MmAncw8EbLoiEs/SKXcsmhJZOtqeMMMuUvJsHgIvve2HM2lFjPSLSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423940; c=relaxed/simple;
	bh=nuvRIscnyK27VWFtijzblRj4MHEcBPtGuk1VAf95ndg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nn/M5xEu+OHVVClrkqzW86iiTi/w4HQvrl+IaFOTl+FDLyg4FtnZIdrmf1AxkUUKQMn1ygVxWYRiIuDRVYSeCW/fMpG+WqcpcKbab8IeYXuWJ1iP5YxUkIZs14ay0FesCLqSafMyrtp0JoVR+ppPTR05z88REIzlMcmgTbyKgx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oJFjSdot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJFjSdot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2A2C433C7;
	Tue, 26 Mar 2024 03:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423939;
	bh=nuvRIscnyK27VWFtijzblRj4MHEcBPtGuk1VAf95ndg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oJFjSdotPqaEshbrYAEdtGBL9tE5ZjYwzjlVYXhP9XpnvF9WfhunIVqaKwDApvOKR
	 T6G/HqlFZbwCY6PcTUUyJUafb3a6ToQmLryeIW6VhkJWbhuuNf8Dwy2Dv87A1eCBzx
	 wIxxJgvt7uLAGP0RXTumfoJpQ6Dy/fK5N/KsKVZG0ZFXT4iOPE+A5H+DgL0bP42iqo
	 3D7ttjen4vXn8mikTEnQQl5GKKVNJFHYCE23Xh/oymo08L9viNZxHEDRCUE+hU4TsY
	 ku51C+A0QwDCpQq4HD0Na/8SNbZQSyfCmg38ouIyxwfooF2jUY7hTeew1f0GhjO9q9
	 NxJRXfFaODupQ==
Date: Mon, 25 Mar 2024 20:32:19 -0700
Subject: [PATCH 015/110] xfs: teach scrub to check file nlinks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131601.2215168.4141115305099543134.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: f1184081ac97625d30c59851944f4c59ae7ddc2b

Create the necessary scrub code to walk the filesystem's directory tree
so that we can compute file link counts.  Similar to quotacheck, we
create an incore shadow array of link count information and then we walk
the filesystem a second time to compare the link counts.  We need live
updates to keep the information up to date during the lengthy scan, so
this scrubber remains disabled until the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index f10d0aa0e337..515cd27d3b3a 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -712,9 +712,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
+#define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	26
+#define XFS_SCRUB_TYPE_NR	27
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)

