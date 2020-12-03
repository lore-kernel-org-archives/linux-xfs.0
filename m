Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C600C4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 16:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF1D1207A9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 16:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgLCQNH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 11:13:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbgLCQNH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 11:13:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607011899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=QtxHLYFnQFMGlNsGbpTOi8YuiITkcskRAh1vGUSSi64=;
        b=QRasIQeiejeBMDgv92MfT98rphwXciR2c3LQeFCh/l/lJzM0FeN4V2wwYg7j6WnL6fUByw
        hEZs8nEmFK818y6HEMUMPeDGiCfibCN2wTNjh1bIvdkXzlB7GfNuvZ9Y2flvGhMOCcSymt
        D6+rU/OZVVXJzWcHMuzwZyrKoPYdVfE=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-cnLOmJjMMQ2UImCLaIjxqg-1; Thu, 03 Dec 2020 11:11:36 -0500
X-MC-Unique: cnLOmJjMMQ2UImCLaIjxqg-1
Received: by mail-pl1-f200.google.com with SMTP id x17so1451588pll.8
        for <linux-xfs@vger.kernel.org>; Thu, 03 Dec 2020 08:11:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QtxHLYFnQFMGlNsGbpTOi8YuiITkcskRAh1vGUSSi64=;
        b=VRbDP0Sn6ZUN/x7kjoJ+Km75kif7oJ7Ef4E4/TcnUoxcyLbr26P8NqIaNvQgm68z9v
         rgLZ4n/7expHJpp/xYgsgbaC1rm3O8oVfIkvJbzbthHm6Hc+HL5+k2sCBzlZrrQv8vJU
         gKT21KVr6F70rFHTqVTvwGbz5eqeIwGEYm+OoG6Zb0jin6Lj2OogjEzaJeuMsvRzF3Rc
         vp0y3xFyN4yADMj6uuM4krtTPv6EIg6gG94N+eBHp9J5f03K6ZBjgxRg2aJ41ktS3AQH
         5DZ9QNBdsgAgE8VLTJl/Qd1tdUSsWQEh9LiKSBhqbt+QcJuGIR62ifgrNw+9dPBLKPtw
         aLTw==
X-Gm-Message-State: AOAM532WGEWY+YQtFMXx6Q16WivBQATgg/KgruOqOEqB8lFsQGFroUE/
        ESKsEZxhHRrem9bKbVPX9ryEW+kee7mTZdyXx61rv9IFsR8is+vdIhx6ewQTmarK2oeO8OY7RK6
        MToPLJG/g94CdUc7xWu6QTYtB/1YXjcLIWvGyuIRprWsP5VIu9aS1jkIMxAf6T9tJLyKt5iljOg
        ==
X-Received: by 2002:a65:4887:: with SMTP id n7mr3679376pgs.85.1607011894515;
        Thu, 03 Dec 2020 08:11:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznAkyzhga/zc1Khy294sjjSvM47TvbTUt3i6zv8F/f9iPp11RQaAHDbD2vex5RjvSOZCMEfg==
X-Received: by 2002:a65:4887:: with SMTP id n7mr3679348pgs.85.1607011893976;
        Thu, 03 Dec 2020 08:11:33 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l1sm1738798pgg.4.2020.12.03.08.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 08:11:33 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v2 3/6] xfs: move on-disk inode allocation out of xfs_ialloc()
