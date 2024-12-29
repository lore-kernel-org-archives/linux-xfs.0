Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7C617C20F
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479544; cv=none; b=Zzt2LmnzWQY9z3LQuIGjYMeQqtX13gqp+cguqBzJn4pcRDDJ1S3oS3Qv+uESVdDhilWPJfu9pjnlXpMc7n4gV4oQyvhDJcWfnNcypK+QhXJu9ckl5S/B7yd9UTv0okpJJKgsJaxtL6coBcM7MXTdAvMuH8UloL5XrOoaPbfneZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479544; c=relaxed/simple;
	bh=yNMK+cXUUFlYsky9xtRclRAoO+joiKNTh1Amgr5jHw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGVaw8IK3BAizpcb/7FOVagPy40iH7GXbNdTNXn5wUcQKKhhaEIee4ImOO7d4pQzAUce4ZTJ2ppULtVTKQYjgbOM7f6O53e1aVKPZDOcvcJWDpSw6Nk5VMgT+y/U+GFRGWRFlv0OU0SNk7QjAHTPf7/QMxfnnrTmTahRU32gavY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TD3r57gl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TD3r57gl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sykCjcocIlR0khpsmKYVwfZ8dpYtCo1kMYbbxSnV/zU=;
	b=TD3r57gloxrfN2kosAgoAcn2HBozQs3+uUCcgGNrdKsQez2G/prb/Dr+/vzl0u6G0bCb0u
	vfezynPGUQwUqt9evXhla0OrP87GqOEajTbx9UWB/kSwoGIR2Ik+HvbB2/UgEJJKCK+jLT
	uZ2UjenchETl8nnAnd8s3vA2lTn5MuA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-zuCmgeDhNIqAysg-Zp6HpQ-1; Sun, 29 Dec 2024 08:39:00 -0500
X-MC-Unique: zuCmgeDhNIqAysg-Zp6HpQ-1
X-Mimecast-MFC-AGG-ID: zuCmgeDhNIqAysg-Zp6HpQ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361ac8b25fso48579525e9.2
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479539; x=1736084339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sykCjcocIlR0khpsmKYVwfZ8dpYtCo1kMYbbxSnV/zU=;
        b=nQGHzvFeLaXHER2t7vm1o1IVM000tJggY58vPO7iWFu1sSsMzgzNHWOCAqbDcPhWp0
         7gPt/bpgfnJWLNm58CS/R6gRUwsfTm2H/qke/FN78t84AdAXiVUXWo71uuxfkyOKT/Uq
         4TgLrRKiovckRj601GbgKxxc58iJ2NmHMuGxNZbAoG8J7uolecylBRxrRBb0m8zQ4LYO
         8457cGWni6k7LPxxPUKw8mjhkwMSxq4iU2BaSFwoRzR9bl1uRcZXxJQseE9YcpBxFUAJ
         yhX6kZVPHiAUmk3HqU3JngN3sSbruSEAu8hHZGnNc+h8fHDPvHGr+BlfJTDUM44hU6BS
         M6iw==
X-Gm-Message-State: AOJu0YzNys1QJE6iTHw8iT7iQynrjFUrisvZCCcT3/pFpb3e5nhKZz1Y
	ICB8PR2vorExPAdaDlbGuBxiJl0oPwVFNflsHEoImEwixrtvcKVfRVWls6r6B9rEorUb3yncIL6
	q1rJugE6LYFm+2kiDzk1kSuBkl5l0ozQIHP6/Li113OZksZOU0S7ak8v8PIfhLeysG1SMrr/Kg+
	Ncq/SL9w57o+tthrjRx7BLVn4wDTpbhMMR6Dw9teFj
X-Gm-Gg: ASbGncslo29Avr4Q2826dUP9lrMV/WVHxiWVHIUHLI/cQx10O3dvq0fQzulU3+KIDTY
	4ZkXce8mKvTYxJMrucv0Z802sWASPtRi/B7UoMlOpcHE5f0efTEKCEEqy5p2w0Um8jn1pSRsbMT
	+uGrOg6ksgq52uB0S8CxXI0Rum9hwcygCqr8OMkCH3DkG+9dyW6W9z99t4sdMhaZHH/lkcgohdG
	52rzPRyf0k0aqVIfMy6lwd8ymG1XW737MnuLw8QuOATCWcsKvhhLMVmLTSxc5kGeH9KgAcAEny7
	zOJ/ezox6jDFyuk=
