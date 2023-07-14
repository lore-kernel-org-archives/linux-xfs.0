Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D39C0015E
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 14:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbjGNOpU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 10:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235996AbjGNOpN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:45:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B2C268F
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 07:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2467861D3D
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 14:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B3CC433C8;
        Fri, 14 Jul 2023 14:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689345911;
        bh=9sIVcZbhCxcCIppatIwU3lDDyfui51oHHSEw/UZz2JM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fZ9+ITRqzHL+gYLulGseXIFXJJ4QN4DWa5/J+DrGK+cLxTx7ncMIpt6MB7uacITr9
         L1GQ2ACoBHkDVuox1wFkht3zNo/tE4SazqkVFirZTGvrCRL0yu0tK+bFL404wfLZEQ
         n7qaN4ZV1vxydN4Z02Xv9PV5VMWOXaL1HL6FLrAFNszdNUssQ6TPc9IKyRjCdhwJWC
         daH0a5Jo+zVTIF2pX/Br2seaap3EwzwvVgYvHl+qSsICZtvVq2GidE9sK8AyPfAdAs
         epsW0g7vn5WLwqsnyHJsR9G3FXB1l7+PTEyNz5Cphe2Koq5oKavz7Ice/7aO8odtka
         kvXytV6wSHP2A==
Subject: [PATCH 1/3] xfs: convert flex-array declarations in struct
 xfs_attrlist*
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, keescook@chromium.org,
        david@fromorbit.com
Date:   Fri, 14 Jul 2023 07:45:10 -0700
Message-ID: <168934591095.3368057.15849162788748534581.stgit@frogsfrogsfrogs>
In-Reply-To: <168934590524.3368057.8686152348214871657.stgit@frogsfrogsfrogs>
References: <168934590524.3368057.8686152348214871657.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: d6da44c23ec357f132717301ea3319b8aa95274e

As of 6.5-rc1, UBSAN trips over the attrlist ioctl definitions using an
array length of 1 to pretend to be a flex array.  Kernel compilers have
to support unbounded array declarations, so let's correct this.  This
may cause friction with userspace header declarations, but suck is life.

================================================================================
UBSAN: array-index-out-of-bounds in fs/xfs/xfs_ioctl.c:345:18
index 1 is out of range for type '__s32 [1]'
Call Trace:
<TASK>
dump_stack_lvl+0x33/0x50
__ubsan_handle_out_of_bounds+0x9c/0xd0
xfs_ioc_attr_put_listent+0x413/0x420 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
xfs_attr_list_ilocked+0x170/0x850 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
xfs_attr_list+0xb7/0x120 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
xfs_ioc_attr_list+0x13b/0x2e0 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
xfs_attrlist_by_handle+0xab/0x120 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
xfs_file_ioctl+0x1ff/0x15e0 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
vfs_ioctl+0x1f/0x60

The kernel and xfsprogs code that uses these structures will not have
problems, but the long tail of external user programs might.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 9c60ebb3..2cbf9ea3 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -592,12 +592,12 @@ typedef struct xfs_attrlist_cursor {
 struct xfs_attrlist {
 	__s32	al_count;	/* number of entries in attrlist */
 	__s32	al_more;	/* T/F: more attrs (do call again) */
-	__s32	al_offset[1];	/* byte offsets of attrs [var-sized] */
+	__s32	al_offset[];	/* byte offsets of attrs [var-sized] */
 };
 
 struct xfs_attrlist_ent {	/* data from attr_list() */
 	__u32	a_valuelen;	/* number bytes in value of attr */
-	char	a_name[1];	/* attr name (NULL terminated) */
+	char	a_name[];	/* attr name (NULL terminated) */
 };
 
 typedef struct xfs_fsop_attrlist_handlereq {

