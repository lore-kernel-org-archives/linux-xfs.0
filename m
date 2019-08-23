Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58426C3A589
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 04:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F1CA233FD
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 04:56:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a8jrX74E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391606AbfHWE46 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 00:56:58 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43214 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfHWE46 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Aug 2019 00:56:58 -0400
Received: by mail-pg1-f195.google.com with SMTP id k3so5053133pgb.10
        for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2019 21:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ioorVXKA7iL0IywhzLAMKq2Uv5+evmeLYlJD1mL2820=;
        b=a8jrX74E723IX09NlcAH34snBo71XMHO4ZgIg1bxG+CDV0Bj8BNYSxqSkYkEfpIskL
         XYoMG7hLQixrmEYfz157dz/lz2Y5Bp7Hw4oXTvdpgxNPK4Qi1G8XbcpOI3hYZA2+VcGR
         595yFN/0hEiZw2UumLCE63X9DGBHxrTfB3SMdPI67cjr7eEBORNiVOxY+oDs5iIqM4TH
         jbw8hQTlKhq3qk9dxP0FvLGJAyYj2NaP05fDSdAYN2XBKv0r1ghz23Fa+sJIw5p+Fzum
         FrZrxRHopydIM3/QTu/lnoLE5zx/9EEGvYjUzldOK3b+QYaPjaMCIQjdvXkuVtUJ9FZ0
         9Eag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ioorVXKA7iL0IywhzLAMKq2Uv5+evmeLYlJD1mL2820=;
        b=JOCvXuISj+bOWeGPYiE+6JZwxgdyZbB0cEe/foieL59NVFQWeVRBOQMiUTSfeyMN/k
         WjIku0F8frSSC+DiyFZOESVLt5z2yOg6EkdL9uw+wNK6/XYMOd2gM+7RqJRaQc33opOP
         sZ7bhjLd90XRsHuxfcYhPtn4skzq58kpYLumAXuAcjovwDS2wEnbub23PpfGumHkgT+s
         ouXMAEOVpG25Xpc6SfFmdqU9EeEddJCmNlapoQ6pc36dFEP7atebwBIqD0kYyOuHggIc
         nf2lYviFeu3YTRMcdI5PQQUBj24FxkoTHH17nloJuFV+rUfup/kKfOJKuScWHv90j128
         NAfQ==
X-Gm-Message-State: APjAAAViwWooam3z7qqV5X8ukFS6xWe4CI/1D5PeRO5CaOcViS4DEV4E
        KxxEH2oytNz77SL2z7AP94SfPNY=
X-Google-Smtp-Source: APXvYqwJAinZeI42RYbYb1igZlKd/nX6tOiB/rK/nA6PgvFLtrw3XFNmBeTLslO/KwbaXH+g2SA7zQ==
X-Received: by 2002:a62:2603:: with SMTP id m3mr3125225pfm.163.1566536217563;
        Thu, 22 Aug 2019 21:56:57 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id z4sm834426pgp.80.2019.08.22.21.56.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 21:56:56 -0700 (PDT)
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com, xiakaixu1987@gmail.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH] xfs: Fix ABBA deadlock between AGI and AGF in rename()
Message-ID: <08753b9e-4da1-ca61-af12-0b4aad8ed516@gmail.com>
Date:   Fri, 23 Aug 2019 12:56:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When performing rename operation with RENAME_WHITEOUT flag, we will
hold AGF lock to allocate or free extents in manipulating the dirents
firstly, and then doing the xfs_iunlink_remove() call last to hold
AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.

The big problem here is that we have an ordering constraint on AGF
and AGI locking - inode allocation locks the AGI, then can allocate
a new extent for new inodes, locking the AGF after the AGI. Hence
the ordering that is imposed by other parts of the code is AGI before
AGF. So we get an ABBA deadlock between the AGI and AGF here.

Process A:
Call trace:
 ? __schedule+0x2bd/0x620
 schedule+0x33/0x90
 schedule_timeout+0x17d/0x290
 __down_common+0xef/0x125
 ? xfs_buf_find+0x215/0x6c0 [xfs]
 down+0x3b/0x50
 xfs_buf_lock+0x34/0xf0 [xfs]
 xfs_buf_find+0x215/0x6c0 [xfs]
 xfs_buf_get_map+0x37/0x230 [xfs]
 xfs_buf_read_map+0x29/0x190 [xfs]
 xfs_trans_read_buf_map+0x13d/0x520 [xfs]
 xfs_read_agf+0xa6/0x180 [xfs]
 ? schedule_timeout+0x17d/0x290
 xfs_alloc_read_agf+0x52/0x1f0 [xfs]
 xfs_alloc_fix_freelist+0x432/0x590 [xfs]
 ? down+0x3b/0x50
 ? xfs_buf_lock+0x34/0xf0 [xfs]
 ? xfs_buf_find+0x215/0x6c0 [xfs]
 xfs_alloc_vextent+0x301/0x6c0 [xfs]
 xfs_ialloc_ag_alloc+0x182/0x700 [xfs]
 ? _xfs_trans_bjoin+0x72/0xf0 [xfs]
 xfs_dialloc+0x116/0x290 [xfs]
 xfs_ialloc+0x6d/0x5e0 [xfs]
 ? xfs_log_reserve+0x165/0x280 [xfs]
 xfs_dir_ialloc+0x8c/0x240 [xfs]
 xfs_create+0x35a/0x610 [xfs]
 xfs_generic_create+0x1f1/0x2f0 [xfs]
 ...

