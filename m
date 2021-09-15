Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77DAC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB0A6600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhIOXIa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:08:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232733AbhIOXI1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:08:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C72F8600D4;
        Wed, 15 Sep 2021 23:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747227;
        bh=R6EhXo9Iy/Ruzi0mxIqGA5uj+urplHq05EiyO7pdxv8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kHo1RfWvTvFhvw0pEyclmUByy0HjmJm7Zs1lsWLATaIOuMF+WA5anFyxJsoeT0uPf
         p2a9/z52BZia3UUhZSlmrB2Me5tXiPDZuuTiqrbOd6WlSUDmTin9iTdI9fPO88ljdr
         K7lu4uzwHcQHhiLT20RxmneVsL1E2WPcN9eYVTQxeurpTAesF0CPBetVwjaStSGtqV
         F/owgL2CQFRdHrmjRyKSI9gPS5thhLAz7zX7hMBOjPqF4UG9NgA7j7ky8K9yp2x30g
         4x1xnwOqNWBHHe1h/DEoXnH2JjLXuz0EVBVAOQ5zS9MWVEvi5sRaEJn9jvggVQNrQq
         HhRiijVhhtHaw==
Subject: [PATCH 06/61] xfs: Fix fall-through warnings for Clang
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:07:07 -0700
Message-ID: <163174722755.350433.4462645030660733660.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

Source kernel commit: 53004ee78d6273c994534ccf79d993098ac89769

In preparation to enable -Wimplicit-fallthrough for Clang, fix
the following warnings by replacing /* fall through */ comments,
and its variants, with the new pseudo-keyword macro fallthrough:

fs/xfs/libxfs/xfs_alloc.c:3167:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/libxfs/xfs_da_btree.c:286:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/libxfs/xfs_ag_resv.c:346:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/libxfs/xfs_ag_resv.c:388:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/xfs_bmap_util.c:246:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/xfs_export.c:88:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/xfs_export.c:96:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/xfs_file.c:867:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/xfs_ioctl.c:562:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/xfs_ioctl.c:1548:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/xfs_iomap.c:1040:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/xfs_inode.c:852:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/xfs_log.c:2627:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/xfs_trans_buf.c:298:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/scrub/bmap.c:275:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/scrub/btree.c:48:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/scrub/common.c:85:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/scrub/common.c:138:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/scrub/common.c:698:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/scrub/dabtree.c:51:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/scrub/repair.c:951:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/scrub/agheader.c:89:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]

Notice that Clang doesn't recognize /* fall through */ comments as
implicit fall-through markings, so in order to globally enable
-Wimplicit-fallthrough for Clang, these comments need to be
replaced with fallthrough; in the whole codebase.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/linux.h       |   17 +++++++++++++++++
 libxfs/xfs_ag_resv.c  |    4 ++--
 libxfs/xfs_alloc.c    |    2 +-
 libxfs/xfs_da_btree.c |    2 +-
 4 files changed, 21 insertions(+), 4 deletions(-)


diff --git a/include/linux.h b/include/linux.h
index a22f7812..1b237d48 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -359,4 +359,21 @@ fsmap_advance(
 #include <asm-generic/mman-common.h>
 #endif /* HAVE_MAP_SYNC */
 
+/*
+ * Add the pseudo keyword 'fallthrough' so case statement blocks
+ * must end with any of these keywords:
+ *   break;
+ *   fallthrough;
+ *   continue;
+ *   goto <label>;
+ *   return [expression];
+ *
+ *  gcc: https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html#Statement-Attributes
+ */
+#if __has_attribute(__fallthrough__)
+# define fallthrough                    __attribute__((__fallthrough__))
+#else
+# define fallthrough                    do {} while (0)  /* fallthrough */
+#endif
+
 #endif	/* __XFS_LINUX_H__ */
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 1aac3373..7d426d08 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -365,7 +365,7 @@ xfs_ag_resv_alloc_extent(
 		break;
 	default:
 		ASSERT(0);
-		/* fall through */
+		fallthrough;
 	case XFS_AG_RESV_NONE:
 		field = args->wasdel ? XFS_TRANS_SB_RES_FDBLOCKS :
 				       XFS_TRANS_SB_FDBLOCKS;
@@ -407,7 +407,7 @@ xfs_ag_resv_free_extent(
 		break;
 	default:
 		ASSERT(0);
-		/* fall through */
+		fallthrough;
 	case XFS_AG_RESV_NONE:
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
 		return;
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index d99622a6..300a91f8 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3170,7 +3170,7 @@ xfs_alloc_vextent(
 		}
 		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
 		args->type = XFS_ALLOCTYPE_NEAR_BNO;
-		/* FALLTHROUGH */
+		fallthrough;
 	case XFS_ALLOCTYPE_FIRST_AG:
 		/*
 		 * Rotate through the allocation groups looking for a winner.
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 43f090c5..f4e1fe80 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -279,7 +279,7 @@ xfs_da3_node_read_verify(
 						__this_address);
 				break;
 			}
-			/* fall through */
+			fallthrough;
 		case XFS_DA_NODE_MAGIC:
 			fa = xfs_da3_node_verify(bp);
 			if (fa)

