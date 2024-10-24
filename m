Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEB41547C6
	for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 02:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729738312; cv=none; b=gEanIYC7U0Rrdf79TzVBOpjG9lkyOZsK9Eyoz4UmDHt+pWH1yP4RZUcjIGLsODDyO5oHSl7P2UZkqmDNPjHWgiDz14A4wKuHkLnjmFPflqV6fWwllIxPfvkuqTfx1BRzMGwr2etZPYRmqv2Q7l/YFIdx4MxKPJAd2a3lqrYYONw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729738312; c=relaxed/simple;
	bh=6jq2gU/jN94LmlN4G/Za7a6lZP2o/0dQHBy8nEVt0nM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKFRdjCO/mP+C+epODdPFSQ+CKEqYLTz1eb2FaHIN5UD8r6O9AQvNy4sim87eyfcXvqQ4leMDZvRlIdFwPv5uB1m20/41P7Y88rFCkEzB7YeZENP+YsJD7oV+7SJGFnyh+f+1o+fwxCa72/8M9QvginrDfyj5coxLAh86n9Gf8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=h+vzINAm; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="h+vzINAm"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3e5fa17a79dso298953b6e.1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Oct 2024 19:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729738309; x=1730343109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MFxVxs6IH1+Tc5yC3ZO5VgmG5LseHjOqVxmONJI2gjI=;
        b=h+vzINAmUAQyx/HeVIlpapCD3yG1VQ6gyjC+62pilqBjur7U6MvzihzqGqJZVPi1WO
         RmGSj9t8NwfpWYTZCWDwJ1aohpuPQyLeuo20lpiTKD9/aCd1cj5VRlt7CKh/EQsRg7gV
         r/F93ZujCrewxQia3ZTNm4FFiFYIxudTpNBPCuGFfx5zxj8GyRdz55BJY/r5n58yhFsP
         9yuu7XSVzXf2c8gPln3hS+MmKgqzUVRdr+LQABvZJ9X98jU16f1Ptgk4GQuxooNsddH7
         KVy4n4YGiLBS8eU5LAwIg1RCGrHaoECc1nA6swxD3dPHaMhkPm/Y0lR0NfvvjIfO1lWD
         yd0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729738309; x=1730343109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MFxVxs6IH1+Tc5yC3ZO5VgmG5LseHjOqVxmONJI2gjI=;
        b=khAF09OZw3Jbl40eJ0qXmM88UwGaXnLytl2KDWmYG19ScIYE3KMnC28/148w2XDcCk
         H9y8b3taewQcUV/tUzRsDURx5+w2nNBDqVo4OsQWcB9JDXx20MmCU8B9S7EG6sad/fOF
         GFvRI6gcphJd+J6WDc0RpY+k0ss+MlmX/lXhmevLGWdGTUcUpSte10DLEbhDG7t3tw39
         V3SJ02+xlZ2SgusTPQVebe8Wn5pa/w/ABNLJ2Tkd6yNIde6hbnnKWqVATl/AbFopQbDD
         +Sxnth/cLPlGqJYKDCiKB9TSNywWjcOlHOZTkLhVXmT56d/kT9mYcZbwMP8x0DSI4pKS
         3Lxg==
X-Gm-Message-State: AOJu0YzeVlNPUF97WmS/l6OvoLbfaBcUaiI7sJJqrmIgP0kDMft54zjC
	J6hkwA5jvOZDFTw1nF6jJFnvRIj3fVMpBJqLDPWr05vQ4wABGt7fqi7nGNJakmWpg68wOfutZvY
	A
X-Google-Smtp-Source: AGHT+IF1bjWdl9UYFCEgfmQpILmWpC5lCCX1+/J6URLTrAtRJD7HoNe0uu6XJixd3Sc0sRIvoLeSIw==
X-Received: by 2002:a05:6808:18a9:b0:3e4:d3f6:6c97 with SMTP id 5614622812f47-3e6245c873cmr4410263b6e.46.1729738308603;
        Wed, 23 Oct 2024 19:51:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeabeedaasm7477984a12.94.2024.10.23.19.51.47
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 19:51:48 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1t3nwt-004xNs-2n
	for linux-xfs@vger.kernel.org;
	Thu, 24 Oct 2024 13:51:44 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1t3nwu-0000000H7zY-1L0x
	for linux-xfs@vger.kernel.org;
	Thu, 24 Oct 2024 13:51:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: allow sparse inode records at the end of runt AGs
Date: Thu, 24 Oct 2024 13:51:04 +1100
Message-ID: <20241024025142.4082218-3-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241024025142.4082218-1-david@fromorbit.com>
References: <20241024025142.4082218-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Due to the failure to correctly limit sparse inode chunk allocation
in runt AGs, we now have many production filesystems with sparse
inode chunks allocated across the end of the runt AG. xfs_repair
or a growfs is needed to fix this situation, neither of which are
particularly appealing.

