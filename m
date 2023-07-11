Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BACEB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 22:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjGKWUm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 18:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjGKWUl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 18:20:41 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9E910F1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 15:20:40 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b8b2886364so42065935ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 15:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1689114040; x=1691706040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=44rbz7MNgEN+JcsExfwzMln8/mwdWivnbkjYYRFRotE=;
        b=R6JLu8wgAMoacARF4yO9d1TR6Kt2Y/NqDLjqEljJWZSWul4JGZYB5Zaml0DBXst9Vi
         Yx6dxlVF3hjny5BhbE9igHVxxgVLbwDVwcfwnG3lTSbBDYtjTZuOdfiQSHM7wa/7cHOb
         fbwB8u1iBapMt2pvof8r77C2qTg3X3dvlSKlM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689114040; x=1691706040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=44rbz7MNgEN+JcsExfwzMln8/mwdWivnbkjYYRFRotE=;
        b=d9ucsup+JpE9UoURl25yqdOGu3kPnlwLpTVhDVOdmLM8TtQ2n355dzzb0i9ilX1sGB
         4PAEXf9s3iRO9zCF+tCUTBPdulqnmlfP99zecjq7O3tdMrcvoAQCpOhNAnco0vVW086N
         gYWPhcMTxoHIDoCc2Hn5oZwaaM+aUXRalAjl36Cn5ucbmx8s9Py6LdSLG6jYIYyLHPIt
         XqSZBizZOApWgafjlCycrWAGBEpAJ+SMm+zBgRA/uOck2lwa+DOh0LGUDbJTJFRexVCs
         bGZA9a4rwTkBEqpnn0axe9aYhyg7Oa/3coxjPfuxs9Tot+RAK4ZUiVWATdhYVlZVPSQt
         UzLg==
X-Gm-Message-State: ABy/qLbBQVjXNmmaa/sf/VaJmR6ipWuKCk8AGdmPOqpZXpAI/VHSunWU
        /PCRtPlbH4QR5QwuwySLFLF8XQ==
X-Google-Smtp-Source: APBJJlGGbnS5881poIqoTCz22iftDXWejF0JWoICsW/9yfnEojT0OIlnNlC4IVY881QrmM0nVtnURw==
X-Received: by 2002:a17:902:d486:b0:1b8:28f4:f259 with SMTP id c6-20020a170902d48600b001b828f4f259mr14996805plg.69.1689114039880;
        Tue, 11 Jul 2023 15:20:39 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id z17-20020a170903019100b001b80d411e5bsm2417118plg.253.2023.07.11.15.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 15:20:39 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Jeff Layton <jlayton@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] libxfs: Redefine 1-element arrays as flexible arrays
Date:   Tue, 11 Jul 2023 15:20:28 -0700
Message-Id: <20230711222025.never.220-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5712; i=keescook@chromium.org;
 h=from:subject:message-id; bh=HAaPhkhumQsKPm56hSwQiXGxicXdzk40iP3sQ53E6UQ=;
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBkrdWsZAMypC/yfQcBQjCJtWdOsEHzmFHAPoIhk
 AuhkzwgzkeJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZK3VrAAKCRCJcvTf3G3A
 Jj4KD/9orCFhQEL8Ogj7eE+4xZCjBnSVhRXE8gyIzYf/K451uLgI5RHQxsy9Q1dQiOz52Bfpc44
 sF8OG6LWBJlPT0xMbUMI5BGVERBF3z1XM/chymmfcQhs0Iwy0cFWZpirOMMDweJ6BudDEvuU3Xm
 96pMQMvm6xLpX/9OgzDVD3hiE3n5+hmISkRzzwlhWviXGmMKQR0Gfm06PVnFKLKyYUl8fhmmcmL
 Qf/gLmd/+mYjZb/paFDUa9jR0ahkMovu0ZMiIwnRF7fQznPegSDdXseq/WJiATnBeUCYKptEvka
 4vsfgEMFOYz2rf9U3l9oBNLi8bFAvk3rlwk8XV091wCIW6J26QFTGtilgoUtOFrcWX5NU20Cspn
 cTg70gVUIVOG7dvZW9Wub/hEUtvLtDBFg/GwT1Aj9c2bPT6//yl1yDYADMxPBZEvAZofSnd/zm/
 DA/fE9NT2xKfvd+1cNb1hiqAJ5IacQh7CzyUiUCjO0DKczfkWRhzXQF8vWr+rBYoG8TGYQfN6hq
 28QmrEJaIL7oYbNN6DPxPs2c6FvIE0BLSMq9TaV+Kdg+VMNyUfUAXWwq8zLC/O7NVgR6Fi1feK5
 HG/eZNtP08KUEFEoiKDBx/lCriV1fOIZ2pxYiobi7De+UOSxAx3O3uzJUlVzu9Xhb/lRbm3fGDC
 ikaeQto 8z5vFlNg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To allow for code bases that include libxfs (e.g. the Linux kernel) and
build with strict flexible array handling (-fstrict-flex-arrays=3),
FORTIFY_SOURCE, and/or UBSAN bounds checking, redefine the remaining
1-element trailing arrays as true flexible arrays, but without changing
their structure sizes. This is done via a union to retain a single element
(named "legacy_padding"). As not all distro headers may yet have the
UAPI stddef.h __DECLARE_FLEX_ARRAY macro, include it explicitly in
platform_defs.h.in.

