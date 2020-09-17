Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974CFC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 09:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55F242083B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 09:44:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G1bugI9d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgIQJoa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 05:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgIQJo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 05:44:29 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48ACC06174A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 02:44:28 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b124so848811pfg.13
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 02:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3OIsccCbAPpFX8X2t7gDY6lXFy86qUcFvfIu10IbvtY=;
        b=G1bugI9dEcox5YW+eUWjgQCaFENFh7eV6Tju0CQOIdbm9MkDj4dbIrt7h/sCYMDlXP
         xB5+eSa+nuV7+YRWnXdT+hQJYj8OvtP8LtnsEghWwXov0K1Oh+be9dh4x/G22JNh63Mt
         xEAG5M7KxZduQcfYhy+F2wzMRi93P+S3nKIhJIy0b1LcHKsemVcGynesk66GzRabGsyY
         1Ft4S5+Tha5PWh1mBsFlB6O6VT9/e/OiY1SbsfuKGlTyhvE+evP+etJi7gmHdlqTPh24
         mPMfYNMG8kfUbNlQyU9drHNRt4yN8VSXQA5oUVkKgfgSDNiqusIes0cvrvDNdLjrf5XW
         01qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3OIsccCbAPpFX8X2t7gDY6lXFy86qUcFvfIu10IbvtY=;
        b=QfPbnnBdvFvHjkZRU63QhHb5AmlkG+DKS6LV+57x+pRooJ/Ntn0M4v3DTvpg35i/to
         mVuNrx4yy3OFcJgMTIEA+eR1yqOYOHc7DatUBtBLJhYZ3NUv2QAMeTonxd7gBdKUY6w2
         VzHeTaCmHz1ClFt/Df7KB17BMK54OtV9/85pK/c9otLW3LX1dUMa5j5G58TJK4uPs0Oz
         /SQtQxUtATfxUua+eR0JYnY8P7qU0nZf8K/dVCtakqtJkZdKnaIad02JqRzO0YCjVcL2
         MRFw/snB5Fm8938HXMSqUdwFhi3QNo+qR1MMw2A73ce037o8ovhA8Q1JoOOqhc3+egR9
         fv5w==
X-Gm-Message-State: AOAM532PptUNWLU6r0pr/OfY+PG555JPasiYpIJGkq7dDaOcyHGbW/0o
        1u3RuRdNB5LsPLlG99eT5+4KITafwFg=
X-Google-Smtp-Source: ABdhPJyW0GPhX11ZGxOvPri5Tf9prWd7shfEasUhkglQnCIiGv3MrmGEFEDMtSRy6p8Eo1I5AEfpPQ==
X-Received: by 2002:a63:4e4f:: with SMTP id o15mr21088424pgl.202.1600335866315;
        Thu, 17 Sep 2020 02:44:26 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.198])
        by smtp.gmail.com with ESMTPSA id h12sm19848467pfo.68.2020.09.17.02.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 02:44:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com
Subject: [PATCH] xfs: Set xfs_buf's b_ops member when zeroing bitmap/summary files
Date:   Thu, 17 Sep 2020 15:13:56 +0530
Message-Id: <20200917094356.2858-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In xfs_growfs_rt(), we enlarge bitmap and summary files by allocating
new blocks for both files. For each of the new blocks allocated, we
allocate an xfs_buf, zero the payload, log the contents and commit the
transaction. Hence these buffers will eventually find themselves
appended to list at xfs_ail->ail_buf_list.

Later, xfs_growfs_rt() loops across all of the new blocks belonging to
the bitmap inode to set the bitmap values to 1. In doing so, it
allocates a new transaction and invokes the following sequence of
functions,
  - xfs_rtfree_range()
    - xfs_rtmodify_range()
      - xfs_rtbuf_get()
        We pass '&xfs_rtbuf_ops' as the ops pointer to xfs_trans_read_buf().
        - xfs_trans_read_buf()
	  We find the xfs_buf of interest in per-ag hash table, invoke
	  xfs_buf_reverify() which ends up assigning '&xfs_rtbuf_ops' to
	  xfs_buf->b_ops.

On the other hand, if xfs_growfs_rt_alloc() had allocated a few blocks
for the bitmap inode and returned with an error, all the xfs_bufs
corresponding to the new bitmap blocks that have been allocated would
continue to be on xfs_ail->ail_buf_list list without ever having a
non-NULL value assigned to their b_ops members. An AIL flush operation
would then trigger the following warning message to be printed on the
console,

  XFS (loop0): _xfs_buf_ioapply: no buf ops on daddr 0x58 len 8
  00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  CPU: 3 PID: 449 Comm: xfsaild/loop0 Not tainted 5.8.0-rc4-chandan-00038-g4d8c2b9de9ab-dirty #37
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
  Call Trace:
   dump_stack+0x57/0x70
   _xfs_buf_ioapply+0x37c/0x3b0
   ? xfs_rw_bdev+0x1e0/0x1e0
   ? xfs_buf_delwri_submit_buffers+0xd4/0x210
   __xfs_buf_submit+0x6d/0x1f0
   xfs_buf_delwri_submit_buffers+0xd4/0x210
   xfsaild+0x2c8/0x9e0
   ? __switch_to_asm+0x42/0x70
   ? xfs_trans_ail_cursor_first+0x80/0x80
   kthread+0xfe/0x140
   ? kthread_park+0x90/0x90
   ret_from_fork+0x22/0x30

This message indicates that the xfs_buf had its b_ops member set to
NULL.

This commit fixes the issue by assigning "&xfs_rtbuf_ops" to b_ops
member of each of the xfs_bufs logged by xfs_growfs_rt_alloc().

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---

PS: I had got xfs_growfs_rt_alloc() to return an error code after
allocating a few blocks by injecting an error tag from userspace. This
was done to test "Prevent inode extent overflow" patchset. The error
injection causes xfs_growfs_rt_alloc() to return -EFBIG error code
when an inode's extent count goes beyond a certain threshold.

 fs/xfs/xfs_rtalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ace99cfa3e8b..9d4e33d70d2a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -849,6 +849,7 @@ xfs_growfs_rt_alloc(
 				goto out_trans_cancel;
 
 			xfs_trans_buf_set_type(tp, bp, buf_type);
+			bp->b_ops = &xfs_rtbuf_ops;
 			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
 			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 			/*
-- 
2.28.0