The on disk layout from the metadump shows AG 12 as a runt that is
1031 blocks in length and the last inode chunk allocated on disk at
agino 8192.

$ xfs_db -c "agi 12" -c "p length" -c "p newino"a \
> -c "convert agno 12 agino 8192 agbno" \
> -c "a free_root" -c p /mnt/scratch/t.img
length = 1031
newino = 8192
0x400 (1024)
magic = 0x46494233
level = 0
numrecs = 3
leftsib = null
rightsib = null
bno = 62902208
lsn = 0xb5500001849
uuid = e941c927-8697-4c16-a828-bc98e3878f7d
owner = 12
crc = 0xfe0a5c41 (correct)
recs[1-3] = [startino,holemask,count,freecount,free]
1:[128,0,64,11,0xc1ff00]
2:[256,0,64,3,0xb]
3:[8192,0xff00,32,32,0xffffffffffffffff]

The agbno of the inode chunk is 0x400 (1024), but there are only 7
blocks from there to the end of the AG. No inode cluster should have
been allocated there, but the bug fixed in the previous commit
allowed that. We can see from the finobt record #3 that there is a
sparse inode record at agbno 1024 that is for 32 inodes - 4 blocks
worth of inodes. Hence we have a valid inode cluster from agbno
1024-1027 on disk, and we are trying to allocation inodes from it.

This is due to the sparse inode feature requiring sb->sb_spino_align
being set to the inode cluster size, whilst the sb->sb_inoalignmt is
set to the full chunk size.  The args.max_agbno bug in sparse inode
alignment allows an inode cluster at the start of the irec which is
sb_spino_align aligned and sized, but the remainder of the irec to
be beyond EOAG.

There is actually nothing wrong with having a sparse inode cluster
that ends up overlapping the end of the runt AG - it just means that
attempts to make it non-sparse will fail because there's no
contiguous space available to fill out the chunk. However, we can't
even get that far because xfs_inobt_get_rec() will validate the
irec->ir_startino and xfs_verify_agino() will fail on an irec that
spans beyond the end of the AG:

XFS (loop0): finobt record corruption in AG 12 detected at xfs_inobt_check_irec+0x44/0xb0!
XFS (loop0): start inode 0x2000, count 0x20, free 0x20 freemask 0xffffffffffffffff, holemask 0xff00

Hence the actual maximum agino we could allocate is the size of the
AG rounded down by the size of of an inode cluster, not the size of
a full inode chunk. Modify __xfs_agino_range() code to take this
sparse inode case into account and hence allow us of the already
allocated sparse inode chunk at the end of a runt AG.

That change, alone, however, is not sufficient, as
xfs_inobt_get_rec() hard codes the maximum inode number in the chunk
and attempts to verify the last inode number in the chunk.  This
fails because the of the sparse inode record is beyond the end of
the AG. Hence we have to look at the hole mask in the sparse inode
record to determine where the highest allocated inode is. We then
use the calculated high inode number to determine if the allocated
sparse inode cluster fits within the AG.

With this, inode allocation on a sparse inode cluster at the end
of a runt AG now succeeds. Hence any filesystem that has allocated a
cluster in this location will no longer fail allocation and issue
corruption warnings.

Fixes: 56d1115c9bc7 ("xfs: allocate sparse inode chunks on full chunk allocation failure")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c     | 47 ++++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_ialloc.c | 20 +++++++++++++---
 2 files changed, 54 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 5ca8d0106827..33290af6ab01 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -238,15 +238,36 @@ xfs_ag_block_count(
 			mp->m_sb.sb_dblocks);
 }
 
-/* Calculate the first and last possible inode number in an AG. */
+/*
+ * Calculate the first and last possible inode number in an AG.
+ *
+ * Due to a bug in sparse inode allocation for the runt AG at the end of the
+ * filesystem, we can have a valid sparse inode chunk on disk that spans beyond
+ * the end of the AG. Sparse inode chunks have special alignment - the full
+ * chunk must always be naturally aligned, and the regions that are allocated
+ * sparsely are cluster sized and aligned.
+ *
+ * The result of this is that for sparse inode setups, sb->sb_inoalignmt is
+ * always the size of the chunk, and that means M_IGEO(mp)->cluster_align isn't
+ * actually cluster alignment, it is chunk alignment. That means a sparse inode
+ * cluster that overlaps the end of the AG can never be valid based on "cluster
+ * alignment" even though all the inodes allocated within the sparse chunk at
+ * within the valid bounds of the AG and so can be used.
+ *
+ * Hence for the runt AG, the valid maximum inode number is based on sparse
+ * inode cluster alignment (sb->sb_spino_align) and not the "cluster alignment"
+ * value.
+ */
 static void
 __xfs_agino_range(
 	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
 	xfs_agblock_t		eoag,
 	xfs_agino_t		*first,
 	xfs_agino_t		*last)
 {
 	xfs_agblock_t		bno;
+	xfs_agblock_t		end_align;
 
 	/*
 	 * Calculate the first inode, which will be in the first
@@ -259,7 +280,12 @@ __xfs_agino_range(
 	 * Calculate the last inode, which will be at the end of the
 	 * last (aligned) cluster that can be allocated in the AG.
 	 */
-	bno = round_down(eoag, M_IGEO(mp)->cluster_align);
+	if (xfs_has_sparseinodes(mp) && agno == mp->m_sb.sb_agcount - 1)
+		end_align = mp->m_sb.sb_spino_align;
+	else
+		end_align = M_IGEO(mp)->cluster_align;
+
+	bno = round_down(eoag, end_align);
 	*last = XFS_AGB_TO_AGINO(mp, bno) - 1;
 }
 
