Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEEE9C64EC7
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Feb 2023 05:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjB1FM4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Feb 2023 00:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjB1FM4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2023 00:12:56 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F48F1713
        for <linux-xfs@vger.kernel.org>; Mon, 27 Feb 2023 21:12:54 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id n6so7816526plf.5
        for <linux-xfs@vger.kernel.org>; Mon, 27 Feb 2023 21:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=QZWDz+SbPERUqTv/9yk+IIa/0hPRblTGjYg5NgdoKK8=;
        b=tPUAlQWpmMpSOiySo7SiXBiJw2oHzh/r2FvyIDjXOe3WxIrr5MbNNpP8/qDdVo5kPe
         UErbtFxQZgghcogw8fSPM9XFdIb0JwY42Tb8U8xrqeZrjRywIo7H8qlfh4eCjP2sJtGN
         tNpYxqqRoIvGYI2raALQU7wQoZ+WrGPUVNPwzFHTscxBqMde1+JtNQZOvpyRGDfdQn3a
         RWVuAWGsuaubKoAtuCNDtLC5WY4c2e79akuCfk9OxRCqy8MD4LIv1EAJkROXgTgZDCS3
         /xVgSpz3dOPD0y/NGiqCY8nVW6kynjM2hPlSYHYauH/gsnuW9lNWq1xwbqBctGipELpk
         WjyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QZWDz+SbPERUqTv/9yk+IIa/0hPRblTGjYg5NgdoKK8=;
        b=SWiqcJAuvIBpAdLpvbWJy3awpiHUIkLHQQtj2NElvyuymNoyj9Hb+ibzK4SWVO9CEm
         ydSmvOajqAvWo6Wni7M9K4e46E3yksNWxmnXdGeV5nS+UWSxMcDRL7UytE2Qk+iMzbZD
         /xcUt4mblR3pYysFoxPh00oSi455JU57Dwx/6cGTkgs/9+us6gxmg94SqJpTtIEIrDV8
         hG4BT/jxNcJlGd/+RekYzO/E19Rzfu9FSVph8Dc42Eg3z+UI5j71bldOlHY6ClLgmyr3
         LKfZ2CDjG47vz0njfeQgfARQO2WMg8xkK1GiI3uQRHQEQXzYQ1fBA/DvnWxMWUp5tfYB
         tAxw==
X-Gm-Message-State: AO0yUKVTvS9qN9bJdUIWqYI90Ra94JzlTi56QFwgdmaZYatcgLb0cwbe
        Qc9jNoALS7YMOPe315jwvvNgwuGq2mffLCyE
X-Google-Smtp-Source: AK7set9KLwuvVC8Q6+M99u+CLUSYkkYGj7jEBS+Gyrw6a74P636suFdhqq63DjqB+Gv++Hrip3yoKQ==
X-Received: by 2002:a17:903:2810:b0:19c:dbce:dce0 with SMTP id kp16-20020a170903281000b0019cdbcedce0mr1200473plb.69.1677561173631;
        Mon, 27 Feb 2023 21:12:53 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902c1c400b0019a96a6543esm5397279plc.184.2023.02.27.21.12.52
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 21:12:53 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pWsIE-0030bI-8M
        for linux-xfs@vger.kernel.org; Tue, 28 Feb 2023 16:12:50 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pWsIE-005C9e-0X
        for linux-xfs@vger.kernel.org;
        Tue, 28 Feb 2023 16:12:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: quotacheck failure can race with background inode inactivation
Date:   Tue, 28 Feb 2023 16:12:50 +1100
Message-Id: <20230228051250.1238353-1-david@fromorbit.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The background inode inactivation can attached dquots to inodes, but
this can race with a foreground quotacheck failure that leads to
disabling quotas and freeing the mp->m_quotainfo structure. The
background inode inactivation then tries to allocate a quota, tries
to dereference mp->m_quotainfo, and crashes like so:

XFS (loop1): Quotacheck: Unsuccessful (Error -5): Disabling quotas.
xfs filesystem being mounted at /root/syzkaller.qCVHXV/0/file0 supports timestamps until 2038 (0x7fffffff)
BUG: kernel NULL pointer dereference, address: 00000000000002a8
....
CPU: 0 PID: 161 Comm: kworker/0:4 Not tainted 6.2.0-c9c3395d5e3d #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Workqueue: xfs-inodegc/loop1 xfs_inodegc_worker
RIP: 0010:xfs_dquot_alloc+0x95/0x1e0
....
Call Trace:
 <TASK>
 xfs_qm_dqread+0x46/0x440
 xfs_qm_dqget_inode+0x154/0x500
 xfs_qm_dqattach_one+0x142/0x3c0
 xfs_qm_dqattach_locked+0x14a/0x170
 xfs_qm_dqattach+0x52/0x80
 xfs_inactive+0x186/0x340
 xfs_inodegc_worker+0xd3/0x430
 process_one_work+0x3b1/0x960
 worker_thread+0x52/0x660
 kthread+0x161/0x1a0
 ret_from_fork+0x29/0x50
 </TASK>
....

Prevent this race by flushing all the queued background inode
inactivations pending before purging all the cached dquots when
quotacheck fails.

Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_qm.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e2c542f6dcd4..78ca52e55f03 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1321,15 +1321,14 @@ xfs_qm_quotacheck(
 
 	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
 			NULL);
-	if (error) {
-		/*
-		 * The inode walk may have partially populated the dquot
-		 * caches.  We must purge them before disabling quota and
-		 * tearing down the quotainfo, or else the dquots will leak.
-		 */
-		xfs_qm_dqpurge_all(mp);
-		goto error_return;
-	}
+
+	/*
+	 * On error, the inode walk may have partially populated the dquot
+	 * caches.  We must purge them before disabling quota and tearing down
+	 * the quotainfo, or else the dquots will leak.
+	 */
+	if (error)
+		goto error_purge;
 
 	/*
 	 * We've made all the changes that we need to make incore.  Flush them
@@ -1363,10 +1362,8 @@ xfs_qm_quotacheck(
 	 * and turn quotaoff. The dquots won't be attached to any of the inodes
 	 * at this point (because we intentionally didn't in dqget_noattach).
 	 */
-	if (error) {
-		xfs_qm_dqpurge_all(mp);
-		goto error_return;
-	}
+	if (error)
+		goto error_purge;
 
 	/*
 	 * If one type of quotas is off, then it will lose its
@@ -1376,7 +1373,7 @@ xfs_qm_quotacheck(
 	mp->m_qflags &= ~XFS_ALL_QUOTA_CHKD;
 	mp->m_qflags |= flags;
 
- error_return:
+error_return:
 	xfs_buf_delwri_cancel(&buffer_list);
 
 	if (error) {
@@ -1395,6 +1392,21 @@ xfs_qm_quotacheck(
 	} else
 		xfs_notice(mp, "Quotacheck: Done.");
 	return error;
+
+error_purge:
+	/*
+	 * On error, we may have inodes queued for inactivation. This may try
+	 * to attach dquots to the inode before running cleanup operations on
+	 * the inode and this can race with the xfs_qm_destroy_quotainfo() call
+	 * below that frees mp->m_quotainfo. To avoid this race, flush all the
+	 * pending inodegc operations before we purge the dquots from memory,
+	 * ensuring that background inactivation is idle whilst we turn off
+	 * quotas.
+	 */
+	xfs_inodegc_flush(mp);
+	xfs_qm_dqpurge_all(mp);
+	goto error_return;
+
 }
 
 /*
-- 
2.39.2

