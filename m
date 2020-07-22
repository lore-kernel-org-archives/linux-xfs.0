Return-Path: <SRS0=rRn/=BB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73DBDC433E5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 09:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D2CD2065D
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 09:05:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZIFM5ghq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731079AbgGVJFf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jul 2020 05:05:35 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52477 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726821AbgGVJFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jul 2020 05:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595408733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/YRNdaRonx+aPybyeFu8IWe4p/QPJORz4FAJpHobIWE=;
        b=ZIFM5ghqaGDd0brUU1DTJPnNrzj9eRG0fdGA9PK840ZdtjpvTjdOcZqX3leminlqOb9JUK
        Ty+DqXjSt5li6Y5Bk2yu2nfO8oU5WgBqTeKNQmFUsFVhmFrJGD2SMb3r7p0yS0KwziXcbd
        E8/dexgfLPM20KSxgd9EksuUHHFBiRg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-YIjOcWeOO_ybdBri6Ec7dw-1; Wed, 22 Jul 2020 05:05:30 -0400
X-MC-Unique: YIjOcWeOO_ybdBri6Ec7dw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD3A118C63C0
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2020 09:05:29 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 301DEBA66
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2020 09:05:28 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] xfs: Refactor xfs_da_state_alloc() helper
Date:   Wed, 22 Jul 2020 11:05:18 +0200
Message-Id: <20200722090518.214624-6-cmaiolino@redhat.com>
In-Reply-To: <20200722090518.214624-1-cmaiolino@redhat.com>
References: <20200722090518.214624-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Every call to xfs_da_state_alloc() also requires setting up state->args
and state->mp

Change xfs_da_state_alloc() to receive an xfs_da_args_t as argument and
return a xfs_da_state_t with both args and mp already set.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Changelog:
	V3:
		- Originally this patch removed xfs_da_state_alloc(),
		  per hch's suggestion, instead of removing, it has been
		  refactored, to also set state->{args,mp} which removes
		  a few lines of code.

 fs/xfs/libxfs/xfs_attr.c      | 17 +++++------------
 fs/xfs/libxfs/xfs_da_btree.c  |  8 ++++++--
 fs/xfs/libxfs/xfs_da_btree.h  |  2 +-
 fs/xfs/libxfs/xfs_dir2_node.c | 17 +++++------------
 fs/xfs/scrub/dabtree.c        |  4 +---
 5 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 3b1bd6e112f89..52e01fc0c5d04 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -750,9 +750,7 @@ xfs_attr_node_addname(
 	dp = args->dp;
 	mp = dp->i_mount;
 restart:
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = mp;
+	state = xfs_da_state_alloc(args);
 
 	/*
 	 * Search to see if name already exists, and get back a pointer
@@ -899,9 +897,8 @@ xfs_attr_node_addname(
 		 * attr, not the "new" one.
 		 */
 		args->attr_filter |= XFS_ATTR_INCOMPLETE;
-		state = xfs_da_state_alloc();
-		state->args = args;
-		state->mp = mp;
+		state = xfs_da_state_alloc(args);
+
 		state->inleaf = 0;
 		error = xfs_da3_node_lookup_int(state, &retval);
 		if (error)
@@ -975,9 +972,7 @@ xfs_attr_node_removename(
 	 * Tie a string around our finger to remind us where we are.
 	 */
 	dp = args->dp;
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = dp->i_mount;
+	state = xfs_da_state_alloc(args);
 
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
@@ -1207,9 +1202,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
 
 	trace_xfs_attr_node_get(args);
 
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = args->dp->i_mount;
+	state = xfs_da_state_alloc(args);
 
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index a4e1f01daf3d8..47da88154b434 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -79,9 +79,13 @@ kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
  * We don't put them on the stack since they're large.
  */
 xfs_da_state_t *
-xfs_da_state_alloc(void)
+xfs_da_state_alloc(xfs_da_args_t *args)
 {
-	return kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
+	xfs_da_state_t *state = kmem_cache_zalloc(xfs_da_state_zone,
+						  GFP_NOFS | __GFP_NOFAIL);
+	state->args = args;
+	state->mp = args->dp->i_mount;
+	return state;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 6e25de6621e4f..bb039dcb0cce4 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -219,7 +219,7 @@ enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,
 				const unsigned char *name, int len);
 
 
-xfs_da_state_t *xfs_da_state_alloc(void);
+xfs_da_state_t *xfs_da_state_alloc(xfs_da_args_t *args);
 void xfs_da_state_free(xfs_da_state_t *state);
 
 void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 6ac4aad98cd76..5d51265d29d6f 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2015,9 +2015,7 @@ xfs_dir2_node_addname(
 	/*
 	 * Allocate and initialize the state (btree cursor).
 	 */
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = args->dp->i_mount;
+	state = xfs_da_state_alloc(args);
 	/*
 	 * Look up the name.  We're not supposed to find it, but
 	 * this gives us the insertion point.
@@ -2086,9 +2084,8 @@ xfs_dir2_node_lookup(
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = args->dp->i_mount;
+	state = xfs_da_state_alloc(args);
+
 	/*
 	 * Fill in the path to the entry in the cursor.
 	 */
@@ -2139,9 +2136,7 @@ xfs_dir2_node_removename(
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = args->dp->i_mount;
+	state = xfs_da_state_alloc(args);
 
 	/* Look up the entry we're deleting, set up the cursor. */
 	error = xfs_da3_node_lookup_int(state, &rval);
@@ -2206,9 +2201,7 @@ xfs_dir2_node_replace(
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = args->dp->i_mount;
+	state = xfs_da_state_alloc(args);
 
 	/*
 	 * We have to save new inode number and ftype since
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 44b15015021f3..e56786f0a13c8 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -476,9 +476,7 @@ xchk_da_btree(
 	ds.dargs.whichfork = whichfork;
 	ds.dargs.trans = sc->tp;
 	ds.dargs.op_flags = XFS_DA_OP_OKNOENT;
-	ds.state = xfs_da_state_alloc();
-	ds.state->args = &ds.dargs;
-	ds.state->mp = mp;
+	ds.state = xfs_da_state_alloc(&ds.dargs);
 	ds.sc = sc;
 	ds.private = private;
 	if (whichfork == XFS_ATTR_FORK) {
-- 
2.26.2

