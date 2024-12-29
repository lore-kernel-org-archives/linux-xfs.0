Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DF415820C
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479554; cv=none; b=RHfOo9PuwA701y9jOfz4PnCtfJhcm4SIuxweQO5mlhq9xE2GpR1gfLMZS4m5+ytHEQYiS7JYg6QWFr2tNMI9DMFsSFXvgznEQjhD5yqsCfjb84lyQNk/z/PjyX6tUyJ1mBy9dFGvAPdRkRLc0IZPE17Ty7aVfw9cH1Mu5+X+afY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479554; c=relaxed/simple;
	bh=0zWKacQlc9i9XxUkmK5NkdmAjIlpKZFQcR90rYZAxm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7TQd1KTS6U2ojTj8Xyso3cJXNokvieYZZvAZS0Bo4aPElsLP+PcTmPB2gqdyBzt+mA6Wt8sdkpucGMEigwhAlHWnWT++jatzpEMghp6NU/d93hOtZToVrNrycKww2/uVCnokzOL6oGig2LG+YsDpATJdGf2pAOYbusxft7ZwZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DBLF4jP4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DBLF4jP4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Na2m5UMPWh3vwqiIBEvQcu/97KImYI+t91MlSg7cSc=;
	b=DBLF4jP48p1kZqNyHXUqYrkKdIdz4PSPFM2UP27voKdgrQIO+94E21aqJNyZA3wBiWuf3g
	4jkEII5EWEsFH9a+LuMPVSGh00IMbaTixZ8mZbgZTd09dB9Ar50/iW13r8OQFHamY8Mjrj
	lth7f9PpRAcnaq9XRO0/YygCU24t4oo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-iBfegatJNCiu-MABES_NNA-1; Sun, 29 Dec 2024 08:39:09 -0500
X-MC-Unique: iBfegatJNCiu-MABES_NNA-1
X-Mimecast-MFC-AGG-ID: iBfegatJNCiu-MABES_NNA
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385d52591d6so4009162f8f.1
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479548; x=1736084348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Na2m5UMPWh3vwqiIBEvQcu/97KImYI+t91MlSg7cSc=;
        b=aeQJ4Y4Gf277w7V/e1sXuQFJ9PMA6i11gVOv0DxWNu7KWIsWTqD5YuP8Z5WMfTQFNu
         ngFICVcF3AKHqKC/iZdoQVBCAJ/7b03KaTgvwiHaSY6YAr1JuyaWXpPDYk60UOdbieIf
         XbpJm8LuRrlVIeHh1xDCZml/hKFeaWSVACORGNjX+z5eACD6RfFIp/gjwwy/oSdphdqv
         zi4yUNFpccPsfVjHybJlS1qvWJkRCOlwWyFJfYEWlc6kHm18KozVgAAOJVavrFF0A9Ox
         nvEu7El5nnz5uytOyeiUfkZrKTNY5e88xwLugKADAutr7RQYD1L1KXnRciysz2WA+zkk
         o/xw==
X-Gm-Message-State: AOJu0YzF4A1rCYVo0oZE9YjkG//G26nOQy/6UMccY8key53g6AuYZwvc
	OFxwCD2ucWv/43rhjdFYztLISm0rxe5Wh55rlo67ODN/qBXmEwR1Q5YNJK5Gq4HB+9s68Fkqru8
	tS04VnxsII2cnZLHUacVsKEZU//NgOig4HfA6HVQKyVn1rDdVnTU6MgRLHXXONMz5VNFJEZQAWM
	/rqWS2ogAnCJDelw8pcjI6CNBsRgEu0DCjoN8PSBhI
X-Gm-Gg: ASbGnctochbxfXvckFC2L1psgL/8HDer9S5DcEt+2CrqPT2WdV65UYKzt5op7A3zOMi
	wy2uZ9RCQcPc03tF8L68uDsA1M7QZnKb8FPZFqDM8mfj4mstkmWiuu77sqfDFnadVjAaYDORrlq
	mr1gM6QTComVgo5nWP+SUNQTyc87fGiaNpJMhN4sn21zOMi853RxwVqrD8RkaoQl8hXCUbdeRjQ
	njnDadm8ROVCkgOezj3Z6OfaI/YrJYIOvt94Niu9J5wP9Nt7Zf1U39hwpjagMDDmi5/VZSQUiH6
	zwAwWekXk5c7odw=
