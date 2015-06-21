Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4789629E11
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 04:24:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E6CB4AC004
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 02:24:26 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 0FznzADzQ84QGGxG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 02:24:24 -0700 (PDT)
Received: from smtpout2.drei.com ([109.126.64.2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z6bUG-0001zq-1i
	for xfs@oss.sgi.com; Sun, 21 Jun 2015 09:24:24 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/8] xfsprogs: remove the uchar_t typedef
Date: Sun, 21 Jun 2015 11:22:01 +0200
Message-Id: <1434878524-18176-6-git-send-email-hch@lst.de>
In-Reply-To: <1434878524-18176-1-git-send-email-hch@lst.de>
References: <1434878524-18176-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/hash.c             |  2 +-
 db/metadump.c         | 42 +++++++++++++++++++++---------------------
 include/darwin.h      |  1 -
 include/freebsd.h     |  4 ----
 include/gnukfreebsd.h |  4 ----
 include/linux.h       |  5 -----
 mkfs/proto.c          |  2 +-
 repair/attr_repair.c  |  2 +-
 8 files changed, 24 insertions(+), 38 deletions(-)

diff --git a/db/hash.c b/db/hash.c
index 02376e6..bb1b2ab 100644
--- a/db/hash.c
+++ b/db/hash.c
@@ -52,7 +52,7 @@ hash_f(
 {
 	xfs_dahash_t	hashval;
 
-	hashval = libxfs_da_hashname((uchar_t *)argv[1], (int)strlen(argv[1]));
+	hashval = libxfs_da_hashname((unsigned char *)argv[1], (int)strlen(argv[1]));
 	dbprintf("0x%x\n", hashval);
 	return 0;
 }
diff --git a/db/metadump.c b/db/metadump.c
index cca9b49..ecfe85e 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -403,7 +403,7 @@ struct name_ent {
 	struct name_ent		*next;
 	xfs_dahash_t		hash;
 	int			namelen;
-	uchar_t			name[1];
+	unsigned char		name[1];
 };
 
 #define NAME_TABLE_SIZE		4096
@@ -429,7 +429,7 @@ nametable_clear(void)
  * return a pointer to its entry, otherwise return a null pointer.
  */
 static struct name_ent *
-nametable_find(xfs_dahash_t hash, int namelen, uchar_t *name)
+nametable_find(xfs_dahash_t hash, int namelen, unsigned char *name)
 {
 	struct name_ent	*ent;
 
@@ -446,7 +446,7 @@ nametable_find(xfs_dahash_t hash, int namelen, uchar_t *name)
  * name's new entry, or a null pointer if an error occurs.
  */
 static struct name_ent *
-nametable_add(xfs_dahash_t hash, int namelen, uchar_t *name)
+nametable_add(xfs_dahash_t hash, int namelen, unsigned char *name)
 {
 	struct name_ent	*ent;
 
@@ -467,10 +467,10 @@ nametable_add(xfs_dahash_t hash, int namelen, uchar_t *name)
 #define is_invalid_char(c)	((c) == '/' || (c) == '\0')
 #define rol32(x,y)		(((x) << (y)) | ((x) >> (32 - (y))))
 
-static inline uchar_t
+static inline unsigned char
 random_filename_char(void)
 {
-	static uchar_t filename_alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
+	static unsigned char filename_alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 						"abcdefghijklmnopqrstuvwxyz"
 						"0123456789-_";
 
@@ -485,7 +485,7 @@ is_orphanage_dir(
 	struct xfs_mount	*mp,
 	xfs_ino_t		dir_ino,
 	size_t			name_len,
-	uchar_t			*name)
+	unsigned char		*name)
 {
 	return dir_ino == mp->m_sb.sb_rootino &&
 			name_len == ORPHANAGE_LEN &&
@@ -504,7 +504,7 @@ static int
 in_lost_found(
 	xfs_ino_t		ino,
 	int			namelen,
-	uchar_t			*name)
+	unsigned char		*name)
 {
 	static xfs_ino_t	orphanage_ino = 0;
 	char			s[24];	/* 21 is enough (64 bits in decimal) */
@@ -545,13 +545,13 @@ static void
 obfuscate_name(
 	xfs_dahash_t	hash,
 	size_t		name_len,
-	uchar_t		*name)
+	unsigned char	*name)
 {
-	uchar_t		*newp = name;
+	unsigned char	*newp = name;
 	int		i;
 	xfs_dahash_t	new_hash = 0;
-	uchar_t		*first;
-	uchar_t		high_bit;
+	unsigned char	*first;
+	unsigned char	high_bit;
 	int		shift;
 
 	/*
@@ -700,16 +700,16 @@ obfuscate_name(
 static int
 flip_bit(
 	size_t		name_len,
-	uchar_t		*name,
+	unsigned char	*name,
 	uint32_t	bitseq)
 {
 	int	index;
 	size_t	offset;
-	uchar_t	*p0, *p1;
-	uchar_t	m0, m1;
+	unsigned char *p0, *p1;
+	unsigned char m0, m1;
 	struct {
 	    int		byte;	/* Offset from start within name */
-	    uchar_t	bit;	/* Bit within that byte */
+	    unsigned char bit;	/* Bit within that byte */
 	} bit_to_flip[][2] = {	/* Sorted by second entry's byte */
 	    { { 0, 0 }, { 1, 7 } },	/* Each row defines a pair */
 	    { { 1, 0 }, { 2, 7 } },	/* of bytes and a bit within */
@@ -838,7 +838,7 @@ flip_bit(
 static int
 find_alternate(
 	size_t		name_len,
-	uchar_t		*name,
+	unsigned char	*name,
 	uint32_t	seq)
 {
 	uint32_t	bitseq = 0;
@@ -875,9 +875,9 @@ find_alternate(
  * are already in the table.
  */
 static int
-handle_duplicate_name(xfs_dahash_t hash, size_t name_len, uchar_t *name)
+handle_duplicate_name(xfs_dahash_t hash, size_t name_len, unsigned char *name)
 {
-	uchar_t		new_name[name_len + 1];
+	unsigned char	new_name[name_len + 1];
 	uint32_t	seq = 1;
 
 	if (!nametable_find(hash, name_len, name))
@@ -910,7 +910,7 @@ static void
 generate_obfuscated_name(
 	xfs_ino_t		ino,
 	int			namelen,
-	uchar_t			*name)
+	unsigned char		*name)
 {
 	xfs_dahash_t		hash;
 
@@ -1028,8 +1028,8 @@ obfuscate_path_components(
 	char			*buf,
 	__uint64_t		len)
 {
-	uchar_t			*comp = (uchar_t *)buf;
-	uchar_t			*end = comp + len;
+	unsigned char		*comp = (unsigned char *)buf;
+	unsigned char		*end = comp + len;
 	xfs_dahash_t		hash;
 
 	while (comp < end) {
diff --git a/include/darwin.h b/include/darwin.h
index 95f865b..ca9f8f4 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -127,7 +127,6 @@ typedef u_int32_t	xfs_dev_t;
 typedef int64_t		xfs_daddr_t;
 typedef char*		xfs_caddr_t;
 
-typedef unsigned char	uchar_t;
 #define stat64		stat
 #define fstat64		fstat
 #define lseek64		lseek
diff --git a/include/freebsd.h b/include/freebsd.h
index b51688b..d01c0c1 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -55,10 +55,6 @@ typedef __int64_t	xfs_daddr_t;
 typedef char*		xfs_caddr_t;
 typedef off_t		loff_t;
 
-#ifndef	_UCHAR_T_DEFINED
-typedef unsigned char	uchar_t;
-#define	_UCHAR_T_DEFINED	1
-#endif
 typedef enum { B_FALSE,B_TRUE }	boolean_t;
 
 #define	O_LARGEFILE	0
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index 2140acd..e92858d 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -45,10 +45,6 @@ typedef __int64_t	xfs_daddr_t;
 typedef char*		xfs_caddr_t;
 typedef off_t		loff_t;
 
-#ifndef	_UCHAR_T_DEFINED
-typedef unsigned char	uchar_t;
-#define	_UCHAR_T_DEFINED	1
-#endif
 typedef enum { B_FALSE,B_TRUE }	boolean_t;
 
 #define HAVE_FID	1
diff --git a/include/linux.h b/include/linux.h
index 5586290..da50421 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -144,11 +144,6 @@ typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
 typedef char*		xfs_caddr_t;
 
-#ifndef	_UCHAR_T_DEFINED
-typedef unsigned char	uchar_t;
-#define	_UCHAR_T_DEFINED	1
-#endif
-
 #ifndef _BOOLEAN_T_DEFINED
 typedef enum {B_FALSE, B_TRUE}	boolean_t;
 #define _BOOLEAN_T_DEFINED	1
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 45565b7..df29880 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -443,7 +443,7 @@ parseproto(
 	mode |= val;
 	creds.cr_uid = (int)getnum(pp);
 	creds.cr_gid = (int)getnum(pp);
-	xname.name = (uchar_t *)name;
+	xname.name = (unsigned char *)name;
 	xname.len = name ? strlen(name) : 0;
 	xname.type = 0;
 	tp = libxfs_trans_alloc(mp, 0);
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 8901640..772b73b 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -1121,7 +1121,7 @@ process_leaf_attr_remote(
 	if (remotep->namelen == 0 || namecheck((char *)&remotep->name[0], 
 						remotep->namelen) || 
 			be32_to_cpu(entry->hashval) != 
-				libxfs_da_hashname((uchar_t *)&remotep->name[0], 
+				libxfs_da_hashname((unsigned char *)&remotep->name[0], 
 						remotep->namelen) ||
 			be32_to_cpu(entry->hashval) < last_hashval ||
 			be32_to_cpu(remotep->valueblk) == 0) {
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
