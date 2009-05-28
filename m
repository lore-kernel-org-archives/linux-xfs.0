Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SFkiv3261322 for <xfs@oss.sgi.com>; Thu, 28 May 2009 10:46:45 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF8B71D37B7B
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 08:46:57 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id nrSY72SY6wBn1SI4 for <xfs@oss.sgi.com>;
	Thu, 28 May 2009 08:46:57 -0700 (PDT)
Message-ID: <4A1EB1E6.6040606@sandeen.net>
Date: Thu, 28 May 2009 10:46:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 0.5/9] Replace MAXNAMELEN with NAME_MAX + 1
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>	<1243450413-12681-2-git-send-email-sandeen@sandeen.net>
	<20090528095657.GA651@infradead.org>
In-Reply-To: <20090528095657.GA651@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Drop the xfs-specific MAXNAMELEN in favor of the Posix NAME_MAX

This makes it easier to lose libxfs.h later.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/dmapi/src/common/lib/print.c b/dmapi/src/common/lib/print.c
index 373064f..bbed8f3 100644
--- a/dmapi/src/common/lib/print.c
+++ b/dmapi/src/common/lib/print.c
@@ -25,9 +25,6 @@
 #include <lib/hsm.h>
 
 #include <string.h>
-#ifdef linux
-#define MAXNAMELEN 256
-#endif
 
   /*
    * Define some standard formats for the printf statements below.
@@ -96,7 +93,7 @@ print_one_mount_event(
 	char		hans1[HANDLE_STR], hans2[HANDLE_STR], hans3[HANDLE_STR];
 	void		*namp1, *namp2;
 	size_t		nlen1, nlen2;
-	char		nams1[MAXNAMELEN], nams2[MAXNAMELEN];
+	char		nams1[NAME_MAX + 1], nams2[NAME_MAX + 1];
 	mode_t		mode;
 
 #if	VERITAS_21
@@ -207,7 +204,7 @@ print_one_message(
 	void		*hanp1, *hanp2, *namp1, *namp2;
 	u_int		hlen1, hlen2, nlen1, nlen2;
 	char		hans1[HANDLE_STR], hans2[HANDLE_STR];
-	char		nams1[MAXNAMELEN], nams2[MAXNAMELEN];
+	char		nams1[NAME_MAX + 1], nams2[NAME_MAX + 1];
 
 	/***** USER EVENTS *****/
 
diff --git a/dmapi/src/suite1/cmd/print_event.c b/dmapi/src/suite1/cmd/print_event.c
index 9a4beba..e34cafe 100644
--- a/dmapi/src/suite1/cmd/print_event.c
+++ b/dmapi/src/suite1/cmd/print_event.c
@@ -65,8 +65,6 @@ clear_region_event(
 	size_t		 hlen,
 	char		*hans1);
 
-#define MAXNAMELEN 256
-
 /*
  * Keep these global so the exit_handler and err_msg routines can get to them
  */
