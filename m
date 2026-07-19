Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BFE390228
	for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2026 11:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784460629; cv=none; b=rDbdphoBkRIBFOu7/a71ILqXHV7Bh2j61jatrCCGLWZQ8bZYL0AS+5WqQ7snXcsZNt2pf+wNxcl3wnbf/FwIyulA+Lu56YGoiPqneGUSARTkOuyJUBAOgsY+HvbbDasGv8KFBUl87OiEQMTjuwdY5nxNQDFszBcxV3ubeB8pRO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784460629; c=relaxed/simple;
	bh=FSXmXuZkpD9nyi/dqQkJZh9+x96eMR1gGqIF9ULr7Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7Vb/VL4EzE9WJo2Ghi2xNspc2dSHO+YwuNE9YLWB3J9MI3nuJbdioUsBk5VrJsIEBaUJF4WeJlWzV/kaParrvMXd85HteU1bcUPUYut2+VyyEbi461GvC7hYyXvoGm26hwkPBImhoFWXHcQbK1iNqVbI680FTfzyPCSQCOeKZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N5MZwzt7; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N5MZwzt7"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ceed7018c8so37664405ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2026 04:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784460624; x=1785065424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1Afy7GemuDlWgnkzFmnf+fPudhFvneCa90qqK9FLigo=;
        b=N5MZwzt7TV/DZrK6WQoqpLn2UITpvF7TZdMe5zBVAKaORi1Qz18gf08I0d5M3GwUTJ
         tlzz8dYFPaDkEURLWeUIpXa51qxUfeD8Y8tzXyVKrFDLFyk8GglBh4HN6poiAfYrDGU/
         ApcLEDCgl2D8F+TAiKsypmzFjF/Pb3LEt3ClE0erMHEwZejjUnOd+Z4h/ZYCzeNoJ6Q7
         ux52NCTI3C/gWnFzCVMPSddN6hDckXas4PGASXKfcVH/rsz6cilZ+m4+rc3a5ZdmYZ3Y
         DqgqmOnIJG1/qZeshLgZbeJz3mt9LCzhyBdyu0PXjiJMmPpjSPfKXza2CtP1GMpVhAbo
         f5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784460624; x=1785065424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1Afy7GemuDlWgnkzFmnf+fPudhFvneCa90qqK9FLigo=;
        b=jg8ZuAQHs+bD+yzl8iA1EoEavqrnDvIb8tPYh608PjD7U+5/J3YabY5sJ03BVmLM4q
         tAMD8xI6mh4L7wFw+O+YvWAb0MK9hvph4OLynO6K4LjG/ohBid15jTqmZADx75OOZI9g
         MYSVAPHGtRV4RoC/bURuzCuNMJpgbspGfea2agYhGQinNfqmYwAKSzhHylpqLfPv4WLZ
         ds/1CKqierJWAJesEHzcGyEXyNrWJLVZKwDmWG/MM5ygmzX2Ne1TRTpMvyWL0NG6Ns/B
         v4ddpDFo69gt/N5Hccxxf0ap4Ful/G1M+TS7ZAOWnH6HEoQXvBoo0zWNdvzu9JscQbHs
         tL8g==
X-Gm-Message-State: AOJu0YxdNLLno9UbuTEgybIPx6Q7ibxr2LWF3Ai242qfZ9wulepRqLEh
	HRnUMtUxdb9zZVC1Y438ACrmoB6Nz0FiOyzdf7kP5tUzAowxZj0lGHM/