Date:   Fri,  4 Dec 2020 00:10:25 +0800
Message-Id: <20201203161028.1900929-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201203161028.1900929-1-hsiangkao@redhat.com>
References: <20201203161028.1900929-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So xfs_ialloc() will only address in-core inode allocation then.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_inode.c | 200 +++++++++++++++------------------------------
 1 file changed, 65 insertions(+), 135 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4ebfb1a18f0f..34eca1624397 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -761,68 +761,25 @@ xfs_inode_inherit_flags2(
 }
 
 /*
- * Allocate an inode on disk and return a copy of its in-core version.
- * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
- * appropriately within the inode.  The uid and gid for the inode are
- * set according to the contents of the given cred structure.
- *
- * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
- * has a free inode available, call xfs_iget() to obtain the in-core
- * version of the allocated inode.  Finally, fill in the inode and
- * log its initial contents.  In this case, ialloc_context would be
- * set to NULL.
- *
- * If xfs_dialloc() does not have an available inode, it will replenish
- * its supply by doing an allocation. Since we can only do one
- * allocation within a transaction without deadlocks, we must commit
- * the current transaction before returning the inode itself.
- * In this case, therefore, we will set ialloc_context and return.
- * The caller should then commit the current transaction, start a new
- * transaction, and call xfs_ialloc() again to actually get the inode.
- *
- * To ensure that some other process does not grab the inode that
- * was allocated during the first call to xfs_ialloc(), this routine
- * also returns the [locked] bp pointing to the head of the freelist
- * as ialloc_context.  The caller should hold this buffer across
- * the commit and pass it back into this routine on the second call.
- *
- * If we are allocating quota inodes, we do not have a parent inode
- * to attach to or associate with (i.e. pip == NULL) because they
- * are not linked into the directory structure - they are attached
- * directly to the superblock - and so have no parent.
+ * Initialise a newly allocated inode and return the in-core inode to the
+ * caller locked exclusively.
  */
-static int
+static struct xfs_inode *
 xfs_ialloc(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*pip,
-	umode_t		mode,
-	xfs_nlink_t	nlink,
-	dev_t		rdev,
-	prid_t		prid,
-	xfs_buf_t	**ialloc_context,
-	xfs_inode_t	**ipp)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*pip,
+	xfs_ino_t		ino,
+	umode_t			mode,
+	xfs_nlink_t		nlink,
+	dev_t			rdev,
+	prid_t			prid)
 {
-	struct xfs_mount *mp = tp->t_mountp;
-	xfs_ino_t	ino;
-	xfs_inode_t	*ip;
-	uint		flags;
-	int		error;
-	struct timespec64 tv;
-	struct inode	*inode;
-
-	/*
-	 * Call the space management code to pick
-	 * the on-disk inode to be allocated.
-	 */
-	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode,
-			    ialloc_context, &ino);
-	if (error)
-		return error;
-	if (*ialloc_context || ino == NULLFSINO) {
-		*ipp = NULL;
-		return 0;
-	}
-	ASSERT(*ialloc_context == NULL);
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*ip;
+	unsigned int		flags;
+	int			error;
+	struct timespec64	tv;
+	struct inode		*inode;
 
 	/*
 	 * Protect against obviously corrupt allocation btree records. Later
@@ -833,18 +790,16 @@ xfs_ialloc(
 	 */
 	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
 		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
-		return -EFSCORRUPTED;
+		return ERR_PTR(-EFSCORRUPTED);
 	}
 
 	/*
-	 * Get the in-core inode with the lock held exclusively.
-	 * This is because we're setting fields here we need
-	 * to prevent others from looking at until we're done.
+	 * Get the in-core inode with the lock held exclusively to prevent
+	 * others from looking at until we're done.
 	 */
-	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE,
-			 XFS_ILOCK_EXCL, &ip);
+	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE, XFS_ILOCK_EXCL, &ip);
 	if (error)
-		return error;
+		return ERR_PTR(error);
 	ASSERT(ip != NULL);
 	inode = VFS_I(ip);
 	inode->i_mode = mode;
