Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3AFC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06AC960EE9
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhIOXNA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:13:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOXNA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:13:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C287D60E94;
        Wed, 15 Sep 2021 23:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747500;
        bh=9zrtQjQnelUTOTSmv5PTql5Nru4mqzP8d3fG8I6n6ks=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oGcBo5QeoCyHILo1XW3XXf0aQGTkQWO0d95hdz1cjchnFlsp4tyAAOkwi4R+ORudZ
         d2IiZ2r0hQAUw427ATzUejM/bcNlWox60TYTOKIVa9BXFofQ4dg9CbWw4hrkT30R5n
         1hc1mQVKtitDP9nDB6cv76f1Jw7/jT3u6xXXpAaLbdauacL4snnt7beGlFKk52PLQX
         ZYGjRVYElpwBscDC+tzwzfyBfGI41LDlgEH/lJNGQG6KNHU82pMM5DTa92PgOk18kg
         Gg8itygGzfJMDdLo9X3D8441+Z4Fe3nI2HqnLDpKYQfWxPTFBZ8Lo/J68e+bQv2lyB
         n44zGlPyztrqw==
Subject: [PATCH 56/61] xfs: Fix multiple fall-through warnings for Clang
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:11:40 -0700
Message-ID: <163174750051.350433.11412593867682976379.stgit@magnolia>
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

Source kernel commit: 5937e00017f1d1dd4551e723ebfa306671f27843

In preparation to enable -Wimplicit-fallthrough for Clang, fix
the following warnings by replacing /* fallthrough */ comments,
and its variants, with the new pseudo-keyword macro fallthrough:

fs/xfs/libxfs/xfs_attr.c:487:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/libxfs/xfs_attr.c:500:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/libxfs/xfs_attr.c:532:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/libxfs/xfs_attr.c:594:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/libxfs/xfs_attr.c:607:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/libxfs/xfs_attr.c:1410:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/libxfs/xfs_attr.c:1445:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
fs/xfs/libxfs/xfs_attr.c:1473:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]

Notice that Clang doesn't recognize /* fallthrough */ comments as
implicit fall-through markings, so in order to globally enable
-Wimplicit-fallthrough for Clang, these comments need to be
replaced with fallthrough; in the whole codebase.

Link: https://github.com/KSPP/linux/issues/115
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index d6195789..80a6a96f 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -483,7 +483,7 @@ xfs_attr_set_iter(
 		if (error)
 			return error;
 
-		/* fallthrough */
+		fallthrough;
 	case XFS_DAS_RM_LBLK:
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
 		dac->dela_state = XFS_DAS_RM_LBLK;
@@ -496,7 +496,7 @@ xfs_attr_set_iter(
 			return -EAGAIN;
 		}
 
-		/* fallthrough */
+		fallthrough;
 	case XFS_DAS_RD_LEAF:
 		/*
 		 * This is the last step for leaf format. Read the block with
@@ -528,7 +528,7 @@ xfs_attr_set_iter(
 				return error;
 		}
 
-		/* fallthrough */
+		fallthrough;
 	case XFS_DAS_ALLOC_NODE:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
@@ -590,7 +590,7 @@ xfs_attr_set_iter(
 		if (error)
 			return error;
 
-		/* fallthrough */
+		fallthrough;
 	case XFS_DAS_RM_NBLK:
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
 		dac->dela_state = XFS_DAS_RM_NBLK;
@@ -603,7 +603,7 @@ xfs_attr_set_iter(
 			return -EAGAIN;
 		}
 
-		/* fallthrough */
+		fallthrough;
 	case XFS_DAS_CLR_FLAG:
 		/*
 		 * The last state for node format. Look up the old attr and
@@ -1406,7 +1406,7 @@ xfs_attr_remove_iter(
 			state = dac->da_state;
 		}
 
-		/* fallthrough */
+		fallthrough;
 	case XFS_DAS_RMTBLK:
 		dac->dela_state = XFS_DAS_RMTBLK;
 
@@ -1441,7 +1441,7 @@ xfs_attr_remove_iter(
 			return -EAGAIN;
 		}
 
-		/* fallthrough */
+		fallthrough;
 	case XFS_DAS_RM_NAME:
 		/*
 		 * If we came here fresh from a transaction roll, reattach all
@@ -1469,7 +1469,7 @@ xfs_attr_remove_iter(
 			return -EAGAIN;
 		}
 
-		/* fallthrough */
+		fallthrough;
 	case XFS_DAS_RM_SHRINK:
 		/*
 		 * If the result is small enough, push it all into the inode.

