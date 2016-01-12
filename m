Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BFCFE29E00
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 15:11:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B23818F8040
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:11:27 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id 91xEBIHO0Vrm1IeM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:11:26 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id EE1502089D
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:11:24 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3pg4Mc5xQGz5vNH
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:11:24 +0100 (CET)
Date: Tue, 12 Jan 2016 22:08:49 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH 6/6] Prefer stdint types over __uint*_t and __int*_t
Message-ID: <20160112210849.GG10044@nyan>
References: <cover.1452632647.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1452632647.git.felix.janda@posteo.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Felix Janda <felix.janda@posteo.de>
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
index 6054773..515d392 100644
--- a/common/hsmapi.c
+++ b/common/hsmapi.c
@@ -585,7 +585,7 @@ HsmModifyExtentMap(
 	struct getbmapx	*bmap)
 {
 	dmf_f_ctxt_t	*dmf_f_ctxtp = (dmf_f_ctxt_t *)contextp;
-	__int64_t	length;
+	int64_t	length;
 
 	if (bmap[0].bmv_entries <= 0) {
 		return 1;	/* caller must already be at EOF */
diff --git a/doc/xfsdump.html b/doc/xfsdump.html
index 9c6722e..f85128f 100644
--- a/doc/xfsdump.html
+++ b/doc/xfsdump.html
@@ -1935,7 +1935,7 @@ The files are constructed like so:
 <pre>
 typedef struct invt_counter {
     INVT_COUNTER_FIELDS
-        __uint32_t    ic_vernum;/* on disk version number for posterity */\
+        uint32_t    ic_vernum;/* on disk version number for posterity */\
         u_int         ic_curnum;/* number of sessions/invindices recorded \
                                    so far */                              \
         u_int         ic_maxnum;/* maximum number of sessions/inv_indices \
@@ -1975,7 +1975,7 @@ typedef struct invt_fstab {
 <pre>
 typedef struct invt_counter {
     INVT_COUNTER_FIELDS
-        __uint32_t    ic_vernum;/* on disk version number for posterity */\
+        uint32_t    ic_vernum;/* on disk version number for posterity */\
         u_int         ic_curnum;/* number of sessions/invindices recorded \
                                    so far */                              \
         u_int         ic_maxnum;/* maximum number of sessions/inv_indices \
@@ -2012,7 +2012,7 @@ typedef struct invt_entry {
 <pre>
 typedef struct invt_sescounter {
     INVT_COUNTER_FIELDS
-        __uint32_t    ic_vernum;/* on disk version number for posterity */\
+        uint32_t    ic_vernum;/* on disk version number for posterity */\
         u_int         ic_curnum;/* number of sessions/invindices recorded \
                                    so far */                              \
         u_int         ic_maxnum;/* maximum number of sessions/inv_indices \
@@ -2034,7 +2034,7 @@ typedef struct invt_seshdr {
     off64_t    sh_streams_off; /* offset to start of the set of
                                   stream hdrs */
     time_t     sh_time;        /* time of the dump */
-    __uint32_t sh_flag;        /* for misc flags */
+    uint32_t sh_flag;        /* for misc flags */
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
index 1690271..364ffbc 100644
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
+        uint32_t    ic_vernum;/* on disk version number for posterity */\
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
2.4.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