X-Received: by 2002:a05:6000:18a5:b0:386:3672:73e4 with SMTP id ffacd0b85a97d-38a1a2746a3mr31667310f8f.26.1735479546415;
        Sun, 29 Dec 2024 05:39:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFHFM47AA0b3ZWvyliS/St2aNASRxqmSACTqLZRz0sidCnI0meOHabfaEgNjGexLisPtRzYWQ==
X-Received: by 2002:a05:6000:18a5:b0:386:3672:73e4 with SMTP id ffacd0b85a97d-38a1a2746a3mr31667289f8f.26.1735479545976;
        Sun, 29 Dec 2024 05:39:05 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:04 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 11/14] xfs: add interface for page cache mapped remote xattrs
Date: Sun, 29 Dec 2024 14:38:33 +0100
Message-ID: <20241229133836.1194272-12-aalbersh@kernel.org>
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

From: Andrey Albershteyn <aalbersh@redhat.com>

Leafs of the remote attributes contain xfs_attr3_rmt_hdr with CRC
of the extended attribute and owner info. Each block of the extent
has this header.

Due to this fact we can not easily map the content of extended
attribute to the page. This would be very helpful for fsverity as we
can use extended attributes to store merkle tree and map these
blocks to the page cache.

This commit changes format of the leafs by shifting CRC the btree
name struct. This however creates inconsistency problem as CRC
update could not happen even though data is updated.

This is solved by storing both CRCs - for old data and for the new
one. Attribute flag points to the correct CRC.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c        | 189 +++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_attr.h        |   8 ++
 fs/xfs/libxfs/xfs_attr_remote.c |  12 --
 fs/xfs/libxfs/xfs_da_btree.h    |   1 +
 fs/xfs/libxfs/xfs_da_format.h   |   3 +
 fs/xfs/libxfs/xfs_ondisk.h      |   9 +-
 fs/xfs/libxfs/xfs_sb.c          |   2 +
 fs/xfs/xfs_mount.h              |   2 +
 8 files changed, 207 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 55b18ec8bc10..d357405f22ee 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -27,6 +27,7 @@
 #include "xfs_attr_item.h"
 #include "xfs_xattr.h"
 #include "xfs_parent.h"
+#include "xfs_iomap.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
 
@@ -344,6 +345,175 @@ xfs_attr_set_resv(
 	return ret;
 }
 
