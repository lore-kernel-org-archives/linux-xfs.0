Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4925FC43334
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 10:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381608AbiFQKHf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 06:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381574AbiFQKHU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 06:07:20 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE1F6A011;
        Fri, 17 Jun 2022 03:06:58 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a15so5118721wrh.2;
        Fri, 17 Jun 2022 03:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=loriEoiVPoDrwPGkS8Q5XLOnTWcA/2w8hcb95i2ZPaE=;
        b=oqjAWdy8E9mBMlxIqQuip+44uzZRTrJPoz8xDEN/HE8QmYhSr73zFDJMjB/TVexTy7
         5x1vpIELIHSsHuGZN+6VojK4fd/JLAELaVchUpzzvvWmm1P2gLR4DQkpjgr8PTcZfgVK
         A6b2uT9KT6Vj0Fb2C0FsNpw+cNFK0Qn/QigS3kn8lDvxmL9r3JHTTZev75yyTIzs+EzM
         u5u/wDHR8qLFnPf+UVpx603JjyBaDdioThvGPchLVkrjovWS3nk9XUpwLWQK2CIyecy4
         /KsePWtJspWveevJOj+QHv9E5LbvwHKefKLPBCsvdPgLSpW6JeJDldtcAxJB+QBS423w
         0UEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=loriEoiVPoDrwPGkS8Q5XLOnTWcA/2w8hcb95i2ZPaE=;
        b=dK+CCzl66+FupfJp70vysql4exV5I7kK0WXkGrpK+Lgm9TjWkeCAUqsgGgz9dEJw1e
         TOah5u3FKqmUEeaunCBd+Sk0rPlXK/leFoq4jiWZ1Ypp+fJehWOANVq4bgNGsfjp6MsR
         j7AUVf2WCQBjTy4c1qXsjhZT0Lu6Z5XyYdiMk7iGFxizsX5Wl/2cjDqxao8GTtBTwolF
         +n9wm8/W37+43r3nqjLKPSxjPL5rFAg/aWu9n1yW7i7hK/YDIH6JXECFW8O33Og1b6KM
         E41boyj4FYZ9libLr536AstJ5+roBQxM6TUa4ac4+eUUGv8GtTbOc+TQ8+4vmKzWMobp
         AUWg==
X-Gm-Message-State: AJIora8ttp3ysjvizmWCeJYjUhNfecKGyCXdPgMG5/85r0QkGt5QjbhZ
        OQtuuaoYKPw6WOqnw6kfIo4=
X-Google-Smtp-Source: AGRyM1ubRH7Q0YRz2AFsOMHjK2er0Q4X1+tqKqDrw1fcjgRMwfTKB6D3iVTKi44Vel9uTJ5hDj+5jg==
X-Received: by 2002:a5d:6a0e:0:b0:213:1f7f:e1cc with SMTP id m14-20020a5d6a0e000000b002131f7fe1ccmr8661795wru.31.1655460417077;
        Fri, 17 Jun 2022 03:06:57 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id m42-20020a05600c3b2a00b003973435c517sm5265534wms.0.2022.06.17.03.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:06:56 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 06/11] xfs: refactor xfs_file_fsync
Date:   Fri, 17 Jun 2022 13:06:36 +0300
Message-Id: <20220617100641.1653164-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617100641.1653164-1-amir73il@gmail.com>
References: <20220617100641.1653164-1-amir73il@gmail.com>
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

