Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3934E3F9D5
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 17:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757213; cv=none; b=IkNbrpXOXg7JXcVuR51wMW7K/Y7KbI0V72y83pdwyohEWEaKEN3/v8ubW6baGY8TKPVg7gjc/doB6bL9H/x4qeFJCXTFdxKvZdXXo1jfolyVXGwx4FrsIOQOetAlXDNnlURRbBef2oV+xZabRtVLXkZhTnwRiGnM15gti3l/DAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757213; c=relaxed/simple;
	bh=7l53g4r9uK3eL4SXXr6ZAW/3PpM1Ss0BM47wmOGH+oU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bM/nHx/zBBoPmOKQzB8n99U9r69bz9jEhOBZlIOgYjHaBjZ7TpOEKn/BmwU/r9hM5pCvlhHFY9gy+ipuHDeRt/XgOjCGSrrWZjG2jIChKOiWoCQG5Kfn+/CaqSx9kQdEHcp8AlK6VDVXOIqHQSyp26YMtSphdcmTRLi7GoIrHPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DpopBjY8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DpopBjY8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707757211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RflzGF+DQN60/OpUvC96cyl+K5968zvCI4MfQmmPzEc=;
	b=DpopBjY8GBRMtgjKO3euGSOPFa3Pnxwyiogu/0tvJ86j3pw7iYYzF8SHOtzdEwCA+Kl70q
	VtV1t3xwJiAgGvvuWJuK3VwH7RpjXL2p104H119VbjfswEkxUNngUBH2nudkvPFb9FwzH0
	3LFDIEzlKdz4jfNiJOsHSRrBmL+eTHg=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-yXGIyriuMOmyA45S9_2tyA-1; Mon, 12 Feb 2024 12:00:07 -0500
X-MC-Unique: yXGIyriuMOmyA45S9_2tyA-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2d09cf0adc1so34923341fa.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 09:00:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757206; x=1708362006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RflzGF+DQN60/OpUvC96cyl+K5968zvCI4MfQmmPzEc=;
        b=hh++Pd+QOxP8q03yNQNWczbpIR7m7c8lisMf4MYdzuUBoC1xJ1rna29WgorzrT6KnT
         buyhWdpXcRSeUj2Jto6cnmShkPK78X2oEd2xR8RnaMfx76F6hbfK8LCMpz0Dyt0kyoPH
         mRX5bJAxpIl/0MDGRJO54uniiOtutmSaOEOQfLGN47deKXl06P/k9WN0AUpN2d3JP0O9
         Qd16sV3K5LVSZm93my0g6t4W6GMMXJX+uRhlck1qqnqztFY7cxgdKMn2fWA9/kWCBdTR
         lHEMasSC4iV0yTY3edAisCnLpOdZnKNzDvgl/ntPQ9Xxd51t4sOIHABQNPsU9Vp7cmob
         AOsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCq4oXDq4wMEDDDsFOBHnjZCp0+4wJewdMP41/0eKrdfkkfTZoZKj4fT6NDls8wL3YHXwvXJpvYA98gHXULK4KycGp1RnGIXWe
X-Gm-Message-State: AOJu0YxEQTlPCD37vLXHycTYUFA22N7ohRqFa2ZrHc+gj6HhtUt8B/aw
	Aje6D7Ep0pj8JubgzqpG5mdaPVG4P68Cdd+UZhRvaRyTLWO2BC3rq3JI2lCl9FN4hIX+yjYgaiw
	pltLiJO/G6T5kLcknPeHAmOWgB9r51Bsypm9dzfrXcHeEm3V33tSNLrqV
X-Received: by 2002:a2e:a714:0:b0:2d0:c3f8:d3b7 with SMTP id s20-20020a2ea714000000b002d0c3f8d3b7mr4320304lje.8.1707757205883;
        Mon, 12 Feb 2024 09:00:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG72MY/zWOPQ2v6XwG+yAyFluuh1CkAYjSjeHPHCrF1ln3wDLd477OAaxYVkHR1fVJIi26RWQ==