@@ -270,7 +296,8 @@ xfs_agino_range(
 	xfs_agino_t		*first,
 	xfs_agino_t		*last)
 {
-	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
+	return __xfs_agino_range(mp, agno, xfs_ag_block_count(mp, agno),
+			first, last);
 }
 
 int
@@ -284,7 +311,7 @@ xfs_update_last_ag_size(
 		return -EFSCORRUPTED;
 	pag->block_count = __xfs_ag_block_count(mp, prev_agcount - 1,
 			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks);
-	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+	__xfs_agino_range(mp, pag->pag_agno, pag->block_count, &pag->agino_min,
 			&pag->agino_max);
 	xfs_perag_rele(pag);
 	return 0;
@@ -345,8 +372,8 @@ xfs_initialize_perag(
 		pag->block_count = __xfs_ag_block_count(mp, index, new_agcount,
 				dblocks);
 		pag->min_block = XFS_AGFL_BLOCK(mp);
-		__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
-				&pag->agino_max);
+		__xfs_agino_range(mp, pag->pag_agno, pag->block_count,
+				&pag->agino_min, &pag->agino_max);
 	}
 
 	index = xfs_set_inode_alloc(mp, new_agcount);
@@ -932,8 +959,8 @@ xfs_ag_shrink_space(
 
 	/* Update perag geometry */
 	pag->block_count -= delta;
-	__xfs_agino_range(pag->pag_mount, pag->block_count, &pag->agino_min,
-				&pag->agino_max);
+	__xfs_agino_range(mp, pag->pag_agno, pag->block_count,
+				&pag->agino_min, &pag->agino_max);
 
 	xfs_ialloc_log_agi(*tpp, agibp, XFS_AGI_LENGTH);
 	xfs_alloc_log_agf(*tpp, agfbp, XFS_AGF_LENGTH);
@@ -1003,8 +1030,8 @@ xfs_ag_extend_space(
 
 	/* Update perag geometry */
 	pag->block_count = be32_to_cpu(agf->agf_length);
-	__xfs_agino_range(pag->pag_mount, pag->block_count, &pag->agino_min,
-				&pag->agino_max);
+	__xfs_agino_range(pag->pag_mount, pag->pag_agno, pag->block_count,
+				&pag->agino_min, &pag->agino_max);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 6258527315f2..d68b53334990 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -108,22 +108,36 @@ xfs_inobt_rec_freecount(
 	return hweight64(realfree);
 }
 
+/* Compute the highest allocated inode in an incore inode record. */
+static xfs_agino_t
+xfs_inobt_rec_highino(
+	const struct xfs_inobt_rec_incore	*irec)
+{
+	if (xfs_inobt_issparse(irec->ir_holemask))
+		return xfs_highbit64(xfs_inobt_irec_to_allocmask(irec));
+	return XFS_INODES_PER_CHUNK;
+}
+
 /* Simple checks for inode records. */
 xfs_failaddr_t
 xfs_inobt_check_irec(
 	struct xfs_perag			*pag,
 	const struct xfs_inobt_rec_incore	*irec)
 {
+	xfs_agino_t	high_ino = xfs_inobt_rec_highino(irec);
+
 	/* Record has to be properly aligned within the AG. */
 	if (!xfs_verify_agino(pag, irec->ir_startino))
 		return __this_address;
-	if (!xfs_verify_agino(pag,
-				irec->ir_startino + XFS_INODES_PER_CHUNK - 1))
+
+	if (!xfs_verify_agino(pag, irec->ir_startino + high_ino - 1))
 		return __this_address;
+
 	if (irec->ir_count < XFS_INODES_PER_HOLEMASK_BIT ||
 	    irec->ir_count > XFS_INODES_PER_CHUNK)
 		return __this_address;
-	if (irec->ir_freecount > XFS_INODES_PER_CHUNK)
+
+	if (irec->ir_freecount > irec->ir_count)
 		return __this_address;
 
 	if (xfs_inobt_rec_freecount(irec) != irec->ir_freecount)
-- 
2.45.2

