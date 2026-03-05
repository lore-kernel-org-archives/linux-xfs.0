Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFFB2AD16
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 04:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772684781; cv=none; b=fNW1ZYen5qp9Fc1U772WpVqjleac11IKzQI6Qp+VijPXqaXlUKvex0PIrHdLQuddaXfdbAk4CFdm4c+L9Zw7J8+b5D6N5n6RrRhKLnlENsnMvaXCTcPBk1DQq/Fpc3OuAl2ianYxwJGhFL9fSIluflGMx5k/mMBMXf+e3eX6iWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772684781; c=relaxed/simple;
	bh=ouwTk/OMkXFP4MOACwtDgyEyOY+u3Fd9bPQ41bDZYic=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XU1QWwpFxXbjVcwNiY+UEXk/X5tDYWwOathj1/cnoxsoL4aCWX7MgfpkqZ97jrFoQJnTO28Wrdl/wLcp67OmejWkzEZB6BDPjbuL/c5CyfdU89/cmdP/91w//kldn+RTqEg7vvVPrfzb8m3Zy7We6W+ndB11zjYd4Z17L7y4Wp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WCHKuP0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WCHKuP0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E193C116C6;
	Thu,  5 Mar 2026 04:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772684781;
	bh=ouwTk/OMkXFP4MOACwtDgyEyOY+u3Fd9bPQ41bDZYic=;
	h=Date:From:To:Cc:Subject:From;
	b=WCHKuP0LZwW9P5rXMTUoPcibdh8lP3glHncW7QWYeIJedBKdu+J72yO0dJj6vWqcm
	 Y9x8uvGtEfvb4zFI01vA5BWC0h4/kr4bamhoMulU3e2Yj8NS7uhX4RYLVm6E0UbWST
	 0vQBhphGEhH1SL7i3ysWp5iSycjCgf3LCJU+vE6QEqTDNzESIcNpWvIHGd7hnT6OQj
	 G2MtwR+TR39prTukvrot/kARmT3DOt2x8CeWRrRNIJF+AjMrC1YcJrSih/Ox7GIEfD
	 ECI23CTuHXXV1JXpr9id/KHNz/q4iHLe6o5HpQ51WkqRJC5SdT0eaSLAUKKVBqVGqo
	 bFjojYDEEwx6Q==
Date: Wed, 4 Mar 2026 20:26:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix undersized l_iclog_roundoff values
Message-ID: <20260305042620.GC57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

If the superblock doesn't list a log stripe unit, we set the incore log
roundoff value to 512.  This leads to corrupt logs and unmountable
filesystems in generic/617 on a disk with 4k physical sectors...

XFS (sda1): Mounting V5 Filesystem ff3121ca-26e6-4b77-b742-aaff9a449e1c
XFS (sda1): Torn write (CRC failure) detected at log block 0x318e. Truncating head block from 0x3197.
XFS (sda1): failed to locate log tail
XFS (sda1): log mount/recovery failed: error -74
XFS (sda1): log mount failed
XFS (sda1): Mounting V5 Filesystem ff3121ca-26e6-4b77-b742-aaff9a449e1c
XFS (sda1): Ending clean mount

...on the current xfsprogs for-next which has a broken mkfs.  xfs_info
shows this...

meta-data=/dev/sda1              isize=512    agcount=4, agsize=644992 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=1
data     =                       bsize=4096   blocks=2579968, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=4096  sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=268435456 extents
         =                       zoned=0      start=0 reserved=0

...observe that the log section has sectsz=4096 sunit=0, which means
that the roundoff factor is 512, not 4096 as you'd expect.  We should
fix mkfs not to generate broken filesystems, but anyone can fuzz the
ondisk superblock so we should be more cautious.  I think the inadequate
logic predates commit a6a65fef5ef8d0, but that's clearly going to
require a different backport.

Cc: <stable@vger.kernel.org> # v5.14
Fixes: a6a65fef5ef8d0 ("xfs: log stripe roundoff is a property of the log")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b96f262ba1391e..f807f8f4f70584 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1357,6 +1357,8 @@ xlog_alloc_log(
 
 	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
 		log->l_iclog_roundoff = mp->m_sb.sb_logsunit;
+	else if (mp->m_sb.sb_logsectsize > 0)
+		log->l_iclog_roundoff = mp->m_sb.sb_logsectsize;
 	else
 		log->l_iclog_roundoff = BBSIZE;
 
