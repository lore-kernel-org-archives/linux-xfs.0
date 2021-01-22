Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E7AC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 16:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61F8823AA1
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 16:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbhAVQvJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Jan 2021 11:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbhAVQo6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jan 2021 11:44:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10718C0613D6;
        Fri, 22 Jan 2021 08:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=irLuJu46wFlvKBuIGQmEQWUaIHSxZIK3WfK+r5wo/RA=; b=A0wOEF80cFkEtWtUmJNuUbPufX
        vygpyGcfQpRf+biQL9uJqWqSYcNEPH2GeqD7NOnRwUZ6Tv/Ows9bvaNiSM3ZV/dOiVGSe9KfrR83a
        Bi4eIMV0dMK6EmdeZAXmwB6++rJnDyfaUhg6tFOqTdXUk7HQjW0cAK1aLQvvM4e8m8BR67s7YTIro
        ygXaxBYbRHj5U86LpmVYiPtdHGf4GOjfrmfeXjoyurmQTi5kDgJ2LT91gsV1SUH6y/68c5R/wPEEP
        HLGUOIzrwuRyXjU9uGX93nDWlYyiTDrbkkwxngvs6FKFLGtDmH2/6SouX3YvFOoyqiIEsNESov/0e
        EgmPa7Jg==;
Received: from [2001:4bb8:188:1954:662b:86d3:ab5f:ac21] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l2zKj-000xh9-LP; Fri, 22 Jan 2021 16:31:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, avi@scylladb.com,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 06/11] xfs: improve the reflink_bounce_dio_write tracepoint
Date:   Fri, 22 Jan 2021 17:20:38 +0100
Message-Id: <20210122162043.616755-7-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210122162043.616755-1-hch@lst.de>
References: <20210122162043.616755-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use a more suitable event class.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  | 2 +-
 fs/xfs/xfs_trace.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index aa64e78fc3c467..a696bd34f71d21 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -560,7 +560,7 @@ xfs_file_dio_write(
 		 * files yet, as we can't unshare a partial block.
 		 */
 		if (xfs_is_cow_inode(ip)) {
-			trace_xfs_reflink_bounce_dio_write(ip, iocb->ki_pos, count);
+			trace_xfs_reflink_bounce_dio_write(iocb, from);
 			return -ENOTBLK;
 		}
 		iolock = XFS_IOLOCK_EXCL;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a6d04d860a565e..0cfd65cd67c190 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1321,6 +1321,8 @@ DEFINE_RW_EVENT(xfs_file_dax_read);
 DEFINE_RW_EVENT(xfs_file_buffered_write);
 DEFINE_RW_EVENT(xfs_file_direct_write);
 DEFINE_RW_EVENT(xfs_file_dax_write);
+DEFINE_RW_EVENT(xfs_reflink_bounce_dio_write);
+
 
 DECLARE_EVENT_CLASS(xfs_imap_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
@@ -3294,8 +3296,6 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_found);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_enospc);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_convert_cow);
 
-DEFINE_SIMPLE_IO_EVENT(xfs_reflink_bounce_dio_write);
-
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap);
-- 
2.29.2

