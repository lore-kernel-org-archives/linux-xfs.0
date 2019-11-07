Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0518C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 11:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ABFF214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 11:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387796AbfKGLf6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 06:35:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfKGLf5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Nov 2019 06:35:57 -0500
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D9B3E7C0A8
        for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2019 11:35:56 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id e7so804700wro.22
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:35:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=87W1sJyPRVJRXoVUu0qjLgP5slz0HbSJES2DkNNmUHo=;
        b=LYB+6+zlwEVIiXEepIlSSCwvmU0pWrw6I0Y+PL+ZXFQDrKZCVJp7kWYsbuLC/40zkK
         FfPWLXW204nqge+FZATZmpaMwkYwzaa6sEXfrBvka0Sj/IZFqNAj0+S1t3f9Qavyxxb4
         H9pLuPYP6+WsvTF+C+vhS4i4CDc1aVVorUvT8awDA8EAf4DrOztqjx+UYLxzLuGkb46Q
         NARKhc5XxM6bzf5cV7EmRkfWiIX5IlCiDEugdklIooUciaHfuFqJ/KYKsyqGqs6F2Ebk
         XR2JgcQzwvRePE15DhYyyCNmpyWHN0+x4HvoID0PfCEzOBlLuwAS/snzLWCchWFXnT6D
         WrmA==
X-Gm-Message-State: APjAAAWE/Ezvi/j8FrbJkbdRNbgc5QsDKXgIjPE+mS5NhYa1hbIvIGGB
        Z70Tiang6aBvpZdVoXGxLPsCnRA0Hdn+JiTT2f40JfT26bsKjjLqwNBtJEYqwKOXHuGU+3/EZ6T
        vpWF+vKXC+7DM6EN/VUUc
X-Received: by 2002:a1c:750e:: with SMTP id o14mr2622788wmc.28.1573126555367;
        Thu, 07 Nov 2019 03:35:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqwRB/2KbckHJzfhZhowjze+ZCCr8lM4SKAeCtyT7WqJKfgy6Cld70z6IlXt/ndLFwYGWZqlJw==
X-Received: by 2002:a1c:750e:: with SMTP id o14mr2622759wmc.28.1573126555059;
        Thu, 07 Nov 2019 03:35:55 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id a6sm1532888wmj.1.2019.11.07.03.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 03:35:54 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH 1/5] xfs: remove the xfs_disk_dquot_t typedef
