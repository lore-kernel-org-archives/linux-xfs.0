Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C67274652
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 15:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760975128; cv=none; b=Y1Plvq+ACn5jnLmYjPdazs+yyGoBuwnjGTbB6KoMRQIJoI+XhkGO1DAqVqYhM+s7g6HISjtQ+V2S0fYAkjde6bt28ViraI++SREBJ6LvicvR5TBegezTZh5TJzX6rPhSzW6nh8Mg8X5hivsxCOxd3Y3hsvOs5t0WaFNGocJy0nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760975128; c=relaxed/simple;
	bh=XhoTQACn2S1l7m6hk6V9q+qLnS64PwK+PPfZyQ0zhWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ncw4h9f///0jK3jEO4aCeeIZYlDUhOEAQ2Sz7SshJANx4bsnlCbasGM2NzlksD7MNwVTLVPH9N5tvZ/gSy3GQIBXnLI+dvLeMUWS97BElfsgCx24HxVNGlfQTnneF9GDquZ9cmtexTBUP7Yi0FNDEL3+mJGj9vjsSnaeQm9+D/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NDzNCuIa; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NDzNCuIa"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-290dc630a07so21757765ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 08:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760975124; x=1761579924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/A6PDJ878bMpzeeeuWt78TX280dlboDZmg7F2IEIc28=;
        b=NDzNCuIaUB+kzP2+gtAeZ08cbrs+jlIVsHw5VvCjN495IuX5gnvs+nclYPJ9lAIXMP
         Okhw1m+tXavyhhxafnDTTmAapo3CJNMT9OZoitIQX99HT7qhy+oYJc9oGdJ6NxDlHRyL
         CuNi2RodUlxTnfmGhsLwER7UFq9UgBu1BKsUX9pbcwypi2ePeU/5n03CdJgZbalrV0e5
         dVzG4Ek/Pp1MP2LWBAji1MZEMs9QjdlBi6X8GBPGAMFvH4mMe0ckjBlNzXvW8A2CsaKb
         9eNPkTcFOmffpPOaq+H+WvgorB+gsahkDCXtGUdUKNm2VVv5LAcDpnkFd/rFOLaUU/HT
         0OIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760975124; x=1761579924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/A6PDJ878bMpzeeeuWt78TX280dlboDZmg7F2IEIc28=;
        b=A0fFTcBfAvutUxJYHZ7IrlFrE54xUi7lzwa1iHRyoR4X7B9q7Ens+b/R9UoEbS67B8
         ragYhAp9thccAgZyXEMpZzPJ/dnR4wqxgc0pmo1THR1FbdXzF/kxD5+Oq5KDCJsziS5x
         YkbYhvzvPdb9QsfVNhP07or19Che7RjRkmZPv6ECpIR5Sfw0H5vzMjBl6sVWyElPvbRW
         DuS3eUmK70rv5ZNfi8Lpkahjg9n96fQ71kf6PNryxKOFHdRayLYgi6y7WMnEplDbIQ5A
         Vpkz2blbikeDKnZzbcKdTXxolosgQWs1DHUpbpQIyIpVjP9PaXBAk0sY+yNhRn12t3Fs
         6DTQ==
X-Gm-Message-State: AOJu0YzezlhkmKT2/BkbK0B8Bm69HHhqlfdxdMGBqbjlE46hR7UXVVJI
	RNlP3asX7UwA5msK2Xt4ldgLYE3M05w9eQVdVnLqWzhRZ06QwFkX3xv/0L5qDQ==
X-Gm-Gg: ASbGncsBOUp24n9gAIyHYqWlo5y39yJgWySb/TeVHqGFPBbCIPEuPFQ2KlSpi7WXB9/
	e1GPhSCfUPZ28UsoNT+h+tDAcoexmp/wabs0qWJmH7wxDiBkXJ6YKt7QKcu9vKaSV8XB0BKcuFx
	z6EAmBhx1W8ftAc9WaQ2hZ9I+8Ferqd9aUtlMlzAhEOW+h25E4iBSwnY6HrJG3gpSug0MIv/sWC
	ofeAnrbrZ95SRXkCUrxH1nmYIa1knCO7iFc6KKsrt5aEUlHa+lgqktbvncyIx1gTouQ67aws44w
	97evtOY/9xt7+lR4qm3ozLgrdQOD9+4tS2yZSza/XVa3/T3abMhdESiBu7bzinxXIAtXmDIsGom
	YiOXIMH9PZdbUW+cJzwUB+hGD+My+5NxPx5574cQHKUijzct3jXD47N4P96JdGDg79m56toncl2
	VKtGHy03OD6L3l03/HSEFn90vCT9/8IjHZotEYBQuRPIVjPJofizsDOuGrovIs1xb0
X-Google-Smtp-Source: AGHT+IEpl/vlIj2UDkhZDvgx7nkJOOLUUfXqTwqJZl+E9bPqRUB9XRaWLFXTNwAKeI/ewbUcZitfBA==
X-Received: by 2002:a17:902:e544:b0:249:37ad:ad03 with SMTP id d9443c01a7336-290cba4ebdamr167983125ad.34.1760975123446;
        Mon, 20 Oct 2025 08:45:23 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.204.231])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b73727sm8075327a12.40.2025.10.20.08.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 08:45:23 -0700 (PDT)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: nirjhar.roy.lists@gmail.com,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	bfoster@redhat.com,
	david@fromorbit.com,
	hsiangkao@linux.alibaba.com
Subject: [RFC V3 3/3] xfs: Add support to shrink multiple empty AGs
Date: Mon, 20 Oct 2025 21:13:44 +0530
Message-ID: <4ff3b8846c3b81a2ab97e0f8bc713b91c9dbb5b3.1760640936.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch is based on a previous RFC[1] by Gao Xiang and various
ideas proposed by Dave Chinner in the RFC[1].

This patch adds the functionality to shrink the filesystem beyond
1 AG. We can remove only empty AGs in order to prevent loss
of data. Before I summarize the overall steps of the shrink
process, I would like to introduce some of the terminologies:

1. Empty AG - An AG with no allocated space other than AG headers, empty
   AG btree root blocks, and AGFL reserved blocks.  Removal of this AG
   will not result in any data loss.

2. Active/Online AG - Online AG and active AG will be used
   interchangebly. An AG is active or online when all the regular
   operations can be done on it. When we mount a filesystem, all
   the AGs are by default online/active. In terms of implementation,
   an online AG will have number of active references greater than 0
   (default is 1 i.e, an AG by default is online/active).

3. AG offlining/deactivation - AG offlining and AG deactivation will
   be used interchangebly. An AG is said to be offlined/deactivated
   when no new high level operation can be started on the AG. This is
   implemented with the help of active references. When the active
   reference count of an AG is 0, the AG is said to be deactivated.
   No new active reference can be taken if the present active reference
   count is 0. This way a barrier is formed from preventing new high
   level operations to get started on an already offlined AG.

4. Reactivating an AG - If we try to remove an offlined AG but for some
   reason, we can't, then we reactivate the AG i.e, the AG will once
   more be in an usable state i.e, the active reference count will be
   set to 1. All the high level operations can now be performed on this
   AG. In terms of implementation, in order to activate an AG, we
   atomically set the active reference count to 1.

5. AG removal - This means that an AG no longer exists in the filesystem.
   It will be reflected in the usable/total size of the device too
   (using tools like df).

6. New tail AG - This refers to the last AG that will be formed after
   the removal of 1 or more AGs. For example, if there are 4 AGs, each
   with 32 blocks, then there are total of 4 * 32 = 128 blocks. Now,
   if we remove 40 blocks, AG 3(indexed at 0) will be completely
   removed (32 blocks) and from AG 2, we will remove 8 blocks.
   So AG 2 will be the new tail AG.

7. Old tail AG - This is the last AG before the start of the shrink
   process. If the number of blocks removed is less than the AG
   size, then the old tail AG will be the same as the new tail
   AG.

8. AG stabilization - This simply means that the in-memory contents
   are synched to the disk.

The overall steps for the removal of AG(s) are as follows:
PHASE 1: Preparing the AGs for removal
1. Deactivate the AGs to be removed completely - This is done
   by the function xfs_shrinkfs_deactivate_ags(). The steps to deactivate
   an AG are as follows(function is xfs_perag_deactivate()):
     1.a Manually reserve/reduce from the global fdblock free counters
         the perag pagf_freeblks + pagf_flcount. This is done in order
         to prevent a race where, some AGs have been offlined but
         the delayed  allocator has already promised some bytes
         and the real extent/block allocation is failing due to the
         AG(s) being offline.
         So shrink operation reserves to the shrink transaction the
         space to be removed from the incore fdblocks and either
         commits that change to the ondisk fdblocks
         (shrink succeeds) or gives it back (shrink fails).
     1.b Wait for the active reference to come to 0.
         This is done so that no other entity is racing while the removal
         is in progress i.e, no new high level operation can start on that
         AG while we are trying to remove the AG.
         AG deactivation will fail if the AG is non-empty at the time of
         deactivation.
2. Once we have waited for the active references to come down to 0,
   we make sure that all the pending operations on that AG are completed
   and the in-core and on-disk structures are in synch i.e, the AG is
   stabilized on to the disk.
   The steps to stablize the AG onto the disk are as follows:
   2.a We need to flush and empty the logs and wait for all the pending
       I/Os to complete - for this, perform a log force+ail push by
       calling xfs_ail_push_all_sync(). This also ensures that
       none of the future logged transactions will refer to these
       AGs during log recovery in case if sudden shutdown/crash
       happens while we are trying to remove these AGs. We also sync
       the superblock with the disk.
   2.b Wait for all the busy extents for the target AGs to be resolved
      (done by the function xfs_extent_busy_wait_ags())
   2.c Flush the xfs_discard_wq workqueue
3. Once the AG is deactivated and stabilized on to the disk, we check if
   all the target AGs are empty, and if not, we fail the shrink process.
   We are not supporting partial shrink i.e, the shrink will
   either completely fail or completely succeed.

PHASE 2: Shrink new tail group, punch out totally empty groups
4. Once the preparation phase is over, we start the actual removal
   process. This is done in the function xfs_shrinkfs_remove_ags().
   Here we first remove the blocks, then update the metadata of
   new last tail AG and then remove the  AGs (and their associated
   data structures) one by one (in function xfs_shrinkfs_remove_ag()).
5. In the end we log the changes and commit the transaction.

Removal of each incore AG structure is done by the function
xfs_shrinkfs_remove_ag().
The steps can be outlined as follows:
1. Free the per AG reservation - this will result in correct free
   space/used space information.
2. Freeing the intents drain queue.
3. Freeing busy extents list.
4. Remove the perag cached buffers and then the buffer cache.
5. Freeing the struct xfs_group pointer - Before this is done, we
   assert that all the active and passive references are down to 0.
   We remove all the cached buffers associated with the offlined AGs
   to be removed - this releases the passive references of the AGs
   consumed by the cached buffers.

