Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD5DC433E3
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 13:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7264B20738
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 13:31:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NJN5en6Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgHRNbj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 09:31:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58728 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726689AbgHRNbc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 09:31:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597757479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=5fNApR1ulwJRwWyDfPgmTeJClPdHh9gM3OxX4wQmBm0=;
        b=NJN5en6YuQPzJHm+KKKE8FQXnn9tYfeZ3g0m5HucSC/2aWTIsyUoitvUbApRovengV1LaI
        ilgYohIT9nKziwo32am/8gHHZyhoTC3jcpmBT3UrosxDTSc+vNFUCOxPvxf/p0Sx1+SVKu
        XxQi50cUe3pQtt2oblLMvhT57ug/LQU=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-WU-vPGRUPaugdzWQi4KzDQ-1; Tue, 18 Aug 2020 09:31:17 -0400
X-MC-Unique: WU-vPGRUPaugdzWQi4KzDQ-1
Received: by mail-pf1-f198.google.com with SMTP id 19so12981115pfu.20
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 06:31:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5fNApR1ulwJRwWyDfPgmTeJClPdHh9gM3OxX4wQmBm0=;
        b=CGSyEGPKYM9ZqVlxG/DBTve3Q4yeAOKat1YdZ9xrqcVOnqkO02c0BG+bwiCU0SQnfE
         rStpUyHfdsEmPKlkZRDKy5kXlaUVwSLyJo0nAzjiDdqWKJhikoFjKbO/53hu2cgN0LLZ
         avmnHEWvhY0ZymNIrDkHXgHyjrzzGWlAlan+aU/t6d66X+f/5rsmrcGm/ymJxh9FGKVJ
         cOQ9D/XX2Ft63yz2NnduT4WmVc/E9i7OD9Dy2decER5nRGo0zRohtC6DXsYi1CtY5p/a
         eNWXeXgUDNv44Bm2oIf5nb3Edx2q4gOYqPxdzpQ8jDgd8uaJQBRoCiwRPn8/tHWK8djd
         5EQA==
X-Gm-Message-State: AOAM5324T7HX7nfD1oPGlOkKXn55O2YxUp12szT8YUxx3PzrFauEEpat
        +91hPsrjbm/TLCX8q1TKkL7mSjLBNgyLmSl3QVTArVPT1j0SbN89jmWqFQe28driHMP7554aIvs
        B0LGmqKI+GNtu+3HNZyK2
X-Received: by 2002:a17:90a:f690:: with SMTP id cl16mr16976642pjb.77.1597757475697;
        Tue, 18 Aug 2020 06:31:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEjvO8p2afuEb0mYhSBozvlyGZNywEZJaKe8x2rw1lkcCz3I0Drz4pndPum/U2Uz0XkXokuA==
X-Received: by 2002:a17:90a:f690:: with SMTP id cl16mr16976609pjb.77.1597757475222;
        Tue, 18 Aug 2020 06:31:15 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h5sm24563099pfq.146.2020.08.18.06.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 06:31:14 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v4 2/3] xfs: introduce perag iunlink lock
Date:   Tue, 18 Aug 2020 21:30:14 +0800
Message-Id: <20200818133015.25398-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200818133015.25398-1-hsiangkao@redhat.com>
References: <20200724061259.5519-1-hsiangkao@redhat.com>
 <20200818133015.25398-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently, we use AGI buffer lock to protect in-memory linked
list for unlinked inodes but since it's not necessary to modify
AGI unless the head of the unlinked list is modified.

Therefore, let's add another per-AG dedicated lock to protect
the whole list, and get rid of taking AGI buffer lock in
xfs_iunlink_remove() if the head is untouched.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_inode.c        | 111 +++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_inode.h        |   1 +
 fs/xfs/xfs_iunlink_item.c |  16 ++++++
 fs/xfs/xfs_mount.c        |   4 ++
 fs/xfs/xfs_mount.h        |   9 ++++
 5 files changed, 128 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7ee778bcde06..f32a1172b5cd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -47,7 +47,7 @@ kmem_zone_t *xfs_inode_zone;
 #define	XFS_ITRUNC_MAX_EXTENTS	2
 
 STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
-STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
+STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *, bool);
 
 /*
  * helper function to extract extent size hint from inode
@@ -1398,7 +1398,7 @@ xfs_link(
 	 * Handle initial link state of O_TMPFILE inode
 	 */
 	if (VFS_I(sip)->i_nlink == 0) {
-		error = xfs_iunlink_remove(tp, sip);
+		error = xfs_iunlink_remove(tp, sip, false);
 		if (error)
 			goto error_return;
 	}
@@ -2001,6 +2001,18 @@ xfs_iunlink_insert_inode(
 	return xfs_iunlink_update_bucket(tp, agno, agibp, next_agino, agino);
 }
 
