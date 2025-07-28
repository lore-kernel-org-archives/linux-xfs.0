Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C8127CB0A
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734700; cv=none; b=O3OjMIuepyRaBaVNXfHDSNe+RZbmE9+Tu165yym9CxtVN5CGzDBxbM4HPGLCZ9l+LxwpIyIEzuAFHKU5WNdJSXGAUC52OtGTRtmWqpygccWZaotTkRhEu3j91pemG0+AT9ari2UTkLnt+tvwPit9TOGmbspbjZ9nOwla66PgIJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734700; c=relaxed/simple;
	bh=x5Nz15KXwUIsABy9dFJxBXLugqrRmEQkQIjmRIGsyMM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AzjR2EeJTnn7+4cizwUQsLnN6DMQzr35X/M0OY6UBajRy5B1hguwE13e3dAFHQGzzeJwqgSUoaMXwaE26iCbXb+yF4Q5yrgi3ZGpMPvVhBexmaYFQ/HQCMh3xzbBkJ+bZAeBTMjCI4dO0mQUYMHPobE0u8A2s19WVOvjIGfPmoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mg2n9LbN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mg2n9LbN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zG3xbYkfyqe9KTbJIkVzQy7IvrDkvNxqTUGdcuAb7ck=;
	b=Mg2n9LbN7fi0cuwXmsltSt8v+n1cnrq0P67Cb/oy16u8YhU90jDYDX5ZMxC7iUZROdSfp2
	WT8JeL+8jmHnVVTfotDo5dtYgyDaR/WODGLg33H2gEt782A2soJdTrGXOqPA/FoKykNz75
	y3jtkR0gXofjlwNrk4h944WLNqMnkgk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-VK8_aYViPCuPi7ZvnUZm5Q-1; Mon, 28 Jul 2025 16:31:36 -0400
X-MC-Unique: VK8_aYViPCuPi7ZvnUZm5Q-1
X-Mimecast-MFC-AGG-ID: VK8_aYViPCuPi7ZvnUZm5Q_1753734695
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6155b4544bfso680024a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734695; x=1754339495;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zG3xbYkfyqe9KTbJIkVzQy7IvrDkvNxqTUGdcuAb7ck=;
        b=ew5tT/yqIeL81Hf6SIdu3G4rEAK7IalnTcK7vxxgkjlVqnn+lOzm+FftATfdggpue0
         R7freZLxQXqtCK7F70hH7M/QCX3ffqBF8w8tMJUO1yf4+8oq2Y91EHiedZ+p2XcgH+Pu
         J7SP1zswb9jciTfKR248YjxpSYzWb17icLrNOmKbqhSpo+78N79IB8bNTAyropokD8TA
         QKEj8r6NusicLTRtmmamHKfVlo5pyknQXwmHzc6cVWYz4TQbkhXKzjSZqZ1S6j8ZiqzA
         LGQcb6aWNXHjkM6KgpekL0JTz727BFl1mLVYwrg2EO+SY1JO4SBx8JpdSRrUujYQYXxr
         wRHw==
X-Forwarded-Encrypted: i=1; AJvYcCUSNff55x5X/FsM0Ih8TYQC1QG721s2kkbrQCqBNoIeLjfu6Zrlq4P8K3yMIVakR7v6WFnO7TTQ0IA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsSSmcD4EnL2xELqpKwLueDWpyB2AREFzKWa2gr5AHwfd1nTp3
	T1SHeuctToVwIKzDx5K2vnwGrk0hiaj/6H380tjU07q/jfpC11+n2nYyOMuQFsqd8XW3jsrxKbU
	+CS1XInVlZU9GIlm/BQqKEMr1dJCNOJQOYltvf2qAuioHsZXcykoYGeang+/a
X-Gm-Gg: ASbGncslMQ/sNwCYz8em+2kchiK1TzyCNw6NScYHSrwicpteRtaDQVNhRmNjk/U5eZV
	Ll3WNxDf9DbjU5X0UC+FYEMigISHem5ia9Rd8sswWm9EXUVLrXd37X2pwexxaew68I3fAMy/hqE
	n39aL14DgeC8SOKM/jkTHgPdYoXngc/uIZIWgsYkhLhvkEXpOQuHN4Oxki17aUoA0bHDuxXEDDz
	U7O2FBI18XU2v/fM1bsicGxwPg/MM/0lRDVFErx4kIPNWGtU2DgcxXwJiZd1IRc92/dpcOTDMey
	cP0IXxwu/99hxGwemMH0jEpVAEXaDxEyPik0Jhp0odHleg==
