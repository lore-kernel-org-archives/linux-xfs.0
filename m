Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 15:58:16 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB7Nw6aG017371
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 15:58:08 -0800
Subject: [PATCH] fix compiler warnings
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
Content-Type: multipart/mixed; boundary="=-pl6DHbZIDDM10OZV7dtx"
Date: Fri, 08 Dec 2006 10:57:08 +1100
Message-Id: <1165535828.30459.42.camel@edge>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: bnaujok@sgi.com, chatz@sgi.com
Cc: xfs@oss.sgi.com

--=-pl6DHbZIDDM10OZV7dtx
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The xfsprogs userspace builds have been generating hundreds of
warnings with recent gcc versions for some time, due to the
char signedness inconsistencies we have in places.  Here's a
patch to clean that up, so we can at least see the interesting
warnings cropping up now.

cheers.

-- 
Nathan

--=-pl6DHbZIDDM10OZV7dtx
Content-Disposition: attachment; filename=fix-gcc-warnings
Content-Type: text/plain; name=fix-gcc-warnings; charset=UTF-8
Content-Transfer-Encoding: 8bit

util.c: In function 'libxfs_dir_bogus_removename':
util.c:470: warning: pointer targets in assignment differ in signedness
util.c: In function 'libxfs_dir2_bogus_removename':
util.c:531: warning: pointer targets in assignment differ in signedness

 gcc -I. -g -O2 -DNDEBUG -DVERSION=\"2.8.18\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -c xfs_dir.c  -fPIC -DPIC -o .libs/xfs_dir.o
xfs_dir.c: In function 'xfs_dir_startup':
xfs_dir.c:36: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir.c:37: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir.c: In function 'libxfs_dir_createname':
xfs_dir.c:118: warning: pointer targets in assignment differ in signedness
xfs_dir.c:120: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir.c: In function 'libxfs_dir_removename':
xfs_dir.c:180: warning: pointer targets in assignment differ in signedness
xfs_dir.c:182: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir.c: In function 'libxfs_dir_lookup':
xfs_dir.c:224: warning: pointer targets in assignment differ in signedness
xfs_dir.c:226: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir.c: In function 'libxfs_dir_replace':
xfs_dir.c:269: warning: pointer targets in assignment differ in signedness
xfs_dir.c:271: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
 gcc -I. -g -O2 -DNDEBUG -DVERSION=\"2.8.18\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -c xfs_dir_leaf.c  -fPIC -DPIC -o .libs/xfs_dir_leaf.o
xfs_dir_leaf.c: In function 'libxfs_dir_shortform_to_leaf':
xfs_dir_leaf.c:290: warning: pointer targets in assignment differ in signedness
xfs_dir_leaf.c:306: warning: pointer targets in assignment differ in signedness
xfs_dir_leaf.c:316: warning: pointer targets in assignment differ in signedness
xfs_dir_leaf.c:319: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir_leaf.c: In function 'xfs_dir_leaf_to_shortform':
xfs_dir_leaf.c:452: warning: pointer targets in assignment differ in signedness
 gcc -I. -g -O2 -DNDEBUG -DVERSION=\"2.8.18\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -c xfs_dir2.c  -fPIC -DPIC -o .libs/xfs_dir2.o
xfs_dir2.c: In function 'libxfs_dir2_createname':
xfs_dir2.c:99: warning: pointer targets in assignment differ in signedness
xfs_dir2.c:101: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2.c: In function 'libxfs_dir2_lookup':
xfs_dir2.c:150: warning: pointer targets in assignment differ in signedness
xfs_dir2.c:152: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2.c: In function 'libxfs_dir2_removename':
xfs_dir2.c:207: warning: pointer targets in assignment differ in signedness
xfs_dir2.c:209: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2.c: In function 'libxfs_dir2_replace':
xfs_dir2.c:262: warning: pointer targets in assignment differ in signedness
xfs_dir2.c:264: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
 gcc -I. -g -O2 -DNDEBUG -DVERSION=\"2.8.18\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -c xfs_attr_leaf.c  -fPIC -DPIC -o .libs/xfs_attr_leaf.o
xfs_attr_leaf.c: In function 'xfs_attr_shortform_to_leaf':
xfs_attr_leaf.c:375: warning: pointer targets in assignment differ in signedness
xfs_attr_leaf.c:377: warning: pointer targets in assignment differ in signedness
xfs_attr_leaf.c:380: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_attr_leaf.c: In function 'xfs_attr_leaf_to_shortform':
xfs_attr_leaf.c:513: warning: pointer targets in assignment differ in signedness
xfs_attr_leaf.c:515: warning: pointer targets in assignment differ in signedness
 gcc -I. -g -O2 -DNDEBUG -DVERSION=\"2.8.18\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -c xfs_dir2_block.c  -fPIC -DPIC -o .libs/xfs_dir2_block.o
xfs_dir2_block.c: In function 'libxfs_dir2_sf_to_block':
xfs_dir2_block.c:1049: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2_block.c:1049: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2_block.c:1049: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2_block.c:1049: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2_block.c:1049: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2_block.c:1049: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2_block.c:1049: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2_block.c:1049: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2_block.c:1049: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2_block.c:1049: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2_block.c:1049: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2_block.c:1049: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
xfs_dir2_block.c:1049: warning: pointer targets in passing argument 1 of 'libxfs_da_hashname' differ in signedness
 gcc -I. -g -O2 -DNDEBUG -DVERSION=\"2.8.18\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -c xfs_attr.c  -fPIC -DPIC -o .libs/xfs_attr.o
