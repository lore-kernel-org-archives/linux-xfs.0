Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD83C5AE4A
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344469AbjKPC2n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235606AbjKPC2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:43 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F59D19D;
        Wed, 15 Nov 2023 18:28:40 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-5c194b111d6so262853a12.0;
        Wed, 15 Nov 2023 18:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101720; x=1700706520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fm0nurSqmX2QXFRztZniu+GFOzuvFBEG1IBYCjPNRJs=;
        b=a/TGRGYFVZ1Bkz3hXcfKhI6txyEAxHWZlyUvrgLU0kw17pems4I4DNUG/aJeEcHFmL
         6d9sS66IOXRhVxF2h8zGyhTJBF+geo4hQ3NrhqzhSjDZRbgXsOU5NdZouELhTpgZm1Lk
         qEWGFK2nuuURzZJImHCWEedhhJ/zGqC6s3RsV4hBalaUU9d4abhPurn01VO8JJRyTIHX
         vuEdVwedKzGp4QSQ2lPY2c9+XGhKS+MCFy1sjwrycB/SYz9/0lJndqr9goHCYo/GcR7l
         0i2prTaa9l1ufmkUxG2e9X48xW+z3c060foVnqU20O593dV3xh75OKpgz2u9uTLDpwuE
         arCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101720; x=1700706520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fm0nurSqmX2QXFRztZniu+GFOzuvFBEG1IBYCjPNRJs=;
        b=i5pNry/dVy7pXfSgHCOX0tDFiu1c3o5qZWMnimvLBW4bzOZ35ezIndzp1NYSkdeA5T
         uQFY5vYbSV95hJDCd5ub25AXXlRXFMph44iDCGASeGgS96yuJ4PdrU9WaaMliz6kHm16
         GQ7tDD7BOp/Ph7vt6+vmGg4lAAS+Y+9mFHcALfSrJcdMkiPrjdm09QtsmIqtt4oswsQV
         xQxhQb0h6Sm7huMoQ5TqNeir284+EGjtCw6HxtGWKX6MvrZ03+lgRlnECgTH0+WTyFr0
         kSBFe1X9yy52s+iFEK7E7Ysb6a06HVSCiohaUMHCkie2KK+3vLc/jqttIzrEagggmGGZ
         BrFw==
X-Gm-Message-State: AOJu0YxGCOEEUfbKnOEQhyRHM4cVLpcBnwToS3p9WIamwLhvqcw+MtiH
        zjJ7atednS+Zhgai5Ko5nyvzOXc7/rLOoQ==
X-Google-Smtp-Source: AGHT+IH2g4CPXDAzTdQ281XpPmWim6uGCjXwDSKCIRhgIEI9M8s0LoHWc5gFZektvZ1TB8JmdzVSaQ==
X-Received: by 2002:a05:6a20:840b:b0:186:de1b:666 with SMTP id c11-20020a056a20840b00b00186de1b0666mr11816916pzd.25.1700101719658;
        Wed, 15 Nov 2023 18:28:39 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:39 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 02/17] xfs: don't leak xfs_buf_cancel structures when recovery fails
Date:   Wed, 15 Nov 2023 18:28:18 -0800
Message-ID: <20231116022833.121551-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231116022833.121551-1-leah.rumancik@gmail.com>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 8db074bd84df5ccc88bff3f8f900f66f4b8349fa ]

If log recovery fails, we free the memory used by the buffer
cancellation buckets, but we don't actually traverse each bucket list to
free the individual xfs_buf_cancel objects.  This leads to a memory
leak, as reported by kmemleak in xfs/051:

unreferenced object 0xffff888103629560 (size 32):
  comm "mount", pid 687045, jiffies 4296935916 (age 10.752s)
  hex dump (first 32 bytes):
    08 d3 0a 01 00 00 00 00 08 00 00 00 01 00 00 00  ................
    d0 f5 0b 92 81 88 ff ff 80 64 64 25 81 88 ff ff  .........dd%....
  backtrace:
    [<ffffffffa0317c83>] kmem_alloc+0x73/0x140 [xfs]
    [<ffffffffa03234a9>] xlog_recover_buf_commit_pass1+0x139/0x200 [xfs]
    [<ffffffffa032dc27>] xlog_recover_commit_trans+0x307/0x350 [xfs]
    [<ffffffffa032df15>] xlog_recovery_process_trans+0xa5/0xe0 [xfs]
    [<ffffffffa032e12d>] xlog_recover_process_data+0x8d/0x140 [xfs]
    [<ffffffffa032e49d>] xlog_do_recovery_pass+0x19d/0x740 [xfs]
    [<ffffffffa032f22d>] xlog_do_log_recovery+0x6d/0x150 [xfs]
    [<ffffffffa032f343>] xlog_do_recover+0x33/0x1d0 [xfs]
    [<ffffffffa032faba>] xlog_recover+0xda/0x190 [xfs]
    [<ffffffffa03194bc>] xfs_log_mount+0x14c/0x360 [xfs]
    [<ffffffffa030bfed>] xfs_mountfs+0x50d/0xa60 [xfs]
    [<ffffffffa03124b5>] xfs_fs_fill_super+0x6a5/0x950 [xfs]
    [<ffffffff812b92a5>] get_tree_bdev+0x175/0x280
    [<ffffffff812b7c3a>] vfs_get_tree+0x1a/0x80
    [<ffffffff812e366f>] path_mount+0x6ff/0xaa0
    [<ffffffff812e3b13>] __x64_sys_mount+0x103/0x140

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index dc099b2f4984..635f7f8ed9c2 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1044,9 +1044,22 @@ void
 xlog_free_buf_cancel_table(
 	struct xlog	*log)
 {
+	int		i;
+
 	if (!log->l_buf_cancel_table)
 		return;
 
+	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++) {
+		struct xfs_buf_cancel	*bc;
+
+		while ((bc = list_first_entry_or_null(
+				&log->l_buf_cancel_table[i],
+				struct xfs_buf_cancel, bc_list))) {
+			list_del(&bc->bc_list);
+			kmem_free(bc);
+		}
+	}
+
 	kmem_free(log->l_buf_cancel_table);
 	log->l_buf_cancel_table = NULL;
 }
-- 
2.43.0.rc0.421.g78406f8d94-goog