Process B:
Call trace:
 ? __schedule+0x2bd/0x620
 ? xfs_bmapi_allocate+0x245/0x380 [xfs]
 schedule+0x33/0x90
 schedule_timeout+0x17d/0x290
 ? xfs_buf_find+0x1fd/0x6c0 [xfs]
 __down_common+0xef/0x125
 ? xfs_buf_get_map+0x37/0x230 [xfs]
 ? xfs_buf_find+0x215/0x6c0 [xfs]
 down+0x3b/0x50
 xfs_buf_lock+0x34/0xf0 [xfs]
 xfs_buf_find+0x215/0x6c0 [xfs]
 xfs_buf_get_map+0x37/0x230 [xfs]
 xfs_buf_read_map+0x29/0x190 [xfs]
 xfs_trans_read_buf_map+0x13d/0x520 [xfs]
 xfs_read_agi+0xa8/0x160 [xfs]
 xfs_iunlink_remove+0x6f/0x2a0 [xfs]
 ? current_time+0x46/0x80
 ? xfs_trans_ichgtime+0x39/0xb0 [xfs]
 xfs_rename+0x57a/0xae0 [xfs]
 xfs_vn_rename+0xe4/0x150 [xfs]
 ...

In this patch we move the xfs_iunlink_remove() call to
before acquiring the AGF lock to preserve correct AGI/AGF locking
order.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_inode.c | 85 +++++++++++++++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6467d5e..584b9d1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3282,9 +3282,10 @@ struct xfs_iunlink {
 					spaceres);
 
 	/*
-	 * Set up the target.
+	 * Check for expected errors before we dirty the transaction
+	 * so we can return an error without a transaction abort.
 	 */
-	if (target_ip == NULL) {
+	if (!target_ip) {
 		/*
 		 * If there's no space reservation, check the entry will
 		 * fit before actually inserting it.
@@ -3294,6 +3295,46 @@ struct xfs_iunlink {
 			if (error)
 				goto out_trans_cancel;
 		}
+	} else {
+		/*
+		 * If target exists and it's a directory, check that whether
+		 * it can be destroyed.
+		 */
+		if (S_ISDIR(VFS_I(target_ip)->i_mode) &&
+		    (!(xfs_dir_isempty(target_ip)) ||
+		    (VFS_I(target_ip)->i_nlink > 2))) {
+			error = -EEXIST;
+			goto out_trans_cancel;
+		}
+	}
+
+	/*
+	 * Directory entry creation below may acquire the AGF. Remove
+	 * the whiteout from the unlinked list first to preserve correct
+	 * AGI/AGF locking order. This dirties the transaction so failures
+	 * after this point will abort and log recovery will clean up the
+	 * mess.
+	 *
+	 * For whiteouts, we need to bump the link count on the whiteout
+	 * inode. After this point, we have a real link, clear the tmpfile
+	 * state flag from the inode so it doesn't accidentally get misused
+	 * in future.
+	 */
+	if (wip) {
+		ASSERT(VFS_I(wip)->i_nlink == 0);
+		error = xfs_iunlink_remove(tp, wip);
+		if (error)
+			goto out_trans_cancel;
+
+		xfs_bumplink(tp, wip);
+		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
+		VFS_I(wip)->i_state &= ~I_LINKABLE;
+	}
+
+	/*
+	 * Set up the target.
+	 */
+	if (target_ip == NULL) {
 		/*
 		 * If target does not exist and the rename crosses
 		 * directories, adjust the target directory link count
@@ -3312,22 +3353,6 @@ struct xfs_iunlink {
 		}
 	} else { /* target_ip != NULL */
 		/*
-		 * If target exists and it's a directory, check that both
-		 * target and source are directories and that target can be
-		 * destroyed, or that neither is a directory.
-		 */
-		if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
-			/*
-			 * Make sure target dir is empty.
-			 */
-			if (!(xfs_dir_isempty(target_ip)) ||
-			    (VFS_I(target_ip)->i_nlink > 2)) {
-				error = -EEXIST;
-				goto out_trans_cancel;
-			}
-		}
-
-		/*
 		 * Link the source inode under the target name.
 		 * If the source inode is a directory and we are moving
 		 * it across directories, its ".." entry will be
@@ -3417,30 +3442,6 @@ struct xfs_iunlink {
 	if (error)
 		goto out_trans_cancel;
 
-	/*
-	 * For whiteouts, we need to bump the link count on the whiteout inode.
-	 * This means that failures all the way up to this point leave the inode
-	 * on the unlinked list and so cleanup is a simple matter of dropping
-	 * the remaining reference to it. If we fail here after bumping the link
-	 * count, we're shutting down the filesystem so we'll never see the
-	 * intermediate state on disk.
-	 */
-	if (wip) {
-		ASSERT(VFS_I(wip)->i_nlink == 0);
-		xfs_bumplink(tp, wip);
-		error = xfs_iunlink_remove(tp, wip);
-		if (error)
-			goto out_trans_cancel;
-		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
-
-		/*
-		 * Now we have a real link, clear the "I'm a tmpfile" state
-		 * flag from the inode so it doesn't accidentally get misused in
-		 * future.
-		 */
-		VFS_I(wip)->i_state &= ~I_LINKABLE;
-	}
-
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
-- 
1.8.3.1

-- 
kaixuxia
