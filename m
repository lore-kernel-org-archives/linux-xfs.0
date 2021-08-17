Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B23C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BB4C61038
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236526AbhHQXnl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:43:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236443AbhHQXnl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:43:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DD80604AC;
        Tue, 17 Aug 2021 23:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243787;
        bh=eVWsWm23Oc5Qk+zkPqSn4iboWoTH1fXVzHWlyEuRKC8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Gnifzww7Z7qWluNPPel9cD/blJInxvulcdNkT4z1bArAAwMy6fYZ8Pl83DjbOtKod
         OihsYHLI6IlvmtJ98PA0Jo5HSxcJeocEE3Yx9S3d/iQMAb+hC1MA0ExYbTmVNpZqoG
         iMeBDdJ5BcZq36D2z1MyrvIKEdDksE8xC3v4lJFNBfIPVaf3aagN79BAH2Emu7iumr
         wGbtUTlbrNwircxCcDY8zlG9HVclcQ2HO25EQGXQEJJqbTueEIkdNBHfUE+JfxueG6
         7H/BGg2wE4wKlnF7CXEVRm6IxoU2vafayNRhwblVSeq0ta8LiyqXULMj6wbmLQxgh6
         4k4T0P6wpBNmg==
Subject: [PATCH 10/15] xfs: disambiguate units for ftrace fields tagged
 "count"
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:43:07 -0700
Message-ID: <162924378705.761813.11309968953103960937.stgit@magnolia>
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

Some of our tracepoints have a field known as "count".  That name
doesn't describe any units, which makes the fields not very useful.
Rename the fields to capture units and ensure the format is hexadecimal
when we're referring to blocks, extents, or IO operations.

"blockcount" are in units of fs blocks
"bytecount" are in units of bytes
"icount" are in units of inode records

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trace.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7ae654f7ae82..07da753588d5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -346,7 +346,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx state %s cur %p/%d "
-		  "fileoff 0x%llx startblock 0x%llx count %lld flag %d caller %pS",
+		  "fileoff 0x%llx startblock 0x%llx blockcount 0x%llx flag %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
@@ -806,7 +806,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 		__entry->pincount = atomic_read(&ip->i_pincount);
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %pS",
+	TP_printk("dev %d:%d ino 0x%llx icount %d pincount %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->count,
@@ -1386,7 +1386,7 @@ DECLARE_EVENT_CLASS(xfs_file_class,
 		__entry->offset = iocb->ki_pos;
 		__entry->count = iov_iter_count(iter);
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx count 0x%zx",
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx bytecount 0x%zx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
@@ -1433,7 +1433,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
 		__entry->startblock = irec ? irec->br_startblock : 0;
 		__entry->blockcount = irec ? irec->br_blockcount : 0;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx count %zd "
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx bytecount 0x%zx "
 		  "fork %s startoff 0x%llx startblock 0x%llx blockcount 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
@@ -1476,7 +1476,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 		__entry->count = count;
 	),
 	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx disize 0x%llx "
-		  "pos 0x%llx count %zd",
+		  "pos 0x%llx bytecount 0x%zx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->isize,
@@ -3217,7 +3217,7 @@ DECLARE_EVENT_CLASS(xfs_double_io_class,
 		__field(loff_t, src_isize)
 		__field(loff_t, src_disize)
 		__field(loff_t, src_offset)
-		__field(size_t, len)
+		__field(long long, len)
 		__field(xfs_ino_t, dest_ino)
 		__field(loff_t, dest_isize)
 		__field(loff_t, dest_disize)
@@ -3235,7 +3235,7 @@ DECLARE_EVENT_CLASS(xfs_double_io_class,
 		__entry->dest_disize = dest->i_disk_size;
 		__entry->dest_offset = doffset;
 	),
-	TP_printk("dev %d:%d count %zd "
+	TP_printk("dev %d:%d bytecount 0x%llx "
 		  "ino 0x%llx isize 0x%llx disize 0x%llx pos 0x%llx -> "
 		  "ino 0x%llx isize 0x%llx disize 0x%llx pos 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),