X-Received: by 2002:a05:600c:1994:b0:435:306:e5dd with SMTP id 5b1f17b1804b1-43668b5dfaamr262071935e9.22.1735479538709;
        Sun, 29 Dec 2024 05:38:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGbjuoOvXjbOiBKJcvvfFziJXvofNI6P7m1VXl0j+iKi1xAr4xpA5oXMZPEBLw8+2twrgZIoA==
X-Received: by 2002:a05:600c:1994:b0:435:306:e5dd with SMTP id 5b1f17b1804b1-43668b5dfaamr262071755e9.22.1735479538113;
        Sun, 29 Dec 2024 05:38:58 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:38:55 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 06/14] libxfs: pass xfs_sb to xfs_attr3_leaf_name_remote()
Date: Sun, 29 Dec 2024 14:38:28 +0100
Message-ID: <20241229133836.1194272-7-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133836.1194272-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133836.1194272-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be needed to check with feature flags if new format of
xfs_attr_leaf_name_remote is in use.

This commit just changes signature of xfs_attr3_leaf_name_remote()
by adding xfs_sb. Superblock will be used in later commit.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 80 +++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_da_format.h |  5 ++-
 fs/xfs/scrub/attr.c           |  2 +-
 fs/xfs/scrub/attr_repair.c    |  3 +-
 fs/xfs/scrub/listxattr.c      |  3 +-
 fs/xfs/xfs_attr_inactive.c    |  2 +-
 fs/xfs/xfs_attr_list.c        |  3 +-
 7 files changed, 65 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index fddb55605e0c..c657638efe04 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -73,7 +73,11 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
 			struct xfs_attr_leafblock *dst_leaf,
 			struct xfs_attr3_icleaf_hdr *dst_ichdr, int dst_start,
 			int move_count);
-STATIC int xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index);
+STATIC int
+xfs_attr_leaf_entsize(
+		struct xfs_mount	*mp,
+		xfs_attr_leafblock_t	*leaf,
+		int			index);
 
 /*
  * attr3 block 'firstused' conversion helpers.
@@ -274,7 +278,7 @@ xfs_attr3_leaf_verify_entry(
 		if (lentry->namelen == 0)
 			return __this_address;
 	} else {
-		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
+		rentry = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf, idx);
 		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 		name_end = (char *)rentry + namesize;
 		if (rentry->namelen == 0)
@@ -1560,7 +1564,8 @@ xfs_attr3_leaf_add_work(
 		memcpy((char *)&name_loc->nameval[args->namelen], args->value,
 				   be16_to_cpu(name_loc->valuelen));
 	} else {
-		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
+		name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf,
+						      args->index);
 		name_rmt->namelen = args->namelen;
 		memcpy((char *)name_rmt->name, args->name, args->namelen);
 		entry->flags |= XFS_ATTR_INCOMPLETE;
@@ -1571,9 +1576,10 @@ xfs_attr3_leaf_add_work(
 		args->rmtblkcnt = xfs_attr3_rmt_blocks(mp, args->valuelen);
 		args->rmtvaluelen = args->valuelen;
 	}
-	xfs_trans_log_buf(args->trans, bp,
-	     XFS_DA_LOGRANGE(leaf, xfs_attr3_leaf_name(leaf, args->index),
-				   xfs_attr_leaf_entsize(leaf, args->index)));
+	xfs_trans_log_buf(
+		args->trans, bp,
+		XFS_DA_LOGRANGE(leaf, xfs_attr3_leaf_name(leaf, args->index),
+				xfs_attr_leaf_entsize(mp, leaf, args->index)));
 
 	/*
 	 * Update the control info for this leaf node
@@ -1594,7 +1600,7 @@ xfs_attr3_leaf_add_work(
 						sizeof(xfs_attr_leaf_entry_t));
 		}
 	}
-	ichdr->usedbytes += xfs_attr_leaf_entsize(leaf, args->index);
+	ichdr->usedbytes += xfs_attr_leaf_entsize(mp, leaf, args->index);
 }
 
 /*
@@ -1910,6 +1916,7 @@ xfs_attr3_leaf_figure_balance(
 	struct xfs_attr_leafblock	*leaf1 = blk1->bp->b_addr;
 	struct xfs_attr_leafblock	*leaf2 = blk2->bp->b_addr;
 	struct xfs_attr_leaf_entry	*entry;
+	struct xfs_mount		*mp = state->mp;
 	int				count;
 	int				max;
 	int				index;
@@ -1958,8 +1965,8 @@ xfs_attr3_leaf_figure_balance(
 		/*
 		 * Figure out if next leaf entry would be too much.
 		 */
