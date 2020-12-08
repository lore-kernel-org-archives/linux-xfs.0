Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A07C4361B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 12:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A6FE23A9B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 12:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgLHMXJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 07:23:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26768 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729424AbgLHMXJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Dec 2020 07:23:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607430103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=J59CpIHABVhPzEGvzEppdhYhc7QmrrNmU0hchNcI7Fo=;
        b=Dl/E1Vz07lOv9mTJ9zOLLyadjix8d1+NAzeCnmIjt2LXXYZ542rPy/LPCT7nLUJkPSuiOI
        2/qoG7bezdl95OXhFEBBUlsoOnwdtT6brp3Rg9TlL5v4f/pCz2fk9+/AocK4+bLcxnt2QW
        SDa2w7MHPvkgaIEBTFIf4yl5AeE1m6Q=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-xTGR-sb9OeOp5JWJ9L3nAA-1; Tue, 08 Dec 2020 07:21:41 -0500
X-MC-Unique: xTGR-sb9OeOp5JWJ9L3nAA-1
Received: by mail-pg1-f200.google.com with SMTP id f6so894419pgh.3
        for <linux-xfs@vger.kernel.org>; Tue, 08 Dec 2020 04:21:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J59CpIHABVhPzEGvzEppdhYhc7QmrrNmU0hchNcI7Fo=;
        b=a+LUkiCPCNBwfhwX7eSXQisHA6iSrbde6MP6xHOrfqGF075iJVm5fyckYbiyKOCfK5
         Jze6Nni5Lr+dRgm6V3kvv/jKyx+t5tgUMtnFaefCt8911Mx3cD88ha1cfKPXZogZeigh
         KhKL/qLjN/roLZ4ysp4HZesZQOR9PqxIEvrZw1xkUP6fTTgp6vN+m6SYYev6wkfnG98u
         mukAmmsB91TDjmCG3iUXNzHlli34ycec9+AKU4d+njeghydayaxGV7qcqT58N/sqxhTw
         JUM/AWuRIODM5Qs9ykwld9D7RutdjOkyAP6jNGxZKBkcaQ9tkwxaLj9bDGNx7qQyG30p
         /ClA==
X-Gm-Message-State: AOAM533azCpiR3e0VEhcgQomq790BykHz7fj3PHYgG0oUtuhd1L03xDO
        JRA+3ePv8dJfRqAkICVF1u39RuTiu6EX56YtId0NEkn905XU60/bdRYtOThrIIu7ZjDQUbZt7MK
        nlDBbFG5ejN3GyUuIsGjUPLcUXfCZ42Ecg0HCVO+sbwfBmphB9xCZ+6FaGU+aDT5pqKH6SP/MXQ
        ==
X-Received: by 2002:a17:902:bf4a:b029:da:d0b8:6489 with SMTP id u10-20020a170902bf4ab02900dad0b86489mr20861312pls.58.1607430100579;
        Tue, 08 Dec 2020 04:21:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhODr52e93r4x/a/ewxKi9nNtcu6lftj52UwAN/JqRq6uFgMXJvmndLw6o+HWt8NiEPsXEzQ==
X-Received: by 2002:a17:902:bf4a:b029:da:d0b8:6489 with SMTP id u10-20020a170902bf4ab02900dad0b86489mr20861290pls.58.1607430100231;
        Tue, 08 Dec 2020 04:21:40 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a29sm1156926pfr.73.2020.12.08.04.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 04:21:39 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 2/6] xfs: introduce xfs_dialloc_roll()
Date:   Tue,  8 Dec 2020 20:19:59 +0800
Message-Id: <20201208122003.3158922-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201208122003.3158922-1-hsiangkao@redhat.com>
References: <20201208122003.3158922-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Introduce a helper to make the on-disk inode allocation rolling
logic clearer in preparation of the following cleanup.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 43 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |  5 +++++
 fs/xfs/xfs_inode.c         | 37 +-------------------------------
 3 files changed, 49 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 45cf7e55f5ee..23e94d43acb2 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1682,6 +1682,49 @@ xfs_dialloc_ag(
 	return error;
 }
 
+int
+xfs_dialloc_roll(
+	struct xfs_trans	**tpp,
+	struct xfs_buf		*agibp)
+{
+	struct xfs_trans	*tp = *tpp;
+	struct xfs_dquot_acct	*dqinfo = NULL;
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
+		tp->t_flags &= ~XFS_TRANS_DQ_DIRTY;
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
+	if (error)
+		return error;
+	xfs_trans_bjoin(tp, agibp);
+	return 0;
+}
+
 /*
  * Allocate an inode on disk.
  *
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 72b3468b97b1..bd6e0db9e23c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -32,6 +32,11 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 	return xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog);
 }
 
+int
+xfs_dialloc_roll(
+	struct xfs_trans	**tpp,
+	struct xfs_buf		*agibp);
+
 /*
  * Allocate an inode on disk.
  * Mode is used to tell whether the new inode will need space, and whether
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2bfbcf28b1bd..76282da7a05c 100644
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
@@ -1003,46 +1001,13 @@ xfs_dir_ialloc(
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
 			xfs_buf_relse(ialloc_context);
 			*tpp = tp;
 			*ipp = NULL;
 			return code;
 		}
-		xfs_trans_bjoin(tp, ialloc_context);
 
 		/*
 		 * Call ialloc again. Since we've locked out all
-- 
2.18.4