+/*
+ * Find attribute specified in args and return iomap pointing to the attribute
+ * data
+ */
+int
+xfs_attr_read_iomap(
+	struct xfs_da_args	*args,
+	struct iomap		*iomap)
+{
+	struct xfs_inode	*ip = args->dp;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+	struct xfs_bmbt_irec	map[1];
+	int			nmap = 1;
+	int			seq;
+	unsigned int		lockmode = XFS_ILOCK_SHARED;
+	int			ret;
+	uint64_t		pos = xfs_attr_get_position(args);
+
+	ASSERT(!args->region_offset);
+
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
+	/* We just need to find the attribute and block it's pointing
+	 * to. The reading of data would be done by iomap */
+	args->valuelen = 0;
+	error = xfs_attr_get(args);
+	if (error)
+		return error;
+
+	if (xfs_need_iread_extents(&ip->i_af))
+		lockmode = XFS_ILOCK_EXCL;
+	xfs_ilock(ip, lockmode);
+	error = xfs_bmapi_read(ip, (xfs_fileoff_t)args->rmtblkno,
+			       args->rmtblkcnt, map, &nmap,
+			       XFS_BMAPI_ATTRFORK);
+	xfs_iunlock(ip, lockmode);
+	if (error)
+		return error;
+
+	map[0].br_startoff = XFS_B_TO_FSB(mp, pos | args->region_offset);
+
+	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_XATTR);
+	trace_xfs_iomap_found(ip, pos, args->valuelen, XFS_ATTR_FORK, map);
+	ret = xfs_bmbt_to_iomap(ip, iomap, map, 0, IOMAP_F_XATTR, seq);
+	/* Attributes are at args->region_offset in cache, beyond EOF of the
+	 * file */
+	iomap->flags |= IOMAP_F_BEYOND_EOF;
+
+	return ret;
+}
+
+int
+xfs_attr_read_end_io(
+		struct xfs_da_args		*args)
+{
+	struct xfs_inode			*ip = args->dp;
+	struct xfs_attr_leafblock		*leaf;
+	struct xfs_attr_leaf_entry		*entry;
+	struct xfs_attr_leaf_name_remote	*name_rmt;
+	struct xfs_buf				*bp;
+	struct xfs_mount			*mp = args->dp->i_mount;
+	uint32_t				crc;
+	int					error;
+	unsigned int				whichcrc;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+
+	if (!xfs_inode_hasattr(args->dp)) {
+		error = -ENOATTR;
+		goto out_unlock;
+	}
+
+	error = xfs_iread_extents(args->trans, args->dp, XFS_ATTR_FORK);
+	if (error)
+		goto out_unlock;
+
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+			args->blkno, &bp);
+	if (error)
+		goto out_unlock;
+
+	leaf = bp->b_addr;
+	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
+
+	whichcrc = (entry->flags & XFS_ATTR_RMCRC_SEL) != 0;
+	name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf,
+					      args->index);
+
+	xfs_calc_cksum(args->value, args->valuelen, &crc);
+	error = name_rmt->crc[whichcrc] != crc;
+	if (error) {
+		if (name_rmt->crc[~whichcrc & 1] != crc) {
+			error = -EFSCORRUPTED;
+			goto out_buf_relse;
+		} else {
+			error = -EFSBADCRC;
+			goto out_buf_relse;
+		}
+	}
+
+out_buf_relse:
+	xfs_buf_relse(bp);
+out_unlock:
+	xfs_iunlock(args->dp, XFS_ILOCK_SHARED);
+	return error;
+}
+
+/*
+ * Create an attribute described in args and return iomap pointing to the extent
+ * where attribute data has to be written.
+ *
+ * Created attribute has XFS_ATTR_INCOMPLETE set, and doesn't have any data CRC.
+ * Therefore, when IO is complete xfs_attr_write_end_ioend() need to be called.
+ */
+int
+xfs_attr_write_iomap(
+	struct xfs_da_args	*args,
+	struct iomap		*iomap)
+{
+	struct xfs_inode	*ip = args->dp;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+	int			nmap = 1;
+	int			seq;
+	struct xfs_bmbt_irec	imap[1];
+	uint64_t		pos = xfs_attr_get_position(args);
+	unsigned int		blksize = mp->m_attr_geo->blksize;
+
+	ASSERT(!args->region_offset);
+
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
+	/* We just want to allocate blocks without copying any data there */
+	args->op_flags |= XFS_DA_OP_EMPTY;
+	args->valuelen = round_up(min_t(int, args->valuelen, blksize), blksize);
+
+	error = xfs_attr_set(args, XFS_ATTRUPDATE_UPSERT, false);
+	if (error)
+		return error;
+
+	ASSERT(args->dp->i_af.if_format != XFS_DINODE_FMT_LOCAL);
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	error = xfs_bmapi_read(ip, (xfs_fileoff_t)args->rmtblkno,
+			       args->rmtblkcnt, imap, &nmap,
+			       XFS_BMAPI_ATTRFORK);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	if (error)
+		return error;
+
+	/* Instead of xattr extent offset, which will be over data, we need
+	 * merkle tree offset in page cache */
+	imap[0].br_startoff = XFS_B_TO_FSBT(mp, pos | args->region_offset);
+
+	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_XATTR);
+	xfs_bmbt_to_iomap(ip, iomap, imap, 0, IOMAP_F_XATTR, seq);
+
+	return 0;
+}
+
+int
+xfs_attr_write_end_ioend(
+		struct xfs_da_args	*args)
+{
+	return xfs_attr_set(args, XFS_ATTRUPDATE_FLAGS, false);
+}
+
 /*
  * Add an attr to a shortform fork. If there is no space,
  * xfs_attr_shortform_addname() will convert to leaf format and return -ENOSPC.
@@ -642,11 +812,15 @@ xfs_attr_rmtval_alloc(
 			goto out;
 	}
 
-	if (!(args->op_flags & XFS_DA_OP_EMPTY)) {
+	if (args->op_flags & XFS_DA_OP_EMPTY) {
+		/* Set XFS_ATTR_INCOMLETE flag as attribute doesn't have a value
+		 * yet (which should be written by iomap). */
+		error = xfs_attr3_leaf_setflag(args);
+	} else {
 		error = xfs_attr_rmtval_set_value(args);
-		if (error)
-			return error;
 	}
+	if (error)
+		return error;
 
 	attr->xattri_dela_state = xfs_attr_complete_op(attr,
 						++attr->xattri_dela_state);
@@ -1613,3 +1787,12 @@ xfs_attr_intent_destroy_cache(void)
 	kmem_cache_destroy(xfs_attr_intent_cache);
 	xfs_attr_intent_cache = NULL;
 }
+
+/* Retrieve attribute position from the attr data */
+uint64_t
+xfs_attr_get_position(
+	struct xfs_da_args	*args)
+{
+	ASSERT(args->namelen == sizeof(uint64_t));
+	return be64_to_cpu(*(uint64_t*)args->name);
+}
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b851e2e4b63c..3d137117154e 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_ATTR_H__
 #define	__XFS_ATTR_H__
 