Addresses the warnings being seen under Linux:
https://lore.kernel.org/all/20230710170243.GF11456@frogsfrogsfrogs

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/platform_defs.h.in | 18 ++++++++++++++++++
 libxfs/xfs_da_format.h     | 38 ++++++++++++++++++++++++++++----------
 libxfs/xfs_fs.h            | 12 ++++++++++--
 3 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 315ad77cfb78..a55965ce050d 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -134,6 +134,24 @@ static inline size_t __ab_c_size(size_t a, size_t b, size_t c)
 #    define fallthrough                    do {} while (0)  /* fallthrough */
 #endif
 
+#ifndef __DECLARE_FLEX_ARRAY
+/**
+ * __DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
+ *
+ * @type: The type of each flexible array element
+ * @name: The name of the flexible array member
+ *
+ * In order to have a flexible array member in a union or alone in a
+ * struct, it needs to be wrapped in an anonymous struct with at least 1
+ * named member, but that member can be empty.
+ */
+#define __DECLARE_FLEX_ARRAY(type, name)	\
+	struct { \
+		struct { } __empty_ ## name; \
+		type name[]; \
+	}
+#endif
+
 /* Only needed for the kernel. */
 #define __init
 
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 25e2841084e1..4af92f16d5cd 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -580,18 +580,23 @@ xfs_dir2_block_leaf_p(struct xfs_dir2_block_tail *btp)
 /*
  * Entries are packed toward the top as tight as possible.
  */
+struct xfs_attr_sf_entry {
+	uint8_t namelen;	/* actual length of name (no NULL) */
+	uint8_t valuelen;	/* actual length of value (no NULL) */
+	uint8_t flags;		/* flags bits (see xfs_attr_leaf.h) */
+	uint8_t nameval[];	/* name & value bytes concatenated */
+};
+
 struct xfs_attr_shortform {
 	struct xfs_attr_sf_hdr {	/* constant-structure header block */
 		__be16	totsize;	/* total bytes in shortform list */
 		__u8	count;	/* count of active entries */
 		__u8	padding;
 	} hdr;
-	struct xfs_attr_sf_entry {
-		uint8_t namelen;	/* actual length of name (no NULL) */
-		uint8_t valuelen;	/* actual length of value (no NULL) */
-		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
-		uint8_t nameval[];	/* name & value bytes concatenated */
-	} list[1];			/* variable sized array */
+	union {
+		struct xfs_attr_sf_entry legacy_padding;
+		__DECLARE_FLEX_ARRAY(struct xfs_attr_sf_entry, list);
+	};
 };
 
 typedef struct xfs_attr_leaf_map {	/* RLE map of free bytes */
@@ -620,19 +625,29 @@ typedef struct xfs_attr_leaf_entry {	/* sorted on key, not name */
 typedef struct xfs_attr_leaf_name_local {
 	__be16	valuelen;		/* number of bytes in value */
 	__u8	namelen;		/* length of name bytes */
-	__u8	nameval[1];		/* name/value bytes */
+	union {
+		__u8	legacy_padding;
+		__DECLARE_FLEX_ARRAY(__u8, nameval);	/* name/value bytes */
+	};
 } xfs_attr_leaf_name_local_t;
 
 typedef struct xfs_attr_leaf_name_remote {
 	__be32	valueblk;		/* block number of value bytes */
 	__be32	valuelen;		/* number of bytes in value */
 	__u8	namelen;		/* length of name bytes */
-	__u8	name[1];		/* name bytes */
+	union {
+		__u8	legacy_padding;
+		__DECLARE_FLEX_ARRAY(__u8, name);	/* name bytes */
+	};
 } xfs_attr_leaf_name_remote_t;
 
 typedef struct xfs_attr_leafblock {
 	xfs_attr_leaf_hdr_t	hdr;	/* constant-structure header block */
-	xfs_attr_leaf_entry_t	entries[1];	/* sorted on key, not name */
+	union {
+		xfs_attr_leaf_entry_t	legacy_padding;
+		/* sorted on key, not name */
+		__DECLARE_FLEX_ARRAY(xfs_attr_leaf_entry_t, entries);
+	};
 	/*
 	 * The rest of the block contains the following structures after the
 	 * leaf entries, growing from the bottom up. The variables are never
@@ -664,7 +679,10 @@ struct xfs_attr3_leaf_hdr {
 
 struct xfs_attr3_leafblock {
 	struct xfs_attr3_leaf_hdr	hdr;
-	struct xfs_attr_leaf_entry	entries[1];
+	union {
+		struct xfs_attr_leaf_entry	legacy_padding;
+		__DECLARE_FLEX_ARRAY(struct xfs_attr_leaf_entry, entries);
+	};
 
 	/*
 	 * The rest of the block contains the following structures after the
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 1cfd5bc6520a..d6ec66ef0194 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -590,12 +590,20 @@ typedef struct xfs_attrlist_cursor {
 struct xfs_attrlist {
 	__s32	al_count;	/* number of entries in attrlist */
 	__s32	al_more;	/* T/F: more attrs (do call again) */
-	__s32	al_offset[1];	/* byte offsets of attrs [var-sized] */
+	union {
+		__s32	legacy_padding;
+		/* byte offsets of attrs [var-sized] */
+		__DECLARE_FLEX_ARRAY(__s32, al_offset);
+	};
 };
 
 struct xfs_attrlist_ent {	/* data from attr_list() */
 	__u32	a_valuelen;	/* number bytes in value of attr */
-	char	a_name[1];	/* attr name (NULL terminated) */
+	union {
+		char	legacy_padding;
+		/* attr name (NULL terminated) */
+		__DECLARE_FLEX_ARRAY(char, a_name);
+	};
 };
 
 typedef struct xfs_fsop_attrlist_handlereq {
-- 
2.34.1