+void
+xfs_iunlink_unlock(
+	struct xfs_perag	*pag)
+{
+	/* Does not unlock AGI, ever. xfs_trans_commit() does that. */
+	if (!--pag->pag_iunlink_refcnt) {
+		smp_store_release(&pag->pag_iunlink_trans, NULL);
+		mutex_unlock(&pag->pag_iunlink_mutex);
+	}
+	xfs_perag_put(pag);
+}
+
 /*
  * This is called when the inode's link count has gone to 0 or we are creating
  * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
@@ -2017,6 +2029,7 @@ xfs_iunlink(
 	struct xfs_buf		*agibp;
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	int			error;
+	struct xfs_perag	*pag;
 
 	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(VFS_I(ip)->i_mode != 0);
@@ -2027,6 +2040,14 @@ xfs_iunlink(
 	if (error)
 		return error;
 
+	/* XXX: will be shortly removed instead in the next commit. */
+	pag = xfs_perag_get(mp, agno);
+	/* paired with smp_store_release() in xfs_iunlink_unlock() */
+	if (smp_load_acquire(&pag->pag_iunlink_trans) != tp)
+		mutex_lock(&pag->pag_iunlink_mutex);
+	WRITE_ONCE(pag->pag_iunlink_trans, tp);
+	++pag->pag_iunlink_refcnt;
+
 	/*
 	 * Insert the inode into the on disk unlinked list, and if that
 	 * succeeds, then insert it into the in memory list. We do it in this
@@ -2037,11 +2058,72 @@ xfs_iunlink(
 	if (!error)
 		list_add(&ip->i_unlink, &agibp->b_pag->pag_ici_unlink_list);
 
+	xfs_iunlink_unlock(pag);
 	return error;
 }
 
+/*
+ * Lock the perag and take AGI lock if agi_unlinked is touched as well for
+ * xfs_iunlink_remove_inode().
+ *
+ * Inode allocation in the O_TMPFILE path defines the AGI/unlinked list lock
+ * order as being AGI->perag unlinked list lock. We are inverting it here as
+ * the fast path tail addition does not need to modify the AGI at all. Hence
+ * AGI lock is only needed if the head is modified, correct locking order.
+ */
+static struct xfs_perag *
+xfs_iunlink_remove_lock(
+	xfs_agino_t		agno,
+	struct xfs_trans        *tp,
+	struct xfs_inode	*ip,
+	struct xfs_buf		**agibpp,
+	bool			force_agi)
+{
+	struct xfs_mount        *mp = tp->t_mountp;
+	struct xfs_perag	*pag;
+	int			error;
+
+	pag = xfs_perag_get(mp, agno);
+	/* paired with smp_store_release() in xfs_iunlink_unlock() */
+	if (smp_load_acquire(&pag->pag_iunlink_trans) == tp) {
+		/*
+		 * if pag_iunlink_trans is the current trans, we're
+		 * in the current process context, so it's safe here.
+		 */
+		ASSERT(mutex_is_locked(&pag->pag_iunlink_mutex));
+		goto out;
+	}
+
+	if (!force_agi) {
+		mutex_lock(&pag->pag_iunlink_mutex);
+		if (ip != list_first_entry(&pag->pag_ici_unlink_list,
+				struct xfs_inode, i_unlink))
+			goto out;
+		mutex_unlock(&pag->pag_iunlink_mutex);
+	}
+
+	/*
+	 * some paths (e.g. xfs_create_tmpfile) could take AGI lock in
+	 * this transaction in advance and we should keep the proper
+	 * locking order: AGI buf lock and then pag_iunlink_mutex.
+	 */
+	error = xfs_read_agi(mp, tp, agno, agibpp);
+	if (error) {
+		xfs_perag_put(pag);
+		return ERR_PTR(error);
+	}
+
+	mutex_lock(&pag->pag_iunlink_mutex);
+	ASSERT(!pag->pag_iunlink_refcnt);
+out:
+	WRITE_ONCE(pag->pag_iunlink_trans, tp);
+	++pag->pag_iunlink_refcnt;
+	return pag;
+}
+
 static int
 xfs_iunlink_remove_inode(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agibp,
 	struct xfs_inode	*ip)
