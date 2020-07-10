Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A48C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 09:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2195D2065D
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 09:15:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VYY795yD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgGJJP5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 05:15:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60893 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726787AbgGJJP5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 05:15:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594372556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GFlxW5hMwsWK0K88e6qnQsMKiVlCj9kCGldga0nVWsE=;
        b=VYY795yDVv1lJidVOCtu5QM1TGWIy1T+MJqitdAelytpPAcfTSMEuE+FVUWG6emQielQyp
        4VccdrAm89pnm85RO+e2CDy4pzyOIsFuoZWXmEyigHnLMyQw6vwgEmoGxdD50c0hcvNssv
        O+cxxQ0qPW4U3exG2Ensu5NgmVUS6UQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-qPuT7vtKPX2oQ9_tCGGS4w-1; Fri, 10 Jul 2020 05:15:52 -0400
X-MC-Unique: qPuT7vtKPX2oQ9_tCGGS4w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 489F8100CCC0
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:15:51 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.193.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2A5D78A44
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:15:50 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] xfs: Remove xfs_da_state_alloc() helper
Date:   Fri, 10 Jul 2020 11:15:36 +0200
Message-Id: <20200710091536.95828-6-cmaiolino@redhat.com>
In-Reply-To: <20200710091536.95828-1-cmaiolino@redhat.com>
References: <20200710091536.95828-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_da_state_alloc() can simply be replaced by kmem_cache_zalloc()
calls directly. No need to keep this helper around.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c      |  9 +++++----
 fs/xfs/libxfs/xfs_da_btree.c  | 10 ----------
 fs/xfs/libxfs/xfs_da_btree.h  |  1 -
 fs/xfs/libxfs/xfs_dir2_node.c |  8 ++++----
 fs/xfs/scrub/dabtree.c        |  3 ++-
 5 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 3b1bd6e112f89..a9499b2fdfb83 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -750,7 +750,7 @@ xfs_attr_node_addname(
 	dp = args->dp;
 	mp = dp->i_mount;
 restart:
-	state = xfs_da_state_alloc();
+	state = kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
 	state->args = args;
 	state->mp = mp;
 
@@ -899,7 +899,8 @@ xfs_attr_node_addname(
 		 * attr, not the "new" one.
 		 */
 		args->attr_filter |= XFS_ATTR_INCOMPLETE;
-		state = xfs_da_state_alloc();
+		state = kmem_cache_zalloc(xfs_da_state_zone,
+					  GFP_NOFS | __GFP_NOFAIL);
 		state->args = args;
 		state->mp = mp;
 		state->inleaf = 0;
@@ -975,7 +976,7 @@ xfs_attr_node_removename(
 	 * Tie a string around our finger to remind us where we are.
 	 */
 	dp = args->dp;
-	state = xfs_da_state_alloc();
+	state = kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
 	state->args = args;
 	state->mp = dp->i_mount;
 
@@ -1207,7 +1208,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
 
 	trace_xfs_attr_node_get(args);
 
-	state = xfs_da_state_alloc();
+	state = kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
 	state->args = args;
 	state->mp = args->dp->i_mount;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index a4e1f01daf3d8..a704c1a91bece 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -74,16 +74,6 @@ STATIC int	xfs_da3_blk_unlink(xfs_da_state_t *state,
 
 kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
 
-/*
- * Allocate a dir-state structure.
- * We don't put them on the stack since they're large.
- */
-xfs_da_state_t *
-xfs_da_state_alloc(void)
-{
-	return kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
-}
-
 /*
  * Kill the altpath contents of a da-state structure.
  */
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 6e25de6621e4f..50c803ffb80d8 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -219,7 +219,6 @@ enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,
 				const unsigned char *name, int len);
 
 
-xfs_da_state_t *xfs_da_state_alloc(void);
 void xfs_da_state_free(xfs_da_state_t *state);
 
 void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 6ac4aad98cd76..8d9c0df5b0836 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2015,7 +2015,7 @@ xfs_dir2_node_addname(
 	/*
 	 * Allocate and initialize the state (btree cursor).
 	 */
-	state = xfs_da_state_alloc();
+	state = kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
 	state->args = args;
 	state->mp = args->dp->i_mount;
 	/*
@@ -2086,7 +2086,7 @@ xfs_dir2_node_lookup(
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
-	state = xfs_da_state_alloc();
+	state = kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
 	state->args = args;
 	state->mp = args->dp->i_mount;
 	/*
@@ -2139,7 +2139,7 @@ xfs_dir2_node_removename(
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
-	state = xfs_da_state_alloc();
+	state = kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
 	state->args = args;
 	state->mp = args->dp->i_mount;
 
@@ -2206,7 +2206,7 @@ xfs_dir2_node_replace(
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
-	state = xfs_da_state_alloc();
+	state = kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
 	state->args = args;
 	state->mp = args->dp->i_mount;
 
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 44b15015021f3..cf454957db1f8 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -476,7 +476,8 @@ xchk_da_btree(
 	ds.dargs.whichfork = whichfork;
 	ds.dargs.trans = sc->tp;
 	ds.dargs.op_flags = XFS_DA_OP_OKNOENT;
-	ds.state = xfs_da_state_alloc();
+	ds.state = kmem_cache_zalloc(xfs_da_state_zone,
+				     GFP_NOFS | __GFP_NOFAIL);
 	ds.state->args = &ds.dargs;
 	ds.state->mp = mp;
 	ds.sc = sc;
-- 
2.26.2

