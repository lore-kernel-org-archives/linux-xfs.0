Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D981C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 10:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345961AbiFAKqr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 06:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352371AbiFAKqD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 06:46:03 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2A3814AA;
        Wed,  1 Jun 2022 03:45:59 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id q21so1782180wra.2;
        Wed, 01 Jun 2022 03:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KtH8GLMcafEYSB20tONa+zJ9ioX5tusX1ZCZq7mMdkA=;
        b=OYiJF8IkYWo+pvv/QFkFP37snbX/mqn8II0s1X8xQb2d35XFOiBAuh488BYDaN7FDg
         gyTtI8HcppUQ1pZdoujy4P4EScBFCkFlmJS1akp6EdX8xTQKVJe+kfztdBygPZ1919vG
         A2FIAkseEcp2LBCllYtD/egpd1I+TC8WR56DpmUxDlWNq3oWgNmG0m0meLXkQGt4FHop
         TUQ4+s0eQrky7IkUOJrOifw7a2qjOPGOpb1BGbzYQP7ablN1aP3/Kb/6amGcon74uO8m
         oQZqkqcjxNg85hILHWggRsit71WmaLbcwG+Af2R49HiBn2oTcKUQy5a4DSwKNMxI1fXb
         LUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KtH8GLMcafEYSB20tONa+zJ9ioX5tusX1ZCZq7mMdkA=;
        b=Gtt/VtAnUhvW7Wqs1ITxw1CEsvBjwraw1cshEmXcggxiqu98Za10Q1/78AfMJwUop0
         u/N1rzrV8zZgsXZ5jEXYJBGeOnShLc1hpivtpMcaVRr9jnKMpBMZScQkiMvv4qDxZC85
         qAI1ft6sBXnhaE56fhJmf+9Sx9iGfSCu9hrwNkIjMuQZ0/CcdrHFG9HLfu+5Uvh6rDzH
         jbcFgbBWReANx235t7tSe0JHJ/4M4ZvSTI3H0MCS+8QOSPhIT4NWHWQ14m2/+DY4o2j6
         W3YS86Yfp/msX6UbmYJIgUPORaVT8EEZOASwSKMAv04mDi+cmJ+LRWsN7jo0BEqeYsRi
         yg1A==
X-Gm-Message-State: AOAM531b2woo9K7sUAKxMhq0x8blde/Gco1xiZL8yuq8zP5qKsP6kna7
        X5ZtV5lXNX8iKiCkdLD5V08=
X-Google-Smtp-Source: ABdhPJzq97m2fnUxvb1nKJQb59FtkhhKuNlswE1bx6aje3nVxPUXzUGUTvIdAdlF9BSdk4kZNzVeRw==
X-Received: by 2002:adf:e8c3:0:b0:210:3dc0:6c8 with SMTP id k3-20020adfe8c3000000b002103dc006c8mr2649016wrn.611.1654080357827;
        Wed, 01 Jun 2022 03:45:57 -0700 (PDT)
Received: from localhost.localdomain ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id h9-20020a5d4309000000b002102af52a2csm1562150wrq.9.2022.06.01.03.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 03:45:57 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 3/8] xfs: sync lazy sb accounting on quiesce of read-only mounts
Date:   Wed,  1 Jun 2022 13:45:42 +0300
Message-Id: <20220601104547.260949-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220601104547.260949-1-amir73il@gmail.com>
References: <20220601104547.260949-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 50d25484bebe94320c49dd1347d3330c7063bbdb upstream.

xfs_log_sbcount() syncs the superblock specifically to accumulate
the in-core percpu superblock counters and commit them to disk. This
is required to maintain filesystem consistency across quiesce
(freeze, read-only mount/remount) or unmount when lazy superblock
accounting is enabled because individual transactions do not update
the superblock directly.

This mechanism works as expected for writable mounts, but
xfs_log_sbcount() skips the update for read-only mounts. Read-only
mounts otherwise still allow log recovery and write out an unmount
record during log quiesce. If a read-only mount performs log
recovery, it can modify the in-core superblock counters and write an
unmount record when the filesystem unmounts without ever syncing the
in-core counters. This leaves the filesystem with a clean log but in
an inconsistent state with regard to lazy sb counters.

Update xfs_log_sbcount() to use the same logic
xfs_log_unmount_write() uses to determine when to write an unmount
record. This ensures that lazy accounting is always synced before
the log is cleaned. Refactor this logic into a new helper to
distinguish between a writable filesystem and a writable log.
Specifically, the log is writable unless the filesystem is mounted
with the norecovery mount option, the underlying log device is
read-only, or the filesystem is shutdown. Drop the freeze state
check because the update is already allowed during the freezing
process and no context calls this function on an already frozen fs.
Also, retain the shutdown check in xfs_log_unmount_write() to catch
the case where the preceding log force might have triggered a
shutdown.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_log.c   | 28 ++++++++++++++++++++--------
 fs/xfs/xfs_log.h   |  1 +
 fs/xfs/xfs_mount.c |  3 +--
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fa2d05e65ff1..b445e63cbc3c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -347,6 +347,25 @@ xlog_tic_add_region(xlog_ticket_t *tic, uint len, uint type)
 	tic->t_res_num++;
 }
 
+bool
+xfs_log_writable(
+	struct xfs_mount	*mp)
+{
+	/*
+	 * Never write to the log on norecovery mounts, if the block device is
+	 * read-only, or if the filesystem is shutdown. Read-only mounts still
+	 * allow internal writes for log recovery and unmount purposes, so don't
+	 * restrict that case here.
+	 */
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+		return false;
+	if (xfs_readonly_buftarg(mp->m_log->l_targ))
+		return false;
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return false;
+	return true;
+}
+
 /*
  * Replenish the byte reservation required by moving the grant write head.
  */
@@ -886,15 +905,8 @@ xfs_log_unmount_write(
 {
 	struct xlog		*log = mp->m_log;
 
-	/*
-	 * Don't write out unmount record on norecovery mounts or ro devices.
-	 * Or, if we are doing a forced umount (typically because of IO errors).
-	 */
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
-	    xfs_readonly_buftarg(log->l_targ)) {
-		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
+	if (!xfs_log_writable(mp))
 		return;
-	}
 
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 58c3fcbec94a..98c913da7587 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -127,6 +127,7 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
 int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
 void      xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
+bool	xfs_log_writable(struct xfs_mount *mp);
 
 struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7110507a2b6b..a62b8a574409 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1176,8 +1176,7 @@ xfs_fs_writable(
 int
 xfs_log_sbcount(xfs_mount_t *mp)
 {
-	/* allow this to proceed during the freeze sequence... */
-	if (!xfs_fs_writable(mp, SB_FREEZE_COMPLETE))
+	if (!xfs_log_writable(mp))
 		return 0;
 
 	/*
-- 
2.25.1