[1] https://lore.kernel.org/all/20210414195240.1802221-1-hsiangkao@redhat.com/

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Inspired-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_ag.c        | 163 ++++++++++++++-
 fs/xfs/libxfs/xfs_ag.h        |  14 ++
 fs/xfs/libxfs/xfs_alloc.c     |  10 +-
 fs/xfs/xfs_buf.c              |  78 ++++++++
 fs/xfs/xfs_buf.h              |   1 +
 fs/xfs/xfs_buf_item_recover.c |  37 ++--
 fs/xfs/xfs_extent_busy.c      |  30 +++
 fs/xfs/xfs_extent_busy.h      |   2 +
 fs/xfs/xfs_fsops.c            | 364 ++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_mount.h            |   3 +
 fs/xfs/xfs_trans.c            |   1 -
 11 files changed, 664 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index f2b35d59d51e..d7f955d48c5c 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -193,20 +193,32 @@ xfs_agino_range(
 }
 
 /*
- * Update the perag of the previous tail AG if it has been changed during
- * recovery (i.e. recovery of a growfs).
+ * This function does the following:
+ * - Updates the previous perag tail if prev_agcount < current agcount i.e, the
+ *   filesystem has grown OR
+ * - Updates the current tail AG when prev_agcount > current agcount i.e, the
+ *   filesystem has shrunk beyond 1 AG OR
+ * - Updates the current tail AG when only the last AG was shrunk or grown i.e,
+ *   prev_agcount == mp->m_sb.sb_agcount.
  */
 int
 xfs_update_last_ag_size(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		prev_agcount)
 {
-	struct xfs_perag	*pag = xfs_perag_grab(mp, prev_agcount - 1);
+	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag;
 
+	if (prev_agcount >= mp->m_sb.sb_agcount)
+		agno = mp->m_sb.sb_agcount - 1;
+	else
+		agno = prev_agcount - 1;
+
+	pag = xfs_perag_grab(mp, agno);
 	if (!pag)
 		return -EFSCORRUPTED;
-	pag_group(pag)->xg_block_count = __xfs_ag_block_count(mp,
-			prev_agcount - 1, mp->m_sb.sb_agcount,
+	pag_group(pag)->xg_block_count = __xfs_ag_block_count(mp, agno,
+			mp->m_sb.sb_agcount,
 			mp->m_sb.sb_dblocks);
 	__xfs_agino_range(mp, pag_group(pag)->xg_block_count, &pag->agino_min,
 			&pag->agino_max);
@@ -290,6 +302,48 @@ xfs_initialize_perag(
 	return error;
 }
 
+void
+xfs_perag_activate(struct xfs_perag	*pag)
+{
+	ASSERT(!xfs_perag_is_active(pag));
+	init_waitqueue_head(&pag_group(pag)->xg_active_wq);
+	atomic_set(&pag_group(pag)->xg_active_ref, 1);
+	xfs_add_fdblocks(pag_mount(pag), pag->pagf_freeblks +
+			pag->pagf_flcount);
+}
+
+int
+xfs_perag_deactivate(struct xfs_perag	*pag)
+{
+	int	error = 0;
+
+	ASSERT(xfs_perag_is_active(pag));
+	if (!xfs_perag_is_empty(pag))
+		return -ENOTEMPTY;
+	/*
+	 * Manually reduce/reserve (pagf_freeblks + pagf_flcount) worth of
+	 * free datablocks from the global counters. This is necessary
+	 * in order to prevent a race where, some AGs have been temporarily
+	 * offlined but the delayed allocator has already promised some bytes
+	 * and later the real extent/block allocation is failing due to
+	 * the AG(s) being offline.
+	 * If the overall shrink fails, we will restore the values.
+	 */
+	error = xfs_dec_fdblocks(pag_mount(pag),
+			pag->pagf_freeblks + pag->pagf_flcount, false);
+	if (error)
+		return error;
+	xfs_perag_rele(pag);
+	do {
+		error = wait_event_killable(pag_group(pag)->xg_active_wq,
+				!xfs_perag_is_active(pag));
+		if (error == -ERESTARTSYS)
+			return error;
+
+	} while (xfs_perag_is_active(pag));
+	return 0;
+}
+
 static int
 xfs_get_aghdr_buf(
 	struct xfs_mount	*mp,
@@ -758,7 +812,6 @@ xfs_ag_shrink_space(
 	xfs_agblock_t		aglen;
 	int			error, err2;
 
-	ASSERT(pag_agno(pag) == mp->m_sb.sb_agcount - 1);
 	error = xfs_ialloc_read_agi(pag, *tpp, 0, &agibp);
 	if (error)
 		return error;
@@ -872,6 +925,104 @@ xfs_ag_shrink_space(
 	return err2;
 }
 
+/*
+ * This function checks whether an AG is empty. An AG is eligible to be
+ * removed if it is empty.
+ */
+bool
+xfs_perag_is_empty(struct xfs_perag	*pag)
+{
+	struct xfs_buf		*agfbp = NULL;
+	struct xfs_mount	*mp = pag_mount(pag);
+	bool			is_empty = false;
+	int			error = 0;
+	struct xfs_agf		*agf = NULL;
+
+	/*
+	 * Read the on-disk data structures to get the correct length of the AG.
+	 * All the AGs have the same length except the last AG.
+	 */
+	error = xfs_alloc_read_agf(pag, NULL, 0, &agfbp);
+	if (!error) {
+		agf = agfbp->b_addr;
+		/*
+		 * We don't need to check if the log blocks belong here since
+		 * the log blocks are taken from the number of free blocks, and
+		 * if the given AG has log blocks, then those many number of
+		 * blocks will be consumed from the number of free blocks and
+		 * the AG empty condition will not hold true.
+		 */
+		if (pag->pagf_freeblks + pag->pagf_flcount +
+		    mp->m_ag_prealloc_blocks == be32_to_cpu(agf->agf_length))
+			is_empty = true;
+		xfs_buf_relse(agfbp);
+	}
+	return is_empty;
+}
+
+/*
+ * This function removes an entire empty AG. Before removing the struct
+ * xfs_perag reference, it removes the associated data structures. Before
+ * removing an AG, the caller must ensure that the AG has been deactivated with
+ * no active references and it has been fully stabilized on the disk.
+ */
+void
+xfs_shrinkfs_remove_ag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_group	*xg = NULL;
+	struct xfs_perag	*cur_pag = NULL;
+
+	/*
+	 * Number of AGs can't be less than 2
+	 */
+	ASSERT(agno >= 2);
+	xg = xa_erase(&mp->m_groups[XG_TYPE_AG].xa, agno);
+	cur_pag = to_perag(xg);
+
+	ASSERT(!xfs_perag_is_active(cur_pag));
+	/*
+	 * Since we are freeing the AG, we should clear the perag reservations
+	 * for the corresponding AGs.
+	 */
+	xfs_ag_resv_free(cur_pag);
+	/*
+	 * We have already ensured in the AG preparation phase that all intents
+	 * for the offlined AGs have been resolved. So it safe to free it here.
+	 */
+	xfs_defer_drain_free(&xg->xg_intents_drain);
+	/*
+	 * We have already ensured in the AG preparation phase that all busy
+	 * extents for the offlined AGs have been resolved. So it safe to free
+	 * it here.
+	 */
+	kfree(xg->xg_busy_extents);
+	cancel_delayed_work_sync(&cur_pag->pag_blockgc_work);
+
+	/*
+	 * Remove all the cached buffers for the given AG.
+	 */
+	xfs_buf_cache_invalidate(cur_pag);
+	/*
+	 * Now that the cached buffers have been released, remove the
+	 * cache/hashtable itself. We should not change the order of the buffer
+	 * removal and cache removal.
+	 */
+	xfs_buf_cache_destroy(&cur_pag->pag_bcache);
+	/*
+	 * One final assert, before we remove the xg. Since the cached buffers
+	 * for the offlined AGs are already removed, their passive references
+	 * should be 0. Also, the active references are 0 too, so no new
+	 * operation can start and race and get new references.
+	 */
+	XFS_IS_CORRUPT(mp, atomic_read(&pag_group(cur_pag)->xg_ref) != 0);
+	/*
+	 * Finally free the struct xfs_perag of the AG.
+	 */
+	kfree_rcu_mightsleep(xg);
+}
+
 void
 xfs_growfs_compute_deltas(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index f7b56d486468..c91698b96702 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -112,6 +112,11 @@ static inline xfs_agnumber_t pag_agno(const struct xfs_perag *pag)
 	return pag->pag_group.xg_gno;
 }
 
+static inline bool xfs_perag_is_active(struct xfs_perag	*pag)
+{
+	return atomic_read(&pag_group(pag)->xg_active_ref) > 0;
+}
+
 /*
  * Per-AG operational state. These are atomic flag bits.
  */
@@ -140,6 +145,7 @@ void xfs_free_perag_range(struct xfs_mount *mp, xfs_agnumber_t first_agno,
 		xfs_agnumber_t end_agno);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
 int xfs_update_last_ag_size(struct xfs_mount *mp, xfs_agnumber_t prev_agcount);
+bool xfs_perag_is_empty(struct xfs_perag *pag);
 
 /* Passive AG references */
 static inline struct xfs_perag *
@@ -263,6 +269,9 @@ xfs_ag_contains_log(struct xfs_mount *mp, xfs_agnumber_t agno)
 	       agno == XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart);
 }
 
+void xfs_perag_activate(struct xfs_perag *pag);
+int xfs_perag_deactivate(struct xfs_perag *pag);
+
 static inline struct xfs_perag *
 xfs_perag_next_wrap(
 	struct xfs_perag	*pag,
@@ -290,6 +299,10 @@ xfs_perag_next_wrap(
 	return NULL;
 }
 
+#define for_each_agno_range_reverse(agno, oagcount, nagcount) \
+	for ((agno) = ((oagcount) - 1); (typeof(oagcount))(agno) >= \
+		((typeof(oagcount))(nagcount) - 1); (agno)--)
+
 /*
  * Iterate all AGs from start_agno through wrap_agno, then restart_agno through
  * (start_agno - 1).
@@ -331,6 +344,7 @@ struct aghdr_init_data {
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
 int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
 			xfs_extlen_t delta);
+void xfs_shrinkfs_remove_ag(struct xfs_mount *mp, xfs_agnumber_t agno);
 void
 xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
 	int64_t *deltap, xfs_agnumber_t *nagcountp);
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ad381c73abc4..878a236735d3 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3209,10 +3209,14 @@ xfs_validate_ag_length(
 	if (length != mp->m_sb.sb_agblocks) {
 		/*
 		 * During growfs, the new last AG can get here before we
-		 * have updated the superblock. Give it a pass on the seqno
-		 * check.
+		 * have updated the superblock. During shrink, the new last AG
+		 * will be updated and the AGs from newag to old AG will be
+		 * removed. So seqno here maybe not be equal to
+		 * mp->m_sb.sb_agcount - 1 since the super block is not yet
+		 * updated globally.
 		 */
-		if (bp->b_pag && seqno != mp->m_sb.sb_agcount - 1)
+		if (!xfs_is_shrinking(mp) &&
+			bp->b_pag && seqno != mp->m_sb.sb_agcount - 1)
 			return __this_address;
 		if (length < XFS_MIN_AG_BLOCKS)
 			return __this_address;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 773d959965dc..225e527a47af 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -948,6 +948,84 @@ xfs_buf_rele(
 		xfs_buf_rele_cached(bp);
 }
 
+/*
+ * This function populates a list of all the cached buffers of the given AG
+ * in the to_be_free list head.
+ */
+static void
+xfs_buf_cache_grab_all(
+	struct xfs_perag	*pag,
+	struct list_head	*to_be_freed)
+{
+	struct xfs_buf		*bp;
+	struct rhashtable_iter	iter;
+
+	rhashtable_walk_enter(&pag->pag_bcache.bc_hash, &iter);
+	do {
+		rhashtable_walk_start(&iter);
+		while ((bp = rhashtable_walk_next(&iter)) && !IS_ERR(bp)) {
+			ASSERT(list_empty(&bp->b_list));
+			ASSERT(list_empty(&bp->b_li_list));
+			list_add_tail(&bp->b_list, to_be_freed);
+		}
+		rhashtable_walk_stop(&iter);
+	} while (cond_resched(), bp == ERR_PTR(-EAGAIN));
+	rhashtable_walk_exit(&iter);
+}
+
+/*
+ * This function frees all the cached buffers (struct xfs_buf) associated with
+ * the given offline AG. The caller must ensure that the AG which is passed
+ * is offline and completely stabilized on the disk. Also, the caller should
+ * ensure that all the cached buffers are not queued for any pending i/o
+ * i.e, the b_list for all the cached buffers are empty - since we will be using
+ * b_list to get list of all the bufs that need to be freed.
+ */
+void
+xfs_buf_cache_invalidate(struct xfs_perag	*pag)
+{
+	/*
+	 * First get the list of buffers we want to free.
+	 * We need to populate to_be_freed list and cannot directly free
+	 * the buffers during the hashtable walk. rhashtable_walk_start() takes
+	 * an RCU and xfs_buf_rele eventually calls xfs_buf_free (for
+	 * cached buffers). xfs_buf_free() might sleep (depending on the
+	 * whether the buffer was allocated using vmalloc or kmalloc) and
+	 * cannot be called within an RCU context. Hence we first populate
+	 * the buffers within an RCU context and free them outside it.
+	 */
+	struct list_head	to_be_freed;
+	struct xfs_buf		*bp, *tmp;
+
+	ASSERT(!xfs_perag_is_active(pag));
+
+	INIT_LIST_HEAD(&to_be_freed);
+
+	xfs_buf_cache_grab_all(pag, &to_be_freed);
+	list_for_each_entry_safe(bp, tmp, &to_be_freed, b_list) {
+		list_del(&bp->b_list);
+		spin_lock(&bp->b_lock);
+		ASSERT(bp->b_pag == pag);
+		ASSERT(!xfs_buf_is_uncached(bp));
+		/*
+		 * Since we have made sure that this is being called on an
+		 * AG with active refcount = 0, the b_hold value of any cached
+		 * buffer should not exceed 1 (i.e, the default value) and hence
+		 * can be safely removed. Hence, it should also be in an
+		 * unlocked state.
+		 */
+		ASSERT(bp->b_hold == 1);
+		ASSERT(!xfs_buf_islocked(bp));
+		/*
+		 * We should set b_lru_ref to 0 so that it gets deleted from
+		 * the lru during the call to xfs_buf_rele.
+		 */
+		atomic_set(&bp->b_lru_ref, 0);
+		spin_unlock(&bp->b_lock);
+		xfs_buf_rele(bp);
+	}
+}
+
 /*
  *	Lock a buffer object, if it is not already locked.
  *
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 8fa7bdf59c91..210d7f904a68 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -282,6 +282,7 @@ void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
 extern void xfs_buf_rele(struct xfs_buf *);
+void xfs_buf_cache_invalidate(struct xfs_perag	*pag);
 
 /* Locking and Unlocking Buffers */
 extern int xfs_buf_trylock(struct xfs_buf *);
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index e4c8af873632..f9aadfe071d5 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -747,8 +747,7 @@ xlog_recover_do_primary_sb_buffer(
 	}
 
 	if (mp->m_sb.sb_agcount < orig_agcount) {
-		xfs_alert(mp, "Shrinking AG count in log recovery not supported");
-		return -EFSCORRUPTED;
+		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_SHRINK);
 	}
 	if (mp->m_sb.sb_rgcount < orig_rgcount) {
 		xfs_warn(mp,
@@ -774,18 +773,28 @@ xlog_recover_do_primary_sb_buffer(
 		if (error)
 			return error;
 	}
-
-	/*
-	 * Initialize the new perags, and also update various block and inode
-	 * allocator setting based off the number of AGs or total blocks.
-	 * Because of the latter this also needs to happen if the agcount did
-	 * not change.
-	 */
-	error = xfs_initialize_perag(mp, orig_agcount, mp->m_sb.sb_agcount,
-			mp->m_sb.sb_dblocks, &mp->m_maxagi);
-	if (error) {
-		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
-		return error;
+	if (orig_agcount > mp->m_sb.sb_agcount) {
+		/*
+		 * Remove the old AGs that were removed previously by a growfs
+		 */
+		xfs_free_perag_range(mp, mp->m_sb.sb_agcount, orig_agcount);
+		mp->m_maxagi = xfs_set_inode_alloc(mp, mp->m_sb.sb_agcount);
+		mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
+	} else {
+		/*
+		 * Initialize the new perags, and also the update various block
+		 * and inode allocator setting based off the number of AGs or
+		 * total blocks.
+		 * Because of the latter, this also needs to happen if the
+		 * agcount did not change.
+		 */
+		error = xfs_initialize_perag(mp, orig_agcount,
+				mp->m_sb.sb_agcount,
+				mp->m_sb.sb_dblocks, &mp->m_maxagi);
+		if (error) {
+			xfs_warn(mp, "Failed recovery per-ag init: %d", error);
+			return error;
+		}
 	}
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index da3161572735..6e02632022d2 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -676,6 +676,36 @@ xfs_extent_busy_wait_all(
 			xfs_extent_busy_wait_group(rtg_group(rtg));
 }
 
+/*
+ * Similar to xfs_extent_busy_wait_all() - It waits for all the busy extents to
+ * get resolved for the range of AGs provided. For now, this function is
+ * introduced to be used in online shrink process. Unlike
+ * xfs_extent_busy_wait_all(), this takes a passive reference, because this
+ * function is expected to be called for the AGs whose active reference has
+ * been reduced to 0 i.e, offline AGs.
+ *
+ * @mp - The xfs mount point
+ * @first_agno - The 0 based AG index of the range of AGs from which we will
+ *     start.
+ * @end_agno - The 0 based AG index of the range of AGs from till which we will
+ *     traverse.
+ */
+void
+xfs_extent_busy_wait_ags(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		first_agno,
+	xfs_agnumber_t		end_agno)
+{
+	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag = NULL;
+
+	for_each_agno_range_reverse(agno, end_agno + 1, first_agno + 1) {
+		pag = xfs_perag_get(mp, agno);
+		xfs_extent_busy_wait_group(pag_group(pag));
+		xfs_perag_put(pag);
+	}
+}
+
 /*
  * Callback for list_sort to sort busy extents by the group they reside in.
  */
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 3e6e019b6146..6fcab714be07 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -57,6 +57,8 @@ bool xfs_extent_busy_trim(struct xfs_group *xg, xfs_extlen_t minlen,
 		unsigned *busy_gen);
 int xfs_extent_busy_flush(struct xfs_trans *tp, struct xfs_group *xg,
 		unsigned busy_gen, uint32_t alloc_flags);
+void xfs_extent_busy_wait_ags(struct xfs_mount *mp, xfs_agnumber_t first_agno,
+		xfs_agnumber_t end_agno);
 void xfs_extent_busy_wait_all(struct xfs_mount *mp);
 bool xfs_extent_busy_list_empty(struct xfs_group *xg, unsigned int *busy_gen);
 struct xfs_extent_busy_tree *xfs_extent_busy_alloc(void);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 8353e2f186f6..faac1b3c8daa 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -25,6 +25,7 @@
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
 #include "xfs_metafile.h"
+#include "xfs_trans_priv.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -83,6 +84,297 @@ xfs_resizefs_init_new_ags(
 	return error;
 }
 
+static int
+xfs_shrinkfs_quiesce_ags(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		oagcount,
+	xfs_agnumber_t		nagcount)
+{
+	int	error = 0;
+	int	count = 0;
+
+	/*
+	 * We should wait for the log to be empty and all the pending I/Os to
+	 * be completed so that the AGs are completely stabilized before we
+	 * start tearing them down. Flushing the AIL and synching the superblock
+	 * here ensures that none of the future logged transactions will refer
+	 * to these AGs during log recovery in case if sudden shutdown/crash
+	 * happens while we are trying to remove these AGs.
+	 * The following code is similar to xfs_log_quiesce() and xfs_log_cover.
+	 *
+	 * We are doing a xfs_sync_sb_buf + AIL flush twice. The first
+	 * xfs_sync_sb_buf writes a checkpoint, then the first AIL flush makes
+	 * the first checkpoint stable. The second set of xfs_sync_sb_buf + AIL
+	 * flush synchs the on-disk LSN with the in-core LSN.
+	 * Unlike xfs_log_cover(), we don't necessarily want the background
+	 * filesytem activity/log activity to stop (like in case of unmount
+	 * or freeze).
+	 */
+	cancel_delayed_work_sync(&mp->m_log->l_work);
+	error = xfs_log_force(mp, XFS_LOG_SYNC);
+	if (error)
+		goto out;
+
+	error = xfs_sync_sb_buf(mp, false);
+	if (error)
+		goto out;
+
+	xfs_ail_push_all_sync(mp->m_ail);
+	xfs_buftarg_wait(mp->m_ddev_targp);
+	xfs_buf_lock(mp->m_sb_bp);
+	xfs_buf_unlock(mp->m_sb_bp);
+
+	/*
+	 * The first xfs_sync_sb serves as a reference for the in-core tail
+	 * pointer and the second one updates the on-disk tail with the in-core
+	 * lsn. This is similar to what is being done in xfs_log_cover, however
+	 * here we are explicitly doing this twice in order to ensure forward
+	 * progress as, during shrink the filesystem is active.
+	 */
+	for (count = 0; count < 2; count++) {
+		error = xfs_sync_sb(mp, true);
+		if (error)
+			goto out;
+		xfs_ail_push_all_sync(mp->m_ail);
+	}
+
+	/*
+	 * Wait for all the busy extents to get resolved along with pending trim
+	 * ops for all the offlined AGs.
+	 */
+	xfs_extent_busy_wait_ags(mp, nagcount, oagcount - 1);
+	flush_workqueue(xfs_discard_wq);
+out:
+	xfs_log_work_queue(mp);
+	return error;
+}
+
+/*
+ * Get new active references for all the AGs. This might be called when
+ * shrinkage process encounters a failure at an intermediate stage after the
+ * active references of all/some of the target AGs have become 0.
+ */
+static void
+xfs_shrinkfs_reactivate_ags(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		oagcount,
+	xfs_agnumber_t		nagcount)
+{
+	struct xfs_perag	*pag = NULL;
+	xfs_agnumber_t		agno;
+
+	ASSERT(nagcount < oagcount);
+
+	for_each_agno_range_reverse(agno, oagcount, nagcount + 1) {
+		pag = xfs_perag_get(mp, agno);
+		xfs_perag_activate(pag);
+		xfs_perag_put(pag);
+	}
+}
+
+/*
+ * The function deactivates or puts the AGs to an offline mode. AG deactivation
+ * or AG offlining means that no new operation can be started on that AG. The AG
+ * still exists, however no new high level operation (like extent allocation)
+ * can be started. In terms of implementation, an AG is taken offline or is
+ * deactivated when xg_active_ref of the struct xfs_perag is 0 i.e, the number
+ * of active references becomes 0.
+ * Since active references act as a form of barrier, so once the active
+ * reference of an AG is 0, no new entity can get an active reference and in
+ * this way we ensure that once an AG is offline (i.e, active reference count is
+ * 0), no one will be able to start a new operation in it unless the active
+ * reference count is explicitly set to 1 i.e, the AG is made online/activated.
+ */
+static int
+xfs_shrinkfs_deactivate_ags(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		oagcount,
+	xfs_agnumber_t		nagcount)
+{
+	int			error = 0;
+	struct xfs_perag	*pag = NULL;
+	xfs_agnumber_t		agno;
+
+	ASSERT(nagcount < oagcount);
+
+	/*
+	 * If we are removing 1 or more entire AGs, we only need to take those
+	 * AGs offline which we are planning to remove completely. The new tail
+	 * AG which will be partially shrunk should not be taken offline - since
+	 * we will be doing an online operation on them, just like any other
+	 * high level operation. For complete AG removal, we need to take them
+	 * offline since we cannot start any new operation on them as they will
+	 * be removed eventually.
+	 *
+	 * However, if the number of blocks that we are trying to remove is
+	 * an exact multiple of the AG size (in blocks), then the new tail AG
+	 * will not be shrunk at all.
+	 */
+	for_each_agno_range_reverse(agno, oagcount, nagcount + 1) {
+		pag = xfs_perag_get(mp, agno);
+		error = xfs_perag_deactivate(pag);
+		if (error) {
+			xfs_perag_put(pag);
+			if (agno < oagcount - 1)
+				xfs_shrinkfs_reactivate_ags(mp, oagcount,
+					agno + 1);
+			xfs_clear_shrinking(mp);
+			error = error == -ERESTARTSYS ?
+				-ERESTARTSYS : -ENOTEMPTY;
+			return error;
+		}
+		xfs_perag_put(pag);
+	}
+	/*
+	 * Now that we have deactivated/offlined the AGs, we need to make sure
+	 * that all the pending operations are completed and the in-core and
+	 * the on disk contents are completely in synch i.e, AGs are stablized
+	 * on to the disk.
+	 */
+	error = xfs_shrinkfs_quiesce_ags(mp, oagcount, nagcount);
+	if (error) {
+		xfs_shrinkfs_reactivate_ags(mp, oagcount, nagcount);
+		xfs_clear_shrinking(mp);
+		return error;
+	}
+
+	return 0;
+}
+
+/*
+ * This function does 3 things:
+ * 1. Deactivate the AGs i.e, wait for all the active references to come to 0.
+ * 2. Checks whether all the AGs that shrink process needs to remove are empty.
+ *    If at least one of the target AGs is non-empty, shrink fails and
+ *    xfs_shrinkfs_reactivate_ags() is called.
+ * 3. Calculates the total number of fdblocks (free data blocks) that will be
+ *    removed and stores in id->nfree.
+ * Please look into the individual functions for more details and the definition
+ * of the terminologies.
+ */
+static int
+xfs_shrinkfs_prepare_ags(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		oagcount,
+	xfs_agnumber_t		nagcount,
+	struct aghdr_init_data	*id)
+{
+
+	struct xfs_perag	*pag = NULL;
+	xfs_agnumber_t		agno;
+	int			error = 0;
+
+	ASSERT(nagcount < oagcount);
+
+	/*
+	 * Deactivating/offlining the AGs i.e waiting for the active references
+	 * to come down to 0.
+	 */
+	error = xfs_shrinkfs_deactivate_ags(mp, oagcount, nagcount);
+	if (error)
+		return error;
+	/*
+	 * At this point the AGs have been deactivated/offlined and the in-core
+	 * and the on-disk are synch. So now we need to check whether all the
+	 * AGs that we are trying to remove/delete are empty. Since we are not
+	 * supporting partial shrink success (i.e, the entire requested size
+	 * will be removed or none), we will bail out with a failure code even
+	 * if 1 AG is non-empty.
+	 */
+	for_each_agno_range_reverse(agno, oagcount, nagcount + 1) {
+		pag = xfs_perag_get(mp, agno);
+		if (!xfs_perag_is_empty(pag)) {
+			/* Error out even if one AG is non-empty */
+			xfs_perag_put(pag);
+			xfs_shrinkfs_reactivate_ags(mp, oagcount, nagcount);
+			xfs_clear_shrinking(mp);
+			return -ENOTEMPTY;
+		}
+		/*
+		 * Since these are removed, these free blocks should also be
+		 * subtracted from the total list of free blocks.
+		 */
+		id->nfree += (pag->pagf_freeblks + pag->pagf_flcount);
+		xfs_perag_put(pag);
+	}
+	return 0;
+}
+
+/*
+ * This function does the job of fully removing the blocks and empty AGs (
+ * depending of the values of oagcount and nagcount). By removal it means,
+ * removal of all the perag data structures, other data structures associated
+ * with it and all the perag cached buffers (when AGs are removed). Once this
+ * function succeeds, the AGs/blocks will no longer exist.
+ * The overall steps are as follows (details are in the function):
+ * - calculate the number of blocks that will be removed from the new tail AG
+ *   i.e, the AG that will be shrunk partially.
+ * - call xfs_shrinkfs_remove_ag() that removes the perag cached buffers,
+ *   then frees the perag reservation, other associated datastructures and
+ *   finally the in-memory perag group instance.
+ */
+static int
+xfs_shrinkfs_remove_ags(
+	struct xfs_mount	*mp,
+	struct xfs_trans	**tp,
+	xfs_agnumber_t		oagcount,
+	xfs_agnumber_t		nagcount,
+	int64_t			delta_rem,
+	xfs_agnumber_t		*nagmax)
+{
+	xfs_agnumber_t		agno;
+	int			error = 0;
+	struct xfs_perag	*cur_pag = NULL;
+
+	/*
+	 * This loop is calculating the number of blocks that needs to be
+	 * removed from the new tail AG. If delta_rem is 0 after the loop exits,
+	 * then it means that the number of blocks we want to remove is a
+	 * multiple of AG size (in blocks).
+	 */
+	for_each_agno_range_reverse(agno, oagcount, nagcount + 1) {
+		cur_pag = xfs_perag_get(mp, agno);
+		delta_rem -= xfs_ag_block_count(mp, agno);
+		xfs_perag_put(cur_pag);
+	}
+	/*
+	 * We are first removing blocks from the AG that will form the new tail
+	 * AG. The reason is that, if we encounter an error here, we can simply
+	 * reactivate the AGs (by calling xfs_shrinkfs_reactivate_ags()).
+	 * Removal of complete empty AGs always succeed anyway. However if we
+	 * remove the empty AGs first (which will succeed) and then the new
+	 * last AG shrink fails, then we will again have to re-initialize the
+	 * removed AGs. Hence the former approach seems more efficient to me.
+	 */
+	if (delta_rem) {
+		/*
+		 * Remove delta_rem blocks from the AG that will form the new
+		 * tail AG after the AGs are removed. If the number of blocks to
+		 * be removed is a multiple of AG size, then nothing is done
+		 * here.
+		 */
+		cur_pag = xfs_perag_get(mp, nagcount - 1);
+		error = xfs_ag_shrink_space(cur_pag, tp, delta_rem);
+		xfs_perag_put(cur_pag);
+		if (error) {
+			if (nagcount < oagcount)
+				xfs_shrinkfs_reactivate_ags(mp, oagcount,
+					nagcount);
+			xfs_clear_shrinking(mp);
+			return error;
+		}
+	}
+	/*
+	 * Now, in this final step we remove the perag instance and the
+	 * associated datastructures and cached buffers. This fully removes the
+	 * AG.
+	 */
+	for_each_agno_range_reverse(agno, oagcount, nagcount + 1)
+		xfs_shrinkfs_remove_ag(mp, agno);
+	*nagmax = xfs_set_inode_alloc(mp, nagcount);
+	return error;
+}
+
 /*
  * growfs operations
  */
@@ -98,10 +390,11 @@ xfs_growfs_data_private(
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
 	int64_t			delta;
+	xfs_rfsblock_t		nb_div, nb_mod;
 	bool			lastag_extended = false;
 	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};
-	struct xfs_perag	*last_pag;
+	struct xfs_perag	*last_pag = NULL;
 
 	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
 	if (error)
@@ -122,6 +415,13 @@ xfs_growfs_data_private(
 	if (error)
 		return error;
 	xfs_growfs_compute_deltas(mp, nb, &delta, &nagcount);
+	/*
+	 * Fail if the new tail AG length is < XFS_MIN_AG_BLOCKS during shrink
+	 */
+	nb_div = nb;
+	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
+	if (delta < 0 && nb_mod && nb_mod < XFS_MIN_AG_BLOCKS)
+		return -EINVAL;
 
 	/*
 	 * Reject filesystems with a single AG because they are not
@@ -135,14 +435,23 @@ xfs_growfs_data_private(
 	if (delta == 0)
 		return 0;
 
-	/* TODO: shrinking the entire AGs hasn't yet completed */
-	if (nagcount < oagcount)
-		return -EINVAL;
+	if (delta < 0)
+		xfs_set_shrinking(mp);
+
+	if (nagcount < oagcount) {
+		error = xfs_shrinkfs_prepare_ags(mp, oagcount, nagcount, &id);
+		if (error)
+			return error;
+	}
 
 	/* allocate the new per-ag structures */
 	error = xfs_initialize_perag(mp, oagcount, nagcount, nb, &nagimax);
-	if (error)
+	if (error) {
+		if (nagcount < oagcount)
+			xfs_shrinkfs_reactivate_ags(mp, oagcount, nagcount);
+		xfs_clear_shrinking(mp);
 		return error;
+	}
 
 	if (delta > 0)
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
@@ -151,18 +460,22 @@ xfs_growfs_data_private(
 	else
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata, -delta, 0,
 				0, &tp);
-	if (error)
+	if (error) {
+		if (nagcount < oagcount)
+			xfs_shrinkfs_reactivate_ags(mp, oagcount, nagcount);
 		goto out_free_unused_perag;
+	}
 
-	last_pag = xfs_perag_get(mp, oagcount - 1);
 	if (delta > 0) {
+		last_pag = xfs_perag_get(mp, oagcount - 1);
 		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
 				delta, last_pag, &lastag_extended);
+		xfs_perag_put(last_pag);
 	} else {
 		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_SHRINK);
-		error = xfs_ag_shrink_space(last_pag, &tp, -delta);
+		error = xfs_shrinkfs_remove_ags(mp, &tp, oagcount, nagcount,
+				-delta, &nagimax);
 	}
-	xfs_perag_put(last_pag);
 	if (error)
 		goto out_trans_cancel;
 
@@ -171,12 +484,26 @@ xfs_growfs_data_private(
 	 * seen by the rest of the world until the transaction commit applies
 	 * them atomically to the superblock.
 	 */
-	if (nagcount > oagcount)
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
+	if (nagcount != oagcount)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT,
+			(int64_t)nagcount - (int64_t)oagcount);
 	if (delta)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
-	if (id.nfree)
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
+	if (id.nfree) {
+		/*
+		 * If nagcount < oagcount, then the AG deactivation step
+		 * of the shrink process has already reserved the free
+		 * datablocks and subtracted it from the incore fdblock
+		 * counters. So now all we need to do is subtract 400 from the
+		 * ondisk fdblocks counters.
+		 */
+		if (nagcount < oagcount)
+			xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FDBLOCKS,
+				delta > 0 ? id.nfree : (int64_t)-id.nfree);
+		else
+			xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS,
+				delta > 0 ? id.nfree : (int64_t)-id.nfree);
+	}
 
 	/*
 	 * Sync sb counters now to reflect the updated values. This is
@@ -188,12 +515,18 @@ xfs_growfs_data_private(
 
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
-	if (error)
+	if (error) {
+		if (nagcount < oagcount)
+			xfs_shrinkfs_reactivate_ags(mp, oagcount, nagcount);
+		xfs_clear_shrinking(mp);
 		return error;
+	}
 
 	/* New allocation groups fully initialized, so update mount struct */
 	if (nagimax)
 		mp->m_maxagi = nagimax;