xfs_attr.c: In function 'libxfs_attr_set_int':
xfs_attr.c:106: warning: pointer targets in assignment differ in signedness
xfs_attr.c:108: warning: pointer targets in assignment differ in signedness
xfs_attr.c: In function 'libxfs_attr_remove_int':
xfs_attr.c:316: warning: pointer targets in assignment differ in signedness
xfs_attr.c: In function 'xfs_attr_rmtval_set':
xfs_attr.c:1292: warning: pointer targets in assignment differ in signedness
 gcc -g -O2 -DNDEBUG -DVERSION=\"2.8.18\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -c fstype.c  -fPIC -DPIC -o .libs/fstype.o
fstype.c: In function 'is_reiserfs_magic_string':
fstype.c:158: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:158: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:158: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:158: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:158: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:158: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:158: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:158: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness
fstype.c:160: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:160: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:160: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:160: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:160: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:160: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:160: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:160: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness
fstype.c: In function 'fstype':
fstype.c:222: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:222: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:222: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:222: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:222: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:222: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:222: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:222: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness
fstype.c:228: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:228: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:228: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:228: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:228: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:228: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:228: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:228: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness
fstype.c:234: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:234: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:234: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:234: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:234: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:234: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:234: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:234: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness
fstype.c:235: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:235: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:235: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:235: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:235: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:235: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:235: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:235: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness
fstype.c:236: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:236: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:236: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:236: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:236: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:236: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:236: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:236: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness
fstype.c:237: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:237: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:237: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:237: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:237: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:237: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:237: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:237: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness
fstype.c:238: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:238: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:238: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:238: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:238: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:238: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:238: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:238: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness
fstype.c:241: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:241: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:241: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:241: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:241: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:241: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:241: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:241: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness
fstype.c:242: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:242: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:242: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:242: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:242: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:242: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:242: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:242: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness
fstype.c:243: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:243: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:243: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:243: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:243: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:243: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:243: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:243: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness
fstype.c:244: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:244: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:244: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:244: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
fstype.c:244: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:244: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:244: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
fstype.c:244: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness

gcc  -g -O2 -DNDEBUG -DVERSION=\"2.8.18\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall  -DENABLE_READLINE   -c -o check.o check.c
check.c: In function ‘process_data_dir_v2’:
check.c:2302: warning: pointer targets in passing argument 1 of ‘libxfs_da_hashname’ differ in signedness

gcc  -g -O2 -DNDEBUG -DVERSION=\"2.8.18\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall  -DENABLE_READLINE   -c -o hash.o hash.c
hash.c: In function ‘hash_f’:
hash.c:55: warning: pointer targets in passing argument 1 of ‘libxfs_da_hashname’ differ in signedness