@@ -294,7 +292,7 @@ print_one_mount_event(
 	char		hans1[HANDLE_STR], hans2[HANDLE_STR], hans3[HANDLE_STR];
 	void		*namp1, *namp2;
 	size_t		nlen1, nlen2;
-	char		nams1[MAXNAMELEN], nams2[MAXNAMELEN];
+	char		nams1[NAME_MAX + 1], nams2[NAME_MAX + 1];
 	mode_t		mode;
 
 #if	VERITAS_21
@@ -391,7 +389,7 @@ handle_message(
   void			*hanp1, *hanp2, *namp1, *namp2;
   u_int			hlen1, hlen2, nlen1, nlen2;
   char			hans1[HANDLE_STR], hans2[HANDLE_STR];
-  char			nams1[MAXNAMELEN], nams2[MAXNAMELEN];
+  char			nams1[NAME_MAX + 1], nams2[NAME_MAX + 1];
 
   /*
    * Set the defaults for responding to events
diff --git a/dmapi/src/suite2/src/dm_test_daemon.c b/dmapi/src/suite2/src/dm_test_daemon.c
index 214750a..02f5d0e 100644
--- a/dmapi/src/suite2/src/dm_test_daemon.c
+++ b/dmapi/src/suite2/src/dm_test_daemon.c
@@ -39,10 +39,6 @@
 #include <lib/dmport.h>
 #include <lib/hsm.h>
 
-#ifdef linux
-#define MAXNAMELEN 256
-#endif
-
   /*
    * Define some standard formats for the printf statements below.
    */
@@ -291,7 +287,7 @@ print_one_mount_event(
 	char		hans1[HANDLE_STR], hans2[HANDLE_STR], hans3[HANDLE_STR];
 	void		*namp1, *namp2;
 	size_t		nlen1, nlen2;
-	char		nams1[MAXNAMELEN], nams2[MAXNAMELEN];
+	char		nams1[NAME_MAX + 1], nams2[NAME_MAX + 1];
 	mode_t		mode;
 
 #if	VERITAS
@@ -386,7 +382,7 @@ handle_message(
   void			*hanp1, *hanp2, *namp1, *namp2;
   u_int			hlen1, hlen2, nlen1, nlen2;
   char			hans1[HANDLE_STR], hans2[HANDLE_STR];
-  char			nams1[MAXNAMELEN], nams2[MAXNAMELEN];
+  char			nams1[NAME_MAX + 1], nams2[NAME_MAX + 1];
   void		        *fs_hanp;
   size_t		fs_hlen;
   dm_timestruct_t       *pending_time;
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 308b9bb..6978381 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -477,7 +477,7 @@ attr_list_path(pathname_t *name,
 	       int flags,
 	       attrlist_cursor_t *cursor)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
@@ -501,7 +501,7 @@ attr_list_path(pathname_t *name,
 int
 attr_remove_path(pathname_t *name, const char *attrname, int flags)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
@@ -521,7 +521,7 @@ int
 attr_set_path(pathname_t *name, const char *attrname, const char *attrvalue,
 	      const int valuelength, int flags)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
@@ -556,7 +556,7 @@ check_cwd(void)
 int
 creat_path(pathname_t *name, mode_t mode)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
@@ -697,7 +697,7 @@ doproc(void)
 int
 fent_to_name(pathname_t *name, flist_t *flp, fent_t *fep)
 {
-	char	buf[MAXNAMELEN];
+	char	buf[NAME_MAX + 1];
 	int	i;
 	fent_t	*pfep;
 	int	e;
@@ -762,7 +762,7 @@ free_pathname(pathname_t *name)
 int
 generate_fname(fent_t *fep, int ft, pathname_t *name, int *idp, int *v)
 {
-	char	buf[MAXNAMELEN];
+	char	buf[NAME_MAX + 1];
 	flist_t	*flp;
 	int	id;
 	int	j;
@@ -890,7 +890,7 @@ init_pathname(pathname_t *name)
 int
 lchown_path(pathname_t *name, uid_t owner, gid_t group)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
@@ -909,8 +909,8 @@ lchown_path(pathname_t *name, uid_t owner, gid_t group)
 int
 link_path(pathname_t *name1, pathname_t *name2)
 {
-	char		buf1[MAXNAMELEN];
-	char		buf2[MAXNAMELEN];
+	char		buf1[NAME_MAX + 1];
+	char		buf2[NAME_MAX + 1];
 	int		down1;
 	pathname_t	newname1;
 	pathname_t	newname2;
@@ -964,7 +964,7 @@ link_path(pathname_t *name1, pathname_t *name2)
 int
 lstat64_path(pathname_t *name, struct stat64 *sbuf)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
@@ -1000,7 +1000,7 @@ make_freq_table(void)
 int
 mkdir_path(pathname_t *name, mode_t mode)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
@@ -1019,7 +1019,7 @@ mkdir_path(pathname_t *name, mode_t mode)
 int
 mknod_path(pathname_t *name, mode_t mode, dev_t dev)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
@@ -1040,7 +1040,7 @@ namerandpad(int id, char *buf, int i)
 {
 	int		bucket;
 	static int	buckets[] =
-				{ 2, 4, 8, 16, 32, 64, 128, MAXNAMELEN - 1 };
+				{ 2, 4, 8, 16, 32, 64, 128, NAME_MAX };
 	int		padlen;
 	int		padmod;
 
@@ -1060,7 +1060,7 @@ namerandpad(int id, char *buf, int i)
 int
 open_path(pathname_t *name, int oflag)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
@@ -1079,7 +1079,7 @@ open_path(pathname_t *name, int oflag)
 DIR *
 opendir_path(pathname_t *name)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	DIR		*rval;
 
@@ -1120,7 +1120,7 @@ process_freq(char *arg)
 int
 readlink_path(pathname_t *name, char *lbuf, size_t lbufsiz)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
@@ -1139,8 +1139,8 @@ readlink_path(pathname_t *name, char *lbuf, size_t lbufsiz)
 int
 rename_path(pathname_t *name1, pathname_t *name2)
 {
-	char		buf1[MAXNAMELEN];
-	char		buf2[MAXNAMELEN];
+	char		buf1[NAME_MAX + 1];
+	char		buf2[NAME_MAX + 1];
 	int		down1;
 	pathname_t	newname1;
 	pathname_t	newname2;
@@ -1194,7 +1194,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 int
 rmdir_path(pathname_t *name)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
@@ -1267,7 +1267,7 @@ show_ops(int flag, char *lead_str)
 int
 stat64_path(pathname_t *name, struct stat64 *sbuf)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
@@ -1286,7 +1286,7 @@ stat64_path(pathname_t *name, struct stat64 *sbuf)
 int
 symlink_path(const char *name1, pathname_t *name)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
         
@@ -1310,7 +1310,7 @@ symlink_path(const char *name1, pathname_t *name)
 int
 truncate64_path(pathname_t *name, off64_t length)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
@@ -1329,7 +1329,7 @@ truncate64_path(pathname_t *name, off64_t length)
 int
 unlink_path(pathname_t *name)
 {
-	char		buf[MAXNAMELEN];
+	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
diff --git a/src/dirperf.c b/src/dirperf.c
index a222fff..459ae34 100644
--- a/src/dirperf.c
+++ b/src/dirperf.c
@@ -28,7 +28,6 @@
 #include <string.h>
 #include <unistd.h>
 
-#define MAXNAMELEN 256
 #ifndef __sgi__
 typedef unsigned int uint_t;
 #endif
@@ -81,7 +80,7 @@ main(int argc, char **argv)
 	DIR		*dirp;
 	int		i;
 	int		j;
-	char		name[MAXNAMELEN];
+	char		name[NAME_MAX + 1];
 	struct stat	stb;
 	double		stime;
 
@@ -150,8 +149,8 @@ main(int argc, char **argv)
 	minchars = hexchars(lastsize - 1);
 	if (nchars < minchars)
 		nchars = minchars;
-	else if (nchars >= MAXNAMELEN)
-		nchars = MAXNAMELEN - 1;
+	else if (nchars >= NAME_MAX + 1)
+		nchars = NAME_MAX;
 	if (ndirs > MAX_DIR_COUNT)
 		ndirs = MAX_DIR_COUNT;
 	if (ndirs < MIN_DIR_COUNT)
diff --git a/src/dmiperf.c b/src/dmiperf.c
index e27d783..bcd0625 100644
--- a/src/dmiperf.c
+++ b/src/dmiperf.c
@@ -34,7 +34,6 @@
 #include <attr/attributes.h>
 #endif
 
-#define MAXNAMELEN 256
 #ifndef sgi
 typedef unsigned int uint_t;
 #endif
@@ -92,7 +91,7 @@ main(int argc, char **argv)
 	uint_t		cursize;
 	int		i;
 	int		j;
-	char		name[MAXNAMELEN];
+	char		name[NAME_MAX + 1];
 	char		attr[DMFATTRLEN];
 	double		stime;
 
@@ -168,8 +167,8 @@ main(int argc, char **argv)
 	minchars = hexchars(lastsize - 1);
 	if (nchars < minchars)
 		nchars = minchars;
-	else if (nchars >= MAXNAMELEN)
-		nchars = MAXNAMELEN - 1;
+	else if (nchars >= NAME_MAX + 1)
+		nchars = NAME_MAX;
 	if (ndirs > MAX_DIR_COUNT)
 		ndirs = MAX_DIR_COUNT;
 	if (ndirs < MIN_DIR_COUNT)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
