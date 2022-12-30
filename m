Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7303C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiLaDAl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiLaDAk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:00:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E891929B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:00:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D530561D07
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C6DC433D2;
        Sat, 31 Dec 2022 03:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455639;
        bh=gDz99+4hlZFaG62aQqlbXxamSrWqa2W41b1OYzS95xQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PV/ycm2y7bbJOAyGjk1z2xi8BnhwWb3AY43jjnMjMhrZuD3MxspFDJOVhHH3iGCdQ
         9nQcldmKw/kPNt3FaleGZPhjXmKFsSNRnsQakgAy/jXqe0T5G/+s4cczZe3IKAn+wm
         NTnbUfwV8+VaEQJho8S9GxUqidlNZUd5CiEvzoPEcsTrKsNBfFrbdySd2cCJ4NmQIZ
         r0TTbh5Zr5CHhASVNI6Y71JmW4EBPW49DLIP8R7naclvcp5LpR8rOJKycB957pB+kF
         MgJ8FY7XJPPHhJZSWRGMy0mB13OhWa4cNum7rq3tam7WKTyiQU7j3HsbT2fzdOuWNL
         dbujx7BGzOxPg==
Subject: [PATCH 25/41] xfs_db: support the realtime refcountbt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:11 -0800
Message-ID: <167243881100.734096.18302912584792693090.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Wire up various parts of xfs_db for realtime refcount support.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/btblock.c             |    3 +++
 db/btdump.c              |   11 ++++++++++-
 db/btheight.c            |    5 +++++
 libxfs/libxfs_api_defs.h |    1 +
 man/man8/xfs_db.8        |    1 +
 5 files changed, 20 insertions(+), 1 deletion(-)


diff --git a/db/btblock.c b/db/btblock.c
index 0a581593a59..6ea146ba62a 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -159,6 +159,9 @@ block_to_bt(
 	case TYP_REFCBT:
 		magic = crc ? XFS_REFC_CRC_MAGIC : 0;
 		break;
+	case TYP_RTREFCBT:
+		magic = crc ? XFS_RTREFC_CRC_MAGIC : 0;
+		break;
 	default:
 		ASSERT(0);
 	}
diff --git a/db/btdump.c b/db/btdump.c
index 9c528e5a11a..31f32a8f7a5 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -447,7 +447,8 @@ is_btree_inode(void)
 	struct xfs_dinode	*dip;
 
 	dip = iocur_top->data;
-	return dip->di_format == XFS_DINODE_FMT_RMAP;
+	return dip->di_format == XFS_DINODE_FMT_RMAP ||
+	       dip->di_format == XFS_DINODE_FMT_REFCOUNT;
 }
 
 static int
@@ -457,6 +458,7 @@ dump_btree_inode(
 	char			*prefix;
 	struct xfs_dinode	*dip;
 	struct xfs_rtrmap_root	*rtrmap;
+	struct xfs_rtrefcount_root *rtrefc;
 	int			level;
 	int			numrecs;
 	int			ret;
@@ -469,6 +471,12 @@ dump_btree_inode(
 		level = be16_to_cpu(rtrmap->bb_level);
 		numrecs = be16_to_cpu(rtrmap->bb_numrecs);
 		break;
+	case XFS_DINODE_FMT_REFCOUNT:
+		prefix = "u3.rtrefcbt";
+		rtrefc = (struct xfs_rtrefcount_root *)XFS_DFORK_DPTR(dip);
+		level = be16_to_cpu(rtrefc->bb_level);
+		numrecs = be16_to_cpu(rtrefc->bb_numrecs);
+		break;
 	default:
 		dbprintf("Unknown metadata inode type %u\n", dip->di_format);
 		return 0;
@@ -550,6 +558,7 @@ btdump_f(
 	case TYP_BMAPBTA:
 	case TYP_BMAPBTD:
 	case TYP_RTRMAPBT:
+	case TYP_RTREFCBT:
 		return dump_btree_long(iflag);
 	case TYP_INODE:
 		if (is_btree_inode())
diff --git a/db/btheight.c b/db/btheight.c
index 25ce3400334..9dd21ddae9a 100644
--- a/db/btheight.c
+++ b/db/btheight.c
@@ -58,6 +58,11 @@ struct btmap {
 		.maxlevels	= libxfs_rtrmapbt_maxlevels_ondisk,
 		.maxrecs	= libxfs_rtrmapbt_maxrecs,
 	},
+	{
+		.tag		= "rtrefcountbt",
+		.maxlevels	= libxfs_rtrefcountbt_maxlevels_ondisk,
+		.maxrecs	= libxfs_rtrefcountbt_maxrecs,
+	},
 };
 
 static void
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 0ac00fca337..a1c6efd5ca9 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -252,6 +252,7 @@
 
 #define xfs_rtrefcountbt_create_path	libxfs_rtrefcountbt_create_path
 #define xfs_rtrefcountbt_droot_maxrecs	libxfs_rtrefcountbt_droot_maxrecs
+#define xfs_rtrefcountbt_maxlevels_ondisk	libxfs_rtrefcountbt_maxlevels_ondisk
 #define xfs_rtrefcountbt_maxrecs	libxfs_rtrefcountbt_maxrecs
 
 #define xfs_rtrmapbt_calc_reserves	libxfs_rtrmapbt_calc_reserves
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index a277ea5e668..a694c8ed916 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -455,6 +455,7 @@ The supported btree types are:
 .IR bmapbt ,
 .IR refcountbt ,
 .IR rmapbt ,
+.IR rtrefcountbt ,
 and
 .IR rtrmapbt .
 The magic value

