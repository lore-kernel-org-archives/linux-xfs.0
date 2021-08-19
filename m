Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9E2C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 17:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B1E1601FE
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 17:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhHSRKh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 13:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhHSRKh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Aug 2021 13:10:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1458660FE6;
        Thu, 19 Aug 2021 17:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629393001;
        bh=AqhfCPSJH+/QX33IIfW5UsnsmpdVFCDlz/m0oIM/jCU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YEvcV5VF9mqOIXbbR9HLPcEK2NDRjuaiXbmWdSKFG2D1pi4HouRVeaBVE8D3PBv8J
         2426BknJqoXCJADLQjjUMMMqI0S5uZoh8EgsGZ3Sg9AHWjEkIkS7XTgQuBU2xl4wFS
         +eKBoQ8J+kzS2pxqcPGLtR6fZd9nVsskxRW4rl5ddx8HEgVjghmFzcRGe3r1ZbeVo1
         XEPc5fyJWFdFFFn8TfTCvC0IV4obk0nSE5ueF6VSWX6mfViRo5KZWl/lLlSVqnZwac
         sya/SmLu2dxoe3j5+38mKtvqDYSPEsbKKCokN+kL5XOxgtNFauvzpmv5GSstLR4flf
         xUThNy1bfw0Eg==
Date:   Thu, 19 Aug 2021 10:10:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, sandeen@sandeen.net, cmaiolino@redhat.com
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 16/15] xfs: start documenting common units and tags used
 in tracepoints
Message-ID: <20210819171000.GU12640@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <20210819030728.GN12640@magnolia>
 <20210819034647.GR12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819034647.GR12640@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Because there are a lot of tracepoints that express numeric data with
an associated unit and tag, document what they are to help everyone else
keep these thigns straight.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
v2: update unit names, say that we want hex, and put related tag names
together
v3: more corrections of unit names
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
index 676b66173bb1..6d025a231d3e 100644
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
+ * fsbcount: number of blocks in an extent, in fs blocks
+ *
+ * daddr: physical block number in 512b blocks
+ * bbcount: number of blocks in a physical extent, in 512b blocks
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
