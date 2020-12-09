Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E45C1B0D8
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 11:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE6CD23B77
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 11:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730765AbgLILa4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 06:30:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32401 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729260AbgLILa4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 06:30:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607513369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CcBzLVl1B0hB409MFh3hNt3GjsIOtwUEc3hmbVI40Fg=;
        b=haCfijjOQ0PHhYC0f7jVcHeMc8nlp+iihCaZ8BR2J/7/UA4f8/n6U17raFeBqeE3ziM959
        eJqUdL2ZE9UXKoFfPw77m93HoXs3fDny3FOA2lSuaU05y02GRkR/sXVZD0wnPACvOSwPSU
        fi1cObn4taLhzTFrYj64QXM7Rbi3cbM=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-PHQRoZTqP-G9zATO3tiSpw-1; Wed, 09 Dec 2020 06:29:27 -0500
X-MC-Unique: PHQRoZTqP-G9zATO3tiSpw-1
Received: by mail-pl1-f198.google.com with SMTP id x17so642711pll.8
        for <linux-xfs@vger.kernel.org>; Wed, 09 Dec 2020 03:29:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CcBzLVl1B0hB409MFh3hNt3GjsIOtwUEc3hmbVI40Fg=;
        b=NehG4HpY7HV1M5OBZjTfhHNBbtB3SfZR0QBneZHw3AfMK3Tgi/fKfoZk2OFUCNj1Ni
         07dvsTdYX+E7P93AMTP6Hp1BPdgksAbVCum8h9f51P1fnAtuLo+hmh9FwYSA9W4TJHyg
         iAfPwjBnQY5CP6tVOzbdYZnpRToIgPebNuxqwl9Txxn2pH1DI1jfwTpVeyPWYKClgZMn
         Hipb0/5/UA5dONcAKWlmu9QrNTPpM7x8yOzkEc1Ba2FLxsPOaYr9yd3pKUxcA8z7AAfJ
         q1wCC+Pp4hiXV+XZlShUZ77UlCO19B47m2aEwqaxtfTQSjL/WK1gU4ai1GakNN+Xxmui
         YYsw==
X-Gm-Message-State: AOAM533hLQn/5N5silPNT6+1KoUQVAjcFica69n+STiEcCbsDCkzIW57
        T3XxIFOW7tgCOMuEaPoKhPl0bgoItrxytLh+NTDuCDm/Zqy8TEBpYr7dEBD3/AVZDpR/GmyYd0V
        HdVxOtLe9sJcIwgqnX0aNrmIuHPXPR6N9CBh3+gnT6rtvUSCXrwgQqQZqYYwqqh//INUAVNAIJg
        ==
X-Received: by 2002:a62:764a:0:b029:19d:9fa8:5bc6 with SMTP id r71-20020a62764a0000b029019d9fa85bc6mr1920636pfc.76.1607513366709;
        Wed, 09 Dec 2020 03:29:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy+4fyeTAwxQeW2bffBIEVA8nhNOfKxzA1Dxgqjvh4sb8Fcf1riO5hDSi5t5iDDj03Qg5ywFA==
X-Received: by 2002:a62:764a:0:b029:19d:9fa8:5bc6 with SMTP id r71-20020a62764a0000b029019d9fa85bc6mr1920603pfc.76.1607513366369;
        Wed, 09 Dec 2020 03:29:26 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y5sm2231280pfp.45.2020.12.09.03.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 03:29:25 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 2/6] xfs: introduce xfs_dialloc_roll()
Date:   Wed,  9 Dec 2020 19:28:16 +0800
Message-Id: <20201209112820.114863-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201209112820.114863-1-hsiangkao@redhat.com>
References: <20201209112820.114863-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Introduce a helper to make the on-disk inode allocation rolling
logic clearer in preparation of the following cleanup.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
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
2.27.0

