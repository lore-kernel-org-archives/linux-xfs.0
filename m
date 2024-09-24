Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645DE1AE85E;
	Tue, 24 Sep 2024 18:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203173; cv=none; b=Q1PZFpFQLCgZRqOMTN+ZZFgswWf6TFWWRAycuKyVRhi99QkftPaa/GNyNvpDG/4Wa/3yCVI0Ad/3NlCz4gwDfCs7ZqioqwCEOWghfg25b+kQKdCyyGLZmWeGjxUfKXf1YtVv34fvOwHbUwighgKR1Ns3GoZMU+IWxw7xJd9cOb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203173; c=relaxed/simple;
	bh=8Ixj3FOqUYJNs/W6ZWsxAuz3Mg1c1IJvpiZ0tJJJOGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvtykTxBg0qezM5GFDnB3gkBrHg1Hy4mRzb/XpBAcBne2LplrFRRSLQJUgHKS+1+DrVhMrfH/6H3Rzf2Ktf4msYDX+jayqj11jfw0opWlwitI82cHM1H+9lFXW1lKXblHqhBGeyyi2MYyXZaKYv/+vCh6e8FBlC84cpdBgVX26k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UU+29lEB; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UU+29lEB"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2d8881850d9so4781419a91.3;
        Tue, 24 Sep 2024 11:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203171; x=1727807971; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nO3YBG5o73Vw2lWjqc0u+EarG5ykEMqbJfL066qNrLI=;
        b=UU+29lEBxb5tmjQV5xUNlAx+jGQx9cfmLmabGzUO5MTwh66VA6t5v96AJGSOE8mUno
         A+uX4FB3QtsCHUhQq03dQOGqtEjVTeMg/cVLLt6Txt74lL8t6i9V5hF7iBHkjFYkHvsP
         ii28nndagNTzqZrd69/yzCqs7uCoQjyOoPl9dCJf6ZzbE3Yq8LBKg46KxXxnD5vhoaaU
         pjpmVjEqJeY+omX7t/SF+55aRmC9gGIoLs/t2XHNs63gvLcm1/vkIEUicZAIfYaEHqbI
         kPPNzEiPFBNNnVcdRj8Tf9MCHpo6bClkq7addxV5Mad6lXIa8jxvKNbfU0xZ75XPxCRM
         aQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203171; x=1727807971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nO3YBG5o73Vw2lWjqc0u+EarG5ykEMqbJfL066qNrLI=;
        b=GX22r7MCjTcUcDKAx5GYn2+Ewrz0J87yqut701wcTP/9SkQEI+uISuWcNmaY2iTMdY
         hhfxjpOzgBgAtJ18dvzfifWBlpyiqRzGrXjhLrAJLcdrExusjRmD8+YXq2Vbvxt+oe82
         Vs1L+wEamV/wpgv8wQxcAGCuBX1JSrIncxJ0gt0c+bgmsX7tGuXGDtPDg+dCKf7g5L7G
         uzHlnQpo+t3fFLB+dIALhXwhjSVHcKY8roL1hX+5Q+nGLlC7+sshF8Q9KPpaPFCgKj3i
         0rRk5F55d8UQ57MjZdcnXj9QGBK/DgCwLA6I9CVjQt0KRikMP9bU8FdZsHlZ4Fnp8XCA
         Jagw==
X-Gm-Message-State: AOJu0YxBYrtmeLXi/1cfHM15kJzlMaKMRe1DH4dp1WMTA7H5KaOVw63Y
	8FvM72oqjAEMSuunG99uLtwoGunrRGf75nLFhy+gLvBG9GsWjdXopY8yk4eF
X-Google-Smtp-Source: AGHT+IEe7ekUuaJs1FtbV7LouEUTTdoCxb5fDVD386fAI8gR3WD/a+5wsFjCHrVkynR7VvvoT3ZRDQ==
X-Received: by 2002:a17:90b:94f:b0:2d8:a373:481e with SMTP id 98e67ed59e1d1-2e06ae8446fmr104388a91.24.1727203171508;
        Tue, 24 Sep 2024 11:39:31 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:31 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 26/26] xfs: set bnobt/cntbt numrecs correctly when formatting new AGs
