Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFFCBC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 977F66108B
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbhHSDrX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:47:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235806AbhHSDrX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Aug 2021 23:47:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 633EC6108B;
        Thu, 19 Aug 2021 03:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629344807;
        bh=/L2ACPT1hpPZccodMrv1gZvTVhn5yaqJi2/eZdC15Tg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oc34ebp7IM2yHyfVi9rvQbeixW2qi3/eaQCoh1WAyp4006kAGSX8t9gDlpUqrETVb
         FHETTdhRf8AOatP+cV+2NS2p+xLV0qZBLamXGmyTPn3l92w4skpoQaUNCWiCfgCF7h
         L1DNi3ysNPAd6jSz6p59uEy2gGz0K7bPqQHfr2Se6f/zS31rykSJE/jX/mOMAPHnF4
         YBULfH7KzRpvms3vedaaGxmLAbCV8NbPpMolhnj9PIDZ256mxeNHp//dXv5WG/mSZ9
         +y7AUzSAzYBplu0goOcjl93OLJUpqcR4L/jZnD+xteS+/syNRCmjwB9gUo4jBMSTBR
         1e7iRJOvqqzWQ==
Date:   Wed, 18 Aug 2021 20:46:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 16/15] xfs: start documenting common units and tags used
 in tracepoints
Message-ID: <20210819034647.GR12640@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <20210819030728.GN12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819030728.GN12640@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Because there are a lot of tracepoints that express numeric data with
an associated unit and tag, document what they are to help everyone else
keep these thigns straight.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: update unit names, say that we want hex, and put related tag names together
---
 fs/xfs/scrub/trace.h |    4 ++++
 fs/xfs/xfs_trace.h   |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index dfb10966af24..a7bbb84f91a7 100644
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
index 676b66173bb1..2694e1022b7b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2,6 +2,41 @@
 /*
  * Copyright (c) 2009, Christoph Hellwig
  * All Rights Reserved.
+ *
+ * NOTE: none of these tracepoints shall be considered a stable kernel ABI
+ * as they can change at any time.
+ *
+ * Current conventions for printing numbers measuring specific units:
+ *
+ * agno: allocation group number
+ *
+ * agino: per-AG inode number
+ * ino: filesystem inode number
+ *
+ * agbno: per-AG block number in fs blocks
+ * startblock: physical block number for file mappings.  This is either a
+ *             segmented fsblock for data device mappings, or a rfsblock
+ *             for realtime device mappings
+ * blockcount: number of blocks in an extent, in fs blocks
+ *
+ * daddr: physical block number in 512b blocks
+ * daddrcount: number of blocks in a physical extent, in 512b blocks
+ *
+ * owner: reverse-mapping owner, usually inodes
+ *
+ * fileoff: file offset, in fs blocks
+ * pos: file offset, in bytes
+ * bytecount: number of bytes
+ *
+ * disize: ondisk file size, in bytes
+ * isize: incore file size, in bytes
+ *
+ * forkoff: inode fork offset, in bytes
+ *
+ * ireccount: number of inode records
+ *
+ * Numbers describing space allocations (blocks, extents, inodes) should be
+ * formatted in hexadecimal.
  */
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM xfs
