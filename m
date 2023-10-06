Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB476E92FE4
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbjJFSxr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbjJFSxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:53:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D43C2
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ktbSkcxQ2MopqhRASA9Ckw22XP9yki7f3Ov+tcO2rNo=;
        b=aFRefZ8NbV9ZwdBERd7Q1BAS90tTLo86vsOsNoaldxcn2UqvgVXvAf1K8O7lTIKhzVZGTC
        Ri7FIW31V5d+XBO7Q1M0zOFx2dHdT+ydY4hoDEExk0PYIrfKMsJfS3ufr+6GNAcrmgUuh1
        hnQHvSuXV6x1hPOk1KmX3CSjDctF0no=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-O0LuG8C8MEKa1wF9kCuw3g-1; Fri, 06 Oct 2023 14:52:22 -0400
X-MC-Unique: O0LuG8C8MEKa1wF9kCuw3g-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9b98bbf130cso207014466b.2
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618340; x=1697223140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ktbSkcxQ2MopqhRASA9Ckw22XP9yki7f3Ov+tcO2rNo=;
        b=PNQAM9iOEL0mULaGmqMVcI4myYHVOaOxXfXrNItgWvuCPNFOsOG1Vg5XX/VovOD+Vm
         icoGOn/pQ3OZ/pNJwfJctxwcAqD52v0hHSudiQ9Yy/ebNC7lzwkdCFhs0/3VaVWrCCmX
         maNQuAX+FsiGQgMMp0xWicabFJHDA6rJTti2qzZa/v1vecqrmQXieIqmBjVjjVqKLIC3
         xRy5H7XiA2tzV7IZmoBGy/VvGDudI8HTqafPRNJjzxxdSBolEAH4pYQH103EWAONbUnQ
         UXxE0GN0gJ+B+Wvv2A+79g6dQc3Ai7vUuKTAfWHSLSo4v+z4cmtXKXwRWTVhu7cGUe7O
         SdAQ==
X-Gm-Message-State: AOJu0Yy1yJDGczCv/6VJZ1BfIg6vIa9gCXt/aLXbTrK9ornNdkjIMiX4
        69FnJSO2O15AeHDYyKoeEsRB6cffpK+/8Y3cPg3TGl3kdDb4ahIEr72NmI2zn0rIb8rw3qjSAt2
        X+WPTRWe6t6IGhQ2/8XHz3Ll03oyd3AdQHpNdetkJom7AbzzjDkfgprStK0D+LJFPe/H8bnpc4J
        r1Rog=
X-Received: by 2002:a17:906:7389:b0:9a5:b878:7336 with SMTP id f9-20020a170906738900b009a5b8787336mr9458393ejl.7.1696618339638;
        Fri, 06 Oct 2023 11:52:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8lxCo4QwcGyHuut/Kl0nJ04gFPevq0GQQoylmYhEvfcxf5ro/6Re6/UX6v05VxDmigGzCCw==
X-Received: by 2002:a17:906:7389:b0:9a5:b878:7336 with SMTP id f9-20020a170906738900b009a5b8787336mr9458373ejl.7.1696618339243;
        Fri, 06 Oct 2023 11:52:19 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:18 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com,
        Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 01/28] xfs: Add new name to attri/d
