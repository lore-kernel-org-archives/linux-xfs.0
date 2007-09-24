Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 11:07:39 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8OI7WQ3003116
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 11:07:35 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8OI7WA5017823
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 20:07:32 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8OI7WEc017820
	for xfs@oss.sgi.com; Mon, 24 Sep 2007 20:07:32 +0200
Date: Mon, 24 Sep 2007 20:07:32 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfsidbg: kill vnode leftovers
Message-ID: <20070924180732.GA17635@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

While we're at fixing up xfsidbg I have this little gem:

Kill the kdbm_vn, kdbm_vnode and xi2vnode xfsidbg commands.

The last one just printed a Linux inode (despite it's description)
and that is much better done by the inode command in
kdb/modules/kdbm_pg.c.  The latter two both print the vnode (nothing
left here) and the inode and again that is better done using the
inode command.  Interestingly those latter two did exactly the
same despite their quite different descriptions which weren't
correct for either command.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-09-23 14:20:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-09-23 14:21:21.000000000 +0200
@@ -1731,39 +1731,6 @@ printflags(register uint64_t flags,
 	return;
 }
 
-
-static void	printvnode(bhv_vnode_t *vp, unsigned long addr)
-{
-	kdb_printf("vnode: 0x%lx\n", addr);
-	kdb_printf("\n");
-}
-
-static int	kdbm_vnode(
-	int	argc,
-	const char **argv)
-{
-	unsigned long addr;
-	int nextarg = 1;
-	long offset = 0;
-	int diag;
-	bhv_vnode_t vp;
-
-	if (argc != 1)
-		return KDB_ARGCOUNT;
-
-	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
-
-	if (diag)
-		return diag;
-
-	if ((diag = kdb_getarea(vp, addr)))
-		return diag;
-
-	printvnode(&vp, addr);
-
-	return 0;
-}
-
 #ifdef	XFS_INODE_TRACE
 /*
  * Print a inode trace entry.
@@ -1957,76 +1924,6 @@ static int	kdbm_iptraceaddr(
 #endif	/* XFS_INODE_TRACE */
 
 
-static void	printinode(struct inode *ip)
-{
-	unsigned long	addr;
-
-
-	if (ip == NULL)
-		return;
-
-	kdb_printf(" i_ino = %lu i_count = %u i_size %Ld\n",
-					ip->i_ino, atomic_read(&ip->i_count),
-					ip->i_size);
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-	kdb_printf(
-		" i_mode = 0x%x  i_nlink = %d  i_rdev = 0x%x i_state = 0x%lx\n",
-					ip->i_mode, ip->i_nlink,
-					kdev_t_to_nr(ip->i_rdev), ip->i_state);
-#else
-	kdb_printf(
-		" i_mode = 0x%x  i_nlink = %d  i_rdev = 0x%x i_state = 0x%lx\n",
-					ip->i_mode, ip->i_nlink,
-					ip->i_rdev, ip->i_state);
-#endif
-	kdb_printf(" i_list.nxt = 0x%p i_list.prv = 0x%p\n",
-					ip->i_list.next, ip->i_list.prev);
-	kdb_printf(" i_dentry.nxt = 0x%p i_dentry.prv = 0x%p\n",
-					ip->i_dentry.next,
-					ip->i_dentry.prev);
-
-	addr = (unsigned long)ip;
-
-	kdb_printf(" i_sb = 0x%p i_op = 0x%p i_data = 0x%lx nrpages = %lu\n",
-					ip->i_sb, ip->i_op,
-					addr + offsetof(struct inode, i_data),
-					ip->i_data.nrpages);
-
-	kdb_printf("  vnode ptr 0x%p\n", vn_from_inode(ip));
-}
-
-
-static int	kdbm_vn(
-	int	argc,
-	const char **argv)
-{
-	int		diag;
-	int		nextarg = 1;
-	long		offset = 0;
-	unsigned long	addr;
-	struct inode	*ip;
-	bhv_vnode_t	vp;
-
-	if (argc != 1)
-		return KDB_ARGCOUNT;
-
-	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
-	if (diag)
-		return diag;
-
-	if ((diag = kdb_getarea(vp, addr)))
-		return diag;
-
-	ip = vn_to_inode((bhv_vnode_t *)addr);
-	kdb_printf("--> Inode @ 0x%p\n", ip);
-	printinode(ip);
-
-	kdb_printf("--> Vnode @ 0x%lx\n", addr);
-	printvnode(&vp, addr);
-	return 0;
-}
-
-
 static char	*bp_flag_vals[] = {
 /*  0 */ "READ", "WRITE", "MAPPED", "PARTIAL", "ASYNC",
 /*  5 */ "NONE", "DELWRI",  "STALE", "FS_MANAGED", "FS_DATAIOD",
@@ -2226,35 +2123,6 @@ kdbm_iomap(int argc, const char **argv)
 	return 0;
 }
 
-static int
-kdbm_i2vnode(int argc, const char **argv)
-{
-	bhv_vnode_t vp;
-	struct inode *ip;
-	unsigned long addr;
-	long offset=0;
-	int nextarg;
-	int diag;
-
-	if (argc != 1)
-		return KDB_ARGCOUNT;
-
-	nextarg = 1;
-	if ((diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL)))
-		return diag;
-	ip = (struct inode *)addr;
-	if ((diag = kdb_getarea(vp, (unsigned long)vn_from_inode(ip))))
-		return diag;
-
-	kdb_printf("--> Inode @ 0x%p\n", ip);
-	printinode(ip);
-
-	kdb_printf("--> Vnode @ 0x%p\n", vn_from_inode(ip));
-	printvnode(&vp, (unsigned long)vn_from_inode(ip));
-
-	return 0;
-}
-
 #ifdef XFS_BUF_TRACE
 static int xfs_buf_trace_entry(ktrace_entry_t *ktep)
 {
@@ -2371,8 +2239,6 @@ struct xif {
 };
 
 static struct xif xfsidbg_funcs[] = {
-  {  "vn",	kdbm_vn,	"<vnode>", "Dump inode/vnode/trace"},
-  {  "vnode",	kdbm_vnode,	"<vnode>", "Dump vnode"},
 #ifdef XFS_INODE_TRACE
   {  "iptrace",	kdbm_iptrace,	"<iptrace>", "Dump inode Trace"},
   {  "iptraceaddr",	kdbm_iptraceaddr, "<iptrace>",
@@ -2563,7 +2429,6 @@ static struct xif xfsbuf_funcs[] = {
   {  "xbp",	kdbm_bp,	"<vaddr>",	"Display xfs_buf_t" },
   {  "xbpflags",kdbm_bp_flags,	"<flags>",	"Display xfs_buf flags" },
   {  "xiomap",	kdbm_iomap,	"<xfs_iomap_t *>",	"Display IOmap" },
-  {  "xi2vnode",kdbm_i2vnode,	"<inode *>",	"Display Vnode" },
   {  "xbpdelay",kdbm_bpdelay,	"0|1",		"Display delwri buffers" },
 #ifdef XFS_BUF_TRACE
   {  "xbptrace",kdbm_bptrace,	"<vaddr>|<count>",	"xfs_buf_t trace" },
