Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5UKP7g9255609 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 15:25:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C0EAE5CDE9
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 13:25:05 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	B4Sdvv9s0qLg4hal for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2011 13:25:05 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QcNnN-0006pV-7L
	for xfs@oss.sgi.com; Thu, 30 Jun 2011 20:25:05 +0000
Date: Thu, 30 Jun 2011 16:25:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: fix gcc 4.6 variable set but not used warnings
Message-ID: <20110630202505.GA23276@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/db/bmroot.c
===================================================================
--- xfsprogs-dev.orig/db/bmroot.c	2011-06-30 22:16:37.986169145 +0200
+++ xfsprogs-dev/db/bmroot.c	2011-06-30 22:16:53.036168961 +0200
@@ -192,11 +192,9 @@ bmrootd_key_offset(
 {
 	xfs_bmdr_block_t	*block;
 	xfs_bmdr_key_t		*kp;
-	xfs_dinode_t		*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
-	dip = obj;
 	block = (xfs_bmdr_block_t *)((char *)obj + byteize(startoff));
 	ASSERT(be16_to_cpu(block->bb_level) > 0);
 	kp = XFS_BMDR_KEY_ADDR(block, idx);
Index: xfsprogs-dev/growfs/xfs_growfs.c
===================================================================
--- xfsprogs-dev.orig/growfs/xfs_growfs.c	2011-06-30 22:15:46.909503114 +0200
+++ xfsprogs-dev/growfs/xfs_growfs.c	2011-06-30 22:16:15.546169457 +0200
@@ -304,7 +304,6 @@ main(int argc, char **argv)
 	error = 0;
 	if (dflag | aflag) {
 		xfs_growfs_data_t	in;
-		__uint64_t		new_agcount;
 
 		if (!mflag)
 			maxpct = geo.imaxpct;
@@ -318,9 +317,6 @@ main(int argc, char **argv)
 			error = 1;
 		}
 
-		new_agcount = dsize / geo.agblocks
-			   + (dsize % geo.agblocks != 0);
-
 		if (!error && dsize < geo.datablocks) {
 			fprintf(stderr, _("data size %lld too small,"
 				" old size is %lld\n"),
Index: xfsprogs-dev/repair/phase6.c
===================================================================
--- xfsprogs-dev.orig/repair/phase6.c	2011-06-30 22:16:58.736168887 +0200
+++ xfsprogs-dev/repair/phase6.c	2011-06-30 22:17:12.169502056 +0200
@@ -3217,7 +3217,6 @@ process_dir_inode(
 	xfs_fsblock_t		first;
 	xfs_inode_t		*ip;
 	xfs_trans_t		*tp;
-	xfs_dahash_t		hashval;
 	dir_hash_tab_t		*hashtab;
 	int			need_dot, committed;
 	int			dirty, num_illegal, error, nres;
@@ -3344,8 +3343,6 @@ process_dir_inode(
 	}
 	dir_hash_done(hashtab);
 
-	hashval = 0;
-
 	/*
 	 * We don't support repairing of v1 dir anymore, report errors and exit
 	 */
Index: xfsprogs-dev/rtcp/xfs_rtcp.c
===================================================================
--- xfsprogs-dev.orig/rtcp/xfs_rtcp.c	2011-06-30 22:15:12.339503542 +0200
+++ xfsprogs-dev/rtcp/xfs_rtcp.c	2011-06-30 22:15:31.239503313 +0200
@@ -36,7 +36,6 @@ main(int argc, char **argv)
 {
 	register int	c, i, r, errflg = 0;
 	struct stat64	s2;
-	int		eflag;
 	int		extsize = - 1;
 
 	progname = basename(argv[0]);
@@ -47,7 +46,6 @@ main(int argc, char **argv)
 	while ((c = getopt(argc, argv, "pe:V")) != EOF) {
 		switch (c) {
 		case 'e':
-			eflag = 1;
 			extsize = atoi(optarg);
 			break;
 		case 'p':
Index: xfsprogs-dev/db/attrset.c
===================================================================
--- xfsprogs-dev.orig/db/attrset.c	2011-06-30 22:17:29.352835173 +0200
+++ xfsprogs-dev/db/attrset.c	2011-06-30 22:17:54.212834865 +0200
@@ -80,7 +80,7 @@ attr_set_f(
 {
 	xfs_inode_t	*ip = NULL;
 	char		*name, *value, *sp;
-	int		c, namelen, valuelen = 0, flags = 0;
+	int		c, valuelen = 0, flags = 0;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -139,7 +139,6 @@ attr_set_f(
 	}
 
 	name = argv[optind];
-	namelen = strlen(name);
 
 	if (valuelen) {
 		value = (char *)memalign(getpagesize(), valuelen);
@@ -184,7 +183,7 @@ attr_remove_f(
 {
 	xfs_inode_t	*ip = NULL;
 	char		*name;
-	int		c, namelen, flags = 0;
+	int		c, flags = 0;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -226,7 +225,6 @@ attr_remove_f(
 	}
 
 	name = argv[optind];
-	namelen = strlen(name);
 
 	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip, 0)) {
 		dbprintf(_("failed to iget inode %llu\n"),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