Date: Tue, 24 Sep 2024 11:38:51 -0700
Message-ID: <20240924183851.1901667-27-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 8e698ee72c4ecbbf18264568eb310875839fd601 ]

Through generic/300, I discovered that mkfs.xfs creates corrupt
filesystems when given these parameters:

Filesystems formatted with --unsupported are not supported!!
meta-data=/dev/sda               isize=512    agcount=8, agsize=16352 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
data     =                       bsize=4096   blocks=130816, imaxpct=25
         =                       sunit=32     swidth=128 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=8192, version=2
         =                       sectsz=512   sunit=32 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 blks
Discarding blocks...Done.
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - 16:30:50: zeroing log - 16320 of 16320 blocks done
        - scan filesystem freespace and inode maps...
agf_freeblks 25, counted 0 in ag 4
sb_fdblocks 8823, counted 8798

The root cause of this problem is the numrecs handling in
xfs_freesp_init_recs, which is used to initialize a new AG.  Prior to
calling the function, we set up the new bnobt block with numrecs == 1
and rely on _freesp_init_recs to format that new record.  If the last
record created has a blockcount of zero, then it sets numrecs = 0.

That last bit isn't correct if the AG contains the log, the start of the
log is not immediately after the initial blocks due to stripe alignment,
and the end of the log is perfectly aligned with the end of the AG.  For
this case, we actually formatted a single bnobt record to handle the
free space before the start of the (stripe aligned) log, and incremented
arec to try to format a second record.  That second record turned out to
be unnecessary, so what we really want is to leave numrecs at 1.

The numrecs handling itself is overly complicated because a different
function sets numrecs == 1.  Change the bnobt creation code to start
with numrecs set to zero and only increment it after successfully
formatting a free space extent into the btree block.

Fixes: f327a00745ff ("xfs: account for log space when formatting new AGs")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index bb0c700afe3c..bf47efe08a58 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -415,10 +415,12 @@ xfs_freesp_init_recs(
 		ASSERT(start >= mp->m_ag_prealloc_blocks);
 		if (start != mp->m_ag_prealloc_blocks) {
 			/*
-			 * Modify first record to pad stripe align of log
+			 * Modify first record to pad stripe align of log and
+			 * bump the record count.
 			 */
 			arec->ar_blockcount = cpu_to_be32(start -
 						mp->m_ag_prealloc_blocks);
+			be16_add_cpu(&block->bb_numrecs, 1);
 			nrec = arec + 1;
 
 			/*
@@ -429,7 +431,6 @@ xfs_freesp_init_recs(
 					be32_to_cpu(arec->ar_startblock) +
 					be32_to_cpu(arec->ar_blockcount));
 			arec = nrec;
-			be16_add_cpu(&block->bb_numrecs, 1);
 		}
 		/*
 		 * Change record start to after the internal log
@@ -438,15 +439,13 @@ xfs_freesp_init_recs(
 	}
 
 	/*
-	 * Calculate the record block count and check for the case where
-	 * the log might have consumed all available space in the AG. If
-	 * so, reset the record count to 0 to avoid exposure of an invalid
-	 * record start block.
+	 * Calculate the block count of this record; if it is nonzero,
+	 * increment the record count.
 	 */
 	arec->ar_blockcount = cpu_to_be32(id->agsize -
 					  be32_to_cpu(arec->ar_startblock));
-	if (!arec->ar_blockcount)
-		block->bb_numrecs = 0;
+	if (arec->ar_blockcount)
+		be16_add_cpu(&block->bb_numrecs, 1);
 }
 
 /*
@@ -458,7 +457,7 @@ xfs_bnoroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, id->agno);
+	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 0, id->agno);
 	xfs_freesp_init_recs(mp, bp, id);
 }
 
@@ -468,7 +467,7 @@ xfs_cntroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 1, id->agno);
+	xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 0, id->agno);
 	xfs_freesp_init_recs(mp, bp, id);
 }
 
-- 
2.46.0.792.g87dc391469-goog

