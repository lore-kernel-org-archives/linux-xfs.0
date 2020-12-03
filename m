Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA797C4361B
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 16:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F2B7207B0
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 16:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387895AbgLCQNA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 11:13:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbgLCQNA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 11:13:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607011893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=0GxpbT/6RBxM+/MfsnfeyJrFNeDMmV0BRjMQqYILpYI=;
        b=VmA8bDMrRA0XiZavTWFwbUKMO5ITr6g617c6B7b+Xg9XMHRYGZLA6AVOaCgNUocIKy2Nv9
        GLRdfQJzQqCpadDg0tk26hyPqmDrqdKluHEJFUtrTjJDIUnK4SNjClMYb4yiwR6TaNPMar
        NUrBKoVvJmD2o7KJoEKRM6f3P7UV1ww=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-QOvdk7RaOLi8w2uyjsmtvA-1; Thu, 03 Dec 2020 11:11:31 -0500
X-MC-Unique: QOvdk7RaOLi8w2uyjsmtvA-1
Received: by mail-pg1-f197.google.com with SMTP id l7so1666257pgq.16
        for <linux-xfs@vger.kernel.org>; Thu, 03 Dec 2020 08:11:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0GxpbT/6RBxM+/MfsnfeyJrFNeDMmV0BRjMQqYILpYI=;
        b=ezfxSVbsH3HopP0zgzTSWKvk8p6XjAr+VbUq7JVXXgHJ4JBYF2xjVOyKdlP8u74vV8
         JNpVYWO18Pf/NTVAl8QqHP/pwyiMR1tTDGJ9U8e/QtqoC96l8zizTHBpwIPBbAGNdusD
         WZl/9FYCikqJkW0w7gCQ3Igu7r69VxnN1pQZtvBFJMxDWAbXWn/OLiCwj6PtE9oFKFRY
         g4RvWXxxnSN6SXmZWUB8ZLJvyaU/LxC+tYz+QYDbkDJrjPHlKY5miTiOI64g/jMC/j1n
         oz0N+sR4LGjA5kg+kjgXjSmlLjusDFfCFyuDD3EB3woCMwIBbWlq7yRpz2gwlFrmzIm/
         6oIg==
X-Gm-Message-State: AOAM530SPK98jx6rqIuoTEu0M9TQJo2aoL9pmMZZg680BZf6NpGTkIhD
        dcjEtJP4PqY88oPFn9S/UTcH1TWr98nLVJplFZ1RDUhZmzdCr0B15X12Giq7hb4jLy3fuxMbzgh
        G35phABCOGIkj2U2PiZVXg4PCTX9QaCTzm19SCTVD/DTlcLAHF4bgcNKujwcqMwdszzYkwV9mVw
        ==
X-Received: by 2002:a17:90a:8c4:: with SMTP id 4mr3677405pjn.204.1607011890223;
        Thu, 03 Dec 2020 08:11:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxH4j0NM5reHOzxUoieDz0aaGjX/mpbwDn4umkUBcJMI9sqrG2p20BqSl2ecOnxZYp/uPl0hQ==
X-Received: by 2002:a17:90a:8c4:: with SMTP id 4mr3677376pjn.204.1607011889884;
        Thu, 03 Dec 2020 08:11:29 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l1sm1738798pgg.4.2020.12.03.08.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 08:11:29 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v2 2/6] xfs: introduce xfs_dialloc_roll()
Date:   Fri,  4 Dec 2020 00:10:24 +0800
Message-Id: <20201203161028.1900929-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201203161028.1900929-1-hsiangkao@redhat.com>
References: <20201203161028.1900929-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Introduce a helper to make the on-disk inode allocation rolling
logic clearer in preparation of the following cleanup.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 45 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |  6 +++++
 fs/xfs/xfs_inode.c         | 39 +--------------------------------
 3 files changed, 52 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 45cf7e55f5ee..d5dc3167e2ff 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1682,6 +1682,51 @@ xfs_dialloc_ag(
 	return error;
 }
 
+int
+xfs_dialloc_roll(
+	struct xfs_trans	**tpp,
+	struct xfs_buf		*agibp)
+{
+	struct xfs_trans	*tp = *tpp;
+	void			*dqinfo = NULL;
+	unsigned int		tflags = 0;
+	int			error;
+
+	/*
+	 * Hold to on to the agibp across the commit so no other allocation can
+	 * come in and take the free inodes we just allocated for our caller.
+	 */
+	xfs_trans_bhold(tp, agibp);
+
+	/*
+	 * We want the quota changes to be associated with the next transaction,
+	 * NOT this one. So, detach the dqinfo from this and attach it to the
+	 * next transaction.
+	 */
+	if (tp->t_dqinfo) {
+		dqinfo = tp->t_dqinfo;
+		tp->t_dqinfo = NULL;
+		tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
+		tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
+	}
+
+	error = xfs_trans_roll(&tp);
+
+	/* Re-attach the quota info that we detached from prev trx. */
+	if (dqinfo) {
+		tp->t_dqinfo = dqinfo;
+		tp->t_flags |= tflags;
+	}
+
+	*tpp = tp;
+	if (error) {
+		xfs_buf_relse(agibp);
+		return error;
+	}
+	xfs_trans_bjoin(tp, agibp);
+	return 0;
+}
+
 /*
  * Allocate an inode on disk.
  *
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 72b3468b97b1..a145e2a72530 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -32,6 +32,12 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 	return xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog);
 }
 
+/* XXX: will be removed in the following patch */
+int
+xfs_dialloc_roll(
+	struct xfs_trans	**tpp,
+	struct xfs_buf		*agibp);
+
 /*
  * Allocate an inode on disk.
  * Mode is used to tell whether the new inode will need space, and whether
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2bfbcf28b1bd..4ebfb1a18f0f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -958,8 +958,6 @@ xfs_dir_ialloc(
 	xfs_inode_t	*ip;
 	xfs_buf_t	*ialloc_context = NULL;
 	int		code;
-	void		*dqinfo;
-	uint		tflags;
 
 	tp = *tpp;
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -1003,46 +1001,11 @@ xfs_dir_ialloc(
 	 * to succeed the second time.
 	 */
 	if (ialloc_context) {
-		/*
-		 * Normally, xfs_trans_commit releases all the locks.
-		 * We call bhold to hang on to the ialloc_context across
-		 * the commit.  Holding this buffer prevents any other
-		 * processes from doing any allocations in this
-		 * allocation group.
-		 */
-		xfs_trans_bhold(tp, ialloc_context);
-
-		/*
-		 * We want the quota changes to be associated with the next
-		 * transaction, NOT this one. So, detach the dqinfo from this
-		 * and attach it to the next transaction.
-		 */
-		dqinfo = NULL;
-		tflags = 0;
-		if (tp->t_dqinfo) {
-			dqinfo = (void *)tp->t_dqinfo;
-			tp->t_dqinfo = NULL;
-			tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
-			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
-		}
-
-		code = xfs_trans_roll(&tp);
-
-		/*
-		 * Re-attach the quota info that we detached from prev trx.
-		 */
-		if (dqinfo) {
-			tp->t_dqinfo = dqinfo;
-			tp->t_flags |= tflags;
-		}
-
+		code = xfs_dialloc_roll(&tp, ialloc_context);
 		if (code) {
-			xfs_buf_relse(ialloc_context);
-			*tpp = tp;
 			*ipp = NULL;
 			return code;
 		}
-		xfs_trans_bjoin(tp, ialloc_context);
 
 		/*
 		 * Call ialloc again. Since we've locked out all
-- 
2.18.4

