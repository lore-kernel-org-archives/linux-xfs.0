Return-Path: <SRS0=3UjW=7T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B6BC433E1
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Jun 2020 08:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAB47207D0
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Jun 2020 08:28:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o4uOhrb3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbgFFI2R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 6 Jun 2020 04:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgFFI2P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jun 2020 04:28:15 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8184FC08C5C2
        for <linux-xfs@vger.kernel.org>; Sat,  6 Jun 2020 01:28:15 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id b7so3865846pju.0
        for <linux-xfs@vger.kernel.org>; Sat, 06 Jun 2020 01:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n0gi0u83M7cBb5px8dNyN1dONnCoo4e2ck6zITVPf+w=;
        b=o4uOhrb3Z1CKyf+s0t5ltXchvtlr9cFVcd3OoulW6IzmqNtI0luYoFgXiIStUAeBEC
         ourKYLAt9KXCyshfEhiYrSQiJldKyx7DaeehY7tkTnVy7dzK5co5v5GKAefdPGtw/SWj
         DshWz6JvuncV4WdJG5YY8WCgzB5Hjeq7/L+Hcp+QOgMRo1HA9zZmjiqMTD7RwNF27/+Q
         biHaBLZvZP7x3Ncdz8wbViI8OA2mZ7K9rbHDs/WhJ1I0eU9sGtllDhX5+Vf0XdH3j3lD
         e0WO+00paUy5zeoKN4Cu2vozCkLlGzW8zre6knIYRV+lPmLjh2QxZHTL47kQPZD+hn0H
         1YDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n0gi0u83M7cBb5px8dNyN1dONnCoo4e2ck6zITVPf+w=;
        b=Wrsm2uX7JKA6gO+DvPuNl+XLdXHTVu9QVEZETcD4ZFuwSXiXTbo7IYTs+bf4bZPKiW
         y8HkIB7nvvX5J0wiN8VfHA7+h31tVWUm/0GPpzpbMaQYx1ZhRmx1UhnwIC0T8xFql4ks
         NUfmJAm4ogACgk3WDEADqrzN6MDVegMZ2xBLO8Cha473Q1v1ueUPrIEsi97CGM2TKKF/
         8vnm2GXdJdoMhHhLvWohUR2/vWoAfA8SaQRz7pW7eZAW+QW8jrVeoSjl0Ib7TMHOyd5P
         5Rrzz9uPQmnd8kQe3w0ilb7T49uVwWAKS33/LwH+bo7wJnHIfd4m8bqMS/aRvj1toSUw
         f9qg==
X-Gm-Message-State: AOAM530dYqItrnWJnmj0+KCRJnq9DR3TBMr486zHkQW89kxatzDsEhsF
        UClf3u5uFJ4FhRfj0QtaXEqCDETo
X-Google-Smtp-Source: ABdhPJxRj6k3SjTlqfioHAYXhs6z+Ndnj+xp7bfSRX8N22j0sIZXpyr3vyPrelIPI9DmXZP38zlavA==
X-Received: by 2002:a17:90a:260b:: with SMTP id l11mr7410088pje.210.1591432094822;
        Sat, 06 Jun 2020 01:28:14 -0700 (PDT)
Received: from localhost.localdomain ([122.167.144.243])
        by smtp.gmail.com with ESMTPSA id j3sm1678130pfh.87.2020.06.06.01.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2020 01:28:14 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com, hch@infradead.org
Subject: [PATCH 2/7] xfs: Check for per-inode extent count overflow
Date:   Sat,  6 Jun 2020 13:57:40 +0530
Message-Id: <20200606082745.15174-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200606082745.15174-1-chandanrlinux@gmail.com>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following error message was noticed when a workload added one
million xattrs, deleted 50% of them and then inserted 400,000 new
xattrs.

XFS (loop0): xfs_iflush_int: detected corrupt incore inode 131, total extents = -19916, nblocks = 102937, ptr ffff9ce33b098c00

The error message was printed during unmounting the filesystem. The
value printed under "total extents" indicates that we overflowed the
per-inode signed 16-bit xattr extent counter.