@@ -2055,7 +2137,7 @@ xfs_iunlink_remove_inode(
 	 * Get the next agino in the list. If we are at the end of the list,
 	 * then the previous inode's i_next_unlinked filed will get cleared.
 	 */
-	if (ip != list_last_entry(&agibp->b_pag->pag_ici_unlink_list,
+	if (ip != list_last_entry(&pag->pag_ici_unlink_list,
 					struct xfs_inode, i_unlink)) {
 		struct xfs_inode *nip = list_next_entry(ip, i_unlink);
 
@@ -2065,7 +2147,7 @@ xfs_iunlink_remove_inode(
 	/* Clear the on disk next unlinked pointer for this inode. */
 	xfs_iunlink_log(tp, ip, next_agino, NULLAGINO);
 
-	if (ip != list_first_entry(&agibp->b_pag->pag_ici_unlink_list,
+	if (ip != list_first_entry(&pag->pag_ici_unlink_list,
 					struct xfs_inode, i_unlink)) {
 		struct xfs_inode *pip = list_prev_entry(ip, i_unlink);
 
@@ -2073,6 +2155,7 @@ xfs_iunlink_remove_inode(
 		return 0;
 	}
 
+	ASSERT(agibp);
 	/* Point the head of the list to the next unlinked inode. */
 	return xfs_iunlink_update_bucket(tp, agno, agibp, agino, next_agino);
 }
@@ -2083,27 +2166,29 @@ xfs_iunlink_remove_inode(
 STATIC int
 xfs_iunlink_remove(
 	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	bool			force_agi)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_buf		*agibp;
+	struct xfs_buf		*agibp = NULL;
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	struct xfs_perag	*pag;
 	int			error;
 
 	trace_xfs_iunlink_remove(ip);
 
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(mp, tp, agno, &agibp);
-	if (error)
-		return error;
+	pag = xfs_iunlink_remove_lock(agno, tp, ip, &agibp, force_agi);
+	if (IS_ERR(pag))
+		return PTR_ERR(pag);
 
 	/*
 	 * Remove the inode from the on-disk list and then remove it from the
 	 * in-memory list. This order of operations ensures we can look up both
 	 * next and previous inode in the on-disk list via the in-memory list.
 	 */
-	error = xfs_iunlink_remove_inode(tp, agibp, ip);
+	error = xfs_iunlink_remove_inode(pag, tp, agibp, ip);
 	list_del(&ip->i_unlink);
+	xfs_iunlink_unlock(pag);
 	return error;
 }
 
@@ -2316,7 +2401,7 @@ xfs_ifree(
 	if (error)
 		return error;
 
-	error = xfs_iunlink_remove(tp, ip);
+	error = xfs_iunlink_remove(tp, ip, false);
 	if (error)
 		return error;
 
@@ -2895,7 +2980,7 @@ xfs_rename(
 	 */
 	if (wip) {
 		ASSERT(VFS_I(wip)->i_nlink == 0);
-		error = xfs_iunlink_remove(tp, wip);
+		error = xfs_iunlink_remove(tp, wip, true);
 		if (error)
 			goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7f8fbb7c8594..d0a221af71db 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -468,5 +468,6 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_iunlink_unlock(struct xfs_perag *pag);
 
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
index 2ee05f98aa97..ae1e73e465b2 100644
--- a/fs/xfs/xfs_iunlink_item.c
+++ b/fs/xfs/xfs_iunlink_item.c
@@ -16,6 +16,7 @@
 #include "xfs_iunlink_item.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_sb.h"
 
 struct kmem_cache	*xfs_iunlink_zone;
 
@@ -28,6 +29,13 @@ static void
 xfs_iunlink_item_release(
 	struct xfs_log_item	*lip)
 {
+	struct xfs_mount	*mp = lip->li_mountp;
+	struct xfs_inode        *ip = IUL_ITEM(lip)->iu_ip;
+	struct xfs_perag	*pag;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	ASSERT(mutex_is_locked(&pag->pag_iunlink_mutex));
+	xfs_iunlink_unlock(pag);
 	kmem_cache_free(xfs_iunlink_zone, IUL_ITEM(lip));
 }
 
@@ -150,7 +158,9 @@ xfs_iunlink_log(
 	xfs_agino_t		old_agino,
 	xfs_agino_t		next_agino)
 {
+	struct xfs_mount        *mp = tp->t_mountp;
 	struct xfs_iunlink_item	*iup;
+	struct xfs_perag	*pag;
 
 	iup = kmem_cache_zalloc(xfs_iunlink_zone, GFP_KERNEL | __GFP_NOFAIL);
 
@@ -164,5 +174,11 @@ xfs_iunlink_log(
 	xfs_trans_add_item(tp, &iup->iu_item);
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &iup->iu_item.li_flags);
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	ASSERT(mutex_is_locked(&pag->pag_iunlink_mutex));
+	ASSERT(pag->pag_iunlink_trans == tp);
+	++pag->pag_iunlink_refcnt;
+	xfs_perag_put(pag);
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f28c969af272..82d264a3350d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -224,6 +224,10 @@ xfs_initialize_perag(
 		if (first_initialised == NULLAGNUMBER)
 			first_initialised = index;
 		spin_lock_init(&pag->pag_state_lock);
+
+		mutex_init(&pag->pag_iunlink_mutex);
+		pag->pag_iunlink_refcnt = 0;
+		pag->pag_iunlink_trans = NULL;
 	}
 
 	index = xfs_set_inode_alloc(mp, agcount);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 98109801a995..fca4c1d28d8e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -372,6 +372,15 @@ typedef struct xfs_perag {
 
 	/* reference count */
 	uint8_t			pagf_refcount_level;
+
+	/* lock to protect unlinked inode list and refcnt */
+	struct mutex            pag_iunlink_mutex;
+
+	/* recursive count of pag_iunlink_mutex */
+	unsigned int		pag_iunlink_refcnt;
+
+	/* (lockless) by which pag_iunlink_mutex is taken */
+	struct xfs_trans	*pag_iunlink_trans;
 } xfs_perag_t;
 
 static inline struct xfs_ag_resv *
-- 
2.18.1

