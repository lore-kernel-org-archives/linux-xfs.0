Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 652C0804D
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 12:13:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A850304051
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 10:13:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Fk2pTYx1tFYEc9jL for
	<xfs@oss.sgi.com>; Wed, 09 Apr 2014 10:13:20 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s39HDJTK011975
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2014 13:13:19 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s39HDI4o011731
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2014 13:13:19 -0400
Message-ID: <53457FAF.7060208@redhat.com>
Date: Wed, 09 Apr 2014 12:13:19 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: remove write-only assignments
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
To: xfs-oss <xfs@oss.sgi.com>

There are many instances where variable assignments are made,
but never read (or are re-assigned before they are read).
The Clang static analyzer finds these.

Here's a chunk of what I think are trivial removals of such
assignments; other detections point to more serious problems
(or are shared w/ kernel code so should probably be fixed there
first).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

These may be a bit tedious to review; perhaps graphical diff
w/ more context would help in some cases?

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 9f2f99d..71adb57 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -238,7 +238,7 @@ killall(void)
 void
 handler(int sig)
 {
-	pid_t	pid = getpid();
+	pid_t	pid;
 	int	status, i;
 
 	pid = wait(&status);
@@ -912,7 +912,6 @@ main(int argc, char **argv)
 			    - (__uint64_t)mp->m_sb.sb_fdblocks + 10 * num_ags));
 
 	kids = num_targets;
