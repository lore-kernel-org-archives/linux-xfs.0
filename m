Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B17C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA3336102A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbhHQXnr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236443AbhHQXnq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:43:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9ADC61008;
        Tue, 17 Aug 2021 23:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243793;
        bh=6qYxnrYM2UmDgEl0ESQ75xG95w456zqU5RIVsxnqB/s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sL4HP5T/8o01DfIxmfN0s3NcFtdyBq9KwF7NwLaefrn8evti1PFUWRhNlSHlARJ42
         43DWpbwDd9GoxxT5MAK1fOpAYHOnu8k3k2TMqitbBQH6rRZ95NH9017qYg3mEacvNC
         9qoKXFKNMaL4MNuQaKoJjVq6eESmW0It09kFU0A8PqsJFRPFrUQ4emrVhEokeqXnUA
         SyXxkmY7EVMYzvmhkN3MQNRH7dF/Hxc/JDOpQe/YogTxYdJEDtnUYthYJoUWpquPNG
         OGnC0HUlVMKraB8FwLdmLQq2rsYW5NgE1d7M8n2Aa+0jkJQQM/DsaWv9JxafroBV4l
         JxXJrgJCaBH2A==
Subject: [PATCH 11/15] xfs: rename i_disk_size fields in ftrace output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:43:12 -0700
Message-ID: <162924379266.761813.11427424580864028418.stgit@magnolia>
In-Reply-To: <162924373176.761813.10896002154570305865.stgit@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Whenever we record i_disk_size (i.e. the ondisk file size), use the
"disize" tag and hexadecimal format consistently.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trace.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 07da753588d5..29bf5fbfa71b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1386,7 +1386,7 @@ DECLARE_EVENT_CLASS(xfs_file_class,
 		__entry->offset = iocb->ki_pos;
 		__entry->count = iov_iter_count(iter);
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx bytecount 0x%zx",
+	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx pos 0x%llx bytecount 0x%zx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
@@ -1433,7 +1433,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
 		__entry->startblock = irec ? irec->br_startblock : 0;
 		__entry->blockcount = irec ? irec->br_blockcount : 0;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx bytecount 0x%zx "
+	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx pos 0x%llx bytecount 0x%zx "
 		  "fork %s startoff 0x%llx startblock 0x%llx blockcount 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
@@ -1512,7 +1512,7 @@ DECLARE_EVENT_CLASS(xfs_itrunc_class,
 		__entry->size = ip->i_disk_size;
 		__entry->new_size = new_size;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx",
+	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx new_size 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
@@ -1543,7 +1543,7 @@ TRACE_EVENT(xfs_pagecache_inval,
 		__entry->start = start;
 		__entry->finish = finish;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx start 0x%llx finish 0x%llx",
+	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx start 0x%llx finish 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
@@ -1573,7 +1573,7 @@ TRACE_EVENT(xfs_bunmap,
 		__entry->caller_ip = caller_ip;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx fileoff 0x%llx blockcount 0x%llx"
+	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx fileoff 0x%llx blockcount 0x%llx"
 		  "flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,

