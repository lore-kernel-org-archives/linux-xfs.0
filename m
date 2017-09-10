Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38064 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750788AbdIJAar (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Sep 2017 20:30:47 -0400
Received: by mail-pf0-f193.google.com with SMTP id q76so3264168pfq.5
        for <linux-xfs@vger.kernel.org>; Sat, 09 Sep 2017 17:30:47 -0700 (PDT)
From: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH 2/5] xfsdump: Use c99 defined [u]int*_t instead of double underscore integer types
Date: Sat,  9 Sep 2017 17:30:32 -0700
Message-Id: <20170910003035.14285-2-raj.khem@gmail.com>
In-Reply-To: <20170910003035.14285-1-raj.khem@gmail.com>
References: <20170910003035.14285-1-raj.khem@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>

Purely a mechanical change

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 common/content_inode.h | 4 ++--
 common/hsmapi.c        | 2 +-
 doc/xfsdump.html       | 8 ++++----
 inventory/inv_oref.h   | 2 +-
 inventory/inv_priv.h   | 4 ++--
 inventory/inventory.h  | 2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/common/content_inode.h b/common/content_inode.h
index a69a9a0..6936e05 100644
--- a/common/content_inode.h
+++ b/common/content_inode.h
@@ -191,10 +191,10 @@ typedef struct bstat bstat_t;
  * and using two 16bit values to hold new 32bit projid was choosen
  * to retain compatibility with "old" filesystems).
  */
-static inline __uint32_t
+static inline uint32_t
 bstat_projid(struct bstat *bs)
 {
-        return (__uint32_t)bs->bs_projid_hi << 16 | bs->bs_projid_lo;
+        return (uint32_t)bs->bs_projid_hi << 16 | bs->bs_projid_lo;
 }
 
 
diff --git a/common/hsmapi.c b/common/hsmapi.c
index 6054773..0709dbe 100644
--- a/common/hsmapi.c
+++ b/common/hsmapi.c
@@ -585,7 +585,7 @@ HsmModifyExtentMap(
 	struct getbmapx	*bmap)
 {
 	dmf_f_ctxt_t	*dmf_f_ctxtp = (dmf_f_ctxt_t *)contextp;
-	__int64_t	length;
+	int64_t		length;
 
 	if (bmap[0].bmv_entries <= 0) {
 		return 1;	/* caller must already be at EOF */
diff --git a/doc/xfsdump.html b/doc/xfsdump.html
index 9c6722e..8cc02d4 100644
--- a/doc/xfsdump.html
+++ b/doc/xfsdump.html
@@ -1935,7 +1935,7 @@ The files are constructed like so:
 <pre>
 typedef struct invt_counter {
     INVT_COUNTER_FIELDS
-        __uint32_t    ic_vernum;/* on disk version number for posterity */\
+        uint32_t      ic_vernum;/* on disk version number for posterity */\
         u_int         ic_curnum;/* number of sessions/invindices recorded \
                                    so far */                              \
         u_int         ic_maxnum;/* maximum number of sessions/inv_indices \
@@ -1975,7 +1975,7 @@ typedef struct invt_fstab {
 <pre>
 typedef struct invt_counter {
     INVT_COUNTER_FIELDS
-        __uint32_t    ic_vernum;/* on disk version number for posterity */\
+        uint32_t      ic_vernum;/* on disk version number for posterity */\
         u_int         ic_curnum;/* number of sessions/invindices recorded \
                                    so far */                              \
         u_int         ic_maxnum;/* maximum number of sessions/inv_indices \
@@ -2012,7 +2012,7 @@ typedef struct invt_entry {
 <pre>
 typedef struct invt_sescounter {
     INVT_COUNTER_FIELDS
-        __uint32_t    ic_vernum;/* on disk version number for posterity */\
+        uint32_t      ic_vernum;/* on disk version number for posterity */\
         u_int         ic_curnum;/* number of sessions/invindices recorded \
                                    so far */                              \
         u_int         ic_maxnum;/* maximum number of sessions/inv_indices \
@@ -2034,7 +2034,7 @@ typedef struct invt_seshdr {
     off64_t    sh_streams_off; /* offset to start of the set of
                                   stream hdrs */
     time_t     sh_time;        /* time of the dump */
-    __uint32_t sh_flag;        /* for misc flags */
+    uint32_t   sh_flag;        /* for misc flags */
     u_char     sh_level;       /* dump level */
     u_char     sh_pruned;      /* pruned by invutil flag */
     char       sh_padding[22];
diff --git a/inventory/inv_oref.h b/inventory/inv_oref.h
index e16684d..38303a4 100644
--- a/inventory/inv_oref.h
+++ b/inventory/inv_oref.h
@@ -46,7 +46,7 @@
 
 
 
-typedef __uint32_t	invt_objtype_t;
+typedef uint32_t	invt_objtype_t;
 
 #define INVT_LOCKED		0x0001
 
diff --git a/inventory/inv_priv.h b/inventory/inv_priv.h
index aa94a33..5f2256d 100644
--- a/inventory/inv_priv.h
+++ b/inventory/inv_priv.h
@@ -120,7 +120,7 @@ typedef struct invt_seshdr {
 	off64_t		sh_streams_off; /* offset to start of the set of 
 					   stream hdrs */
 	time32_t	sh_time;        /* time of the dump */
-	__uint32_t	sh_flag;        /* for misc flags */
+	uint32_t	sh_flag;        /* for misc flags */
 	u_char		sh_level;       /* dump level */
 	u_char		sh_pruned;      /* pruned by invutil flag */
 	char		sh_padding[22];
@@ -184,7 +184,7 @@ typedef struct invt_entry {
 
 /* Cheap Inheritance, and an attempt to avoid a nested type */
 #define INVT_COUNTER_FIELDS  \
-        __uint32_t    ic_vernum;/* on disk version number for posterity */\
+        uint32_t      ic_vernum;/* on disk version number for posterity */\
 	uint	      ic_curnum;/* number of sessions/invindices recorded \
 				   so far */				  \
 	uint	      ic_maxnum;/* maximum number of sessions/inv_indices \
diff --git a/inventory/inventory.h b/inventory/inventory.h
index 134b9ba..c1d7403 100644
--- a/inventory/inventory.h
+++ b/inventory/inventory.h
@@ -43,7 +43,7 @@
 /* length of labels, mntpts, etc */
 #define INV_STRLEN              GLOBAL_HDR_STRING_SZ
 
-typedef __uint32_t		inv_version_t;
+typedef uint32_t		inv_version_t;
 
 /* This is the general inventory version. 
  */
-- 
2.14.1

