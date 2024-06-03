Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34B31386D8
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440958; cv=none; b=PdYlyjqY2mtFGJUt5KGyYIY41erDmCwpRMceo2jLP6A1kGf0GorgtphflqNCHFe9meD6ptOrC5K//PIiaRLyE91vUpdbByPuxfo8MB/WlO/Zv00ARlVj3+7pcqnh/iQN6oU+31/IjYqR7Fa64K5LlMeNy+GrbE4vUaZG5ykM/+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440958; c=relaxed/simple;
	bh=wdOdwusWdTtBQqUlnMyLhe0QCZEihyxe+axQOi/rfNE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BnIIj4AdlAN3iRGWWxKWuo0ntISpvyrlWC0N9zyEkAQPs7gmuf0/QTcJiM4Y0juzKfhXtrhSV4Z7YkFcH2hN95Jfq5gnp/USg1xIqxJzevEeXjr2ulK000zyYs/Wk/dP0njVtI2/O6k3cfEq4j5BygBb+LVaKz6VSvyXjfblOv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kerdEilR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kerdEilR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDAAC2BD10;
	Mon,  3 Jun 2024 18:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440958;
	bh=wdOdwusWdTtBQqUlnMyLhe0QCZEihyxe+axQOi/rfNE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kerdEilReB8GpZKADosU753ZouPqEPTFuj+rP7WkwM3FJ5yNtcaVUPWS+IrbUC5aV
	 p9fu0G7e/lXoRx3c28Vy9c8rxguEN9Di8WQv/QMPoX0HXesTUvj1thZzD0gS2y5f6j
	 lTJ4j/T4WuvX8PiY1+lZAsxZ3+Yc6mIM+EjnorssjPZ5TpnrAiccKXxhWfPNAyJqqs
	 WQXLJZD5DNFo+C/ZhSru5zcKLsgDqkkVG5cigzZP+4+Q+iPgTGO8toUNGTbl1OI7h2
	 MWxfMyEm95UU7ew4WD2gTujtTXWxONpgCiGJl1T12wQ4NF6DGTiy60C9YaGiH6PhCS
	 iZRgHCo3ul7Zg==
Date: Mon, 03 Jun 2024 11:55:57 -0700
Subject: [PATCH 015/111] xfs: teach scrub to check file nlinks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039593.1443973.3385702264293426629.stgit@frogsfrogsfrogs>
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

Source kernel commit: f1184081ac97625d30c59851944f4c59ae7ddc2b

Create the necessary scrub code to walk the filesystem's directory tree
so that we can compute file link counts.  Similar to quotacheck, we
create an incore shadow array of link count information and then we walk
the filesystem a second time to compare the link counts.  We need live
updates to keep the information up to date during the lengthy scan, so
this scrubber remains disabled until the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index f10d0aa0e..515cd27d3 100644
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