@@ -926,20 +881,19 @@ xfs_ialloc(
 
 	/* now that we have an i_mode we can setup the inode structure */
 	xfs_setup_inode(ip);
-
-	*ipp = ip;
-	return 0;
+	return ip;
 }
 
 /*
- * Allocates a new inode from disk and return a pointer to the
- * incore copy. This routine will internally commit the current
- * transaction and allocate a new one if the Space Manager needed
- * to do an allocation to replenish the inode free-list.
- *
- * This routine is designed to be called from xfs_create and
- * xfs_create_dir.
+ * Allocates a new inode from disk and return a pointer to the incore copy. This
+ * routine will internally commit the current transaction and allocate a new one
+ * if we needed to allocate more on-disk free inodes to perform the requested
+ * operation.
  *
+ * If we are allocating quota inodes, we do not have a parent inode to attach to
+ * or associate with (i.e. dp == NULL) because they are not linked into the
+ * directory structure - they are attached directly to the superblock - and so
+ * have no parent.
  */
 int
 xfs_dir_ialloc(
@@ -954,83 +908,59 @@ xfs_dir_ialloc(
 	xfs_inode_t	**ipp)		/* pointer to inode; it will be
 					   locked. */
 {
-	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
 	xfs_buf_t	*ialloc_context = NULL;
-	int		code;
-
-	tp = *tpp;
-	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+	xfs_ino_t	pino = dp ? dp->i_ino : 0;
+	xfs_ino_t	ino;
+	int		error;
 
-	/*
-	 * xfs_ialloc will return a pointer to an incore inode if
-	 * the Space Manager has an available inode on the free
-	 * list. Otherwise, it will do an allocation and replenish
-	 * the freelist.  Since we can only do one allocation per
-	 * transaction without deadlocks, we will need to commit the
-	 * current transaction and start a new one.  We will then
-	 * need to call xfs_ialloc again to get the inode.
-	 *
-	 * If xfs_ialloc did an allocation to replenish the freelist,
-	 * it returns the bp containing the head of the freelist as
-	 * ialloc_context. We will hold a lock on it across the
-	 * transaction commit so that no other process can steal
-	 * the inode(s) that we've just allocated.
-	 */
-	code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid, &ialloc_context,
-			&ip);
+	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
+	*ipp = NULL;
 
 	/*
-	 * Return an error if we were unable to allocate a new inode.
-	 * This should only happen if we run out of space on disk or
-	 * encounter a disk error.
+	 * Call the space management code to pick the on-disk inode to be
+	 * allocated and replenish the freelist.  Since we can only do one
+	 * allocation per transaction without deadlocks, we will need to
+	 * commit the current transaction and start a new one.
+	 * If xfs_dialloc did an allocation to replenish the freelist, it
+	 * returns the bp containing the head of the freelist as
+	 * ialloc_context. We will hold a lock on it across the transaction
+	 * commit so that no other process can steal the inode(s) that we've
+	 * just allocated.
 	 */
-	if (code) {
-		*ipp = NULL;
-		return code;
-	}
-	if (!ialloc_context && !ip) {
-		*ipp = NULL;
-		return -ENOSPC;
-	}
+	error = xfs_dialloc(*tpp, pino, mode, ialloc_context, &ino);
+	if (error)
+		return error;
 
 	/*
 	 * If the AGI buffer is non-NULL, then we were unable to get an
 	 * inode in one operation.  We need to commit the current
-	 * transaction and call xfs_ialloc() again.  It is guaranteed
+	 * transaction and call xfs_ialloc() then.  It is guaranteed
 	 * to succeed the second time.
 	 */
 	if (ialloc_context) {
-		code = xfs_dialloc_roll(&tp, ialloc_context);
-		if (code) {
-			*ipp = NULL;
-			return code;
-		}
-
-		/*
-		 * Call ialloc again. Since we've locked out all
-		 * other allocations in this allocation group,
-		 * this call should always succeed.
-		 */
-		code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid,
-				  &ialloc_context, &ip);
-
+		error = xfs_dialloc_roll(tpp, ialloc_context);
+		if (error)
+			return error;
 		/*
-		 * If we get an error at this point, return to the caller
-		 * so that the current transaction can be aborted.
+		 * Call dialloc again. Since we've locked out all other
+		 * allocations in this allocation group, this call should
+		 * always succeed.
 		 */
-		if (code) {
-			*tpp = tp;
-			*ipp = NULL;
-			return code;
-		}
-		ASSERT(!ialloc_context && ip);
-
+		error = xfs_dialloc(*tpp, pino, mode, ialloc_context, &ino);
+		if (error)
+			return error;
+		ASSERT(!ialloc_context);
 	}
 
-	*ipp = ip;
-	*tpp = tp;
+	if (ino == NULLFSINO)
+		return -ENOSPC;
 
+	/* Initialise the newly allocated inode. */
+	ip = xfs_ialloc(*tpp, dp, ino, mode, nlink, rdev, prid);
+	if (IS_ERR(ip))
+		return PTR_ERR(ip);
+	*ipp = ip;
 	return 0;
 }
 
-- 
2.18.4