X-Gm-Gg: AfdE7cm1PY5g7jjed0QHc8mX4q/hy9AYa6NzmaAcSfkNv/jOBhA+c5hpCgxQByticuJ
	L7o5PxiqNkS9Hvj4h/h06AZEekJr2JtV/ODBeuV+/MLJAHmknMr4T8wSIwe8b/KtieGA4r0oVAs
	3Z1A8pb77E039MzqY4FAcja8jfJqW0MzLAJa/rWDmMZpApuuySRUmKEpxwNPmlBbNysUPtpoqXY
	267Hx9Pf6iR0rJs62PSI4CoojoTcwOIIYPx0vsp4FecOYHV4xUCxo6mU1ASqxsWkQ9ENRUmXXdT
	hAjx8R47PsJfKs0vymnu51tzawGEf3ybUL3Ywt1aekt92GJzKV1YHADQMcTCJCjctT5y50MY3k2
	0kJa/GPlhq4uY7pqAjvG0jJP8m0C3Yr69e5d3rKzm2BiDZT2F82cFVTFAWZYjvjI/qyGsdtcaVD
	0sOFW92HgZa57Qz5FrESdkauxEXtOe00F+A/8tx9hR/4lZxo5bKUWtnRANPg==
X-Received: by 2002:a17:903:178e:b0:2c9:e9c7:2b59 with SMTP id d9443c01a7336-2cf349cc765mr105343195ad.35.1784460624277;
        Sun, 19 Jul 2026 04:30:24 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce2ddfb35sm22035031c88.14.2026.07.19.04.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 04:30:23 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xmei5@asu.edu,
	Weiming Shi <bestswngs@gmail.com>,
	Dave Chinner <dgc@kernel.org>
Subject: [PATCH v3 1/3] xfs: verify log item headers when they are decoded during recovery
Date: Sun, 19 Jul 2026 04:29:21 -0700
Message-ID: <20260719112923.226550-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719112923.226550-1-bestswngs@gmail.com>
References: <20260719112923.226550-1-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Log recovery rebuilds each log item in xlog_recover_add_to_trans() from
the ophdr regions in the journal. The first region carries the item's
format header, and recovery reads the type from its first two bytes and
the region count from the next two to size and populate the item's
ri_buf[] array. Those regions are later cast back to their format
structures and used to drive replay. This is the first point at which
recovery trusts data read from the log, and the geometry it reads here is
used to build the structures every later check and decode step relies on,
so the header should be verified comprehensively here rather than trusted
until something dereferences it.

Do that in xlog_recover_verify_item_header(): require the region to be
large enough to hold the type and count fields before they are read,
resolve the item type against the known xlog_recover_item_ops (rejecting
unrecognised types), and bound the declared region count within the
minimum and maximum a log item of that type is formatted with. A lower
bound matters as much as an upper one: an item that declares fewer
regions than its replay code indexes still passes the completeness check
added later in the series and then reads past its ri_buf[] array, e.g. a
dquot item with qlf_size == 1 still reaches ri_buf[1] in
xlog_recover_dquot_commit_pass2(). Record both bounds in new min_regions
and max_regions fields on xlog_recover_item_ops, where a max_regions of 0
keeps the generic XLOG_MAX_REGIONS_IN_ITEM ceiling used by buffer items.
Resolving the type here also lets us set item->ri_ops at decode time, so
xlog_recover_reorder_trans() no longer has to look it up and can no longer
meet an unrecognised item.

While decoding the continuation of a region in
xlog_recover_add_to_cont_trans(), also reject a continuation that has no
started region to extend, instead of indexing ri_buf[-1] on a
never-populated item.

