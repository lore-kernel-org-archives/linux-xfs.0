Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73D8C3A5A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 11:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B78E421726
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 11:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfH2LfN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 07:35:13 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50626 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727034AbfH2LfM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 07:35:12 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9FB8443E624
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 21:35:09 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3Ihn-0003VH-Vk
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 21:35:07 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3Ihn-0007AU-UW
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 21:35:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfs: consolidate attribute value copying
Date:   Thu, 29 Aug 2019 21:35:04 +1000
Message-Id: <20190829113505.27223-5-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190829113505.27223-1-david@fromorbit.com>
References: <20190829113505.27223-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=FmdZ9Uzk2mMA:10 a=20KFwNOVAAAA:8
        a=_pADRp5l9RgIM4VkoZcA:9 a=s_YcYuMkCaGCMyYs:21 a=ARZvsKPoKUE3U-gS:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The same code is used to copy do the attribute copying in three
different places. Consolidate them into a single function in
preparation from on-demand buffer allocation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 88 +++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 8085c4f0e5a0..f6a595e76343 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -393,6 +393,44 @@ xfs_attr_namesp_match(int arg_flags, int ondisk_flags)
 	return XFS_ATTR_NSP_ONDISK(ondisk_flags) == XFS_ATTR_NSP_ARGS_TO_ONDISK(arg_flags);
 }
 
+static int
+xfs_attr_copy_value(
+	struct xfs_da_args	*args,
+	unsigned char		*value,
+	int			valuelen)
+{
+	/*
+	 * No copy if all we have to do is get the length
+	 */
+	if (args->flags & ATTR_KERNOVAL) {
+		args->valuelen = valuelen;
+		return 0;
+	}
+
+	/*
+	 * No copy if the length of the existing buffer is too small
+	 */
+	if (args->valuelen < valuelen) {
+		args->valuelen = valuelen;
+		return -ERANGE;
+	}
+	args->valuelen = valuelen;
+
+	/* remote block xattr requires IO for copy-in */
+	if (args->rmtblkno)
+		return xfs_attr_rmtval_get(args);
+
+	/*
+	 * This is to prevent a GCC warning because the remote xattr case
+	 * doesn't have a value to pass in. In that case, we never reach here,
+	 * but GCC can't work that out and so throws a "passing NULL to
+	 * memcpy" warning.
+	 */
+	if (!value)
+		return -EINVAL;
+	memcpy(args->value, value, valuelen);
+	return 0;
+}
 
 /*========================================================================
  * External routines when attribute fork size < XFS_LITINO(mp).
@@ -727,11 +765,12 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
  * exist or we can't retrieve the value.
  */
 int
-xfs_attr_shortform_getvalue(xfs_da_args_t *args)
+xfs_attr_shortform_getvalue(
+	struct xfs_da_args	*args)
 {
-	xfs_attr_shortform_t *sf;
-	xfs_attr_sf_entry_t *sfe;
-	int i;
+	struct xfs_attr_shortform *sf;
+	struct xfs_attr_sf_entry *sfe;
+	int			i;
 
 	ASSERT(args->dp->i_afp->if_flags == XFS_IFINLINE);
 	sf = (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
@@ -744,18 +783,8 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
 			continue;
 		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
 			continue;
-		if (args->flags & ATTR_KERNOVAL) {
-			args->valuelen = sfe->valuelen;
-			return 0;
-		}
-		if (args->valuelen < sfe->valuelen) {
-			args->valuelen = sfe->valuelen;
-			return -ERANGE;
-		}
-		args->valuelen = sfe->valuelen;
-		memcpy(args->value, &sfe->nameval[args->namelen],
-						    args->valuelen);
-		return 0;
+		return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
+						sfe->valuelen);
 	}
 	return -ENOATTR;
 }
@@ -2368,7 +2397,6 @@ xfs_attr3_leaf_getvalue(
 	struct xfs_attr_leaf_entry *entry;
 	struct xfs_attr_leaf_name_local *name_loc;
 	struct xfs_attr_leaf_name_remote *name_rmt;
-	int			valuelen;
 
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
@@ -2380,18 +2408,9 @@ xfs_attr3_leaf_getvalue(
 		name_loc = xfs_attr3_leaf_name_local(leaf, args->index);
 		ASSERT(name_loc->namelen == args->namelen);
 		ASSERT(memcmp(args->name, name_loc->nameval, args->namelen) == 0);
-		valuelen = be16_to_cpu(name_loc->valuelen);
-		if (args->flags & ATTR_KERNOVAL) {
-			args->valuelen = valuelen;
-			return 0;
-		}
-		if (args->valuelen < valuelen) {
-			args->valuelen = valuelen;
-			return -ERANGE;
-		}
-		args->valuelen = valuelen;
-		memcpy(args->value, &name_loc->nameval[args->namelen], valuelen);
-		return 0;
+		return xfs_attr_copy_value(args,
+					&name_loc->nameval[args->namelen],
+					be16_to_cpu(name_loc->valuelen));
 	}
 
 	name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
@@ -2401,16 +2420,7 @@ xfs_attr3_leaf_getvalue(
 	args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
 	args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
 					       args->rmtvaluelen);
-	if (args->flags & ATTR_KERNOVAL) {
-		args->valuelen = args->rmtvaluelen;
-		return 0;
-	}
-	if (args->valuelen < args->rmtvaluelen) {
-		args->valuelen = args->rmtvaluelen;
-		return -ERANGE;
-	}
-	args->valuelen = args->rmtvaluelen;
-	return xfs_attr_rmtval_get(args);
+	return xfs_attr_copy_value(args, NULL, args->rmtvaluelen);
 }
 
 /*========================================================================
-- 
2.23.0.rc1

