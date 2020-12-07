Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A932C4167B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 00:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19EEF23123
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 00:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgLGASF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 19:18:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbgLGASF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 19:18:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607300198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=8shifgnJyENzsnf537IZfK2Yi2aGEnRhZljtyUd0Dts=;
        b=VFU/xGZ5sCtoA02x+yXimWA7L5/KsOpPuYTnTkAhLleyUHWKTrQi2ofyyHII0OVRTloILY
        3um0Anbz1x+/OZ2WZ9rA/w7iwp4mn6W7R0hFbKZj/PaQ9WPCbq+wY+MfHIeob8KMf5PsWd
        67DvYK5JjXNXJ4iUEOWpM9GGLVn+25k=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451--lFlZn_hN42AH4ZZgxnsiA-1; Sun, 06 Dec 2020 19:16:34 -0500
X-MC-Unique: -lFlZn_hN42AH4ZZgxnsiA-1
Received: by mail-pf1-f197.google.com with SMTP id u3so7858502pfm.22
        for <linux-xfs@vger.kernel.org>; Sun, 06 Dec 2020 16:16:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8shifgnJyENzsnf537IZfK2Yi2aGEnRhZljtyUd0Dts=;
        b=nt3qyyhlsSXdpP+RTxcrmItmHTA4bQJ870V9XsZiXg/uEsraQIq48fkQ92KJXDoYar
         D/qep6oji5U4h5GfXJ/3IYVsgPC+qb3Z7HMNvbXfLEKNMiH2gsKLvzMwLYMh/xRxIB6P
         OBIsArYRY6T9MViionjgGgSQTlmGyfTvqHwsRc8NS7SlNkHEz4j3j6yJiDhx/++3kWBf
         sxWYZrOYudkTHB5uZWzeSmaWG9bWkiScvA5Li8WRvKW3CeqjH9vydmG0vBee65TmUP4c
         3/p1wCJaniJfeHTTo3MS53TbbHm23AEb+LrK9D22CTiQ60ggGvFQKTiRcRVP4SYjGZwk
         nFXQ==
X-Gm-Message-State: AOAM530BvPAxhsMH/LPE3l5AyCAlcg5Z5gNENK19RgO3XuzFUed38c6w
        5+JzC9MBcXSa0g7zAtK7cdeNGvtmsf2VTWgfTtIQJRukurHif+xHaLn80huKAVwjYVoW6DcA7fP
        WDMBZEl8SGmVW9s4EbtssEDGhIP1RRw4KymQtEgUZs0oYpr+SdGrrgIIkVJOB6QH87NnAm4zybw
        ==
X-Received: by 2002:a17:902:b707:b029:da:a304:1952 with SMTP id d7-20020a170902b707b02900daa3041952mr13440780pls.6.1607300193149;
        Sun, 06 Dec 2020 16:16:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxMUUXVbOx5tnXXkY9Mlm5gHPZ7PIjJHMOquT7B/NWQyFsrvcqIg9YSpjmlFDOh9KmwFE5lNg==
X-Received: by 2002:a17:902:b707:b029:da:a304:1952 with SMTP id d7-20020a170902b707b02900daa3041952mr13440758pls.6.1607300192827;
        Sun, 06 Dec 2020 16:16:32 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o9sm8218056pjl.11.2020.12.06.16.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 16:16:32 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 2/6] xfs: introduce xfs_dialloc_roll()
Date:   Mon,  7 Dec 2020 08:15:29 +0800
Message-Id: <20201207001533.2702719-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201207001533.2702719-1-hsiangkao@redhat.com>
References: <20201207001533.2702719-1-hsiangkao@redhat.com>
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
index 45cf7e55f5ee..3d2862e3ff41 100644
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
index 2bfbcf28b1bd..6672cdffcda5 100644
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
@@ -1003,46 +1001,12 @@ xfs_dir_ialloc(
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
 			*tpp = tp;
 			*ipp = NULL;
 			return code;
 		}
-		xfs_trans_bjoin(tp, ialloc_context);
 
 		/*
 		 * Call ialloc again. Since we've locked out all
@@ -1062,7 +1026,6 @@ xfs_dir_ialloc(
 			return code;
 		}
 		ASSERT(!ialloc_context && ip);
-
 	}
 
 	*ipp = ip;
-- 
2.18.4