-	block = (struct xfs_btree_block *) btree_buf.data;
 
 	for (agno = 0; agno < num_ags && kids > 0; agno++)  {
 		/* read in first blocks of the ag */
diff --git a/db/bmap.c b/db/bmap.c
index 3951b9f..fe620fd 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -88,7 +88,6 @@ bmap(
 		}
 	} else if (fmt == XFS_DINODE_FMT_BTREE) {
 		push_cur();
-		bno = NULLFSBLOCK;
 		rblock = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
 		fsize = XFS_DFORK_SIZE(dip, mp, whichfork);
 		pp = XFS_BMDR_PTR_ADDR(rblock, 1, xfs_bmdr_maxrecs(mp, fsize, 0));
diff --git a/db/check.c b/db/check.c
index baf7f9f..4fd9fd0 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1186,7 +1186,6 @@ blockuse_f(
 		return 0;
 	}
 	optind = 0;
-	count = 1;
 	shownames = 0;
 	fsb = XFS_DADDR_TO_FSB(mp, iocur_top->off >> BBSHIFT);
 	agno = XFS_FSB_TO_AGNO(mp, fsb);
diff --git a/db/convert.c b/db/convert.c
index 1fa094b..de4bfbf 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -200,7 +200,6 @@ convert_f(int argc, char **argv)
 	if (cur_agno != NULLAGNUMBER && (conmask & M(AGNUMBER)) == 0) {
 		cvals[CT_AGNUMBER].agnumber = cur_agno;
 		mask |= M(AGNUMBER);
-		conmask |= ~ctydescs[CT_AGNUMBER].allowed;
 	}
 	v = 0;
 	for (c = (ctype_t)0; c < NCTS; c++) {
diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index fb7eda8..77da707 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -132,7 +132,6 @@ main(int argc, char **argv)
 	maxpct = esize = 0;
 	dsize = lsize = rsize = 0LL;
 	aflag = dflag = iflag = lflag = mflag = nflag = rflag = xflag = 0;
-	ci = 0;
 
 	while ((c = getopt(argc, argv, "dD:e:ilL:m:np:rR:t:xV")) != EOF) {
 		switch (c) {
diff --git a/include/bitops.h b/include/bitops.h
index 276e9a7..e914f8f 100644
--- a/include/bitops.h
+++ b/include/bitops.h
@@ -28,7 +28,6 @@ static inline int fls(int x)
 		r -= 2;
 	}
 	if (!(x & 0x80000000u)) {
-		x <<= 1;
 		r -= 1;
 	}
 	return r;
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 1b691fb..9887423 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -741,7 +741,7 @@ libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
 int
 libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 {
-	int	fd = libxfs_device_to_fd(btp->dev);
+	int	fd;
 	int	error = 0;
 	char	*buf;
 	int	i;
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index a022df4..45a2ed5 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -736,7 +736,6 @@ xlog_print_trans_inode(
 	    *ptr += be32_to_cpu(op_head->oh_len);
 	    if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
 		return 1;
-	    op_head = (xlog_op_header_t *)*ptr;
     }
 
     return 0;
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 8b932d2..60da272 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -89,7 +89,6 @@ xlog_recover_print_buffer(
 	xfs_disk_dquot_t	*ddq;
 
 	f = (xfs_buf_log_format_t *)item->ri_buf[0].i_addr;
-	len = item->ri_buf[0].i_len;
 	printf("	");
 	ASSERT(f->blf_type == XFS_LI_BUF);
 	printf(_("BUF:  #regs:%d   start blkno:0x%llx   len:%d   bmap size:%d   flags:0x%x\n"),
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f7cf394..37c05a9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1964,8 +1964,6 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 		int		rswidth;
 		__uint64_t	rtextbytes;
 
-		rswidth = 0;
-
 		if (!norsflag && !xi.risfile && !(!rtsize && xi.disfile))
 			rswidth = ft.rtswidth;
 		else
diff --git a/quota/path.c b/quota/path.c
index 47fdd93..0c204ed 100644
--- a/quota/path.c
+++ b/quota/path.c
@@ -62,9 +62,9 @@ printpath(
 		else if (qstat.qs_flags & XFS_QUOTA_GDQ_ACCT)
 			c = printf("%sgqnoenforce", c ? ", " : "");
 		if (qstat.qs_flags & XFS_QUOTA_PDQ_ENFD)
-			c = printf("%spquota", c ? ", " : "");
+			printf("%spquota", c ? ", " : "");
 		else if (qstat.qs_flags & XFS_QUOTA_PDQ_ACCT)
-			c = printf("%spqnoenforce", c ? ", " : "");
+			printf("%spqnoenforce", c ? ", " : "");
 		printf(")");
 	}
 	printf("\n");
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index ba85fd9..ba85ac2 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -623,8 +623,6 @@ verify_da_path(xfs_mount_t	*mp,
 #ifdef XR_DIR_TRACE
 		cursor->level[this_level].n = newnode;
 #endif
-		node = newnode;
-
 		entry = cursor->level[this_level].index = 0;
 	}
 	/*
diff --git a/repair/dir2.c b/repair/dir2.c
index 06dc000..14c1435 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -606,7 +606,6 @@ _("bad level %d in block %u for directory inode %" PRIu64 "\n"),
 		cursor->level[this_level].bno = dabno;
 		cursor->level[this_level].hashval =
 			be32_to_cpu(btree[0].hashval);
-		node = newnode;
 
 		entry = cursor->level[this_level].index = 0;
 	}
@@ -780,7 +779,7 @@ process_sf_dir2(
 	 * run through entries, stop at first bad entry, don't need
 	 * to check for .. since that's encoded in its own field
 	 */
-	sfep = next_sfep = xfs_dir2_sf_firstentry(sfp);
+	next_sfep = xfs_dir2_sf_firstentry(sfp);
 	for (i = 0;
 	     i < num_entries && ino_dir_size > (char *)next_sfep - (char *)sfp;
 	     i++) {
diff --git a/repair/phase5.c b/repair/phase5.c
index 77eb125..b173597 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -153,7 +153,6 @@ mk_incore_fstree(xfs_mount_t *mp, xfs_agnumber_t agno)
 		/*
 		 * free extent ends here
 		 */
-		in_extent = 0;
 #if defined(XR_BLD_FREE_TRACE) && defined(XR_BLD_ADD_EXTENT)
 		fprintf(stderr, "adding extent %u [%u %u]\n",
 			agno, extent_start, extent_len);
@@ -223,7 +222,6 @@ setup_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *curs)
 		do_error(_("error - not enough free space in filesystem\n"));
 
 	agb_ptr = curs->btree_blocks;
-	j = curs->level[0].num_blocks;
 
 	/*
 	 * set up the free block array
@@ -438,7 +436,6 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 		do_error(_("can't rebuild fs trees -- not enough free space "
 			   "on ag %u\n"), agno);
 
-	i = 0;
 	while (ext_ptr != NULL && blocks_needed > 0)  {
 		if (ext_ptr->ex_blockcount <= blocks_needed)  {
 			blocks_needed -= ext_ptr->ex_blockcount;
diff --git a/repair/phase6.c b/repair/phase6.c
index 446f3ee..0c35e1c 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1858,7 +1858,6 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 		if (junkit)  {
 			if (inum == orphanage_ino)
 				orphanage_ino = 0;
-			junkit = 0;
 			nbad++;
 			if (!no_modify)  {
 				dep->name[0] = '/';
diff --git a/repair/prefetch.c b/repair/prefetch.c
index e47a48e..e8b3bc0 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -575,7 +575,6 @@ pf_batch_read(
 			 * go through the xfs_buf_t list copying from the
 			 * read buffer into the xfs_buf_t's and release them.
 			 */
-			last_off = first_off;
 			for (i = 0; i < num; i++) {
 
 				pbuf = ((char *)buf) + (LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[i])) - first_off);
diff --git a/repair/sb.c b/repair/sb.c
index b111aca..47177eb 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -597,8 +597,6 @@ free_geo(fs_geo_list_t *list)
 	fs_geo_list_t	*next;
 	fs_geo_list_t	*current;
 
-	current = list;
-
 	for (current = list; current != NULL; current = next)  {
 		next = current->next;
 		free(current);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