+#include <linux/iomap.h>
+
 struct xfs_inode;
 struct xfs_da_args;
 struct xfs_attr_list_context;
@@ -569,6 +571,10 @@ bool xfs_attr_namecheck(unsigned int attr_flags, const void *name,
 		size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 struct xfs_trans_res xfs_attr_set_resv(const struct xfs_da_args *args);
+int xfs_attr_read_iomap(struct xfs_da_args *args, struct iomap *iomap);
+int xfs_attr_read_end_io(struct xfs_da_args *args);
+int xfs_attr_write_iomap(struct xfs_da_args *args, struct iomap *iomap);
+int xfs_attr_write_end_ioend(struct xfs_da_args *args);
 
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
@@ -652,4 +658,6 @@ void xfs_attr_intent_destroy_cache(void);
 int xfs_attr_sf_totsize(struct xfs_inode *dp);
 int xfs_attr_add_fork(struct xfs_inode *ip, int size, int rsvd);
 
+uint64_t xfs_attr_get_position(struct xfs_da_args *args);
+
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 4c44ce1c8a64..17125e2e6c51 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -62,13 +62,6 @@ xfs_attr3_rmt_blocks(
 	struct xfs_mount	*mp,
 	unsigned int		attrlen)
 {
-	/*
-	 * Each contiguous block has a header, so it is not just a simple
-	 * attribute length to FSB conversion.
-	 */
-	if (xfs_has_crc(mp))
-		return howmany(attrlen, xfs_attr3_rmt_buf_space(mp));
-
 	return XFS_B_TO_FSB(mp, attrlen);
 }
 
@@ -467,11 +460,6 @@ xfs_attr_rmt_find_hole(
 	unsigned int		blkcnt;
 	xfs_fileoff_t		lfileoff = 0;
 
-	/*
-	 * Because CRC enable attributes have headers, we can't just do a
-	 * straight byte to FSB conversion and have to take the header space
-	 * into account.
-	 */
 	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
 	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
 						   XFS_ATTR_FORK);
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 2428a3a466cb..81e3426ccb77 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -85,6 +85,7 @@ typedef struct xfs_da_args {
 	int		rmtblkcnt2;	/* remote attr value block count */
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	loff_t		region_offset;	/* offset of the iomapped attr region */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index afc25b6d805e..bf0f73624446 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -645,6 +645,7 @@ typedef struct xfs_attr_leaf_name_local {
 } xfs_attr_leaf_name_local_t;
 
 typedef struct xfs_attr_leaf_name_remote {
+	__be32	crc[2];			/* CRC of the xattr data */
 	__be32	valueblk;		/* block number of value bytes */
 	__be32	valuelen;		/* number of bytes in value */
 	__u8	namelen;		/* length of name bytes */
@@ -715,11 +716,13 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
 #define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
+#define	XFS_ATTR_RMCRC_SEL_BIT	4	/* which CRC field is primary */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
 #define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
+#define XFS_ATTR_RMCRC_SEL	(1u << XFS_ATTR_RMCRC_SEL_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
 
 #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | \
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index ad0dedf00f18..2617081bf989 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -96,10 +96,11 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_local, valuelen,	0);
 	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_local, namelen,	2);
 	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_local, nameval,	3);
-	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, valueblk,	0);
-	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, valuelen,	4);
-	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, namelen,	8);
-	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, name,	9);
+	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, crc,		0);
+	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, valueblk,	8);
+	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, valuelen,	12);
+	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, namelen,	16);
+	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, name,	17);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leafblock,		32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_hdr,		4);
 	XFS_CHECK_OFFSET(struct xfs_attr_sf_hdr, totsize,	0);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 3b5623611eba..20395ba66b94 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -183,6 +183,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_PARENT;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
 		features |= XFS_FEAT_METADIR;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_DXATTR)
+		features |= XFS_FEAT_DXATTR;
 
 	return features;
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d772d908ba3c..1fa4a57421c3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -330,6 +330,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
 #define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
+#define XFS_FEAT_DXATTR		(1ULL << 29)	/* directly mapped xattrs */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -386,6 +387,7 @@ __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 __XFS_HAS_FEAT(metadir, METADIR)
+__XFS_HAS_FEAT(dxattr, DXATTR)
 
 static inline bool xfs_has_rtgroups(struct xfs_mount *mp)
 {
-- 
2.47.0