phase6.c: In function ‘dir_bogus_removename’:
phase6.c:391: warning: pointer targets in passing argument 3 of ‘libxfs_dir2_bogus_removename’ differ in signedness
phase6.c:394: warning: pointer targets in passing argument 3 of ‘libxfs_dir_bogus_removename’ differ in signedness
phase6.c: At top level:
phase6.c:375: warning: ‘dir_removename’ defined but not used
Index: xfsprogs/libxfs/util.c
===================================================================
--- xfsprogs.orig/libxfs/util.c	2006-12-08 09:25:43.471005750 +1100
+++ xfsprogs/libxfs/util.c	2006-12-08 09:26:31.165986500 +1100
@@ -452,7 +452,7 @@ libxfs_bmap_next_offset(
  * This was originally in the kernel, but only used in xfs_repair.
  */
 int
-xfs_dir_bogus_removename(xfs_trans_t *trans, xfs_inode_t *dp, char *name,
+xfs_dir_bogus_removename(xfs_trans_t *trans, xfs_inode_t *dp, uchar_t *name,
 		xfs_fsblock_t *firstblock, xfs_bmap_free_t *flist,
 		xfs_extlen_t total, xfs_dahash_t hashval, int namelen)
 {
@@ -510,7 +510,7 @@ int
 xfs_dir2_bogus_removename(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_inode_t	*dp,		/* incore directory inode */
-	char		*name,		/* name of entry to remove */
+	uchar_t		*name,		/* name of entry to remove */
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
 	xfs_bmap_free_t *flist,		/* bmap's freeblock list */
 	xfs_extlen_t	total,		/* bmap's total block count */
Index: xfsprogs/include/libxfs.h
===================================================================
--- xfsprogs.orig/include/libxfs.h	2006-12-08 09:25:43.547010500 +1100
+++ xfsprogs/include/libxfs.h	2006-12-08 09:26:31.165986500 +1100
@@ -429,33 +429,33 @@ extern void	libxfs_dir_mount (xfs_mount_
 extern void	libxfs_dir2_mount (xfs_mount_t *);
 extern int	libxfs_dir_init (xfs_trans_t *, xfs_inode_t *, xfs_inode_t *);
 extern int	libxfs_dir2_init (xfs_trans_t *, xfs_inode_t *, xfs_inode_t *);
-extern int	libxfs_dir_createname (xfs_trans_t *, xfs_inode_t *, char *,
+extern int	libxfs_dir_createname (xfs_trans_t *, xfs_inode_t *, uchar_t *,
 				int, xfs_ino_t, xfs_fsblock_t *,
 				xfs_bmap_free_t *, xfs_extlen_t);
-extern int	libxfs_dir2_createname (xfs_trans_t *, xfs_inode_t *, char *,
+extern int	libxfs_dir2_createname (xfs_trans_t *, xfs_inode_t *, uchar_t *,
 				int, xfs_ino_t, xfs_fsblock_t *,
 				xfs_bmap_free_t *, xfs_extlen_t);
 extern int	libxfs_dir_lookup (xfs_trans_t *, xfs_inode_t *,
-				char *, int, xfs_ino_t *);
+				uchar_t *, int, xfs_ino_t *);
 extern int	libxfs_dir2_lookup (xfs_trans_t *, xfs_inode_t *,
-				char *, int, xfs_ino_t *);
+				uchar_t *, int, xfs_ino_t *);
 extern int	libxfs_dir_replace (xfs_trans_t *, xfs_inode_t *,
-				char *, int, xfs_ino_t, xfs_fsblock_t *,
+				uchar_t *, int, xfs_ino_t, xfs_fsblock_t *,
 				xfs_bmap_free_t *, xfs_extlen_t);
 extern int	libxfs_dir2_replace (xfs_trans_t *, xfs_inode_t *,
-				char *, int, xfs_ino_t, xfs_fsblock_t *,
+				uchar_t *, int, xfs_ino_t, xfs_fsblock_t *,
 				xfs_bmap_free_t *, xfs_extlen_t);
 extern int	libxfs_dir_removename (xfs_trans_t *, xfs_inode_t *,
-				char *, int, xfs_ino_t, xfs_fsblock_t *,
+				uchar_t *, int, xfs_ino_t, xfs_fsblock_t *,
 				xfs_bmap_free_t *, xfs_extlen_t);
 extern int	libxfs_dir2_removename (xfs_trans_t *, xfs_inode_t *,
-				char *, int, xfs_ino_t, xfs_fsblock_t *,
+				uchar_t *, int, xfs_ino_t, xfs_fsblock_t *,
 				xfs_bmap_free_t *, xfs_extlen_t);
 extern int	libxfs_dir_bogus_removename (xfs_trans_t *, xfs_inode_t *,
-				char *, xfs_fsblock_t *, xfs_bmap_free_t *,
+				uchar_t *, xfs_fsblock_t *, xfs_bmap_free_t *,
 				xfs_extlen_t, xfs_dahash_t, int);
 extern int	libxfs_dir2_bogus_removename (xfs_trans_t *, xfs_inode_t *,
-				char *, xfs_fsblock_t *, xfs_bmap_free_t *,
+				uchar_t *, xfs_fsblock_t *, xfs_bmap_free_t *,
 				xfs_extlen_t, xfs_dahash_t, int);
 
 
Index: xfsprogs/libxfs/xfs_dir.c
===================================================================
--- xfsprogs.orig/libxfs/xfs_dir.c	2006-12-08 09:25:43.479006250 +1100
+++ xfsprogs/libxfs/xfs_dir.c	2006-12-08 09:26:31.165986500 +1100
@@ -33,8 +33,8 @@ xfs_dahash_t	xfs_dir_hash_dot, xfs_dir_h
 void
 xfs_dir_startup(void)
 {
-	xfs_dir_hash_dot = xfs_da_hashname(".", 1);
-	xfs_dir_hash_dotdot = xfs_da_hashname("..", 2);
+	xfs_dir_hash_dot = xfs_da_hashname((const uchar_t *) ".", 1);
+	xfs_dir_hash_dotdot = xfs_da_hashname((const uchar_t *) "..", 2);
 }
 
 /*
@@ -99,7 +99,7 @@ xfs_dir_init(xfs_trans_t *trans, xfs_ino
  * Transitions directory from shortform to Btree as necessary.
  */
 STATIC int						/* error */
-xfs_dir_createname(xfs_trans_t *trans, xfs_inode_t *dp, char *name,
+xfs_dir_createname(xfs_trans_t *trans, xfs_inode_t *dp, uchar_t *name,
 		   int namelen, xfs_ino_t inum, xfs_fsblock_t *firstblock,
 		   xfs_bmap_free_t *flist, xfs_extlen_t total)
 {
@@ -165,7 +165,7 @@ xfs_dir_createname(xfs_trans_t *trans, x
  * Transitions directory from Btree to shortform as necessary.
  */
 STATIC int							/* error */
-xfs_dir_removename(xfs_trans_t *trans, xfs_inode_t *dp, char *name,
+xfs_dir_removename(xfs_trans_t *trans, xfs_inode_t *dp, uchar_t *name,
 		   int namelen, xfs_ino_t ino, xfs_fsblock_t *firstblock,
 		   xfs_bmap_free_t *flist, xfs_extlen_t total)
 {
@@ -209,7 +209,7 @@ xfs_dir_removename(xfs_trans_t *trans, x
 }
 
 STATIC int							/* error */
-xfs_dir_lookup(xfs_trans_t *trans, xfs_inode_t *dp, char *name, int namelen,
+xfs_dir_lookup(xfs_trans_t *trans, xfs_inode_t *dp, uchar_t *name, int namelen,
 				   xfs_ino_t *inum)
 {
 	xfs_da_args_t args;
@@ -251,7 +251,7 @@ xfs_dir_lookup(xfs_trans_t *trans, xfs_i
 }
 
 STATIC int							/* error */
-xfs_dir_replace(xfs_trans_t *trans, xfs_inode_t *dp, char *name, int namelen,
+xfs_dir_replace(xfs_trans_t *trans, xfs_inode_t *dp, uchar_t *name, int namelen,
 				    xfs_ino_t inum, xfs_fsblock_t *firstblock,
 				    xfs_bmap_free_t *flist, xfs_extlen_t total)
 {
Index: xfsprogs/libxfs/xfs_dir2.c
===================================================================
--- xfsprogs.orig/libxfs/xfs_dir2.c	2006-12-08 09:25:43.527009250 +1100
+++ xfsprogs/libxfs/xfs_dir2.c	2006-12-08 09:26:31.165986500 +1100
@@ -77,7 +77,7 @@ STATIC int					/* error */
 xfs_dir2_createname(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*dp,		/* incore directory inode */
-	char			*name,		/* new entry name */
+	uchar_t			*name,		/* new entry name */
 	int			namelen,	/* new entry name length */
 	xfs_ino_t		inum,		/* new entry inode number */
 	xfs_fsblock_t		*first,		/* bmap's firstblock */
@@ -133,7 +133,7 @@ STATIC int				/* error */
 xfs_dir2_lookup(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_inode_t	*dp,		/* incore directory inode */
-	char		*name,		/* lookup name */
+	uchar_t		*name,		/* lookup name */
 	int		namelen,	/* lookup name length */
 	xfs_ino_t	*inum)		/* out: inode number */
 {
@@ -188,7 +188,7 @@ STATIC int				/* error */
 xfs_dir2_removename(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_inode_t	*dp,		/* incore directory inode */
-	char		*name,		/* name of entry to remove */
+	uchar_t		*name,		/* name of entry to remove */
 	int		namelen,	/* name length of entry to remove */
 	xfs_ino_t	ino,		/* inode number of entry to remove */
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
@@ -240,7 +240,7 @@ STATIC int				/* error */
 xfs_dir2_replace(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_inode_t	*dp,		/* incore directory inode */
-	char		*name,		/* name of entry to replace */
+	uchar_t		*name,		/* name of entry to replace */
 	int		namelen,	/* name length of entry to replace */
 	xfs_ino_t	inum,		/* new inode number */
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
Index: xfsprogs/libxfs/xfs_dir_leaf.c
===================================================================
--- xfsprogs.orig/libxfs/xfs_dir_leaf.c	2006-12-08 09:25:43.503007750 +1100
+++ xfsprogs/libxfs/xfs_dir_leaf.c	2006-12-08 09:26:31.165986500 +1100
@@ -287,7 +287,7 @@ xfs_dir_shortform_to_leaf(xfs_da_args_t 
 		goto out;
 	xfs_da_buf_done(bp);
 
-	args.name = ".";
+	args.name = (const uchar_t *) ".";
 	args.namelen = 1;
 	args.hashval = xfs_dir_hash_dot;
 	args.inumber = dp->i_ino;
@@ -303,7 +303,7 @@ xfs_dir_shortform_to_leaf(xfs_da_args_t 
 	if (retval)
 		goto out;
 
-	args.name = "..";
+	args.name = (const uchar_t *) "..";
 	args.namelen = 2;
 	args.hashval = xfs_dir_hash_dotdot;
 	args.inumber = inumber;
@@ -313,9 +313,9 @@ xfs_dir_shortform_to_leaf(xfs_da_args_t 
 
 	sfe = &sf->list[0];
 	for (i = 0; i < INT_GET(sf->hdr.count, ARCH_CONVERT); i++) {
-		args.name = (char *)(sfe->name);
+		args.name = (const uchar_t *)(sfe->name);
 		args.namelen = sfe->namelen;
-		args.hashval = xfs_da_hashname((char *)(sfe->name),
+		args.hashval = xfs_da_hashname((const uchar_t *)(sfe->name),
 					       sfe->namelen);
 		XFS_DIR_SF_GET_DIRINO(&sfe->inumber, &args.inumber);
 		retval = xfs_dir_leaf_addname(&args);
@@ -449,7 +449,7 @@ xfs_dir_leaf_to_shortform(xfs_da_args_t 
 		if (!entry->nameidx)
 			continue;
 		namest = XFS_DIR_LEAF_NAMESTRUCT(leaf, INT_GET(entry->nameidx, ARCH_CONVERT));
-		args.name = (char *)(namest->name);
+		args.name = (const uchar_t *)(namest->name);
 		args.namelen = entry->namelen;
 		args.hashval = INT_GET(entry->hashval, ARCH_CONVERT);
 		XFS_DIR_SF_GET_DIRINO(&namest->inumber, &args.inumber);
Index: xfsprogs/libxfs/xfs_attr_leaf.c
===================================================================
--- xfsprogs.orig/libxfs/xfs_attr_leaf.c	2006-12-08 09:25:43.539010000 +1100
+++ xfsprogs/libxfs/xfs_attr_leaf.c	2006-12-08 09:26:31.169986750 +1100
@@ -372,11 +372,11 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t
 
 	sfe = &sf->list[0];
 	for (i = 0; i < INT_GET(sf->hdr.count, ARCH_CONVERT); i++) {
-		nargs.name = (char *)sfe->nameval;
+		nargs.name = (const uchar_t *)sfe->nameval;
 		nargs.namelen = sfe->namelen;
-		nargs.value = (char *)&sfe->nameval[nargs.namelen];
+		nargs.value = (uchar_t *)&sfe->nameval[nargs.namelen];
 		nargs.valuelen = INT_GET(sfe->valuelen, ARCH_CONVERT);
-		nargs.hashval = xfs_da_hashname((char *)sfe->nameval,
+		nargs.hashval = xfs_da_hashname((const uchar_t *)sfe->nameval,
 						sfe->namelen);
 		nargs.flags = (sfe->flags & XFS_ATTR_SECURE) ? ATTR_SECURE :
 				((sfe->flags & XFS_ATTR_ROOT) ? ATTR_ROOT : 0);
@@ -510,9 +510,9 @@ xfs_attr_leaf_to_shortform(xfs_dabuf_t *
 			continue;
 		ASSERT(entry->flags & XFS_ATTR_LOCAL);
 		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, i);
-		nargs.name = (char *)name_loc->nameval;
+		nargs.name = (const uchar_t *)name_loc->nameval;
 		nargs.namelen = name_loc->namelen;
-		nargs.value = (char *)&name_loc->nameval[nargs.namelen];
+		nargs.value = (uchar_t *)&name_loc->nameval[nargs.namelen];
 		nargs.valuelen = INT_GET(name_loc->valuelen, ARCH_CONVERT);
 		nargs.hashval = INT_GET(entry->hashval, ARCH_CONVERT);
 		nargs.flags = (entry->flags & XFS_ATTR_SECURE) ? ATTR_SECURE :
Index: xfsprogs/libxfs/xfs_attr.c
===================================================================
--- xfsprogs.orig/libxfs/xfs_attr.c	2006-12-08 09:27:45.790650250 +1100
+++ xfsprogs/libxfs/xfs_attr.c	2006-12-08 09:30:15.307994500 +1100
@@ -103,9 +103,9 @@ xfs_attr_set_int(xfs_inode_t *dp, const 
 	 * Fill in the arg structure for this request.
 	 */
 	memset((char *)&args, 0, sizeof(args));
-	args.name = name;
+	args.name = (const uchar_t *)name;
 	args.namelen = namelen;
-	args.value = value;
+	args.value = (uchar_t *)value;
 	args.valuelen = valuelen;
 	args.flags = flags;
 	args.hashval = xfs_da_hashname(args.name, args.namelen);
@@ -313,7 +313,7 @@ xfs_attr_remove_int(xfs_inode_t *dp, con
 	 * Fill in the arg structure for this request.
 	 */
 	memset((char *)&args, 0, sizeof(args));
-	args.name = name;
+	args.name = (const uchar_t *)name;
 	args.namelen = namelen;
 	args.flags = flags;
 	args.hashval = xfs_da_hashname(args.name, args.namelen);
@@ -1289,7 +1289,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 
 	dp = args->dp;
 	mp = dp->i_mount;
-	src = args->value;
+	src = (xfs_caddr_t)args->value;
 
 	/*
 	 * Find a "hole" in the attribute address space large enough for
Index: xfsprogs/libxfs/xfs_dir2_block.c
===================================================================
--- xfsprogs.orig/libxfs/xfs_dir2_block.c	2006-12-08 09:26:53.483381250 +1100
+++ xfsprogs/libxfs/xfs_dir2_block.c	2006-12-08 09:27:10.736459500 +1100
@@ -1046,7 +1046,7 @@ xfs_dir2_sf_to_block(
 		tagp = XFS_DIR2_DATA_ENTRY_TAG_P(dep);
 		INT_SET(*tagp, ARCH_CONVERT, (xfs_dir2_data_off_t)((char *)dep - (char *)block));
 		xfs_dir2_data_log_entry(tp, bp, dep);
-		INT_SET(blp[2 + i].hashval, ARCH_CONVERT, xfs_da_hashname((char *)sfep->name, sfep->namelen));
+		INT_SET(blp[2 + i].hashval, ARCH_CONVERT, xfs_da_hashname((const uchar_t *)sfep->name, sfep->namelen));
 		INT_SET(blp[2 + i].address, ARCH_CONVERT, XFS_DIR2_BYTE_TO_DATAPTR(mp,
 						 (char *)dep - (char *)block));
 		offset = (int)((char *)(tagp + 1) - (char *)block);
Index: xfsprogs/libdisk/fstype.c
===================================================================
--- xfsprogs.orig/libdisk/fstype.c	2006-12-08 09:50:20.955342750 +1100
+++ xfsprogs/libdisk/fstype.c	2006-12-08 09:50:27.711765000 +1100
@@ -141,11 +141,11 @@ may_be_swap(const char *s) {
 
 /* rather weak necessary condition */
 static int
-may_be_adfs(const u_char *s) {
-	u_char *p;
+may_be_adfs(const char *s) {
+	char *p;
 	int sum;
 
-	p = (u_char *) s + 511;
+	p = (char *) s + 511;
 	sum = 0;
 	while(--p != s)
 		sum = (sum >> 8) + (sum & 0xff) + *p;
@@ -301,7 +301,7 @@ fstype(const char *device) {
              goto io_error;
 
 	/* only a weak test */
-        if (may_be_adfs((u_char *) &adfssb)
+        if (may_be_adfs((char *) &adfssb)
             && (adfsblksize(adfssb) >= 8 &&
                 adfsblksize(adfssb) <= 10))
              type = "adfs";
Index: xfsprogs/libdisk/fstype.h
===================================================================
--- xfsprogs.orig/libdisk/fstype.h	2006-12-08 09:49:45.061099500 +1100
+++ xfsprogs/libdisk/fstype.h	2006-12-08 09:51:00.657824000 +1100
@@ -38,8 +38,8 @@
 #define MINIX2_SUPER_MAGIC  0x2468	   /* minix v2, 14 char names */
 #define MINIX2_SUPER_MAGIC2 0x2478         /* minix v2, 30 char names */
 struct minix_super_block {
-	u_char   s_dummy[16];
-	u_char   s_magic[2];
+	char   s_dummy[16];
+	char   s_magic[2];
 };
 #define minixmagic(s)	assemble2le(s.s_magic)
 
@@ -63,8 +63,8 @@ struct  hs_volume_descriptor {
 
 #define EXT_SUPER_MAGIC 0x137D
 struct ext_super_block {
-	u_char   s_dummy[56];
-	u_char   s_magic[2];
+	char   s_dummy[56];
+	char   s_magic[2];
 };
 #define extmagic(s)	assemble2le(s.s_magic)
 
@@ -72,37 +72,37 @@ struct ext_super_block {
 #define EXT2_SUPER_MAGIC    0xEF53
 #define EXT3_FEATURE_COMPAT_HAS_JOURNAL 0x0004
 struct ext2_super_block {
-	u_char 	s_dummy1[56];
-	u_char 	s_magic[2];
-	u_char	s_dummy2[34];
-	u_char	s_feature_compat[4];
-	u_char	s_feature_incompat[4];
-	u_char	s_feature_ro_compat[4];
-	u_char	s_uuid[16];
-	u_char 	s_volume_name[16];
-	u_char	s_dummy3[88];
-	u_char	s_journal_inum[4];	/* ext3 only */
+	char 	s_dummy1[56];
+	char 	s_magic[2];
+	char	s_dummy2[34];
+	char	s_feature_compat[4];
+	char	s_feature_incompat[4];
+	char	s_feature_ro_compat[4];
+	char	s_uuid[16];
+	char 	s_volume_name[16];
+	char	s_dummy3[88];
+	char	s_journal_inum[4];	/* ext3 only */
 };
 #define ext2magic(s)	assemble2le(s.s_magic)
 
 struct reiserfs_super_block
 {
-	u_char		s_block_count[4];
-	u_char		s_free_blocks[4];
-	u_char		s_root_block[4];
-	u_char		s_journal_block[4];
-	u_char		s_journal_dev[4];
-	u_char		s_orig_journal_size[4];
-	u_char		s_journal_trans_max[4];
-	u_char		s_journal_block_count[4];
-	u_char		s_journal_max_batch[4];
-	u_char		s_journal_max_commit_age[4];
-	u_char		s_journal_max_trans_age[4];
-	u_char		s_blocksize[2];
-	u_char		s_oid_maxsize[2];
-	u_char		s_oid_cursize[2];
-	u_char		s_state[2];
-	u_char		s_magic[12];
+	char		s_block_count[4];
+	char		s_free_blocks[4];
+	char		s_root_block[4];
+	char		s_journal_block[4];
+	char		s_journal_dev[4];
+	char		s_orig_journal_size[4];
+	char		s_journal_trans_max[4];
+	char		s_journal_block_count[4];
+	char		s_journal_max_batch[4];
+	char		s_journal_max_commit_age[4];
+	char		s_journal_max_trans_age[4];
+	char		s_blocksize[2];
+	char		s_oid_maxsize[2];
+	char		s_oid_cursize[2];
+	char		s_state[2];
+	char		s_magic[12];
 };
 #define REISERFS_SUPER_MAGIC_STRING "ReIsErFs"
 #define REISER2FS_SUPER_MAGIC_STRING "ReIsEr2Fs"
@@ -112,9 +112,9 @@ struct reiserfs_super_block
 
 #define _XIAFS_SUPER_MAGIC 0x012FD16D
 struct xiafs_super_block {
-    u_char     s_boot_segment[512];     /*  1st sector reserved for boot */
-    u_char     s_dummy[60];
-    u_char     s_magic[4];
+    char     s_boot_segment[512];     /*  1st sector reserved for boot */
+    char     s_dummy[60];
+    char     s_magic[4];
 };
 #define xiafsmagic(s)	assemble4le(s.s_magic)
 
@@ -122,16 +122,16 @@ struct xiafs_super_block {
 #define UFS_SUPER_MAGIC_LE 0x00011954
 #define UFS_SUPER_MAGIC_BE 0x54190100
 struct ufs_super_block {
-    u_char     s_dummy[0x55c];
-    u_char     s_magic[4];
+    char     s_dummy[0x55c];
+    char     s_magic[4];
 };
 #define ufsmagic(s)	assemble4le(s.s_magic)
 
 /* From Richard.Russon@ait.co.uk Wed Feb 24 08:05:27 1999 */
 #define NTFS_SUPER_MAGIC "NTFS"
 struct ntfs_super_block {
-    u_char    s_dummy[3];
-    u_char    s_magic[4];
+    char    s_dummy[3];
+    char    s_magic[4];
 };
 
 /* From inspection of a few FAT filesystems - aeb */
@@ -139,33 +139,33 @@ struct ntfs_super_block {
    it looks like a primary has some directory entries where the extended
    has a partition table: IO.SYS, MSDOS.SYS, WINBOOT.SYS */
 struct fat_super_block {
-    u_char    s_dummy[3];
-    u_char    s_os[8];		/* "MSDOS5.0" or "MSWIN4.0" or "MSWIN4.1" */
+    char    s_dummy[3];
+    char    s_os[8];		/* "MSDOS5.0" or "MSWIN4.0" or "MSWIN4.1" */
 				/* mtools-3.9.4 writes "MTOOL394" */
-    u_char    s_dummy2[32];
-    u_char    s_label[11];	/* for DOS? */
-    u_char    s_fs[8];		/* "FAT12   " or "FAT16   " or all zero   */
+    char    s_dummy2[32];
+    char    s_label[11];	/* for DOS? */
+    char    s_fs[8];		/* "FAT12   " or "FAT16   " or all zero   */
                                 /* OS/2 BM has "FAT     " here. */
-    u_char    s_dummy3[9];
-    u_char    s_label2[11];	/* for Windows? */
-    u_char    s_fs2[8];	        /* garbage or "FAT32   " */
+    char    s_dummy3[9];
+    char    s_label2[11];	/* for Windows? */
+    char    s_fs2[8];	        /* garbage or "FAT32   " */
 };
 
 #define XFS_SUPER_MAGIC "XFSB"
 struct xfs_super_block {
-    u_char    s_magic[4];
-    u_char    s_dummy[28];
-    u_char    s_uuid[16];
-    u_char    s_dummy2[60];
-    u_char    s_fname[12];
+    char    s_magic[4];
+    char    s_dummy[28];
+    char    s_uuid[16];
+    char    s_dummy2[60];
+    char    s_fname[12];
 };
 
 #define CRAMFS_SUPER_MAGIC 0x28cd3d45
 #define CRAMFS_SUPER_MAGIC_BE 0x453dcd28
 struct cramfs_super_block {
-	u_char    s_magic[4];
-	u_char    s_dummy[12];
-	u_char    s_id[16];
+	char    s_magic[4];
+	char    s_dummy[12];
+	char    s_id[16];
 };
 #define cramfsmagic(s)	assemble4le(s.s_magic)
 
@@ -173,81 +173,81 @@ struct cramfs_super_block {
 #define HFSPLUS_SUPER_MAGIC 0x482B
 #define HFSPLUS_SUPER_VERSION 0x004
 struct hfs_super_block {
-	u_char    s_magic[2];
-	u_char    s_version[2];
+	char    s_magic[2];
+	char    s_version[2];
 };
 #define hfsmagic(s)	assemble2le(s.s_magic)
 #define hfsversion(s)	assemble2le(s.s_version)
 
 #define HPFS_SUPER_MAGIC 0xf995e849
 struct hpfs_super_block {
-	u_char    s_magic[4];
-	u_char    s_magic2[4];
+	char    s_magic[4];
+	char    s_magic2[4];
 };
 #define hpfsmagic(s)	assemble4le(s.s_magic)
 
 struct adfs_super_block {
-	u_char    s_dummy[448];
-	u_char    s_blksize[1];
-	u_char    s_dummy2[62];
-	u_char    s_checksum[1];
+	char    s_dummy[448];
+	char    s_blksize[1];
+	char    s_dummy2[62];
+	char    s_checksum[1];
 };
 #define adfsblksize(s)	((uint) s.s_blksize[0])
 
 /* found in first 4 bytes of block 1 */
 struct vxfs_super_block {
-	u_char	s_magic[4];
+	char	s_magic[4];
 };
 #define vxfsmagic(s)	assemble4le(s.s_magic)
 #define VXFS_SUPER_MAGIC 0xa501FCF5
 
 struct jfs_super_block {
 	char	s_magic[4];
-	u_char	s_version[4];
-	u_char	s_dummy1[93];
+	char	s_version[4];
+	char	s_dummy1[93];
 	char	s_fpack[11];
-	u_char	s_dummy2[24];
-	u_char	s_uuid[16];
+	char	s_dummy2[24];
+	char	s_uuid[16];
 	char	s_label[16];
 };
 #define JFS_SUPER1_OFF 0x8000
 #define JFS_MAGIC "JFS1"
 
 struct sysv_super_block {
-	u_char  s_dummy1[504];
-	u_char  s_magic[4];
-	u_char  type[4];
+	char  s_dummy1[504];
+	char  s_magic[4];
+	char  type[4];
 };
 #define sysvmagic(s)		assemble4le(s.s_magic)
 #define SYSV_SUPER_MAGIC	0xfd187e20
 
 struct mdp_super_block {
-	u_char	md_magic[4];
+	char	md_magic[4];
 };
 #define MD_SB_MAGIC	0xa92b4efc
 #define mdsbmagic(s)	assemble4le(s.md_magic)
 
 struct ocfs_volume_header {
-	u_char  minor_version[4];
-	u_char  major_version[4];
-	u_char  signature[128];
+	char  minor_version[4];
+	char  major_version[4];
+	char  signature[128];
 };
 
 struct ocfs_volume_label {
-	u_char  disk_lock[48];
-	u_char  label[64];
-	u_char  label_len[2];
+	char  disk_lock[48];
+	char  label[64];
+	char  label_len[2];
 };
 
 #define ocfslabellen(o)	assemble2le(o.label_len)
 #define OCFS_MAGIC	"OracleCFS"
 
 static inline int
-assemble2le(unsigned char *p) {
+assemble2le(char *p) {
 	return (p[0] | (p[1] << 8));
 }
 
 static inline int
-assemble4le(unsigned char *p) {
+assemble4le(char *p) {
 	return (p[0] | (p[1] << 8) | (p[2] << 16) | (p[3] << 24));
 }
Index: xfsprogs/db/check.c
===================================================================
--- xfsprogs.orig/db/check.c	2006-12-08 09:55:43.307488500 +1100
+++ xfsprogs/db/check.c	2006-12-08 09:55:51.732015000 +1100
@@ -2299,7 +2299,7 @@ process_data_dir_v2(
 		tag_err += INT_GET(*tagp, ARCH_CONVERT) != (char *)dep - (char *)data;
 		addr = XFS_DIR2_DB_OFF_TO_DATAPTR(mp, db,
 			(char *)dep - (char *)data);
-		hash = libxfs_da_hashname((char *)dep->name, dep->namelen);
+		hash = libxfs_da_hashname((uchar_t *)dep->name, dep->namelen);
 		dir_hash_add(hash, addr);
 		ptr += XFS_DIR2_DATA_ENTSIZE(dep->namelen);
 		count++;
Index: xfsprogs/db/hash.c
===================================================================
--- xfsprogs.orig/db/hash.c	2006-12-08 09:56:12.929339750 +1100
+++ xfsprogs/db/hash.c	2006-12-08 09:56:25.478124000 +1100
@@ -52,7 +52,7 @@ hash_f(
 {
 	xfs_dahash_t	hashval;
 
-	hashval = libxfs_da_hashname(argv[1], (int)strlen(argv[1]));
+	hashval = libxfs_da_hashname((uchar_t *)argv[1], (int)strlen(argv[1]));
 	dbprintf("0x%x\n", hashval);
 	return 0;
 }
Index: xfsprogs/mkfs/proto.c
===================================================================
--- xfsprogs.orig/mkfs/proto.c	2006-12-08 09:57:08.404806750 +1100
+++ xfsprogs/mkfs/proto.c	2006-12-08 09:58:06.060410000 +1100
@@ -313,10 +313,10 @@ newdirent(
 	int	error;
 
 	if (XFS_SB_VERSION_HASDIRV2(&mp->m_sb))
-		error = libxfs_dir2_createname(tp, pip, name, namelen,
+		error = libxfs_dir2_createname(tp, pip, (uchar_t*)name, namelen,
 						inum, first, flist, total);
 	else
-		error = libxfs_dir_createname(tp, pip, name, namelen,
+		error = libxfs_dir_createname(tp, pip, (uchar_t*)name, namelen,
 						inum, first, flist, total);
 	if (error)
 		fail(_("directory createname error"), error);
Index: xfsprogs/repair/phase6.c
===================================================================
--- xfsprogs.orig/repair/phase6.c	2006-12-08 09:58:32.542065000 +1100
+++ xfsprogs/repair/phase6.c	2006-12-08 10:02:24.364553000 +1100
@@ -338,10 +338,12 @@ dir_createname(xfs_mount_t *mp, xfs_tran
 		xfs_bmap_free_t *flist, xfs_extlen_t total)
 {
 	if (XFS_SB_VERSION_HASDIRV2(&mp->m_sb))
-		return libxfs_dir2_createname(tp, pip, name, namelen,
+		return libxfs_dir2_createname(tp, pip,
+				(uchar_t *)name, namelen,
 				inum, first, flist, total);
 	else
-		return libxfs_dir_createname(tp, pip, name, namelen,
+		return libxfs_dir_createname(tp, pip,
+				(uchar_t *)name, namelen,
 				inum, first, flist, total);
 }
 
@@ -350,9 +352,11 @@ dir_lookup(xfs_mount_t *mp, xfs_trans_t 
 		int namelen, xfs_ino_t *inum)
 {
 	if (XFS_SB_VERSION_HASDIRV2(&mp->m_sb))
-		return libxfs_dir2_lookup(tp, dp, name, namelen, inum);
+		return libxfs_dir2_lookup(tp, dp,
+					(uchar_t *)name, namelen, inum);
 	else
-		return libxfs_dir_lookup(tp, dp, name, namelen, inum);
+		return libxfs_dir_lookup(tp, dp,
+					(uchar_t *)name, namelen, inum);
 }
 
 static int
@@ -361,23 +365,12 @@ dir_replace(xfs_mount_t *mp, xfs_trans_t
 		xfs_bmap_free_t *flist, xfs_extlen_t total)
 {
 	if (XFS_SB_VERSION_HASDIRV2(&mp->m_sb))
-		return libxfs_dir2_replace(tp, dp, name, namelen, inum,
+		return libxfs_dir2_replace(tp, dp,
+				(uchar_t *)name, namelen, inum,
 				firstblock, flist, total);
 	else
-		return libxfs_dir_replace(tp, dp, name, namelen, inum,
-				firstblock, flist, total);
-}
-
-static int
-dir_removename(xfs_mount_t *mp, xfs_trans_t *tp, xfs_inode_t *dp, char *name,
-		int namelen, xfs_ino_t inum, xfs_fsblock_t *firstblock,
-		xfs_bmap_free_t *flist, xfs_extlen_t total)
-{
-	if (XFS_SB_VERSION_HASDIRV2(&mp->m_sb))
-		return libxfs_dir2_removename(tp, dp, name, namelen, inum,
-				firstblock, flist, total);
-	else
-		return libxfs_dir_removename(tp, dp, name, namelen, inum,
+		return libxfs_dir_replace(tp, dp,
+				(uchar_t *)name, namelen, inum,
 				firstblock, flist, total);
 }
 
@@ -387,10 +380,12 @@ dir_bogus_removename(xfs_mount_t *mp, xf
 		xfs_extlen_t total, xfs_dahash_t hashval, int namelen)
 {
 	if (XFS_SB_VERSION_HASDIRV2(&mp->m_sb))
-		return libxfs_dir2_bogus_removename(tp, dp, name, firstblock,
+		return libxfs_dir2_bogus_removename(tp, dp,
+				(uchar_t *)name, firstblock,
 				flist, total, hashval, namelen);
 	else
-		return libxfs_dir_bogus_removename(tp, dp, name, firstblock,
+		return libxfs_dir_bogus_removename(tp, dp,
+				(uchar_t *)name, firstblock,
 				flist, total, hashval, namelen);
 }
 
@@ -1863,7 +1858,7 @@ longform_dir2_rebuild(
 		libxfs_trans_ihold(tp, ip);
 
 		XFS_BMAP_INIT(&flist, &firstblock);
-		if ((error = libxfs_dir2_createname(tp, ip, (char*)p->name, 
+		if ((error = libxfs_dir2_createname(tp, ip, (uchar_t *)p->name,
 				p->namelen, p->inum, &firstblock, &flist, 
 				nres))) {
 			do_warn(

--=-pl6DHbZIDDM10OZV7dtx--
