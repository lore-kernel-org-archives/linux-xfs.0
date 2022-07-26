Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C03CCA48C
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 09:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbiGZJVf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 05:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237906AbiGZJVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 05:21:33 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670D612D36;
        Tue, 26 Jul 2022 02:21:32 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id mf4so25104335ejc.3;
        Tue, 26 Jul 2022 02:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=loriEoiVPoDrwPGkS8Q5XLOnTWcA/2w8hcb95i2ZPaE=;
        b=LfufXSiYxZ++zkxPxdLhDfKVyCh3Aal6tFIzZq9nL7x6JD73IdGqZTmPhHJVBJDyij
         PaL20gCZdchiU2EingQ1OPoBxz0IdUJpad48OkGD1h48pZ/u2p8unlYRHxE6f/NJLlYn
         sXE4TOqvU2A9H8wZNom/8KYlU4sn5+wcP+DbPGQ/doIR6Pdbos+jkY6pNCq/PaRFPggG
         ZDBIgNWWlqzEJyFqFOr037YZK2GFbdJ40w1zwhPlAxroFfxW8m09hYqlDY75EFoUphXr
         mYW96UZLGx7LmGPkj3j9Z/zM3ocAv+kDibhbA/s+peT0UyMwUhmq1kkTcmzf/2vFdH42
         NNWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=loriEoiVPoDrwPGkS8Q5XLOnTWcA/2w8hcb95i2ZPaE=;
        b=B4pIcPOpWwm3QCnqF42MlYRzemG0nLjozdTffewcjU3QMVnUhamggORUxmcPq/4pcU
         Wq4ZlGF6PkJFjkoAznjnpukxnl1dcnXiJD4+yvJB/CleBtV0eNVuO/Q2kFyaVYZkpHm1
         Ndcl/dp5OA/pg37NZzDh/GltKh+2vJGRCCo6Cy010EIkXDFaSifEH7WteAMoGrkYNYbE
         hEvF5S5PYFALAplSsqBvCxsKasESC568rJUTynQWQEtWdLW43je19s/QuFSaZw1+SWN+
         iLEE1/hObw+sebFjnHcL+qEgM19DhdC6MPTcGJ+ALrukU8WqEWT9IXfj/calzf4sxmg3
         GWOw==
X-Gm-Message-State: AJIora98Am9be6PslN1BicHOVwffjR/RquNrZR4vwglH7yXHLmvIOik1
        adHvmSoHjnTiYo9vapaM3vA=
X-Google-Smtp-Source: AGRyM1vxJZIuvD0iqJuDUTYiw5EwNEILPf2cLvkIfyb3Tz/+QHnjO7Pg7gfZpOtufNIsVk4radzH6Q==
X-Received: by 2002:a17:907:6890:b0:72e:dc8f:ad42 with SMTP id qy16-20020a170907689000b0072edc8fad42mr12782265ejc.683.1658827290838;
        Tue, 26 Jul 2022 02:21:30 -0700 (PDT)
Received: from amir-ThinkPad-T480.kpn (2a02-a45a-4ae9-1-7aa-6650-a0dd-61a2.fixed6.kpn.net. [2a02:a45a:4ae9:1:7aa:6650:a0dd:61a2])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402071100b0043aa17dc199sm8161528edx.90.2022.07.26.02.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 02:21:30 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 1/9] xfs: refactor xfs_file_fsync
Date:   Tue, 26 Jul 2022 11:21:17 +0200
Message-Id: <20220726092125.3899077-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220726092125.3899077-1-amir73il@gmail.com>
References: <20220726092125.3899077-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit f22c7f87777361f94aa17f746fbadfa499248dc8 upstream.

[backported for dependency]

Factor out the log syncing logic into two helpers to make the code easier
to read and more maintainable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_file.c | 81 +++++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5b0f93f73837..414d856e2e75 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -118,6 +118,54 @@ xfs_dir_fsync(
 	return xfs_log_force_inode(ip);
 }
 
+static xfs_lsn_t
+xfs_fsync_lsn(
+	struct xfs_inode	*ip,
+	bool			datasync)
+{
+	if (!xfs_ipincount(ip))
+		return 0;
+	if (datasync && !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
+		return 0;
+	return ip->i_itemp->ili_last_lsn;
+}
+
+/*
+ * All metadata updates are logged, which means that we just have to flush the
+ * log up to the latest LSN that touched the inode.
+ *
+ * If we have concurrent fsync/fdatasync() calls, we need them to all block on
+ * the log force before we clear the ili_fsync_fields field. This ensures that
+ * we don't get a racing sync operation that does not wait for the metadata to
+ * hit the journal before returning.  If we race with clearing ili_fsync_fields,
+ * then all that will happen is the log force will do nothing as the lsn will
+ * already be on disk.  We can't race with setting ili_fsync_fields because that
+ * is done under XFS_ILOCK_EXCL, and that can't happen because we hold the lock
+ * shared until after the ili_fsync_fields is cleared.
+ */
+static  int
+xfs_fsync_flush_log(
+	struct xfs_inode	*ip,
+	bool			datasync,
+	int			*log_flushed)
+{
+	int			error = 0;
+	xfs_lsn_t		lsn;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	lsn = xfs_fsync_lsn(ip, datasync);
+	if (lsn) {
+		error = xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC,
+					  log_flushed);
+
+		spin_lock(&ip->i_itemp->ili_lock);
+		ip->i_itemp->ili_fsync_fields = 0;
+		spin_unlock(&ip->i_itemp->ili_lock);
+	}
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return error;
+}
+
 STATIC int
 xfs_file_fsync(
 	struct file		*file,
@@ -125,13 +173,10 @@ xfs_file_fsync(
 	loff_t			end,
 	int			datasync)
 {
-	struct inode		*inode = file->f_mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_inode_log_item *iip = ip->i_itemp;
+	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error = 0;
 	int			log_flushed = 0;
-	xfs_lsn_t		lsn = 0;
 
 	trace_xfs_file_fsync(ip);
 
@@ -155,33 +200,7 @@ xfs_file_fsync(
 	else if (mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_blkdev_issue_flush(mp->m_ddev_targp);
 
-	/*
-	 * All metadata updates are logged, which means that we just have to
-	 * flush the log up to the latest LSN that touched the inode. If we have
-	 * concurrent fsync/fdatasync() calls, we need them to all block on the
-	 * log force before we clear the ili_fsync_fields field. This ensures
-	 * that we don't get a racing sync operation that does not wait for the
-	 * metadata to hit the journal before returning. If we race with
-	 * clearing the ili_fsync_fields, then all that will happen is the log
-	 * force will do nothing as the lsn will already be on disk. We can't
-	 * race with setting ili_fsync_fields because that is done under
-	 * XFS_ILOCK_EXCL, and that can't happen because we hold the lock shared
-	 * until after the ili_fsync_fields is cleared.
-	 */
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip)) {
-		if (!datasync ||
-		    (iip->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
-			lsn = iip->ili_last_lsn;
-	}
-
-	if (lsn) {
-		error = xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
-		spin_lock(&iip->ili_lock);
-		iip->ili_fsync_fields = 0;
-		spin_unlock(&iip->ili_lock);
-	}
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
 
 	/*
 	 * If we only have a single device, and the log force about was
-- 
2.25.1