Date:   Thu,  7 Nov 2019 12:35:45 +0100
Message-Id: <20191107113549.110129-2-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107113549.110129-1-preichl@redhat.com>
References: <20191107113549.110129-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |  8 ++++----
 fs/xfs/libxfs/xfs_format.h     | 10 +++++-----
 fs/xfs/libxfs/xfs_trans_resv.c |  1 -
 fs/xfs/xfs_dquot.c             | 10 +++++-----
 fs/xfs/xfs_dquot.h             |  8 ++++----
 fs/xfs/xfs_log_recover.c       |  5 +++--
 6 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index e8bd688a4073..67baed82f6a3 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -35,10 +35,10 @@ xfs_calc_dquots_per_chunk(
 
 xfs_failaddr_t
 xfs_dquot_verify(
-	struct xfs_mount *mp,
-	xfs_disk_dquot_t *ddq,
-	xfs_dqid_t	 id,
-	uint		 type)	  /* used only during quotacheck */
+	struct xfs_mount	*mp,
+	struct xfs_disk_dquot	*ddq,
+	xfs_dqid_t		id,
+	uint			type)	  /* used only during quotacheck */
 {
 	/*
 	 * We can encounter an uninitialized dquot buffer for 2 reasons:
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c968b60cee15..4cae17f35e94 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1144,11 +1144,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 
 /*
  * This is the main portion of the on-disk representation of quota
- * information for a user. This is the q_core of the xfs_dquot_t that
+ * information for a user. This is the q_core of the struct xfs_dquot that
  * is kept in kernel memory. We pad this with some more expansion room
  * to construct the on disk structure.
  */
-typedef struct	xfs_disk_dquot {
+struct xfs_disk_dquot {
 	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
 	__u8		d_version;	/* dquot version */
 	__u8		d_flags;	/* XFS_DQ_USER/PROJ/GROUP */
@@ -1171,15 +1171,15 @@ typedef struct	xfs_disk_dquot {
 	__be32		d_rtbtimer;	/* similar to above; for RT disk blocks */
 	__be16		d_rtbwarns;	/* warnings issued wrt RT disk blocks */
 	__be16		d_pad;
-} xfs_disk_dquot_t;
+};
 
 /*
  * This is what goes on disk. This is separated from the xfs_disk_dquot because
  * carrying the unnecessary padding would be a waste of memory.
  */
 typedef struct xfs_dqblk {
-	xfs_disk_dquot_t  dd_diskdq;	/* portion that lives incore as well */
-	char		  dd_fill[4];	/* filling for posterity */
+	struct xfs_disk_dquot	dd_diskdq; /* portion living incore as well */
+	char			dd_fill[4];/* filling for posterity */
 
 	/*
 	 * These two are only present on filesystems with the CRC bits set.
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index d12bbd526e7c..271cca13565b 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -718,7 +718,6 @@ xfs_calc_clear_agi_bucket_reservation(
 
 /*
  * Adjusting quota limits.
- *    the xfs_disk_dquot_t: sizeof(struct xfs_disk_dquot)
  */
 STATIC uint
 xfs_calc_qm_setqlim_reservation(void)
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bcd4247b5014..edf0e81b3a10 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -48,7 +48,7 @@ static struct lock_class_key xfs_dquot_project_class;
  */
 void
 xfs_qm_dqdestroy(
-	xfs_dquot_t	*dqp)
+	struct xfs_dquot	*dqp)
 {
 	ASSERT(list_empty(&dqp->q_lru));
 
@@ -114,7 +114,7 @@ xfs_qm_adjust_dqlimits(
 void
 xfs_qm_adjust_dqtimers(
 	xfs_mount_t		*mp,
-	xfs_disk_dquot_t	*d)
+	struct xfs_disk_dquot	*d)
 {
 	ASSERT(d->d_id);
 
@@ -497,7 +497,7 @@ xfs_dquot_from_disk(
 	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
 
 	/* copy everything from disk dquot to the incore dquot */
-	memcpy(&dqp->q_core, ddqp, sizeof(xfs_disk_dquot_t));
+	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
 
 	/*
 	 * Reservation counters are defined as reservation plus current usage
@@ -989,7 +989,7 @@ xfs_qm_dqput(
  */
 void
 xfs_qm_dqrele(
-	xfs_dquot_t	*dqp)
+	struct xfs_dquot	*dqp)
 {
 	if (!dqp)
 		return;
@@ -1130,7 +1130,7 @@ xfs_qm_dqflush(
 	}
 
 	/* This is the only portion of data that needs to persist */
-	memcpy(ddqp, &dqp->q_core, sizeof(xfs_disk_dquot_t));
+	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
 
 	/*
 	 * Clear the dirty field and remember the flush lsn for later use.
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 4fe85709d55d..7a580dd09a76 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -39,7 +39,7 @@ typedef struct xfs_dquot {
 	int		 q_bufoffset;	/* off of dq in buffer (# dquots) */
 	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
 
-	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
+	struct xfs_disk_dquot	q_core;	/* actual usage & quotas */
 	xfs_dq_logitem_t q_logitem;	/* dquot log item */
 	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
 	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
@@ -49,14 +49,14 @@ typedef struct xfs_dquot {
 	int64_t		 q_low_space[XFS_QLOWSP_MAX];
 	struct mutex	 q_qlock;	/* quota lock */
 	struct completion q_flush;	/* flush completion queue */
-	atomic_t          q_pincount;	/* dquot pin count */
+	atomic_t	  q_pincount;	/* dquot pin count */
 	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
 } xfs_dquot_t;
 
 /*
  * Lock hierarchy for q_qlock:
  *	XFS_QLOCK_NORMAL is the implicit default,
- * 	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
+ *	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
  */
 enum {
 	XFS_QLOCK_NORMAL = 0,
@@ -151,7 +151,7 @@ extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
 extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
 extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
-					xfs_disk_dquot_t *);
+					struct xfs_disk_dquot *);
 extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
 					       struct xfs_dquot *);
 extern xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c1a514ffff55..afb0ec772bdd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2576,6 +2576,7 @@ xlog_recover_do_reg_buffer(
 	int			bit;
 	int			nbits;
 	xfs_failaddr_t		fa;
+	const size_t		size_disk_dquot = sizeof(struct xfs_disk_dquot);
 
 	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
 
@@ -2618,7 +2619,7 @@ xlog_recover_do_reg_buffer(
 					"XFS: NULL dquot in %s.", __func__);
 				goto next;
 			}
-			if (item->ri_buf[i].i_len < sizeof(xfs_disk_dquot_t)) {
+			if (item->ri_buf[i].i_len < size_disk_dquot) {
 				xfs_alert(mp,
 					"XFS: dquot too small (%d) in %s.",
 					item->ri_buf[i].i_len, __func__);
@@ -3249,7 +3250,7 @@ xlog_recover_dquot_pass2(
 		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
 		return -EIO;
 	}
-	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
+	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot)) {
 		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
 			item->ri_buf[1].i_len, __func__);
 		return -EIO;
-- 
2.23.0

