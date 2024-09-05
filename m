Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1EC14F125
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560540; cv=none; b=lvUzNNF2qjrDe2sHbR0l2qK1Ai9VpKUqiTpFCz4Z+QFrr6IQFHTyD2TIiGr6841kOZtZC29ckHaTCiCJ1qKm3cz7UzQjlBtF8MNtdTkVvokzkY4sNcwgKQ9qIC/4oFC/DQ6U0sqoXQfRb9Mf/XsNmFdTj9MLeg6BfzQwtBmsuP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560540; c=relaxed/simple;
	bh=PPNdc3z3NqwEjYCLYKW/QfYOgzNgiCuta5kiBo65KeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJ2icomH4ZdmtoAd4lohHpRibd3iFADbRPVuulCqFwf44/LVaMQK0QjvvWIjdQYjv4aCC8IpCgFslUQEs4lTnw2Cthx60WP6EFMeRlrtJ/d8On3dxYwHBTu4uGy98p/CUDYTBmKSfJLY6cUQ9/5seeMVqwcScsXsaRFWFmqT5Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LXaMdfzC; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LXaMdfzC"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71434174201so866237b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560538; x=1726165338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0L1twsXbiKjyUC98PoGnv6lrlvreY6QLXRsV9mKZ4U=;
        b=LXaMdfzCWPEjt6Sk9VYlxlZLhKEAXdGVYG6fVuJe0f1jZda9KFSohhZBw+Ej46yqsh
         DCURihDq3lTjkQ9oMyY3jg3lkjYvEvhxx/jHT69/wBBNlO3y3yVCdCN7m5upvkWEyrxU
         zedTGOr1Y71w/FRkY2zMJgOuyrI7K/BsgbUEhJ8TIpFc+3AnlgVlp7HxlrUugg0kmvFD
         4YYFdEbNESTBAFa/UwOBX2upo8728hVG8PslN1m9NcpEgTSbnk3YHQwMZ/YYo+CKN4Eu
         Uf2OCoQuonJhfEizdaOKpYBtVEa6ry5gWwp6qRFX8xWRKZkUfyCRreatVMncsH0KG5Vb
         n+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560538; x=1726165338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X0L1twsXbiKjyUC98PoGnv6lrlvreY6QLXRsV9mKZ4U=;
        b=xI4Mout2ihGjLd0k7ROHPtPrOA2fcs2teL0bqjwb2N26cm3Md8aOiZDd4du9V7PX/c
         emsIsD+32ZWjRZVygr1kk6DH5m1sLcrqCsx6MLX4ToWC1uknyU6tFZwvUz3ZomS3Ewaf
         PQmeLHQ6TPziAdQee9FqPqnQyg8tNsupkQGgFL1V1aEjl3ShFJQGQdKM2YI9pWmS9Lyh
         hyGjMDoTwA54kB8kPAScnlWLj8S1ofbtbZfsl8AZ5Rxo0M6TYPii8guCu8tOaWhUZTuL
         nGnDkwbQTMd4in39opoN4FiPO8EmwdAobDsDlYp3ChwVDNwh1zp8JeuTyvvlYeFq5vlt
         XuQw==
X-Gm-Message-State: AOJu0YzJpI3otvAxf1rBVSHi/95OF0yUCv2NWjqP6WwltKe+GiOdVXK8
	gPfuPyZFk/KxyXBUxwFtOT8Tn2lEeQcj6V+Z+UXe0WcZbKyawLytSCeXVv3t
X-Google-Smtp-Source: AGHT+IHNsr7Io7SKqY0PAnRH284SxCVtjzf8mH5VCvkupsFQz5VEKWU8Qhe/2X96sTGcWmKxNemKCQ==
X-Received: by 2002:a17:903:1cf:b0:1fd:8eaf:ea73 with SMTP id d9443c01a7336-20546705a4fmr212233295ad.35.1725560538098;
        Thu, 05 Sep 2024 11:22:18 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:22:17 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 26/26] xfs: set bnobt/cntbt numrecs correctly when formatting new AGs
Date: Thu,  5 Sep 2024 11:21:43 -0700
Message-ID: <20240905182144.2691920-27-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
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

# mkfs.xfs -d size=512M /dev/sda -f -d su=128k,sw=4 --unsupported
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
# xfs_repair -n /dev/sda
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
2.46.0.598.g6f2099f65c-goog