Instead of letting this silent corruption occur, this patch checks for
extent counter (both data and xattr) overflow before we assign the
new value to the corresponding in-memory extent counter.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 92 +++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_inode_fork.c | 29 +++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h |  1 +
 3 files changed, 104 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index edc63dba007f..798fca5c52af 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -906,7 +906,10 @@ xfs_bmap_local_to_extents(
 	xfs_iext_first(ifp, &icur);
 	xfs_iext_insert(ip, &icur, &rec, 0);
 
-	ifp->if_nextents = 1;
+	error = xfs_next_set(ip, whichfork, 1);
+	if (error)
+		goto done;
+
 	ip->i_d.di_nblocks = 1;
 	xfs_trans_mod_dquot_byino(tp, ip,
 		XFS_TRANS_DQ_BCOUNT, 1L);
@@ -1594,7 +1597,10 @@ xfs_bmap_add_extent_delay_real(
 		xfs_iext_remove(bma->ip, &bma->icur, state);
 		xfs_iext_prev(ifp, &bma->icur);
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &LEFT);
-		ifp->if_nextents--;
+
+		error = xfs_next_set(bma->ip, whichfork, -1);
+		if (error)
+			goto done;
 
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1698,7 +1704,10 @@ xfs_bmap_add_extent_delay_real(
 		PREV.br_startblock = new->br_startblock;
 		PREV.br_state = new->br_state;
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
-		ifp->if_nextents++;
+
+		error = xfs_next_set(bma->ip, whichfork, 1);
+		if (error)
+			goto done;
 
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1764,7 +1773,10 @@ xfs_bmap_add_extent_delay_real(
 		 * The left neighbor is not contiguous.
 		 */
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
-		ifp->if_nextents++;
+
+		error = xfs_next_set(bma->ip, whichfork, 1);
+		if (error)
+			goto done;
 
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1851,7 +1863,10 @@ xfs_bmap_add_extent_delay_real(
 		 * The right neighbor is not contiguous.
 		 */
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
-		ifp->if_nextents++;
+
+		error = xfs_next_set(bma->ip, whichfork, 1);
+		if (error)
+			goto done;
 
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1937,7 +1952,10 @@ xfs_bmap_add_extent_delay_real(
 		xfs_iext_next(ifp, &bma->icur);
 		xfs_iext_insert(bma->ip, &bma->icur, &RIGHT, state);
 		xfs_iext_insert(bma->ip, &bma->icur, &LEFT, state);
-		ifp->if_nextents++;
+
+		error = xfs_next_set(bma->ip, whichfork, 1);
+		if (error)
+			goto done;
 
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -2141,7 +2159,11 @@ xfs_bmap_add_extent_unwritten_real(
 		xfs_iext_remove(ip, icur, state);
 		xfs_iext_prev(ifp, icur);
 		xfs_iext_update_extent(ip, state, icur, &LEFT);
-		ifp->if_nextents -= 2;
+
+		error = xfs_next_set(ip, whichfork, -2);
+		if (error)
+			goto done;
+
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2193,7 +2215,11 @@ xfs_bmap_add_extent_unwritten_real(
 		xfs_iext_remove(ip, icur, state);
 		xfs_iext_prev(ifp, icur);
 		xfs_iext_update_extent(ip, state, icur, &LEFT);
-		ifp->if_nextents--;
+
+		error = xfs_next_set(ip, whichfork, -1);
+		if (error)
+			goto done;
+
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2235,7 +2261,10 @@ xfs_bmap_add_extent_unwritten_real(
 		xfs_iext_remove(ip, icur, state);
 		xfs_iext_prev(ifp, icur);
 		xfs_iext_update_extent(ip, state, icur, &PREV);
-		ifp->if_nextents--;
+
+		error = xfs_next_set(ip, whichfork, -1);
+		if (error)
+			goto done;
 
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -2343,7 +2372,10 @@ xfs_bmap_add_extent_unwritten_real(
 
 		xfs_iext_update_extent(ip, state, icur, &PREV);
 		xfs_iext_insert(ip, icur, new, state);
-		ifp->if_nextents++;
+
+		error = xfs_next_set(ip, whichfork, 1);
+		if (error)
+			goto done;
 
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -2419,7 +2451,10 @@ xfs_bmap_add_extent_unwritten_real(
 		xfs_iext_update_extent(ip, state, icur, &PREV);
 		xfs_iext_next(ifp, icur);
 		xfs_iext_insert(ip, icur, new, state);
-		ifp->if_nextents++;
+
+		error = xfs_next_set(ip, whichfork, 1);
+		if (error)
+			goto done;
 
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -2471,7 +2506,10 @@ xfs_bmap_add_extent_unwritten_real(
 		xfs_iext_next(ifp, icur);
 		xfs_iext_insert(ip, icur, &r[1], state);
 		xfs_iext_insert(ip, icur, &r[0], state);
-		ifp->if_nextents += 2;
+
+		error = xfs_next_set(ip, whichfork, 2);
+		if (error)
+			goto done;
 
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -2787,7 +2825,10 @@ xfs_bmap_add_extent_hole_real(
 		xfs_iext_remove(ip, icur, state);
 		xfs_iext_prev(ifp, icur);
 		xfs_iext_update_extent(ip, state, icur, &left);
-		ifp->if_nextents--;
+
+		error = xfs_next_set(ip, whichfork, -1);
+		if (error)
+			goto done;
 
 		if (cur == NULL) {
 			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
@@ -2886,7 +2927,10 @@ xfs_bmap_add_extent_hole_real(
 		 * Insert a new entry.
 		 */
 		xfs_iext_insert(ip, icur, new, state);
-		ifp->if_nextents++;
+
+		error = xfs_next_set(ip, whichfork, 1);
+		if (error)
+			goto done;
 
 		if (cur == NULL) {
 			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
@@ -5083,7 +5127,10 @@ xfs_bmap_del_extent_real(
 		 */
 		xfs_iext_remove(ip, icur, state);
 		xfs_iext_prev(ifp, icur);
-		ifp->if_nextents--;
+
+		error = xfs_next_set(ip, whichfork, -1);
+		if (error)
+			goto done;
 
 		flags |= XFS_ILOG_CORE;
 		if (!cur) {
@@ -5193,7 +5240,10 @@ xfs_bmap_del_extent_real(
 		} else
 			flags |= xfs_ilog_fext(whichfork);
 
-		ifp->if_nextents++;
+		error = xfs_next_set(ip, whichfork, 1);
+		if (error)
+			goto done;
+
 		xfs_iext_next(ifp, icur);
 		xfs_iext_insert(ip, icur, &new, state);
 		break;
@@ -5660,7 +5710,10 @@ xfs_bmse_merge(
 	 * Update the on-disk extent count, the btree if necessary and log the
 	 * inode.
 	 */
-	ifp->if_nextents--;
+	error = xfs_next_set(ip, whichfork, -1);
+	if (error)
+		goto done;
+
 	*logflags |= XFS_ILOG_CORE;
 	if (!cur) {
 		*logflags |= XFS_ILOG_DEXT;
@@ -6047,7 +6100,10 @@ xfs_bmap_split_extent(
 	/* Add new extent */
 	xfs_iext_next(ifp, &icur);
 	xfs_iext_insert(ip, &icur, &new, 0);
-	ifp->if_nextents++;
+
+	error = xfs_next_set(ip, whichfork, 1);
+	if (error)
+		goto del_cursor;
 
 	if (cur) {
 		error = xfs_bmbt_lookup_eq(cur, &new, &i);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 28b366275ae0..3bf5a2c391bd 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -728,3 +728,32 @@ xfs_ifork_verify_local_attr(
 
 	return 0;
 }
+
+int
+xfs_next_set(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	int			delta)
+{
+	struct xfs_ifork	*ifp;
+	int64_t			nr_exts;
+	int64_t			max_exts;
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+
+	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
+		max_exts = MAXEXTNUM;
+	else if (whichfork == XFS_ATTR_FORK)
+		max_exts = MAXAEXTNUM;
+	else
+		ASSERT(0);
+
+	nr_exts = ifp->if_nextents + delta;
+	if ((delta > 0 && nr_exts > max_exts)
+		|| (delta < 0 && nr_exts < 0))
+		return -EOVERFLOW;
+
+	ifp->if_nextents = nr_exts;
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index a4953e95c4f3..a84ae42ace79 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -173,4 +173,5 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
 
+int xfs_next_set(struct xfs_inode *ip, int whichfork, int delta);
 #endif	/* __XFS_INODE_FORK_H__ */
-- 
2.20.1

