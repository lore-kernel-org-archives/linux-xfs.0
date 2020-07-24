Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32ACDC433E5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 06:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E57520714
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 06:14:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VDQyrPgP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgGXGOC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 02:14:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31851 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726539AbgGXGOC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 02:14:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595571240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=SqeFsJ0aJwClQe3JpaTAOGzLruqTfdvKRMMbU8DxMEE=;
        b=VDQyrPgPhy0OC9PGE6yIAUqbSO5PNC7GoQJl6S7wxudRmxyQcG6RWQzb6rxxlewtuD0uxm
        YYu5ceA2Y/0HvnnABt25pvfzXP/3yG/Yw9cUdWc3JOxk9W02Bu49XFf+Rlplkii/fvYplj
        l+MNfp2AVM3J/PL016fOY2cxdze87UI=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-sGSMASS9NWuchUa7EA8TaA-1; Fri, 24 Jul 2020 02:13:58 -0400
X-MC-Unique: sGSMASS9NWuchUa7EA8TaA-1
Received: by mail-pf1-f199.google.com with SMTP id h75so5588101pfe.23
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jul 2020 23:13:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SqeFsJ0aJwClQe3JpaTAOGzLruqTfdvKRMMbU8DxMEE=;
        b=eBBg/ZAlC2cEyx7FWZMLuKt+wq9f3HsfwhfpT9nph6zjAKwibyX81Bdk374Cdfjgy9
         0zGidB7UnXlHXKf86vdF13Uq56giwhTzNfSlwvLYnc0kfFsgRRvcF8IAspbbax3ioVMW
         x6WWLnoil2RVIKDTzqLIAcoTe7ZItxPgur8Y1miLDfhbfv/GG9caRiZ/8eldsJpeknfX
         qw9nS6Wzq91GmTdrgloJLuV4LrYagS1A8udh0CXRlmmAE+Uaa9S7wqHEiBLk6NfWmcXD
         QYlrRenMT88a1E2MfpuxsYxKxPTv7RSdBqA/wQGyYksVH6sMq4bPYDoWqMPps+fMt8yS
         zVWA==
X-Gm-Message-State: AOAM533jCaNOjK8yzqremlJi8Gkq+v/2ii07RY9fON4mudyGXE8Leb7i
        K9ZeYdXbfWcUKK1d8m7ylJ3OQsiNOULew6cFLs01viXiHhYRkE8EhlpdQyFykCs3Cop6QNogQHC
        cQyqakZrnV9mvSXxJ6k9i
X-Received: by 2002:a62:1e43:: with SMTP id e64mr7010914pfe.249.1595571236612;
        Thu, 23 Jul 2020 23:13:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6vhxj0Lfw9p5TKyz28cO1zM1mBzm0ezYOw0ZeGVlWlMW5lwOsZ8tSlMMsJg4oFV/OP5dv1g==
X-Received: by 2002:a62:1e43:: with SMTP id e64mr7010894pfe.249.1595571236251;
        Thu, 23 Jul 2020 23:13:56 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n15sm4899232pjf.12.2020.07.23.23.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 23:13:55 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v2 3/3] xfs: insert unlinked inodes from tail
Date:   Fri, 24 Jul 2020 14:12:59 +0800
Message-Id: <20200724061259.5519-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200724061259.5519-1-hsiangkao@redhat.com>
References: <20200707135741.487-1-hsiangkao@redhat.com>
 <20200724061259.5519-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently, AGI buffer is always touched since xfs_iunlink()
adds unlinked inodes from head unconditionally, but since we
now have the only one unlinked list and if we insert unlinked
inodes from tail instead and there're more than 1 inodes, AGI
buffer modification could be avoided.

In order to do that, let's keep track of the tail of unlinked
inode into the perag all the time in order for xfs_iunlink()
to use.

With this change, it shows that only 938 of 10000 operations
modifies the head of unlinked list with the following workload:
 seq 1 10000 | xargs touch
 find . | xargs -n3 -P100 rm

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_inode.c       | 120 ++++++++++++++++++++++++---------------
 fs/xfs/xfs_log_recover.c |   5 ++
 fs/xfs/xfs_mount.c       |   1 +
 fs/xfs/xfs_mount.h       |   3 +
 4 files changed, 84 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d78aaa8ce252..3cfd84b76955 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1986,6 +1986,38 @@ xfs_iunlink_update_bucket(
 	return 0;
 }
 
