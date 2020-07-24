Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99EE7C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 06:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7397620714
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 06:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H0+oaLr7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgGXGN7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 02:13:59 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26250 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726539AbgGXGN7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 02:13:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595571238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=EErgKm4WWBz+GEyxWgHWlNohF/fDsGVkUyWSU2ZPBSU=;
        b=H0+oaLr7ic9MuB444ZRQHMrSwXWlDkPBUrmysOVfZD7npzE7RalZmWyV5cUiuhABkbU6sJ
        4UIaYubURpZsBL1R/2ojwVeYdaozdZKOp/SpzcX/BxGsj+t3t8JcaxS3a5iJf02CHhUFCK
        4TXe5BssmFHcK4fDGQFvrRb1QBa7tf8=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-TfppMMQANfmQQAv6KboAkw-1; Fri, 24 Jul 2020 02:13:54 -0400
X-MC-Unique: TfppMMQANfmQQAv6KboAkw-1
Received: by mail-pj1-f71.google.com with SMTP id q5so4922169pjd.3
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jul 2020 23:13:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EErgKm4WWBz+GEyxWgHWlNohF/fDsGVkUyWSU2ZPBSU=;
        b=jEk70u4YzB81GmdEywmEAkW85ceRqJC2AKLuHqA1VjnbGW5icQ6hD67JQG8o458pAj
         y9b4jqkv6kLll0O/b5OjRUgpSdwq1uymQ8bpdLYHNoSBc84e6ZwmuyKptxaLTzt11iIl
         zAMn6WvoERc5o/QdjE/hVlw2d8GFAHR1yFktQ4E+yQ+Hg0f5Zb/DTh3xSYA/LSiMmODp
         1Gjmn3wimjHNQDK+TUTQbNzGSkkZdaV8MCZ0qHEu/Se4NIkTYmdpI0M9o7SL7YYxfzkU
         H/xvPQ+I5yaejTKFkQcyAAJePaQ0kvpVe8vFhkH3fWkbKNgu8cUWBmvt27p7fksQgmlB
         Cwow==
X-Gm-Message-State: AOAM530kvdNc6F/138XYD4OV0lWzAXhUYd+1GCd4304CWM6qXjwXbETG
        A/0MKdTpsfezjcwGRthGRazXLEGHkg61JYWSAkrdYJcxpWH7K/AK8TWeG865ouM4Jn91BZ7XJl6
        sHfw7plos6UDq8f+7j6UU
X-Received: by 2002:a17:90a:c915:: with SMTP id v21mr3916298pjt.48.1595571232706;
        Thu, 23 Jul 2020 23:13:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXxtUF4SFs2eZgwTp7ybL6EyK1Tjj5gqtBfSIzJYs/nbIBN3KW7C2Ds/Nq3ZG/zO5qOKy6tQ==
X-Received: by 2002:a17:90a:c915:: with SMTP id v21mr3916279pjt.48.1595571232431;
        Thu, 23 Jul 2020 23:13:52 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n15sm4899232pjf.12.2020.07.23.23.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 23:13:52 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v2 2/3] xfs: introduce perag iunlink lock
Date:   Fri, 24 Jul 2020 14:12:58 +0800
Message-Id: <20200724061259.5519-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200724061259.5519-1-hsiangkao@redhat.com>
References: <20200707135741.487-1-hsiangkao@redhat.com>
 <20200724061259.5519-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently, we use AGI buffer lock to protect in-memory linked list
for unlinked inodes but since it's not necessary to modify AGI
unless the head of the unlinked list is modified.

Therefore, let's add another per-AG dedicated lock to protect the
whole list, and removing AGI buffer lock in xfs_iunlink_remove()
if the head is untouched.

Note that some paths (e.g. xfs_create_tmpfile()) take AGI lock in
its transaction in advance, so the proper locking order is only
AGI lock -> unlinked list lock.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_inode.c | 79 ++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_mount.c |  1 +
 fs/xfs/xfs_mount.h |  3 ++
 3 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4994398373df..d78aaa8ce252 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2039,6 +2039,46 @@ xfs_iunlink_insert_inode(
 	return xfs_iunlink_update_bucket(tp, agno, agibp, 0, agino);
 }
 