-		tmp = totallen + sizeof(*entry) + xfs_attr_leaf_entsize(leaf1,
-									index);
+		tmp = totallen + sizeof(*entry) +
+		      xfs_attr_leaf_entsize(mp, leaf1, index);
 		if (XFS_ATTR_ABS(half - tmp) > lastdelta)
 			break;
 		lastdelta = XFS_ATTR_ABS(half - tmp);
@@ -2132,6 +2139,7 @@ xfs_attr3_leaf_remove(
 	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr3_icleaf_hdr ichdr;
 	struct xfs_attr_leaf_entry *entry;
+	struct xfs_mount *mp = args->dp->i_mount;
 	int			before;
 	int			after;
 	int			smallest;
@@ -2166,7 +2174,7 @@ xfs_attr3_leaf_remove(
 	tmp = ichdr.freemap[0].size;
 	before = after = -1;
 	smallest = XFS_ATTR_LEAF_MAPSIZE - 1;
-	entsize = xfs_attr_leaf_entsize(leaf, args->index);
+	entsize = xfs_attr_leaf_entsize(mp, leaf, args->index);
 	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
 		ASSERT(ichdr.freemap[i].base < args->geo->blksize);
 		ASSERT(ichdr.freemap[i].size < args->geo->blksize);
@@ -2414,6 +2422,7 @@ xfs_attr3_leaf_lookup_int(
 	struct xfs_attr_leaf_entry *entries;
 	struct xfs_attr_leaf_name_local *name_loc;
 	struct xfs_attr_leaf_name_remote *name_rmt;
+	struct xfs_mount *mp = args->dp->i_mount;
 	xfs_dahash_t		hashval;
 	int			probe;
 	int			span;
@@ -2492,7 +2501,8 @@ xfs_attr3_leaf_lookup_int(
 		} else {
 			unsigned int	valuelen;
 
-			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
+			name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf,
+							      probe);
 			valuelen = be32_to_cpu(name_rmt->valuelen);
 			if (!xfs_attr_match(args, entry->flags, name_rmt->name,
 					name_rmt->namelen, NULL, valuelen))
@@ -2528,6 +2538,7 @@ xfs_attr3_leaf_getvalue(
 	struct xfs_attr_leaf_entry *entry;
 	struct xfs_attr_leaf_name_local *name_loc;
 	struct xfs_attr_leaf_name_remote *name_rmt;
+	struct xfs_mount *mp = args->dp->i_mount;
 
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
@@ -2544,7 +2555,7 @@ xfs_attr3_leaf_getvalue(
 					be16_to_cpu(name_loc->valuelen));
 	}
 
-	name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
+	name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf, args->index);
 	ASSERT(name_rmt->namelen == args->namelen);
 	ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
 	args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
@@ -2576,6 +2587,7 @@ xfs_attr3_leaf_moveents(
 {
 	struct xfs_attr_leaf_entry	*entry_s;
 	struct xfs_attr_leaf_entry	*entry_d;
+	struct xfs_mount		*mp = args->dp->i_mount;
 	int				desti;
 	int				tmp;
 	int				i;
@@ -2624,7 +2636,7 @@ xfs_attr3_leaf_moveents(
 	desti = start_d;
 	for (i = 0; i < count; entry_s++, entry_d++, desti++, i++) {
 		ASSERT(be16_to_cpu(entry_s->nameidx) >= ichdr_s->firstused);
-		tmp = xfs_attr_leaf_entsize(leaf_s, start_s + i);
+		tmp = xfs_attr_leaf_entsize(mp, leaf_s, start_s + i);
 #ifdef GROT
 		/*
 		 * Code to drop INCOMPLETE entries.  Difficult to use as we
@@ -2730,12 +2742,15 @@ xfs_attr_leaf_lasthash(
  * (whether local or remote only calculate bytes in this block).
  */
 STATIC int
-xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index)
+xfs_attr_leaf_entsize(
+		struct xfs_mount	*mp,
+		xfs_attr_leafblock_t	*leaf,
+		int			index)
 {
-	struct xfs_attr_leaf_entry *entries;
-	xfs_attr_leaf_name_local_t *name_loc;
-	xfs_attr_leaf_name_remote_t *name_rmt;
-	int size;
+	struct xfs_attr_leaf_entry	*entries;
+	xfs_attr_leaf_name_local_t	*name_loc;
+	xfs_attr_leaf_name_remote_t	*name_rmt;
+	int				size;
 
 	entries = xfs_attr3_leaf_entryp(leaf);
 	if (entries[index].flags & XFS_ATTR_LOCAL) {
@@ -2743,7 +2758,7 @@ xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index)
 		size = xfs_attr_leaf_entsize_local(name_loc->namelen,
 						   be16_to_cpu(name_loc->valuelen));
 	} else {
-		name_rmt = xfs_attr3_leaf_name_remote(leaf, index);
+		name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf, index);
 		size = xfs_attr_leaf_entsize_remote(name_rmt->namelen);
 	}
 	return size;
@@ -2789,6 +2804,7 @@ xfs_attr3_leaf_clearflag(
 	struct xfs_attr_leaf_entry *entry;
 	struct xfs_attr_leaf_name_remote *name_rmt;
 	struct xfs_buf		*bp;
+	struct xfs_mount	*mp = args->dp->i_mount;
 	int			error;
 #ifdef DEBUG
 	struct xfs_attr3_icleaf_hdr ichdr;
@@ -2820,7 +2836,8 @@ xfs_attr3_leaf_clearflag(
 		namelen = name_loc->namelen;
 		name = (char *)name_loc->nameval;
 	} else {
-		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
+		name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf,
+						      args->index);
 		namelen = name_rmt->namelen;
 		name = (char *)name_rmt->name;
 	}
@@ -2835,11 +2852,13 @@ xfs_attr3_leaf_clearflag(
 
 	if (args->rmtblkno) {
 		ASSERT((entry->flags & XFS_ATTR_LOCAL) == 0);
-		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
+		name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf,
+						      args->index);
 		name_rmt->valueblk = cpu_to_be32(args->rmtblkno);
 		name_rmt->valuelen = cpu_to_be32(args->rmtvaluelen);
 		xfs_trans_log_buf(args->trans, bp,
-			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
+				  XFS_DA_LOGRANGE(leaf, name_rmt,
+						  sizeof(*name_rmt)));
 	}
 
 	return 0;
@@ -2856,6 +2875,7 @@ xfs_attr3_leaf_setflag(
 	struct xfs_attr_leaf_entry *entry;
 	struct xfs_attr_leaf_name_remote *name_rmt;
 	struct xfs_buf		*bp;
+	struct xfs_mount	*mp = args->dp->i_mount;
 	int error;
 #ifdef DEBUG
 	struct xfs_attr3_icleaf_hdr ichdr;
@@ -2884,7 +2904,8 @@ xfs_attr3_leaf_setflag(
 	xfs_trans_log_buf(args->trans, bp,
 			XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
 	if ((entry->flags & XFS_ATTR_LOCAL) == 0) {
-		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
+		name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf,
+						      args->index);
 		name_rmt->valueblk = 0;
 		name_rmt->valuelen = 0;
 		xfs_trans_log_buf(args->trans, bp,
@@ -2912,6 +2933,7 @@ xfs_attr3_leaf_flipflags(
 	struct xfs_attr_leaf_name_remote *name_rmt;
 	struct xfs_buf		*bp1;
 	struct xfs_buf		*bp2;
+	struct xfs_mount	*mp = args->dp->i_mount;
 	int error;
 #ifdef DEBUG
 	struct xfs_attr3_icleaf_hdr ichdr1;
@@ -2963,7 +2985,8 @@ xfs_attr3_leaf_flipflags(
 		namelen1 = name_loc->namelen;
 		name1 = (char *)name_loc->nameval;
 	} else {
-		name_rmt = xfs_attr3_leaf_name_remote(leaf1, args->index);
+		name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf1,
+						      args->index);
 		namelen1 = name_rmt->namelen;
 		name1 = (char *)name_rmt->name;
 	}
@@ -2972,7 +2995,8 @@ xfs_attr3_leaf_flipflags(
 		namelen2 = name_loc->namelen;
 		name2 = (char *)name_loc->nameval;
 	} else {
-		name_rmt = xfs_attr3_leaf_name_remote(leaf2, args->index2);
+		name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf2,
+						      args->index2);
 		namelen2 = name_rmt->namelen;
 		name2 = (char *)name_rmt->name;
 	}
@@ -2989,7 +3013,8 @@ xfs_attr3_leaf_flipflags(
 			  XFS_DA_LOGRANGE(leaf1, entry1, sizeof(*entry1)));
 	if (args->rmtblkno) {
 		ASSERT((entry1->flags & XFS_ATTR_LOCAL) == 0);
-		name_rmt = xfs_attr3_leaf_name_remote(leaf1, args->index);
+		name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf1,
+						      args->index);
 		name_rmt->valueblk = cpu_to_be32(args->rmtblkno);
 		name_rmt->valuelen = cpu_to_be32(args->rmtvaluelen);
 		xfs_trans_log_buf(args->trans, bp1,
@@ -3000,7 +3025,8 @@ xfs_attr3_leaf_flipflags(
 	xfs_trans_log_buf(args->trans, bp2,
 			  XFS_DA_LOGRANGE(leaf2, entry2, sizeof(*entry2)));
 	if ((entry2->flags & XFS_ATTR_LOCAL) == 0) {
-		name_rmt = xfs_attr3_leaf_name_remote(leaf2, args->index2);
+		name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf2,
+						      args->index2);
 		name_rmt->valueblk = 0;
 		name_rmt->valuelen = 0;
 		xfs_trans_log_buf(args->trans, bp2,
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 86de99e2f757..afc25b6d805e 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -773,7 +773,10 @@ xfs_attr3_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
 }
 
 static inline xfs_attr_leaf_name_remote_t *
-xfs_attr3_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
+xfs_attr3_leaf_name_remote(
+		struct xfs_sb		*sb,
+		xfs_attr_leafblock_t	*leafp,
+		int			idx)
 {
 	return (xfs_attr_leaf_name_remote_t *)xfs_attr3_leaf_name(leafp, idx);
 }
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 708334f9b2bd..d911cf9cad20 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -361,7 +361,7 @@ xchk_xattr_entry(
 		if (lentry->namelen == 0)
 			xchk_da_set_corrupt(ds, level);
 	} else {
-		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
+		rentry = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf, idx);
 		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 		name_end = (char *)rentry + namesize;
 		if (rentry->namelen == 0 || rentry->valueblk == 0)
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index c7eb94069caf..2a8e70f45361 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -436,7 +436,8 @@ xrep_xattr_recover_leaf(
 			error = xrep_xattr_salvage_local_attr(rx, ent, nameidx,
 					buf_end, lentry);
 		} else {
-			rentry = xfs_attr3_leaf_name_remote(leaf, i);
+			rentry = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf,
+							    i);
 			error = xrep_xattr_salvage_remote_attr(rx, ent, nameidx,
 					buf_end, rentry, i, bp);
 		}
diff --git a/fs/xfs/scrub/listxattr.c b/fs/xfs/scrub/listxattr.c
index 256ff7700c94..70ec6d2ff907 100644
--- a/fs/xfs/scrub/listxattr.c
+++ b/fs/xfs/scrub/listxattr.c
@@ -84,7 +84,8 @@ xchk_xattr_walk_leaf_entries(
 		} else {
 			struct xfs_attr_leaf_name_remote	*name_rmt;
 
-			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+			name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf,
+							      i);
 			name = name_rmt->name;
 			namelen = name_rmt->namelen;
 			value = NULL;
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 24fb12986a56..2495ff76acec 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -106,7 +106,7 @@ xfs_attr3_leaf_inactive(
 		if (!entry->nameidx || (entry->flags & XFS_ATTR_LOCAL))
 			continue;
 
-		name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+		name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf, i);
 		if (!name_rmt->valueblk)
 			continue;
 
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 379b48d015d2..4388443e2db7 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -506,7 +506,8 @@ xfs_attr3_leaf_list_int(
 		} else {
 			xfs_attr_leaf_name_remote_t *name_rmt;
 
-			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+			name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf,
+							      i);
 			name = name_rmt->name;
 			namelen = name_rmt->namelen;
 			value = NULL;
-- 
2.47.0