Date:   Fri,  6 Oct 2023 20:48:55 +0200
Message-Id: <20231006184922.252188-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds two new fields to the atti/d.  They are nname and
nnamelen.  This will be used for parent pointer updates since a
rename operation may cause the parent pointer to update both the
name and value.  So we need to carry both the new name as well as
the target name in the attri/d.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |  12 ++-
 fs/xfs/libxfs/xfs_attr.h       |   4 +-
 fs/xfs/libxfs/xfs_da_btree.h   |   2 +
 fs/xfs/libxfs/xfs_log_format.h |   6 +-
 fs/xfs/xfs_attr_item.c         | 135 +++++++++++++++++++++++++++------
 fs/xfs/xfs_attr_item.h         |   1 +
 6 files changed, 133 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..b1dbed7655e8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -423,6 +423,12 @@ xfs_attr_complete_op(
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	if (do_replace) {
 		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+		if (args->new_namelen > 0) {
+			args->name = args->new_name;
+			args->namelen = args->new_namelen;
+			args->hashval = xfs_da_hashname(args->name,
+							args->namelen);
+		}
 		return replace_state;
 	}
 	return XFS_DAS_DONE;
@@ -922,9 +928,13 @@ xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
+	op_flag = args->new_namelen == 0 ? XFS_ATTRI_OP_FLAGS_REPLACE :
+		  XFS_ATTRI_OP_FLAGS_NVREPLACE;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e4004..3e81f3f48560 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -510,8 +510,8 @@ struct xfs_attr_intent {
 	struct xfs_da_args		*xattri_da_args;
 
 	/*
-	 * Shared buffer containing the attr name and value so that the logging
-	 * code can share large memory buffers between log items.
+	 * Shared buffer containing the attr name, new name, and value so that
+	 * the logging code can share large memory buffers between log items.
 	 */
 	struct xfs_attri_log_nameval	*xattri_nameval;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..a4b29827603f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -55,7 +55,9 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	const uint8_t		*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*new_name;	/* new attr name */
 	int		namelen;	/* length of string (maybe no NULL) */
+	int		new_namelen;	/* new attr name len */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 269573c82808..82f910b857b7 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -117,7 +117,8 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_MAX		30
+#define XLOG_REG_TYPE_ATTR_NNAME	31
+#define XLOG_REG_TYPE_MAX		31
 
 
 /*
@@ -964,6 +965,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -981,7 +983,7 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint32_t	alfi_nname_len;	/* attr new name length */
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 36fe2abb16e6..97ee9d89b5b8 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -75,6 +75,8 @@ static inline struct xfs_attri_log_nameval *
 xfs_attri_log_nameval_alloc(
 	const void			*name,
 	unsigned int			name_len,
+	const void			*nname,
+	unsigned int			nname_len,
 	const void			*value,
 	unsigned int			value_len)
 {
@@ -85,15 +87,25 @@ xfs_attri_log_nameval_alloc(
 	 * this. But kvmalloc() utterly sucks, so we use our own version.
 	 */
 	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
-					name_len + value_len);
+					name_len + nname_len + value_len);
 
 	nv->name.i_addr = nv + 1;
 	nv->name.i_len = name_len;
 	nv->name.i_type = XLOG_REG_TYPE_ATTR_NAME;
 	memcpy(nv->name.i_addr, name, name_len);
 
+	if (nname_len) {
+		nv->nname.i_addr = nv->name.i_addr + name_len;
+		nv->nname.i_len = nname_len;
+		memcpy(nv->nname.i_addr, nname, nname_len);
+	} else {
+		nv->nname.i_addr = NULL;
+		nv->nname.i_len = 0;
+	}
+	nv->nname.i_type = XLOG_REG_TYPE_ATTR_NNAME;
+
 	if (value_len) {
-		nv->value.i_addr = nv->name.i_addr + name_len;
+		nv->value.i_addr = nv->name.i_addr + nname_len + name_len;
 		nv->value.i_len = value_len;
 		memcpy(nv->value.i_addr, value, value_len);
 	} else {
@@ -147,11 +159,15 @@ xfs_attri_item_size(
 	*nbytes += sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(nv->name.i_len);
 
-	if (!nv->value.i_len)
-		return;
+	if (nv->nname.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->nname.i_len);
+	}
 
-	*nvecs += 1;
-	*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	if (nv->value.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	}
 }
 
 /*
@@ -181,6 +197,9 @@ xfs_attri_item_format(
 	ASSERT(nv->name.i_len > 0);
 	attrip->attri_format.alfi_size++;
 
+	if (nv->nname.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	if (nv->value.i_len > 0)
 		attrip->attri_format.alfi_size++;
 
@@ -188,6 +207,10 @@ xfs_attri_item_format(
 			&attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
 	xlog_copy_from_iovec(lv, &vecp, &nv->name);
+
+	if (nv->nname.i_len > 0)
+		xlog_copy_from_iovec(lv, &vecp, &nv->nname);
+
 	if (nv->value.i_len > 0)
 		xlog_copy_from_iovec(lv, &vecp, &nv->value);
 }
@@ -374,6 +397,7 @@ xfs_attr_log_item(
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
 	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 }
@@ -415,7 +439,8 @@ xfs_attr_create_intent(
 		 * deferred work state structure.
 		 */
 		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
-				args->namelen, args->value, args->valuelen);
+				args->namelen, args->new_name,
+				args->new_namelen, args->value, args->valuelen);
 	}
 
 	attrip = xfs_attri_init(mp, attr->xattri_nameval);
