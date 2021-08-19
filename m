Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768B6C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5107961100
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235932AbhHSDIE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235792AbhHSDIE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Aug 2021 23:08:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C956A6108E;
        Thu, 19 Aug 2021 03:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629342448;
        bh=p1EkUZIGt95UkDXU6noKmy5akcDqZXySnPXHdxWKsCc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cRdbuOIEgia5Kw0EBK83qosnUEwXYNT5WOkFrm4ibhhA7QceuUHzw7v3Bp6bFHhi9
         bt9Zs42izWljXwq6Lh1bvIm6fnCKEk5gJ+v0vRr0t7CexK48YONbsL7eAVP0V3P1vU
         8aH3ef8xE3PebA/H6lGToqXSeL8HcKpfThmK4quJjbXRuoPlMzWOGiCw6nzr6Xm2HB
         +13EM6euaOuv8L4H8O2Orx/QuWLX/aXjCWyftGIEjm5oYLeny+gvXZJ2/ufNxzihbd
         7jK138+vEy+Mzc46d5lAKQ3wq+q+vy+ySGXLOoaOFPrBNMcrI/StutHzmTIJ+CXYli
         BrwKAnBBOsuPQ==
Date:   Wed, 18 Aug 2021 20:07:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 16/15] xfs: start documenting common units and tags used in
 tracepoints
Message-ID: <20210819030728.GN12640@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924373176.761813.10896002154570305865.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Because there are a lot of tracepoints that express numeric data with
an associated unit and tag, document what they are to help everyone else
keep these thigns straight.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    4 ++++
 fs/xfs/xfs_trace.h   |   24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index e9b81b7645c1..20f34548bfe5 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2,6 +2,10 @@
 /*
  * Copyright (C) 2017 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * NOTE: none of these tracepoints shall be considered a stable kernel ABI
+ * as they can change at any time.  See xfs_trace.h for documentation of
+ * specific units found in tracepoint output.
  */
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM xfs_scrub
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a72cd56afc8c..c46dd4fea3e3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2,6 +2,30 @@
 /*
  * Copyright (c) 2009, Christoph Hellwig
  * All Rights Reserved.
+ *
+ * NOTE: none of these tracepoints shall be considered a stable kernel ABI
+ * as they can change at any time.
+ *
+ * Current conventions for printing numbers measuring specific units:
+ *
+ * ino: filesystem inode number
+ * agino: per-AG inode number
+ * agno: allocation group number
+ * agbno: per-AG block number in fs blocks
+ * owner: reverse-mapping owner, usually inodes
+ * daddr: physical block number in 512b blocks
+ * startblock: physical block number for file mappings.  This is either a
+ *             segmented fsblock for data device mappings, or a rfsblock
+ *             for realtime device mappings
+ * fileoff: file offset, in fs blocks
+ * pos: file offset, in bytes
+ * forkoff: inode fork offset, in bytes
+ * icount: number of inode records
+ * disize: ondisk file size, in bytes
+ * isize: incore file size, in bytes
+ * fsbcount: number of blocks in an extent, in fs blocks
+ * bbcount: number of blocks in a physical extent, in 512b blocks
+ * bytecount: number of bytes
  */
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM xfs