X-Received: by 2002:a05:6402:358b:b0:601:dc49:a99f with SMTP id 4fb4d7f45d1cf-614f1db598cmr12917549a12.18.1753734695384;
        Mon, 28 Jul 2025 13:31:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGslpLgFD2Wk4HYPGoKY6j2Y+H5h+F7xWmB6k7wiNuq+J2qJjWUKwsn2fyKFE6+B/xOhudYrg==
X-Received: by 2002:a05:6402:358b:b0:601:dc49:a99f with SMTP id 4fb4d7f45d1cf-614f1db598cmr12917527a12.18.1753734694935;
        Mon, 28 Jul 2025 13:31:34 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:34 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:18 +0200
Subject: [PATCH RFC 14/29] xfs: add attribute type for fs-verity
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-14-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
Cc: Andrey Albershteyn <aalbersh@redhat.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3358; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=Roew8FJKORyBWKNq9tpryFTwDISUNruUQdRNGAZxZLU=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvSXjMj7tmYCRmz+O04+a3zRtsbaoi53Eu82rd6
 HHfc5Vaj3JHKQuDGBeDrJgiyzppralJRVL5Rwxq5GHmsDKBDGHg4hSAiXgtZGTY9DJQ30u/yoar
 Y80ykZmJC0RMvFb1Tfw+ey/ncsGEd39XMvx3SjnI375XeIXoRPslaT8uFzD4nZc+sollxhHOxm9
 35tfwAwAb2UWG
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

The fsverity descriptor is stored in the extended attributes of the
inode. Add new attribute type for fs-verity metadata. Add
XFS_ATTR_INTERNAL_MASK to skip parent pointer and fs-verity attributes
as those are only for internal use. While we're at it add a few comments
in relevant places that internally visible attributes are not suppose to
be handled via interface defined in xfs_xattr.c.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h  | 11 ++++++++---
 fs/xfs/libxfs/xfs_log_format.h |  1 +
 fs/xfs/xfs_trace.h             |  3 ++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 86de99e2f757..e5274be2fe9c 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -715,19 +715,23 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
 #define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
+#define	XFS_ATTR_VERITY_BIT	4	/* verity descriptor */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
 #define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
+#define XFS_ATTR_VERITY		(1u << XFS_ATTR_VERITY_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
 
 #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
-					 XFS_ATTR_PARENT)
+					 XFS_ATTR_PARENT | \
+					 XFS_ATTR_VERITY)
 
 /* Private attr namespaces not exposed to userspace */
-#define XFS_ATTR_PRIVATE_NSP_MASK	(XFS_ATTR_PARENT)
+#define XFS_ATTR_PRIVATE_NSP_MASK	(XFS_ATTR_PARENT | \
+					 XFS_ATTR_VERITY)
 
 #define XFS_ATTR_ONDISK_MASK	(XFS_ATTR_NSP_ONDISK_MASK | \
 				 XFS_ATTR_LOCAL | \
@@ -737,7 +741,8 @@ struct xfs_attr3_leafblock {
 	{ XFS_ATTR_LOCAL,	"local" }, \
 	{ XFS_ATTR_ROOT,	"root" }, \
 	{ XFS_ATTR_SECURE,	"secure" }, \
-	{ XFS_ATTR_PARENT,	"parent" }
+	{ XFS_ATTR_PARENT,	"parent" }, \
+	{ XFS_ATTR_VERITY,	"verity" }
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 0d637c276db0..57721f092c80 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -1051,6 +1051,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
 					 XFS_ATTR_PARENT | \
+					 XFS_ATTR_VERITY | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ba45d801df1c..50034c059e8c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -108,7 +108,8 @@ struct xfs_open_zone;
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
 	{ XFS_ATTR_SECURE,	"SECURE" }, \
 	{ XFS_ATTR_INCOMPLETE,	"INCOMPLETE" }, \
-	{ XFS_ATTR_PARENT,	"PARENT" }
+	{ XFS_ATTR_PARENT,	"PARENT" }, \
+	{ XFS_ATTR_VERITY,	"VERITY" }
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),

-- 
2.50.0

