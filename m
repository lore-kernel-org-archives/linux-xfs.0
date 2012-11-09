Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9Dd9Gk112114 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 07:39:09 -0600
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 23F518F8033
	for <xfs@oss.sgi.com>; Fri,  9 Nov 2012 05:41:06 -0800 (PST)
Message-Id: <20121109132714.075017013@sgi.com>
Date: Fri, 09 Nov 2012 07:24:01 -0600
From: rjohnston@sgi.com
Subject: [PATCH 3/3] xfstests: resolve compiler warnings
References: <20121109132358.256359544@sgi.com>
Content-Disposition: inline; filename=xfstests-resolve-compiler-warnings.patch
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This patch resolves the following compiler/configure warnings:

 configure: WARNING: unrecognized options: --enable-lib64 
 warning: 'xxxx' may be used uninitialized in this function [-Wuninitialized]
 warning: variable 'xxx' set but not used [-Wunused-but-set-variable]
 warning: call to function 'foo' without a real prototype [-Wunprototyped-calls] 

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---
 Makefile                         |    3 
 dmapi/src/suite1/cmd/link_test.c |  135 +++++++++++++++++++--------------------
 lib/tlibio.c                     |   18 +----
 ltp/doio.c                       |   91 ++++++++++++--------------
 ltp/growfiles.c                  |   44 +++++-------
 ltp/iogen.c                      |    4 -
 src/fiemap-tester.c              |    2 
 src/ftrunc.c                     |    3 
 src/trunc.c                      |    3 
 9 files changed, 139 insertions(+), 164 deletions(-)

Index: b/Makefile
===================================================================
--- a/Makefile
+++ b/Makefile
@@ -76,8 +76,7 @@ configure: configure.ac
 
 include/builddefs include/config.h: configure
 	./configure \
-                --libexecdir=/usr/lib \
-                --enable-lib64=yes
+                --libexecdir=/usr/lib
 
 aclocal.m4::
 	aclocal --acdir=`pwd`/m4 --output=$@
