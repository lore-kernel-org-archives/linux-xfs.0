Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A849E29E1F
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 83FE18F8040
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:53 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0UsR1003660
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:54 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000852.575807572@sgi.com>
Date: Wed, 15 Jan 2014 16:00:28 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 16/17] xfsprogs: add parent pointer support to xfs_io
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline;
	filename=04-xfsprogs-pptr-xfs_io-getparentpaths_by_handle.c
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

xfs_io parent -p  display parent pointer information for file.
xfs_io parent -c  check parent pointer consistency for filesystem.

---
 include/handle.h   |    6 ++--
 include/jdm.h      |   14 +++------
 include/parent.h   |   13 ++++----
 include/xfs_fs.h   |   11 +++++++
 io/parent.c        |   56 +++++++++++++++++++++++---------------
 libhandle/handle.c |   78 +++++++++++++++++++++++++++++++++++++++++++----------
 libhandle/jdm.c    |   48 ++++++++++++++++++++++----------
 7 files changed, 158 insertions(+), 68 deletions(-)

Index: b/include/handle.h
===================================================================
--- a/include/handle.h
+++ b/include/handle.h
@@ -24,7 +24,7 @@ extern "C" {
 
 struct fsdmidata;
 struct attrlist_cursor;
-struct parent;
+struct xfs_parent;
 
 extern int  path_to_handle (char *__path, void **__hanp, size_t *__hlen);
 extern int  path_to_fshandle (char *__path, void **__fshanp, size_t *__fshlen);
@@ -41,10 +41,10 @@ extern int  attr_list_by_handle (void *_
 				 size_t __bufsize, int __flags,
 				 struct attrlist_cursor *__cursor);
 extern int  parents_by_handle(void *__hanp, size_t __hlen,
-			      struct parent *__buf, size_t __bufsize,
+			      struct xfs_parent *__buf, size_t __bufsize,
 			      unsigned int *__count);
 extern int  parentpaths_by_handle(void *__hanp, size_t __hlen,
-				  struct parent *__buf, size_t __bufsize,
+				  struct xfs_parent *__buf, size_t __bufsize,
 				  unsigned int *__count);
 extern int  fssetdm_by_handle (void *__hanp, size_t __hlen,
 			       struct fsdmidata *__fsdmi);
Index: b/include/jdm.h
===================================================================
--- a/include/jdm.h
+++ b/include/jdm.h
@@ -24,7 +24,7 @@ typedef void	jdm_filehandle_t;	/* fileha
 
 struct xfs_bstat;
 struct attrlist_cursor;
-struct parent;
+struct xfs_parent;
 
 extern jdm_fshandle_t *
 jdm_getfshandle( char *mntpnt);
@@ -62,16 +62,12 @@ jdm_attr_list(	jdm_fshandle_t *fshp,
 		struct attrlist_cursor *cursor);
 
 extern int
-jdm_parents( jdm_fshandle_t *fshp,
-		xfs_bstat_t *statp,
-		struct parent *bufp, size_t bufsz,
-		unsigned int *count);
+jdm_parents( jdm_fshandle_t *fshp, struct xfs_bstat *statp,
+	     struct xfs_parent *bufp, size_t bufsz, unsigned int *count);
 
 extern int
-jdm_parentpaths( jdm_fshandle_t *fshp,
-		xfs_bstat_t *statp,
-		struct parent *bufp, size_t bufsz,
-		unsigned int *count);
+jdm_parentpaths( jdm_fshandle_t *fshp, struct xfs_bstat *statp,
+	         struct xfs_parent *bufp, size_t bufsz, unsigned int *count);
 
 /* macro for determining the size of a structure member */
 #define sizeofmember( t, m )	sizeof( ( ( t * )0 )->m )
Index: b/include/parent.h
===================================================================
--- a/include/parent.h
+++ b/include/parent.h
@@ -18,12 +18,13 @@
 #ifndef __PARENT_H__
 #define	__PARENT_H__
 
-typedef struct parent {
-	__u64	p_ino;
-	__u32	p_gen;
-	__u16	p_reclen;
-	char	p_name[1];
-} parent_t;
+struct xfs_parent {
+	uint64_t	p_ino;          /*parent inode number */
+	uint32_t	p_offset;       /* entry offset in parent inode */
+	uint16_t	p_reclen;       /* name length */
+	uint16_t	p_spare;        /* padding for future */
+	char		p_name[1];      /* name */
+};
 
 typedef struct parent_cursor {
 	__u32	opaque[4];      /* an opaque cookie */
Index: b/include/xfs_fs.h
===================================================================
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
@@ -438,6 +438,15 @@ typedef struct xfs_fsop_attrmulti_handle
 	struct xfs_attr_multiop		__user *ops; /* attr_multi data */
 } xfs_fsop_attrmulti_handlereq_t;
 
+
+typedef struct xfs_fsop_parentlist_handlereq {
+	struct xfs_fsop_handlereq	hreq;	/* handle interface structure */
+	__u32				flags;	/* which namespace to use */
+	__u32				buflen;	/* length of buffer supplied */
+	__u32				__user *ocount;	/* output count ptr */
+	void				__user *buffer;	/* returned names */
+} xfs_fsop_parentlist_handlereq_t;
+
 /*
  * per machine unique filesystem identifier types.
  */
@@ -553,6 +562,8 @@ typedef struct xfs_swapext
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_GETPARENTS_BY_HANDLE	 _IOWR('X', 126, struct xfs_fsop_parentlist_handlereq)
+#define XFS_IOC_GETPARENTPATHS_BY_HANDLE _IOWR('X', 127, struct xfs_fsop_parentlist_handlereq)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
Index: b/io/parent.c
===================================================================
--- a/io/parent.c
+++ b/io/parent.c
@@ -39,14 +39,16 @@ static char *mntpt;
  * check out a parent entry to see if the values seem valid
  */
 static void
-check_parent_entry(xfs_bstat_t *bstatp, parent_t *parent)
+check_parent_entry(
+	struct xfs_bstat	*bstatp,
+	struct xfs_parent	*parent)
 {
 	int sts;
 	char fullpath[PATH_MAX];
 	struct stat statbuf;
 	char *str;
 
-	sprintf(fullpath, _("%s%s"), mntpt, parent->p_name);
+	sprintf(fullpath, _("%s/%s"), mntpt, parent->p_name);
 
 	sts = lstat(fullpath, &statbuf);
 	if (sts != 0) {
@@ -121,19 +123,23 @@ check_parent_entry(xfs_bstat_t *bstatp,
 }
 
 static void
-check_parents(parent_t *parentbuf, size_t *parentbuf_size,
-	     jdm_fshandle_t *fshandlep, xfs_bstat_t *statp)
+check_parents(
+	struct xfs_parent	*parentbuf,
+	size_t			*parentbuf_size,
+	jdm_fshandle_t		*fshandlep,
+	struct xfs_bstat	*statp)
 {
-	int error, i;
-	__u32 count;
-	parent_t *entryp;
+	int			 error, i;
+	__u32			 count = 0;
+	struct xfs_parent	*entryp;
 
 	do {
 		error = jdm_parentpaths(fshandlep, statp, parentbuf, *parentbuf_size, &count);
 
 		if (error == ERANGE) {
 			*parentbuf_size *= 2;
-			parentbuf = (parent_t *)realloc(parentbuf, *parentbuf_size);
+			parentbuf = (struct xfs_parent *)realloc(parentbuf,
+				   			       *parentbuf_size);
 		} else if (error) {
 			fprintf(stderr, _("parentpaths failed for ino %llu: %s\n"),
 			       (unsigned long long) statp->bs_ino,
@@ -154,13 +160,18 @@ check_parents(parent_t *parentbuf, size_
 	entryp = parentbuf;
 	for (i = 0; i < count; i++) {
 		check_parent_entry(statp, entryp);
-		entryp = (parent_t*) (((char*)entryp) + entryp->p_reclen);
+		entryp = (struct xfs_parent*) (((char*)entryp) +
+							 entryp->p_reclen);
 	}
 }
 
 static int
-do_bulkstat(parent_t *parentbuf, size_t *parentbuf_size, xfs_bstat_t *bstatbuf,
-	    int fsfd, jdm_fshandle_t *fshandlep)
+do_bulkstat(
+	struct xfs_parent	*parentbuf,
+	size_t			*parentbuf_size,
+	struct xfs_bstat	*bstatbuf,
+	int			fsfd,
+	jdm_fshandle_t		*fshandlep)
 {
 	__s32 buflenout;
 	__u64 lastino = 0;
@@ -233,7 +244,7 @@ parent_check(void)
 {
 	int fsfd;
 	jdm_fshandle_t *fshandlep;
-	parent_t *parentbuf;
+	struct xfs_parent *parentbuf;
 	size_t parentbuf_size = PARENTBUF_SZ;
 	xfs_bstat_t *bstatbuf;
 
@@ -254,7 +265,7 @@ parent_check(void)
 
 	/* allocate buffers */
         bstatbuf = (xfs_bstat_t *)calloc(BSTATBUF_SZ, sizeof(xfs_bstat_t));
-	parentbuf = (parent_t *)malloc(parentbuf_size);
+	parentbuf = (struct xfs_parent *)malloc(parentbuf_size);
 	if (!bstatbuf || !parentbuf) {
 		fprintf(stderr, _("unable to allocate buffers: %s\n"),
 			strerror(errno));
@@ -276,13 +287,15 @@ parent_check(void)
 }
 
 static void
-print_parent_entry(parent_t *parent, int fullpath)
+print_parent_entry(
+	struct xfs_parent	*parent,
+	int			fullpath)
 {
-       printf(_("p_ino    = %llu\n"),  (unsigned long long) parent->p_ino);
-	printf(_("p_gen    = %u\n"),	parent->p_gen);
+	printf(_("p_ino    = %llu\n"),  (unsigned long long) parent->p_ino);
+	printf(_("p_offset = %u\n"),	parent->p_offset);
 	printf(_("p_reclen = %u\n"),	parent->p_reclen);
 	if (fullpath)
-		printf(_("p_name   = \"%s%s\"\n"), mntpt, parent->p_name);
+		printf(_("p_name   = \"%s/%s\"\n"), mntpt, parent->p_name);
 	else
 		printf(_("p_name   = \"%s\"\n"), parent->p_name);
 }
@@ -295,8 +308,8 @@ parent_list(int fullpath)
 	int error, i;
 	int retval = 1;
 	__u32 count;
-	parent_t *entryp;
-	parent_t *parentbuf = NULL;
+	struct xfs_parent *entryp;
+	struct xfs_parent *parentbuf = NULL;
 	char *path = file->name;
 	int pb_size = PARENTBUF_SZ;
 
@@ -318,7 +331,7 @@ parent_list(int fullpath)
 	}
 
 	do {
-		parentbuf = (parent_t *)realloc(parentbuf, pb_size);
+		parentbuf = (struct xfs_parent *)realloc(parentbuf, pb_size);
 		if (!parentbuf) {
 			fprintf(stderr, _("%s: unable to allocate parent buffer: %s\n"),
 				progname, strerror(errno));
@@ -357,7 +370,8 @@ parent_list(int fullpath)
 	entryp = parentbuf;
 	for (i = 0; i < count; i++) {
 		print_parent_entry(entryp, fullpath);
-		entryp = (parent_t*) (((char*)entryp) + entryp->p_reclen);
+		entryp = (struct xfs_parent *) (((char*)entryp) +
+							 entryp->p_reclen);
 	}
 
 	retval = 0;
Index: b/libhandle/handle.c
===================================================================
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -405,27 +405,77 @@ attr_list_by_handle(
 
 int
 parents_by_handle(
-	void		*hanp,
-	size_t		hlen,
-	parent_t	*buf,
-	size_t		bufsiz,
-	unsigned int	*count)
+	void			*hanp,
+	size_t			hlen,
+	struct xfs_parent	*buf,
+	size_t			bufsiz,
+	unsigned int		*count)
 	
 {
-	errno = EOPNOTSUPP;
-	return -1;
+	int			error, fd;
+	char			*path;
+	char			buffer[MAXPATHLEN+1];
+	unsigned int		buflen = MAXPATHLEN;
+	struct xfs_fsop_parentlist_handlereq plheq;
+
+	if ((fd = handle_to_fsfd(hanp, &path)) < 0)
+		return -1;
+
+	plheq.hreq.fd		= 0;
+	plheq.hreq.path		= NULL;
+	plheq.hreq.oflags	= O_LARGEFILE;
+	plheq.hreq.ihandle	= hanp;
+	plheq.hreq.ihandlen	= hlen;
+	plheq.hreq.ohandle 	= buffer;
+	plheq.hreq.ohandlen	= &buflen;
+	plheq.flags 		= 0x0040;
+	plheq.buffer		= buf;
+	plheq.buflen		= bufsiz;
+	plheq.ocount		= count;
+
+	/* prevent needless EINVAL from the kernel */
+	if (plheq.buflen > XATTR_LIST_MAX)
+		plheq.buflen = XATTR_LIST_MAX;
+
+	error = xfsctl(path, fd, XFS_IOC_GETPARENTS_BY_HANDLE, &plheq);
+	return error;
 }
 
 int
 parentpaths_by_handle(
-	void		*hanp,
-	size_t		hlen,
-	parent_t	*buf,
-	size_t		bufsiz,
-	unsigned int	*count)
+	void			*hanp,
+	size_t			hlen,
+	struct xfs_parent	*buf,
+	size_t			bufsiz,
+	unsigned int		*count)
 {
-	errno = EOPNOTSUPP;
-	return -1;
+	int			error, fd;
+	char			*path;
+	char			buffer[MAXPATHLEN+1];
+	unsigned int		buflen = MAXPATHLEN;
+	struct xfs_fsop_parentlist_handlereq plheq;
+
+	if ((fd = handle_to_fsfd(hanp, &path)) < 0)
+		return -1;
+
+	plheq.hreq.fd		= 0;
+	plheq.hreq.path		= NULL;
+	plheq.hreq.oflags	= O_LARGEFILE;
+	plheq.hreq.ihandle	= hanp;
+	plheq.hreq.ihandlen	= hlen;
+	plheq.hreq.ohandle 	= buffer;
+	plheq.hreq.ohandlen	= &buflen;
+	plheq.flags 		= 0x0040;
+	plheq.buffer		= buf;
+	plheq.buflen		= bufsiz;
+	plheq.ocount		= count;
+
+	/* prevent needless EINVAL from the kernel */
+	if (plheq.buflen > XATTR_LIST_MAX)
+		plheq.buflen = XATTR_LIST_MAX;
+
+	error = xfsctl(path, fd, XFS_IOC_GETPARENTPATHS_BY_HANDLE, &plheq);
+	return error;
 }
 
 int
Index: b/libhandle/jdm.c
===================================================================
--- a/libhandle/jdm.c
+++ b/libhandle/jdm.c
@@ -18,8 +18,8 @@
 
 #include <xfs/xfs.h>
 #include <xfs/handle.h>
-#include <xfs/jdm.h>
 #include <xfs/parent.h>
+#include <xfs/jdm.h>
 
 /* internal fshandle - typecast to a void for external use */
 #define FSHANDLE_SZ		8
@@ -178,21 +178,39 @@ jdm_attr_list(	jdm_fshandle_t *fshp,
 }
 
 int
-jdm_parents( jdm_fshandle_t *fshp,
-		xfs_bstat_t *statp,
-		parent_t *bufp, size_t bufsz,
-		unsigned int *count)
-{
-	errno = EOPNOTSUPP;
-	return -1;
+jdm_parents(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bstat	*statp,
+	struct xfs_parent	*bufp,
+	size_t			bufsz,
+	unsigned int		*count)
+{
+	struct xfs_handle *handle = (struct xfs_handle *) fshp;
+
+	handle->ha_fid.fid_ino = statp->bs_ino;
+	handle->ha_fid.fid_gen = statp->bs_gen;
+	handle->ha_fid.fid_len =
+			sizeof(handle->ha_fid) - sizeof(handle->ha_fid.fid_len);
+
+	return parents_by_handle(handle, sizeof(struct xfs_handle), bufp,
+				 bufsz, count);
 }
 
 int
-jdm_parentpaths( jdm_fshandle_t *fshp,
-		xfs_bstat_t *statp,
-		parent_t *bufp, size_t bufsz,
-		unsigned int *count)
-{
-	errno = EOPNOTSUPP;
-	return -1;
+jdm_parentpaths(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bstat	*statp,
+	struct xfs_parent	*bufp,
+	size_t			bufsz,
+	unsigned int		*count)
+{
+	struct xfs_handle *handle = (struct xfs_handle *) fshp;
+
+	handle->ha_fid.fid_ino = statp->bs_ino;
+	handle->ha_fid.fid_gen = statp->bs_gen;
+	handle->ha_fid.fid_len =
+			sizeof(handle->ha_fid) - sizeof(handle->ha_fid.fid_len);
+
+	return parentpaths_by_handle(handle, sizeof(struct xfs_handle), bufp,
+				     bufsz, count);
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