X-Received: by 2002:a2e:a714:0:b0:2d0:c3f8:d3b7 with SMTP id s20-20020a2ea714000000b002d0c3f8d3b7mr4320288lje.8.1707757205588;
        Mon, 12 Feb 2024 09:00:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUCI5xWx6JvLyWfSAJ6Q4WFI2AndwXEgkjcWOi3n7UScazaiXlJQ3F+5O3ZEeLnF3mMvZUMM0Kqk2f6Elig3wKaA0R4H3TluAWPPO6pG3SjLSFg5pBrn8aRmVycUWixqOVOv+k7yfAnsc5xBH+B9zh0oK5WbAWxOLh7Eq3i2nz9PR12zhEnwLMV2j69+GVLpDZbKGuppdns9JNzBj4DslocMxNUPuwqDyFW
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 14-20020a0564021f4e00b0056176e95a88sm2620261edz.32.2024.02.12.09.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 09:00:03 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 12/25] xfs: add XFS_DA_OP_BUFFER to make xfs_attr_get() return buffer
Date: Mon, 12 Feb 2024 17:58:09 +0100
Message-Id: <20240212165821.1901300-13-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240212165821.1901300-1-aalbersh@redhat.com>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With XBF_VERITY_SEEN flag on xfs_buf XFS can track which buffers
contain verified Merkle tree blocks. However, we also need to expose
the buffer to pass a reference of underlying page to fs-verity.

This patch adds XFS_DA_OP_BUFFER to tell xfs_attr_get() to
xfs_buf_hold() underlying buffer and return it as xfs_da_args->bp.
The caller must then xfs_buf_rele() the buffer. Therefore, XFS will
hold a reference to xfs_buf till fs-verity is verifying xfs_buf's
content.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c        |  5 ++++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |  7 +++++++
 fs/xfs/libxfs/xfs_attr_remote.c | 13 +++++++++++--
 fs/xfs/libxfs/xfs_da_btree.h    |  5 ++++-
 4 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f9846df41669..8e3138af4a5f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -252,6 +252,8 @@ xfs_attr_get_ilocked(
  * If the attribute is found, but exceeds the size limit set by the caller in
  * args->valuelen, return -ERANGE with the size of the attribute that was found
  * in args->valuelen.
+ *
+ * Using XFS_DA_OP_BUFFER the caller have to release the buffer args->bp.
  */
 int
 xfs_attr_get(
@@ -270,7 +272,8 @@ xfs_attr_get(
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 
 	/* Entirely possible to look up a name which doesn't exist */
-	args->op_flags = XFS_DA_OP_OKNOENT;
+	args->op_flags = XFS_DA_OP_OKNOENT |
+					(args->op_flags & XFS_DA_OP_BUFFER);
 
 	lock_mode = xfs_ilock_attr_map_shared(args->dp);
 	error = xfs_attr_get_ilocked(args);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 6374bf107242..51aa5d5df76c 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2449,6 +2449,13 @@ xfs_attr3_leaf_getvalue(
 		name_loc = xfs_attr3_leaf_name_local(leaf, args->index);
 		ASSERT(name_loc->namelen == args->namelen);
 		ASSERT(memcmp(args->name, name_loc->nameval, args->namelen) == 0);
+
+		/* must be released by the caller */
+		if (args->op_flags & XFS_DA_OP_BUFFER) {
+			xfs_buf_hold(bp);
+			args->bp = bp;
+		}
+
 		return xfs_attr_copy_value(args,
 					&name_loc->nameval[args->namelen],
 					be16_to_cpu(name_loc->valuelen));
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d440393b40eb..72908e0e1c86 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -424,9 +424,18 @@ xfs_attr_rmtval_get(
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,
 							&dst);
-			xfs_buf_relse(bp);
-			if (error)
+			xfs_buf_unlock(bp);
+			/* must be released by the caller */
+			if (args->op_flags & XFS_DA_OP_BUFFER)
+				args->bp = bp;
+			else
+				xfs_buf_rele(bp);
+
+			if (error) {
+				if (args->op_flags & XFS_DA_OP_BUFFER)
+					xfs_buf_rele(args->bp);
 				return error;
+			}
 
 			/* roll attribute extent map forwards */
 			lblkno += map[i].br_blockcount;
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 706baf36e175..1534f4102a47 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -59,6 +59,7 @@ typedef struct xfs_da_args {
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
+	struct xfs_buf	*bp;		/* OUT: xfs_buf which contains the attr */
 	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
 	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */
 	xfs_dahash_t	hashval;	/* hash value of name */
@@ -93,6 +94,7 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_REMOVE	(1u << 6) /* this is a remove operation */
 #define XFS_DA_OP_RECOVERY	(1u << 7) /* Log recovery operation */
 #define XFS_DA_OP_LOGGED	(1u << 8) /* Use intent items to track op */
+#define XFS_DA_OP_BUFFER	(1u << 9) /* Return underlying buffer */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -103,7 +105,8 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
 	{ XFS_DA_OP_REMOVE,	"REMOVE" }, \
 	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }, \
-	{ XFS_DA_OP_LOGGED,	"LOGGED" }
+	{ XFS_DA_OP_LOGGED,	"LOGGED" }, \
+	{ XFS_DA_OP_BUFFER,	"BUFFER" }
 
 /*
  * Storage for holding state during Btree searches and split/join ops.
-- 
2.42.0