Index: b/dmapi/src/suite1/cmd/link_test.c
===================================================================
--- a/dmapi/src/suite1/cmd/link_test.c
+++ b/dmapi/src/suite1/cmd/link_test.c
@@ -72,90 +72,87 @@ main(
 	char		*cname = NULL, *sessinfop = NULL;
 	char		*path = NULL, *pathbufp = NULL, **versionstrpp = NULL;
 	int		flags = 0, fd = 0, setdtime = 0, reterror = 0;
-	u_int		urc;
-	int		rc;
-	dm_ssize_t	ssrc;
 
 /* Definitions per the prototypes in dmport.h, in the same order. */
 
-	rc = dm_clear_inherit(sid, hanp, hlen, token, attrnamep);
-	rc = dm_create_by_handle(sid, dirhanp, dirhlen, token,
+	dm_clear_inherit(sid, hanp, hlen, token, attrnamep);
+	dm_create_by_handle(sid, dirhanp, dirhlen, token,
 		hanp, hlen, cname);
-	rc = dm_create_session(oldsid, sessinfop, newsidp);
-	rc = dm_create_userevent(sid, msglen, msgdatap, tokenp);
-	rc = dm_destroy_session(sid);
-	rc = dm_downgrade_right(sid, hanp, hlen, token);
-	rc = dm_fd_to_handle(fd, hanpp, hlenp);
-	rc = dm_find_eventmsg(sid, token, buflen, bufp, rlenp);
-	rc = dm_get_allocinfo(sid, hanp, hlen,
+	dm_create_session(oldsid, sessinfop, newsidp);
+	dm_create_userevent(sid, msglen, msgdatap, tokenp);
+	dm_destroy_session(sid);
+	dm_downgrade_right(sid, hanp, hlen, token);
+	dm_fd_to_handle(fd, hanpp, hlenp);
+	dm_find_eventmsg(sid, token, buflen, bufp, rlenp);
+	dm_get_allocinfo(sid, hanp, hlen,
 		token, offp, nelem, extentp, nelemp);
-	rc = dm_get_bulkall(sid, hanp, hlen, token, mask, attrnamep,
+	dm_get_bulkall(sid, hanp, hlen, token, mask, attrnamep,
 		locp, buflen, bufp, rlenp);
-	rc = dm_get_bulkattr(sid, hanp, hlen, token, mask, locp, buflen, 
+	dm_get_bulkattr(sid, hanp, hlen, token, mask, locp, buflen,
 		bufp, rlenp);
-	rc = dm_get_config(hanp, hlen, flagname, retvalp);
-	rc = dm_get_config_events(hanp, hlen, nelem, eventsetp, nelemp);
-	rc = dm_get_dirattrs(sid, hanp, hlen, token, mask, locp, buflen,
+	dm_get_config(hanp, hlen, flagname, retvalp);
+	dm_get_config_events(hanp, hlen, nelem, eventsetp, nelemp);
+	dm_get_dirattrs(sid, hanp, hlen, token, mask, locp, buflen,
 		bufp, rlenp);
-	rc = dm_get_dmattr(sid, hanp, hlen, token, attrnamep, buflen,
+	dm_get_dmattr(sid, hanp, hlen, token, attrnamep, buflen,
 		bufp, rlenp);
-	rc = dm_get_eventlist(sid, hanp, hlen, token, nelem, eventsetp, nelemp);
-	rc = dm_get_events(sid, maxmsgs, flags, buflen, bufp, rlenp);
-	rc = dm_get_fileattr(sid, hanp, hlen, token, mask, statp);
-	rc = dm_get_mountinfo(sid, hanp, hlen, token, buflen, bufp, rlenp);
-	rc = dm_get_region(sid, hanp, hlen, token, nelem, regbufp, nelemp);
-	rc = dm_getall_disp(sid, buflen, bufp, rlenp);
-	rc = dm_getall_dmattr(sid, hanp, hlen, token, buflen, bufp, rlenp);
-	rc = dm_getall_inherit(sid, hanp, hlen,
+	dm_get_eventlist(sid, hanp, hlen, token, nelem, eventsetp, nelemp);
+	dm_get_events(sid, maxmsgs, flags, buflen, bufp, rlenp);
+	dm_get_fileattr(sid, hanp, hlen, token, mask, statp);
+	dm_get_mountinfo(sid, hanp, hlen, token, buflen, bufp, rlenp);
+	dm_get_region(sid, hanp, hlen, token, nelem, regbufp, nelemp);
+	dm_getall_disp(sid, buflen, bufp, rlenp);
+	dm_getall_dmattr(sid, hanp, hlen, token, buflen, bufp, rlenp);
+	dm_getall_inherit(sid, hanp, hlen,
 		token, nelem, inheritbufp, nelemp);
-	rc = dm_getall_sessions(nelem, sidbufp, nelemp);
-	rc = dm_getall_tokens(sid, nelem, tokenbufp, nelemp);
-	rc = dm_handle_cmp(hanp1, hlen1, hanp2, hlen2);
+	dm_getall_sessions(nelem, sidbufp, nelemp);
+	dm_getall_tokens(sid, nelem, tokenbufp, nelemp);
+	dm_handle_cmp(hanp1, hlen1, hanp2, hlen2);
 	dm_handle_free(hanp, hlen);
-	urc = dm_handle_hash(hanp, hlen);
-	rc = dm_handle_is_valid(hanp, hlen);
-	rc = dm_handle_to_fshandle(hanp, hlen, fshanpp, fshlenp);
-	rc = dm_handle_to_fsid(hanp, hlen, fsidp);
-	rc = dm_handle_to_igen(hanp, hlen, igenp);
-	rc = dm_handle_to_ino(hanp, hlen, inop);
-	rc = dm_handle_to_path(dirhanp, dirhlen, targhanp, targhlen, 
+	dm_handle_hash(hanp, hlen);
+	dm_handle_is_valid(hanp, hlen);
+	dm_handle_to_fshandle(hanp, hlen, fshanpp, fshlenp);
+	dm_handle_to_fsid(hanp, hlen, fsidp);
+	dm_handle_to_igen(hanp, hlen, igenp);
+	dm_handle_to_ino(hanp, hlen, inop);
+	dm_handle_to_path(dirhanp, dirhlen, targhanp, targhlen,
 		buflen, pathbufp, rlenp);
-	rc = dm_init_attrloc(sid, hanp, hlen, token, locp);
-	rc = dm_init_service(versionstrpp);
-	rc = dm_make_handle(&fsid, &ino, &igen, hanpp, hlenp);
-	rc = dm_make_fshandle(&fsid, hanpp, hlenp);
-	rc = dm_mkdir_by_handle(sid, dirhanp, dirhlen, token,
+	dm_init_attrloc(sid, hanp, hlen, token, locp);
+	dm_init_service(versionstrpp);
+	dm_make_handle(&fsid, &ino, &igen, hanpp, hlenp);
+	dm_make_fshandle(&fsid, hanpp, hlenp);
+	dm_mkdir_by_handle(sid, dirhanp, dirhlen, token,
 		hanp, hlen, cname); 
-	rc = dm_move_event(sid, token, targetsid, rtokenp);
-	rc = dm_obj_ref_hold(sid, token, hanp, hlen);
-	rc = dm_obj_ref_query(sid, token, hanp, hlen);
-	rc = dm_obj_ref_rele(sid, token, hanp, hlen);
-	rc = dm_path_to_fshandle(path, hanpp, hlenp);
-	rc = dm_path_to_handle(path, hanpp, hlenp);
-	rc = dm_pending(sid, token, delay);
-	rc = dm_probe_hole(sid, hanp, hlen, token, off, len, roffp, dmrlenp);
-	rc = dm_punch_hole(sid, hanp, hlen, token, off, len);
-	rc = dm_query_right(sid, hanp, hlen, token, rightp);
-	rc = dm_query_session(sid, buflen, bufp, rlenp);
-	ssrc = dm_read_invis(sid, hanp, hlen, token, off, len, bufp);
-	rc =  dm_release_right(sid, hanp, hlen, token);
-	rc = dm_remove_dmattr(sid, hanp, hlen, token, setdtime, attrnamep);
-	rc = dm_request_right(sid, hanp, hlen, token, uflags, right);
-	rc = dm_respond_event(sid, token, response, reterror, buflen, respbufp);
-	rc = dm_send_msg(sid, msgtype, buflen, bufp);
-	rc = dm_set_disp(sid, hanp, hlen, token, eventsetp, maxevent);
-	rc = dm_set_dmattr(sid, hanp, hlen,
+	dm_move_event(sid, token, targetsid, rtokenp);
+	dm_obj_ref_hold(sid, token, hanp, hlen);
+	dm_obj_ref_query(sid, token, hanp, hlen);
+	dm_obj_ref_rele(sid, token, hanp, hlen);
+	dm_path_to_fshandle(path, hanpp, hlenp);
+	dm_path_to_handle(path, hanpp, hlenp);
+	dm_pending(sid, token, delay);
+	dm_probe_hole(sid, hanp, hlen, token, off, len, roffp, dmrlenp);
+	dm_punch_hole(sid, hanp, hlen, token, off, len);
+	dm_query_right(sid, hanp, hlen, token, rightp);
+	dm_query_session(sid, buflen, bufp, rlenp);
+	dm_read_invis(sid, hanp, hlen, token, off, len, bufp);
+	 dm_release_right(sid, hanp, hlen, token);
+	dm_remove_dmattr(sid, hanp, hlen, token, setdtime, attrnamep);
+	dm_request_right(sid, hanp, hlen, token, uflags, right);
+	dm_respond_event(sid, token, response, reterror, buflen, respbufp);
+	dm_send_msg(sid, msgtype, buflen, bufp);
+	dm_set_disp(sid, hanp, hlen, token, eventsetp, maxevent);
+	dm_set_dmattr(sid, hanp, hlen,
 		token, attrnamep, setdtime, buflen, bufp);
-	rc = dm_set_eventlist(sid, hanp, hlen, token, eventsetp, maxevent);
-	rc = dm_set_fileattr(sid, hanp, hlen, token, mask, attrp);
-	rc = dm_set_inherit(sid, hanp, hlen, token, attrnamep, mode);
-	rc = dm_set_region(sid, hanp, hlen, token, nelem, regbufp, exactflagp);
-	rc = dm_set_return_on_destroy(sid, hanp, hlen,
+	dm_set_eventlist(sid, hanp, hlen, token, eventsetp, maxevent);
+	dm_set_fileattr(sid, hanp, hlen, token, mask, attrp);
+	dm_set_inherit(sid, hanp, hlen, token, attrnamep, mode);
+	dm_set_region(sid, hanp, hlen, token, nelem, regbufp, exactflagp);
+	dm_set_return_on_destroy(sid, hanp, hlen,
 		token,  attrnamep, enable);
-	rc = dm_symlink_by_handle(sid, dirhanp, dirhlen, token,
+	dm_symlink_by_handle(sid, dirhanp, dirhlen, token,
 		hanp, hlen, cname, path); 
-	rc = dm_sync_by_handle(sid, hanp, hlen, token);
-	rc = dm_upgrade_right(sid, hanp, hlen, token);
-	ssrc = dm_write_invis(sid, hanp, hlen, flags, token, off, len, bufp);
+	dm_sync_by_handle(sid, hanp, hlen, token);
+	dm_upgrade_right(sid, hanp, hlen, token);
+	dm_write_invis(sid, hanp, hlen, flags, token, off, len, bufp);
 	exit(0);
 }
Index: b/lib/tlibio.c
===================================================================
--- a/lib/tlibio.c
+++ b/lib/tlibio.c
@@ -465,7 +465,6 @@ char **errmsg;	/* char pointer that will
 long wrd;	/* to allow future features, use zero for now */
 {
     int ret = 0;	/* syscall return or used to get random method */
-    char *io_type;		/* Holds string of type of io */
 #ifndef linux
     int omethod = method;
     int listio_cmd;		/* Holds the listio/lio_listio cmd */
@@ -514,10 +513,8 @@ long wrd;	/* to allow future features, u
     /*
      * Determine the system call that will be called and produce
      * the string of the system call and place it in Lio_SysCall.
-     * Also update the io_type char pointer to give brief description
-     * of system call.  Execute the system call and check for
-     * system call failure.  If sync i/o, return the number of
-     * bytes written/read.
+     * Execute the system call and check for system call failure.
+     * If sync i/o, return the number of bytes written/read.
      */
      
     if ( (method & LIO_IO_SYNC) || (method & LIO_IO_TYPES) == 0 ){
@@ -528,7 +525,6 @@ long wrd;	/* to allow future features, u
 
 	sprintf(Lio_SysCall,
 	    "write(%d, buf, %d)", fd, size);
-	io_type="write";
 
         if ( Debug_level ) {
 	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
@@ -556,7 +552,6 @@ long wrd;	/* to allow future features, u
     }
 
     else if ( method & LIO_IO_SYNCV ) {
-	io_type="writev(2)";
 
 	sprintf(Lio_SysCall, 
 		"writev(%d, &iov, 1) nbyte:%d", fd, size);
@@ -667,7 +662,6 @@ char **errmsg;	/* char pointer that will
 long wrd;	/* to allow future features, use zero for now */
 {
     int ret = 0;	/* syscall return or used to get random method */
-    char *io_type;		/* Holds string of type of io */
 #ifndef linux
     int listio_cmd;		/* Holds the listio/lio_listio cmd */
     int omethod = method;
@@ -716,10 +710,8 @@ long wrd;	/* to allow future features, u
     /*
      * Determine the system call that will be called and produce
      * the string of the system call and place it in Lio_SysCall.
-     * Also update the io_type char pointer to give brief description
-     * of system call.  Execute the system call and check for
-     * system call failure.  If sync i/o, return the number of
-     * bytes written/read.
+     * Execute the system call and check for system call failure.
+     * If sync i/o, return the number of bytes written/read.
      */
      
     if ( (method & LIO_IO_SYNC) || (method & LIO_IO_TYPES) == 0 ){
@@ -730,7 +722,6 @@ long wrd;	/* to allow future features, u
 
 	sprintf(Lio_SysCall,
 	    "read(%d, buf, %d)", fd, size);
-	io_type="read";
 
         if ( Debug_level ) {
 	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
@@ -758,7 +749,6 @@ long wrd;	/* to allow future features, u
     }
 
     else if ( method & LIO_IO_SYNCV ) {
-	io_type="readv(2)";
 
 	sprintf(Lio_SysCall, 
 		"readv(%d, &iov, 1) nbyte:%d", fd, size);
Index: b/ltp/doio.c
===================================================================
--- a/ltp/doio.c
+++ b/ltp/doio.c
@@ -210,15 +210,16 @@ void	sigbus_handler();	/* Handle sigbus-
 
 void	cb_handler();		/* Posix aio callback handler. */
 void	noop_handler();		/* Delayop alarm, does nothing. */
-char	*hms();
+char	*hms(time_t  t);
 char	*format_rw();
 char	*format_sds();
 char	*format_listio();
-char	*check_file();
+char	*check_file(char *file, int offset, int length, char *pattern,
+		    int pattern_length, int patshift, int fsa);
 int	doio_fprintf(FILE *stream, char *format, ...);
-void	doio_upanic();
+void	doio_upanic(int mask);
 void	doio();
-void	help();
+void	help(FILE *stream);
 void	doio_delay();
 int     alloc_fd( char *, int );
 int     alloc_mem( int );
@@ -1145,7 +1146,6 @@ struct io_req	*req;
 	static int		pid = -1;
 	int	    	    	fd, nbytes, oflags;
 	/* REFERENCED */
-	int			signo;
 	int	    	    	logged_write, rval, got_lock;
 	long    	    	offset, woffset = 0;
 	char    	    	*addr, pattern, *file, *msg;
@@ -1156,7 +1156,6 @@ struct io_req	*req;
 	 * Misc variable setup
 	 */
 
-	signo   = 0;
 	nbytes	= req->r_data.write.r_nbytes;
 	offset	= req->r_data.write.r_offset;
 	pattern	= req->r_data.write.r_pattern;
@@ -1567,28 +1566,6 @@ fmt_pread(struct io_req *req, struct sys
 }
 
 struct status *
-sy_readv(req, sysc, fd, addr)
-struct io_req	*req;
-struct syscall_info *sysc;
-int fd;
-char *addr;
-{
-	struct status *sy_rwv();
-	return sy_rwv(req, sysc, fd, addr, 0);
-}
-
-struct status *
-sy_writev(req, sysc, fd, addr)
-struct io_req	*req;
-struct syscall_info *sysc;
-int fd;
-char *addr;
-{
-	struct status *sy_rwv();
-	return sy_rwv(req, sysc, fd, addr, 1);
-}
-
-struct status *
 sy_rwv(req, sysc, fd, addr, rw)
 struct io_req	*req;
 struct syscall_info *sysc;
@@ -1628,38 +1605,36 @@ int rw;
 	return(status);
 }
 
-char *
-fmt_readv(struct io_req *req, struct syscall_info *sy, int fd, char *addr)
-{
-	static char	errbuf[32768];
-	char		*cp;
-
-	cp = errbuf;
-	cp += sprintf(cp, "syscall:  %s(%d, (iov on stack), 1)\n",
-		      sy->sy_name, fd);
-	return(errbuf);
-}
-
 struct status *
-sy_mmread(req, sysc, fd, addr)
-struct io_req *req;
+sy_readv(req, sysc, fd, addr)
+struct io_req	*req;
 struct syscall_info *sysc;
 int fd;
 char *addr;
 {
-	struct status *sy_mmrw();
-	return sy_mmrw(req, sysc, fd, addr, 0);
+	return sy_rwv(req, sysc, fd, addr, 0);
 }
 
 struct status *
-sy_mmwrite(req, sysc, fd, addr)
-struct io_req *req;
+sy_writev(req, sysc, fd, addr)
+struct io_req	*req;
 struct syscall_info *sysc;
 int fd;
 char *addr;
 {
-	struct status *sy_mmrw();
-	return sy_mmrw(req, sysc, fd, addr, 1);
+	return sy_rwv(req, sysc, fd, addr, 1);
+}
+
+char *
+fmt_readv(struct io_req *req, struct syscall_info *sy, int fd, char *addr)
+{
+	static char	errbuf[32768];
+	char		*cp;
+
+	cp = errbuf;
+	cp += sprintf(cp, "syscall:  %s(%d, (iov on stack), 1)\n",
+		      sy->sy_name, fd);
+	return(errbuf);
 }
 
 struct status *
@@ -1728,6 +1703,26 @@ int rw;
 	return(status);
 }
 
+struct status *
+sy_mmread(req, sysc, fd, addr)
+struct io_req *req;
+struct syscall_info *sysc;
+int fd;
+char *addr;
+{
+	return sy_mmrw(req, sysc, fd, addr, 0);
+}
+
+struct status *
+sy_mmwrite(req, sysc, fd, addr)
+struct io_req *req;
+struct syscall_info *sysc;
+int fd;
+char *addr;
+{
+	return sy_mmrw(req, sysc, fd, addr, 1);
+}
+
 char *
 fmt_mmrw(struct io_req *req, struct syscall_info *sy, int fd, char *addr)
 {
Index: b/ltp/growfiles.c
===================================================================
--- a/ltp/growfiles.c
+++ b/ltp/growfiles.c
@@ -62,34 +62,30 @@
 #include "dataascii.h"
 #include "random_range.h"
 #include "databin.h"
-
-
-extern char *openflags2symbols();
-
-extern int parse_open_flags();
-extern int background();
-extern int forker();
-extern int datapidgen();
-extern void databingen();
-extern int datapidchk();
-extern int databinchk();
-extern int file_lock();
-
-int file_size();
-int check_write();
-int shrinkfile();
-int check_file();
-int growfile();
+#include "open_flags.h"
+#include "forker.h"
+#include "file_lock.h"
+
+extern int datapidgen(int pid, unsigned char *buffer, int bsize, int offset);
+extern void databingen(int mode, unsigned char *buffer, int bsize, int offset);
+extern int datapidchk(int pid, char *buffer, int bsize, int offset, char **errmsg);
+extern int databinchk(int mode, char *buffer, int bsize, int offset, char **errmsg);
+
+int file_size(int fd);
+int check_write(int fd, int cf_inter, char *filename, int mode);
+int shrinkfile(int fd, char *filename, int trunc_incr, int trunc_inter, int just_trunc);
+int check_file(int fd, int cf_inter, char *filename, int no_file_check);
+int growfile(int fd, char *file, int grow_incr, unsigned char *buf);
 int cleanup();
 int handle_error();
-int lkfile();
+int lkfile(int fd, int operation, int lklevel);
 void usage();
 void help();
-void prt_examples();
+void prt_examples(FILE *stream);
 int set_sig();
 void sig_handler();
 static void notify_others();
-int pre_alloc();
+int pre_alloc(char *file, int fd, int size);
 
 
 #define NEWIO	1	/* Use the tlibio.c functions */
@@ -1223,7 +1219,7 @@ no whole file checking will be performed
 		if ( Debug > 3 ) {
 		    printf("%s: %d DEBUG3 %s/%d: %d Open filename = %s, open flags = %#o %s\n",
 			Progname, Pid, __FILE__, __LINE__, Iter_cnt, filename, ret, 
-		        openflags2symbols(ret, ",", NULL));
+		        openflags2symbols(ret, ",", 0));
 		} else if ( Debug > 2 ) {
 		    printf("%s: %d DEBUG3 %s/%d: %d filename = %s, open flags = %#o\n",
 			Progname, Pid, __FILE__, __LINE__, Iter_cnt, filename, ret);
@@ -1269,7 +1265,7 @@ no whole file checking will be performed
 		 * if we are dealing with a FIFO file.
 		 */
 
-		if (growfile(fd, filename, grow_incr, Buffer) != 0 ) {
+		if (growfile(fd, filename, grow_incr, (unsigned char *)Buffer) != 0 ) {
 			handle_error();
 			lkfile(fd, LOCK_UN, LKLVL1);   /* release lock */
 			close(fd);
@@ -2263,7 +2259,7 @@ int mode;       /* write mode */
 	if ( Debug > 0 )
 	    printf("%s%s: %d DEBUG1 %s/%d: **fd:%d, lk:%d, offset:%d, sz:%d open flags:%#o %s\n",
 		Progname, TagName, Pid, __FILE__, __LINE__, fd, lockfile, 
-		Woffset, Grow_incr, Fileinfo.openflags, openflags2symbols(Fileinfo.openflags, ",", NULL));
+		Woffset, Grow_incr, Fileinfo.openflags, openflags2symbols(Fileinfo.openflags, ",", 0));
 
 	fflush(stderr);
 	return 1;
Index: b/ltp/iogen.c
===================================================================
--- a/ltp/iogen.c
+++ b/ltp/iogen.c
@@ -132,7 +132,7 @@ int	Fileio = 0;		/* flag indicating that
 int	Naio_Strat_Types = 0;	/* # async io completion types		    */
 struct	strmap *Aio_Strat_List[128]; /* Async io completion types	    */
 
-void	startup_info();
+void	startup_info(FILE *stream, int seed);
 
 /*
  * Map async io completion modes (-a args) names to values.  Macros are
@@ -299,7 +299,7 @@ char	**argv;
 void
 startup_info(FILE *stream, int seed)
 {
-    char	*value_to_string(), *type;
+    char	*value_to_string(struct strmap *map, int val), *type;
     int		i;
 
     fprintf(stream, "\n");
Index: b/src/fiemap-tester.c
===================================================================
--- a/src/fiemap-tester.c
+++ b/src/fiemap-tester.c
@@ -423,7 +423,7 @@ compare_fiemap_and_map(int fd, char *map
 {
 	struct fiemap *fiemap;
 	char *fiebuf;
-	int blocks_to_map, ret, cur_extent = 0, last_data;
+	int blocks_to_map, ret, cur_extent = 0, last_data = 0;
 	__u64 map_start, map_length;
 	int i, c;
 
Index: b/src/ftrunc.c
===================================================================
--- a/src/ftrunc.c
+++ b/src/ftrunc.c
@@ -30,7 +30,7 @@ int     argc;
 char    **argv;
 
 {
-char    ch, *filename="testfile";
+char *filename="testfile";
 int c;
 int fd, err;
 
@@ -40,7 +40,6 @@ if(argc != 3)
         }
 
 while((c=getopt(argc,argv,"f:"))!=EOF) {
-                ch = (char)c;
                 switch (c) {
                 case 'f':
                         filename = optarg;
Index: b/src/trunc.c
===================================================================
--- a/src/trunc.c
+++ b/src/trunc.c
@@ -47,7 +47,7 @@ char	**argv;
 	int fd, err, elapsed;
 	char *buf, *goodbuf;
 	time_t starttime;
-        char	ch, *filename="testfile";
+        char *filename="testfile";
  	int c;
 
 if(argc != 3)
@@ -56,7 +56,6 @@ if(argc != 3)
         }
 
 while((c=getopt(argc,argv,"f:"))!=EOF) {
-		ch = (char)c;
 		switch (c) {
 		case 'f':
 			filename = optarg;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