+	if (nagcount < oagcount)
+		mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
 	xfs_set_low_space_thresholds(mp);
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
@@ -222,7 +555,7 @@ xfs_growfs_data_private(
 		xfs_rtrmapbt_compute_maxlevels(mp);
 		xfs_rtrefcountbt_compute_maxlevels(mp);
 	}
-
+	xfs_clear_shrinking(mp);
 	return error;
 
 out_trans_cancel:
@@ -230,6 +563,7 @@ xfs_growfs_data_private(
 out_free_unused_perag:
 	if (nagcount > oagcount)
 		xfs_free_perag_range(mp, oagcount, nagcount);
+	xfs_clear_shrinking(mp);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f046d1215b04..3ee893e77ab7 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -578,6 +578,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_WARNED_ZONED	19
 /* (Zoned) GC is in progress */
 #define XFS_OPSTATE_ZONEGC_RUNNING	20
+/* filesystem is shrinking */
+#define XFS_OPSTATE_SHRINKING		21
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -600,6 +602,7 @@ __XFS_IS_OPSTATE(inode32, INODE32)
 __XFS_IS_OPSTATE(readonly, READONLY)
 __XFS_IS_OPSTATE(inodegc_enabled, INODEGC_ENABLED)
 __XFS_IS_OPSTATE(blockgc_enabled, BLOCKGC_ENABLED)
+__XFS_IS_OPSTATE(shrinking, SHRINKING)
 #ifdef CONFIG_XFS_QUOTA
 __XFS_IS_OPSTATE(quotacheck_running, QUOTACHECK_RUNNING)
 __XFS_IS_OPSTATE(resuming_quotaon, RESUMING_QUOTAON)
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 474f5a04ec63..986b15e2b5d0 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -409,7 +409,6 @@ xfs_trans_mod_sb(
 		tp->t_dblocks_delta += delta;
 		break;
 	case XFS_TRANS_SB_AGCOUNT:
-		ASSERT(delta > 0);
 		tp->t_agcount_delta += delta;
 		break;
 	case XFS_TRANS_SB_IMAXPCT:
-- 
2.43.5

