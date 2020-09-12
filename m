Return-Path: <SRS0=ZFeo=CV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72109C433E2
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Sep 2020 13:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 313FA208E4
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Sep 2020 13:00:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aBhk6iSR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgILNAv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 12 Sep 2020 09:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbgILNAr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 12 Sep 2020 09:00:47 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2FCC061573
        for <linux-xfs@vger.kernel.org>; Sat, 12 Sep 2020 06:00:45 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id e4so2232622pln.10
        for <linux-xfs@vger.kernel.org>; Sat, 12 Sep 2020 06:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Rc3vxwkzaAhbaoo4wZyLa7jwwbOkSSP7gwJahMZwlg=;
        b=aBhk6iSRBbKTldBrq+bx2OjxZbb8SvWAlRXplkhDxAizYFU591cxBS2EnjDJtrDCg4
         2XDMkEddkHcfre8QZRT3kiZjrWCfryzL4dZZobF5o6Okmoy61JnnVNloYOE/KaKqsuwv
         hI0LKSTAK7YHseloNXQK3ZG9rblrkdt1fOAWc1XsjwZ3v0cSRFG/FjRjMIv0xCEvII5m
         5NT/6uK0Qg6ZHGxhhNMWe0sTDVAA0BDsvyn5hYj5e/AeQd/nwiRGoJ/Ywsg5wwnPsZtC
         ELVZYVO41zZv1FL8T9zg6CFL61/+yuLmvpyswJDJOwdCRAIicLBr49NeVwLxyZR0v+jU
         foUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Rc3vxwkzaAhbaoo4wZyLa7jwwbOkSSP7gwJahMZwlg=;
        b=fhVSbQZrLqZb6a5dBYglBnNlDT+IZoqOefo/OIPoARsCZHQG/5xYproMY2sXzmBGeU
         4BsgBfcLmTzLK9pW0utHjUqV2+Gtuqex91J91qMEjyRsnIU/n4B39/zsicsyUa4wMg3F
         RnSfKlv8knZX8XRrQCfGL6MSwKJP1fzUDxIszjjlo5n59VUjyLaQCSwg2YxoiiMu9gjv
         THpldXdf4emNSQX/ibx3H9PlOq723jQBBH15NivJTTlfL2nbdSEsjE7Idr6meyu5VdZu
         ykUrKr2y7AkjGbszL06NjhssUD469aqM4AtjQu90UjPR2TJnG3MKC1ehJM0hfhsCLu8d
         BXgg==
X-Gm-Message-State: AOAM530uh1A500lUHQy9V8ac0ey3Af/mSGoP64Gme4dskH046xr5Dhrf
        Mjsstrmanso9O8dpyFNfqJEbSg4QHY0=
X-Google-Smtp-Source: ABdhPJx+marJ3U1ruQtNDvsA2jNWqV+GVd06bKiNzHWzntvuOMtEzyoujDvg/4A1AqAevS+EJmUk9Q==
X-Received: by 2002:a17:902:8f98:b029:d1:870b:469e with SMTP id z24-20020a1709028f98b02900d1870b469emr6895114plo.3.1599915644503;
        Sat, 12 Sep 2020 06:00:44 -0700 (PDT)
Received: from localhost.localdomain ([122.182.232.233])
        by smtp.gmail.com with ESMTPSA id u4sm5473187pfk.166.2020.09.12.06.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 06:00:43 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com
Subject: [PATCH] xfs: Set xfs_buf type flag when growing summary/bitmap files
Date:   Sat, 12 Sep 2020 18:30:15 +0530
Message-Id: <20200912130015.11473-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following sequence of commands,

  mkfs.xfs -f -m reflink=0 -r rtdev=/dev/loop1,size=10M /dev/loop0
  mount -o rtdev=/dev/loop1 /dev/loop0 /mnt
  xfs_growfs  /mnt

... causes the following call trace to be printed on the console,

XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
Call Trace:
 xfs_buf_item_format+0x632/0x680
 ? kmem_alloc_large+0x29/0x90
 ? kmem_alloc+0x70/0x120
 ? xfs_log_commit_cil+0x132/0x940
 xfs_log_commit_cil+0x26f/0x940
 ? xfs_buf_item_init+0x1ad/0x240
 ? xfs_growfs_rt_alloc+0x1fc/0x280
 __xfs_trans_commit+0xac/0x370
 xfs_growfs_rt_alloc+0x1fc/0x280
 xfs_growfs_rt+0x1a0/0x5e0
 xfs_file_ioctl+0x3fd/0xc70
 ? selinux_file_ioctl+0x174/0x220
 ksys_ioctl+0x87/0xc0
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x3e/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

This occurs because the buffer being formatted has the value of
XFS_BLFT_UNKNOWN_BUF assigned to the 'type' subfield of
bip->bli_formats->blf_flags.

This commit fixes the issue by assigning one of XFS_BLFT_RTSUMMARY_BUF
and XFS_BLFT_RTBITMAP_BUF to the 'type' subfield of
bip->bli_formats->blf_flags before committing the corresponding
transaction.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/xfs_rtalloc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6209e7b6b895..192a69f307d7 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -767,8 +767,12 @@ xfs_growfs_rt_alloc(
 	struct xfs_bmbt_irec	map;		/* block map output */
 	int			nmap;		/* number of block maps */
 	int			resblks;	/* space reservation */
+	enum xfs_blft		buf_type;
 	struct xfs_trans	*tp;
 
+	buf_type = (ip == mp->m_rsumip) ?
+		XFS_BLFT_RTSUMMARY_BUF : XFS_BLFT_RTBITMAP_BUF;
+
 	/*
 	 * Allocate space to the file, as necessary.
 	 */
@@ -830,6 +834,8 @@ xfs_growfs_rt_alloc(
 					mp->m_bsize, 0, &bp);
 			if (error)
 				goto out_trans_cancel;
+
+			xfs_trans_buf_set_type(tp, bp, buf_type);
 			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
 			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 			/*
-- 
2.28.0