@@ -503,7 +528,8 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
-	if (attrp->__pad != 0)
+	if (attrp->alfi_op_flags != XFS_ATTRI_OP_FLAGS_NVREPLACE &&
+	    attrp->alfi_nname_len != 0)
 		return false;
 
 	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
@@ -517,6 +543,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		break;
 	default:
 		return false;
@@ -526,9 +553,14 @@ xfs_attri_validate(
 		return false;
 
 	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
+	    (attrp->alfi_nname_len > XATTR_NAME_MAX) ||
 	    (attrp->alfi_name_len == 0))
 		return false;
 
+	if (op == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    attrp->alfi_value_len != 0)
+		return false;
+
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 
@@ -589,6 +621,8 @@ xfs_attri_item_recover(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
+	args->new_name = nv->nname.i_addr;
+	args->new_namelen = nv->nname.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
@@ -599,6 +633,7 @@ xfs_attri_item_recover(
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		args->value = nv->value.i_addr;
 		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
@@ -689,6 +724,7 @@ xfs_attri_item_relog(
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
 	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
@@ -711,48 +747,102 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
-
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	const void			*attr_nname = NULL;
+	int				op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	len = sizeof(struct xfs_attri_log_format);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[i].i_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	attri_formatp = item->ri_buf[i].i_addr;
 	if (!xfs_attri_validate(mp, attri_formatp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		if (item->ri_total != 4) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				     attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
+	i++;
 	/* Validate the attr name */
-	if (item->ri_buf[1].i_len !=
+	if (item->ri_buf[i].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	attr_name = item->ri_buf[i].i_addr;
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[1].i_addr, item->ri_buf[1].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	i++;
+	if (attri_formatp->alfi_nname_len) {
+		/* Validate the attr nname */
+		if (item->ri_buf[i].i_len !=
+		    xlog_calc_iovec_len(attri_formatp->alfi_nname_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
+
+		attr_nname = item->ri_buf[i].i_addr;
+		if (!xfs_attr_namecheck(attr_nname,
+				attri_formatp->alfi_nname_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
+		i++;
+	}
+
+
 	/* Validate the attr value, if present */
 	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[2].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					item->ri_buf[0].i_addr,
-					item->ri_buf[0].i_len);
+					attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
 
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
 	}
 
 	/*
@@ -761,7 +851,8 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_value,
+			attri_formatp->alfi_name_len, attr_nname,
+			attri_formatp->alfi_nname_len, attr_value,
 			attri_formatp->alfi_value_len);
 
 	attrip = xfs_attri_init(mp, nv);
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index 3280a7930287..24d4968dd6cc 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -13,6 +13,7 @@ struct kmem_zone;
 
 struct xfs_attri_log_nameval {
 	struct xfs_log_iovec	name;
+	struct xfs_log_iovec	nname;
 	struct xfs_log_iovec	value;
 	refcount_t		refcount;
 
-- 
2.40.1