+/*
+ * Lock the perag and take AGI lock if agi_unlinked is touched as well for
+ * xfs_iunlink_remove_inode().
+ *
+ * Inode allocation in the O_TMPFILE path defines the AGI/unlinked list lock
+ * order as being AGI->perag unlinked list lock. We are inverting it here as
+ * the fast path tail addition does not need to modify the AGI at all. Hence
+ * we only need the AGI lock if the tail is empty, correct lock order.
+ */
+static struct xfs_perag *
+xfs_iunlink_remove_lock(
+	xfs_agino_t		agno,
+	struct xfs_trans        *tp,
+	struct xfs_inode	*ip,
+	struct xfs_buf		**agibpp)
+{
+	struct xfs_mount        *mp = tp->t_mountp;
+	struct xfs_perag	*pag;
+	int			error;
+
+	pag = xfs_perag_get(mp, agno);
+	mutex_lock(&pag->pag_unlinked_mutex);
+
+	if (ip->i_prev_unlinked == NULLAGINO) {
+		mutex_unlock(&pag->pag_unlinked_mutex);
+		/*
+		 * some paths (e.g. xfs_create_tmpfile) could take AGI lock
+		 * in this transaction in advance and the only locking order
+		 * AGI buf lock -> pag_unlinked_mutex is safe.
+		 */
+		error = xfs_read_agi(mp, tp, agno, agibpp);
+		if (error) {
+			xfs_perag_put(pag);
+			return ERR_PTR(error);
+		}
+		mutex_lock(&pag->pag_unlinked_mutex);
+	}
+	return pag;
+}
+
 /*
  * Remove can be from anywhere in the list, so we have to do two adjacent inode
  * lookups here so we can update list pointers. We may be at the head or the
@@ -2046,12 +2086,12 @@ xfs_iunlink_insert_inode(
  */
 static int
 xfs_iunlink_remove_inode(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agibp,
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi = agibp->b_addr;
 	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		next_agino = ip->i_next_unlinked;
@@ -2059,6 +2099,7 @@ xfs_iunlink_remove_inode(
 
 	if (ip->i_prev_unlinked == NULLAGINO) {
 		struct xlog	*log = mp->m_log;
+		struct xfs_agi	*agi = agibp->b_addr;
 		short		bucket_index = 0;
 
 		/* During recovery, the old multiple bucket can be applied */
@@ -2083,7 +2124,7 @@ xfs_iunlink_remove_inode(
 		/* lookup previous inode and update to point at next */
 		struct xfs_inode	*pip;
 
-		pip = xfs_iunlink_lookup_prev(agibp->b_pag, ip);
+		pip = xfs_iunlink_lookup_prev(pag, ip);
 		if (IS_ERR_OR_NULL(pip))
 			return -EFSCORRUPTED;
 
@@ -2102,7 +2143,7 @@ xfs_iunlink_remove_inode(
 	if (ip->i_next_unlinked != NULLAGINO) {
 		struct xfs_inode	*nip;
 
-		nip = xfs_iunlink_lookup_next(agibp->b_pag, ip);
+		nip = xfs_iunlink_lookup_next(pag, ip);
 		if (IS_ERR_OR_NULL(nip))
 			return -EFSCORRUPTED;
 
@@ -2126,6 +2167,15 @@ xfs_iunlink_remove_inode(
 	return 0;
 }
 
+static void
+xfs_iunlink_unlock(
+	struct xfs_perag	*pag)
+{
+	/* Does not unlock AGI, ever. xfs_trans_commit() does that. */
+	mutex_unlock(&pag->pag_unlinked_mutex);
+	xfs_perag_put(pag);
+}
+
 /*
  * This is called when the inode's link count has gone to 0 or we are creating
  * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
@@ -2143,7 +2193,6 @@ xfs_iunlink(
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	int			error;
 
-	ASSERT(ip->i_next_unlinked == NULLAGINO);
 	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(VFS_I(ip)->i_mode != 0);
 	trace_xfs_iunlink(ip);
@@ -2153,7 +2202,10 @@ xfs_iunlink(
 	if (error)
 		return error;
 
-	return xfs_iunlink_insert_inode(tp, agibp, ip);
+	mutex_lock(&agibp->b_pag->pag_unlinked_mutex);
+	error = xfs_iunlink_insert_inode(tp, agibp, ip);
+	mutex_unlock(&agibp->b_pag->pag_unlinked_mutex);
+	return error;
 }
 
 /*
@@ -2164,19 +2216,20 @@ xfs_iunlink_remove(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip)
 {
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_buf		*agibp;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	struct xfs_buf		*agibp = NULL;
+	struct xfs_perag	*pag;
 	int			error;
 
 	trace_xfs_iunlink_remove(ip);
 
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(mp, tp, agno, &agibp);
-	if (error)
-		return error;
+	pag = xfs_iunlink_remove_lock(XFS_INO_TO_AGNO(tp->t_mountp, ip->i_ino),
+		tp, ip, &agibp);
+	if (IS_ERR(pag))
+		return PTR_ERR(pag);
 
-	return xfs_iunlink_remove_inode(tp, agibp, ip);
+	error = xfs_iunlink_remove_inode(pag, tp, agibp, ip);
+	xfs_iunlink_unlock(pag);
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 031e96ff022d..f94e14059e61 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -223,6 +223,7 @@ xfs_initialize_perag(
 		if (first_initialised == NULLAGNUMBER)
 			first_initialised = index;
 		spin_lock_init(&pag->pag_state_lock);
+		mutex_init(&pag->pag_unlinked_mutex);
 	}
 
 	index = xfs_set_inode_alloc(mp, agcount);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a72cfcaa4ad1..9a1d0f239fa4 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -372,6 +372,9 @@ typedef struct xfs_perag {
 	/* reference count */
 	uint8_t			pagf_refcount_level;
 
+	/* lock to protect unlinked inode list */
+	struct mutex            pag_unlinked_mutex;
+
 	/*
 	 * Unlinked inode information.  This incore information reflects
 	 * data stored in the AGI, so callers must hold the AGI buffer lock
-- 
2.18.1