+/*
+ * Lock the perag and take AGI lock if agi_unlinked is touched as well
+ * for xfs_iunlink_insert_inode(). As for the details of locking order,
+ * refer to the comments of xfs_iunlink_remove_lock().
+ */
+static struct xfs_perag *
+xfs_iunlink_insert_lock(
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
+	if (!pag->pag_unlinked_tail) {
+		mutex_unlock(&pag->pag_unlinked_mutex);
+
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
  * Always insert at the head, so we only have to do a next inode lookup to
  * update it's prev pointer. The AGI bucket will point at the one we are
@@ -1993,50 +2025,47 @@ xfs_iunlink_update_bucket(
  */
 static int
 xfs_iunlink_insert_inode(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agibp,
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi = agibp->b_addr;
-	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	struct xfs_inode	*pip = pag->pag_unlinked_tail;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		next_agino;
 
-	/*
-	 * Get the index into the agi hash table for the list this inode will
-	 * go on.  Make sure the pointer isn't garbage and that this inode
-	 * isn't already on the list.
-	 */
-	next_agino = be32_to_cpu(agi->agi_unlinked[0]);
-	if (next_agino == agino ||
-	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
-		xfs_buf_mark_corrupt(agibp);
-		return -EFSCORRUPTED;
-	}
-
-	ip->i_prev_unlinked = NULLAGINO;
-	ip->i_next_unlinked = next_agino;
-	if (ip->i_next_unlinked != NULLAGINO) {
-		struct xfs_inode	*nip;
-
-		nip = xfs_iunlink_lookup_next(agibp->b_pag, ip);
-		if (IS_ERR_OR_NULL(nip))
-			return -EFSCORRUPTED;
+	if (!pip) {
+		xfs_agino_t	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+		struct xfs_agi	*agi = agibp->b_addr;
+		int		error;
 
-		if (nip->i_prev_unlinked != NULLAGINO) {
-			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
-						NULL, 0, __this_address);
+		ip->i_prev_unlinked = NULLAGINO;
+		/*
+		 * Get the index into the agi hash table for the list this
+		 * inode will go on.  Make sure the pointer isn't garbage
+		 * and that this inode isn't already on the list.
+		 */
+		next_agino = be32_to_cpu(agi->agi_unlinked[0]);
+		if (next_agino == agino ||
+		    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
+			xfs_buf_mark_corrupt(agibp);
 			return -EFSCORRUPTED;
 		}
-		nip->i_prev_unlinked = agino;
 
-		/* update the on disk inode now */
-		xfs_iunlink_log(tp, ip);
+		/* Point the head of the list to point to this inode. */
+		error = xfs_iunlink_update_bucket(tp, agno, agibp, 0, agino);
+		if (error)
+			return error;
+	} else {
+		ip->i_prev_unlinked = XFS_INO_TO_AGINO(mp, pip->i_ino);
+		ASSERT(pip->i_next_unlinked == NULLAGINO);
+		pip->i_next_unlinked = agino;
+		xfs_iunlink_log(tp, pip);
 	}
-
-	/* Point the head of the list to point to this inode. */
-	return xfs_iunlink_update_bucket(tp, agno, agibp, 0, agino);
+	ip->i_next_unlinked = NULLAGINO;
+	pag->pag_unlinked_tail = ip;
+	return 0;
 }
 
 /*
@@ -2095,6 +2124,7 @@ xfs_iunlink_remove_inode(
 	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		next_agino = ip->i_next_unlinked;
+	struct xfs_inode	*pip = NULL;
 	int			error;
 
 	if (ip->i_prev_unlinked == NULLAGINO) {
@@ -2122,8 +2152,6 @@ xfs_iunlink_remove_inode(
 			return -EFSCORRUPTED;
 	} else {
 		/* lookup previous inode and update to point at next */
-		struct xfs_inode	*pip;
-
 		pip = xfs_iunlink_lookup_prev(pag, ip);
 		if (IS_ERR_OR_NULL(pip))
 			return -EFSCORRUPTED;
@@ -2139,8 +2167,12 @@ xfs_iunlink_remove_inode(
 		xfs_iunlink_log(tp, pip);
 	}
 
-	/* lookup the next inode and update to point at prev */
-	if (ip->i_next_unlinked != NULLAGINO) {
+	if (next_agino == NULLAGINO) {
+		/* only care about the tail of bucket 0 for xfs_iunlink() */
+		if (pag->pag_unlinked_tail == ip)
+			pag->pag_unlinked_tail = pip;
+	} else {
+		/* lookup the next inode and update to point at prev */
 		struct xfs_inode	*nip;
 
 		nip = xfs_iunlink_lookup_next(pag, ip);
@@ -2188,23 +2220,21 @@ xfs_iunlink(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip)
 {
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_buf		*agibp;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	struct xfs_buf		*agibp = NULL;
+	struct xfs_perag	*pag;
 	int			error;
 
 	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(VFS_I(ip)->i_mode != 0);
 	trace_xfs_iunlink(ip);
 
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(mp, tp, agno, &agibp);
-	if (error)
-		return error;
+	pag = xfs_iunlink_insert_lock(XFS_INO_TO_AGNO(tp->t_mountp, ip->i_ino),
+		tp, ip, &agibp);
+	if (IS_ERR(pag))
+		return PTR_ERR(pag);
 
-	mutex_lock(&agibp->b_pag->pag_unlinked_mutex);
-	error = xfs_iunlink_insert_inode(tp, agibp, ip);
-	mutex_unlock(&agibp->b_pag->pag_unlinked_mutex);
+	error = xfs_iunlink_insert_inode(pag, tp, agibp, ip);
+	xfs_iunlink_unlock(pag);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d47eea31c165..30198aea7335 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2801,6 +2801,11 @@ xlog_recover_iunlink_ag(
 					prev_ip->i_next_unlinked = NULLAGINO;
 				break;
 			}
+
+			/* XXX: take pag_unlinked_mutex across the loop? */
+			if (!bucket)
+				agibp->b_pag->pag_unlinked_tail = ip;
+
 			if (prev_ip) {
 				ip->i_prev_unlinked = prev_agino;
 				xfs_irele(prev_ip);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f94e14059e61..f1cd3e9c4da5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -224,6 +224,7 @@ xfs_initialize_perag(
 			first_initialised = index;
 		spin_lock_init(&pag->pag_state_lock);
 		mutex_init(&pag->pag_unlinked_mutex);
+		pag->pag_unlinked_tail = NULL;
 	}
 
 	index = xfs_set_inode_alloc(mp, agcount);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 9a1d0f239fa4..934e7c373042 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -375,6 +375,9 @@ typedef struct xfs_perag {
 	/* lock to protect unlinked inode list */
 	struct mutex            pag_unlinked_mutex;
 
+	/* point to the inode tail of AGI unlinked bucket 0 */
+	struct xfs_inode	*pag_unlinked_tail;
+
 	/*
 	 * Unlinked inode information.  This incore information reflects
 	 * data stored in the AGI, so callers must hold the AGI buffer lock
-- 
2.18.1