Suggested-by: Dave Chinner <dgc@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |  8 ++++
 fs/xfs/xfs_attr_item.c          |  4 ++
 fs/xfs/xfs_bmap_item.c          |  4 ++
 fs/xfs/xfs_dquot_item_recover.c |  4 ++
 fs/xfs/xfs_exchmaps_item.c      |  4 ++
 fs/xfs/xfs_extfree_item.c       |  8 ++++
 fs/xfs/xfs_icreate_item.c       |  2 +
 fs/xfs/xfs_inode_item_recover.c |  2 +
 fs/xfs/xfs_log_recover.c        | 80 ++++++++++++++++++++-------------
 fs/xfs/xfs_refcount_item.c      |  8 ++++
 fs/xfs/xfs_rmap_item.c          |  8 ++++
 11 files changed, 101 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 9e712e62369c..77f51afcbd9c 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -24,6 +24,14 @@ enum xlog_recover_reorder {
 struct xlog_recover_item_ops {
 	uint16_t	item_type;	/* XFS_LI_* type code. */
 
+	/*
+	 * Bounds on the item's declared region count, checked before the
+	 * region array is allocated.  max_regions 0 means no fixed maximum, so
+	 * the generic XLOG_MAX_REGIONS_IN_ITEM ceiling applies (buffers).
+	 */
+	unsigned int	min_regions;
+	unsigned int	max_regions;
+
 	/*
 	 * Help sort recovered log items into the order required to replay them
 	 * correctly.  Log item types that always use XLOG_REORDER_ITEM_LIST do
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index a53ee2b0c54a..cec7c1bb3694 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -1189,6 +1189,8 @@ static const struct xfs_item_ops xfs_attri_item_ops = {
 
 const struct xlog_recover_item_ops xlog_attri_item_ops = {
 	.item_type	= XFS_LI_ATTRI,
+	.max_regions	= 5,
+	.min_regions	= 2,
 	.commit_pass2	= xlog_recover_attri_commit_pass2,
 };
 
@@ -1203,5 +1205,7 @@ static const struct xfs_item_ops xfs_attrd_item_ops = {
 
 const struct xlog_recover_item_ops xlog_attrd_item_ops = {
 	.item_type	= XFS_LI_ATTRD,
+	.max_regions	= 1,
+	.min_regions	= 1,
 	.commit_pass2	= xlog_recover_attrd_commit_pass2,
 };
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 89f6e79a955f..8659428a51bb 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -684,6 +684,8 @@ xlog_recover_bui_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_bui_item_ops = {
 	.item_type		= XFS_LI_BUI,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_bui_commit_pass2,
 };
 
@@ -716,5 +718,7 @@ xlog_recover_bud_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_bud_item_ops = {
 	.item_type		= XFS_LI_BUD,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_bud_commit_pass2,
 };
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index fe419b28de22..5882c688ecc1 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -178,6 +178,8 @@ xlog_recover_dquot_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_dquot_item_ops = {
 	.item_type		= XFS_LI_DQUOT,
+	.max_regions		= 2,
+	.min_regions		= 2,
 	.ra_pass2		= xlog_recover_dquot_ra_pass2,
 	.commit_pass2		= xlog_recover_dquot_commit_pass2,
 };
@@ -211,6 +213,8 @@ xlog_recover_quotaoff_commit_pass1(
 
 const struct xlog_recover_item_ops xlog_quotaoff_item_ops = {
 	.item_type		= XFS_LI_QUOTAOFF,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass1		= xlog_recover_quotaoff_commit_pass1,
 	/* nothing to commit in pass2 */
 };
diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
index c3745d33e54e..d3f0fb677341 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -576,6 +576,8 @@ xlog_recover_xmi_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_xmi_item_ops = {
 	.item_type		= XFS_LI_XMI,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_xmi_commit_pass2,
 };
 
@@ -607,5 +609,7 @@ xlog_recover_xmd_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_xmd_item_ops = {
 	.item_type		= XFS_LI_XMD,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_xmd_commit_pass2,
 };
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 2266d56e37dc..dccc3d159268 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -889,6 +889,8 @@ xlog_recover_efi_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_efi_item_ops = {
 	.item_type		= XFS_LI_EFI,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_efi_commit_pass2,
 };
 
@@ -941,6 +943,8 @@ xlog_recover_rtefi_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rtefi_item_ops = {
 	.item_type		= XFS_LI_EFI_RT,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_rtefi_commit_pass2,
 };
 
@@ -984,6 +988,8 @@ xlog_recover_efd_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_efd_item_ops = {
 	.item_type		= XFS_LI_EFD,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_efd_commit_pass2,
 };
 
@@ -1025,5 +1031,7 @@ xlog_recover_rtefd_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rtefd_item_ops = {
 	.item_type		= XFS_LI_EFD_RT,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_rtefd_commit_pass2,
 };
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 95b0eba242e9..9afe58f7bfd4 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -255,6 +255,8 @@ xlog_recover_icreate_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_icreate_item_ops = {
 	.item_type		= XFS_LI_ICREATE,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.reorder		= xlog_recover_icreate_reorder,
 	.commit_pass2		= xlog_recover_icreate_commit_pass2,
 };
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 169a8fe3bf0a..6b6ac92964d0 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -599,6 +599,8 @@ xlog_recover_inode_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_inode_item_ops = {
 	.item_type		= XFS_LI_INODE,
+	.max_regions		= 4,
+	.min_regions		= 2,
 	.ra_pass2		= xlog_recover_inode_ra_pass2,
 	.commit_pass2		= xlog_recover_inode_commit_pass2,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 09e6678ca487..41fa029054d3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1828,12 +1828,12 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
 
 static const struct xlog_recover_item_ops *
 xlog_find_item_ops(
-	struct xlog_recover_item		*item)
+	unsigned short				item_type)
 {
 	unsigned int				i;
 
 	for (i = 0; i < ARRAY_SIZE(xlog_recover_item_ops); i++)
-		if (ITEM_TYPE(item) == xlog_recover_item_ops[i]->item_type)
+		if (item_type == xlog_recover_item_ops[i]->item_type)
 			return xlog_recover_item_ops[i];
 
 	return NULL;
@@ -1888,14 +1888,13 @@ xlog_find_item_ops(
  * but for all other items there may be specific ordering that we need to
  * preserve.
  */
-STATIC int
+STATIC void
 xlog_recover_reorder_trans(
 	struct xlog		*log,
 	struct xlog_recover	*trans,
 	int			pass)
 {
 	struct xlog_recover_item *item, *n;
-	int			error = 0;
 	LIST_HEAD(sort_list);
 	LIST_HEAD(cancel_list);
 	LIST_HEAD(buffer_list);
@@ -1906,22 +1905,6 @@ xlog_recover_reorder_trans(
 	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
 		enum xlog_recover_reorder	fate = XLOG_REORDER_ITEM_LIST;
 
-		item->ri_ops = xlog_find_item_ops(item);
-		if (!item->ri_ops) {
-			xfs_warn(log->l_mp,
-				"%s: unrecognized type of log operation (%d)",
-				__func__, ITEM_TYPE(item));
-			ASSERT(0);
-			/*
-			 * return the remaining items back to the transaction
-			 * item list so they can be freed in caller.
-			 */
-			if (!list_empty(&sort_list))
-				list_splice_init(&sort_list, &trans->r_itemq);
-			error = -EFSCORRUPTED;
-			break;
-		}
-
 		if (item->ri_ops->reorder)
 			fate = item->ri_ops->reorder(item);
 
@@ -1954,7 +1937,6 @@ xlog_recover_reorder_trans(
 		list_splice_tail(&inode_buffer_list, &trans->r_itemq);
 	if (!list_empty(&cancel_list))
 		list_splice_tail(&cancel_list, &trans->r_itemq);
-	return error;
 }
 
 void
@@ -2039,9 +2021,7 @@ xlog_recover_commit_trans(
 
 	hlist_del_init(&trans->r_list);
 
-	error = xlog_recover_reorder_trans(log, trans, pass);
-	if (error)
-		return error;
+	xlog_recover_reorder_trans(log, trans, pass);
 
 	list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
 		trace_xfs_log_recover_item_recover(log, trans, item, pass);
@@ -2130,6 +2110,10 @@ xlog_recover_add_to_cont_trans(
 	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
 			  ri_list);
 
+	/* the continuation has to extend a region we have already started */
+	if (XFS_IS_CORRUPT(log->l_mp, item->ri_cnt == 0 || !item->ri_buf))
+		return -EFSCORRUPTED;
+
 	old_ptr = item->ri_buf[item->ri_cnt-1].iov_base;
 	old_len = item->ri_buf[item->ri_cnt-1].iov_len;
 
@@ -2143,6 +2127,43 @@ xlog_recover_add_to_cont_trans(
 	return 0;
 }
 
+/*
+ * Validate a newly decoded item header before recovery trusts it to size and
+ * assemble the item's regions: resolve the item type and bound the declared
+ * region count.
+ */
+STATIC int
+xlog_recover_verify_item_header(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	char				*ptr,
+	int				len)
+{
+	struct xfs_inode_log_format	*in_f = (struct xfs_inode_log_format *)ptr;
+	const struct xlog_recover_item_ops *ops;
+	unsigned int			max_regions;
+
+	/* The type and region count fields have to be present to be read. */
+	if (XFS_IS_CORRUPT(log->l_mp,
+			len < offsetofend(struct xfs_inode_log_format, ilf_size)))
+		return -EFSCORRUPTED;
+
+	ops = xlog_find_item_ops(in_f->ilf_type);
+	if (XFS_IS_CORRUPT(log->l_mp, !ops))
+		return -EFSCORRUPTED;
+	item->ri_ops = ops;
+
+	max_regions = ops->max_regions ? ops->max_regions :
+					 XLOG_MAX_REGIONS_IN_ITEM;
+	if (XFS_IS_CORRUPT(log->l_mp,
+			in_f->ilf_size == 0 ||
+			in_f->ilf_size < ops->min_regions ||
+			in_f->ilf_size > max_regions))
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
 /*
  * The next region to add is the start of a new region.  It could be
  * a whole region or it could be the first part of a new region.  Because
@@ -2166,6 +2187,7 @@ xlog_recover_add_to_trans(
 	struct xfs_inode_log_format	*in_f;			/* any will do */
 	struct xlog_recover_item *item;
 	char			*ptr;
+	int			error;
 
 	if (!len)
 		return 0;
@@ -2211,14 +2233,10 @@ xlog_recover_add_to_trans(
 	}
 
 	if (item->ri_total == 0) {		/* first region to be added */
-		if (in_f->ilf_size == 0 ||
-		    in_f->ilf_size > XLOG_MAX_REGIONS_IN_ITEM) {
-			xfs_warn(log->l_mp,
-		"bad number of regions (%d) in inode log format",
-				  in_f->ilf_size);
-			ASSERT(0);
+		error = xlog_recover_verify_item_header(log, item, ptr, len);
+		if (error) {
 			kvfree(ptr);
-			return -EFSCORRUPTED;
+			return error;
 		}
 
 		item->ri_total = in_f->ilf_size;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 8bccf89a7766..ecd2be4d425b 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -741,6 +741,8 @@ xlog_recover_cui_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_cui_item_ops = {
 	.item_type		= XFS_LI_CUI,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_cui_commit_pass2,
 };
 
@@ -796,6 +798,8 @@ xlog_recover_rtcui_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rtcui_item_ops = {
 	.item_type		= XFS_LI_CUI_RT,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_rtcui_commit_pass2,
 };
 
@@ -828,6 +832,8 @@ xlog_recover_cud_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_cud_item_ops = {
 	.item_type		= XFS_LI_CUD,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_cud_commit_pass2,
 };
 
@@ -858,5 +864,7 @@ xlog_recover_rtcud_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rtcud_item_ops = {
 	.item_type		= XFS_LI_CUD_RT,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_rtcud_commit_pass2,
 };
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 2a3a73a8566d..201c8cea74f5 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -770,6 +770,8 @@ xlog_recover_rui_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rui_item_ops = {
 	.item_type		= XFS_LI_RUI,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_rui_commit_pass2,
 };
 
@@ -825,6 +827,8 @@ xlog_recover_rtrui_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rtrui_item_ops = {
 	.item_type		= XFS_LI_RUI_RT,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_rtrui_commit_pass2,
 };
 
@@ -857,6 +861,8 @@ xlog_recover_rud_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rud_item_ops = {
 	.item_type		= XFS_LI_RUD,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_rud_commit_pass2,
 };
 
@@ -887,5 +893,7 @@ xlog_recover_rtrud_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rtrud_item_ops = {
 	.item_type		= XFS_LI_RUD_RT,
+	.max_regions		= 1,
+	.min_regions		= 1,
 	.commit_pass2		= xlog_recover_rtrud_commit_pass2,
 };
-- 
2.43.0

