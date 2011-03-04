Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24JZFNd184614 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 13:35:15 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103041938.p24Jc7BL004854@stout.americas.sgi.com>
Date: Fri, 04 Mar 2011 13:38:07 -0600
Subject: [PATCH 3/5] xfstests: eliminate warnings under
	dmapi/src/suite1/cmd (2)
MIME-Version: 1.0
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

Eliminate build warnings reported on files located under
dmapi/src/suite1/cmd/ (second of three).

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 dmapi/src/suite1/cmd/getall_dmattr.c      |    7 +--
 dmapi/src/suite1/cmd/handle_to_fshandle.c |    3 -
 dmapi/src/suite1/cmd/handle_to_path.c     |   10 ++--
 dmapi/src/suite1/cmd/init_service.c       |    3 -
 dmapi/src/suite1/cmd/link_test.c          |   69 ++++++++++++++++--------------
 dmapi/src/suite1/cmd/make_sparse.c        |    6 +-
 dmapi/src/suite1/cmd/obj_ref_hold.c       |    3 -
 dmapi/src/suite1/cmd/obj_ref_query.c      |    3 -
 dmapi/src/suite1/cmd/obj_ref_rele.c       |    3 -
 dmapi/src/suite1/cmd/path_to_fshandle.c   |    3 -
 dmapi/src/suite1/cmd/path_to_handle.c     |    3 -
 dmapi/src/suite1/cmd/pending.c            |    3 -
 12 files changed, 67 insertions(+), 49 deletions(-)

Index: b/dmapi/src/suite1/cmd/getall_dmattr.c
===================================================================
--- a/dmapi/src/suite1/cmd/getall_dmattr.c
+++ b/dmapi/src/suite1/cmd/getall_dmattr.c
@@ -66,7 +66,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -114,14 +115,14 @@ main(
 	    bufp, &rlenp)) {
 		if (errno == E2BIG) {
 			fprintf(stderr, "dm_getall_dmattr buffer too small, "
-				"should be %d bytes\n", rlenp);
+				"should be %zd bytes\n", rlenp);
 		} else {
 			fprintf(stderr, "dm_getall_dmattr failed, %s\n",
 				strerror(errno));
 		}
 		exit(1);
 	}
-	fprintf(stdout, "rlenp is %d\n", rlenp);
+	fprintf(stdout, "rlenp is %zd\n", rlenp);
 	if (rlenp > 0) {
 		dm_attrlist_t	*attrlist;
 
Index: b/dmapi/src/suite1/cmd/handle_to_fshandle.c
===================================================================
--- a/dmapi/src/suite1/cmd/handle_to_fshandle.c
+++ b/dmapi/src/suite1/cmd/handle_to_fshandle.c
@@ -56,7 +56,8 @@ main(
 	char		buffer[100];
 	int		error;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/handle_to_path.c
===================================================================
--- a/dmapi/src/suite1/cmd/handle_to_path.c
+++ b/dmapi/src/suite1/cmd/handle_to_path.c
@@ -22,6 +22,7 @@
 #include <string.h>
 
 #include <lib/dmport.h>
+#include <lib/hsm.h>
 
 #include <getopt.h>
 #ifdef linux
@@ -84,7 +85,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -130,16 +132,16 @@ main(
 	    buflen, pathbufp, &rlenp)) {
 		if (errno == E2BIG) {
 			fprintf(stderr, "dm_handle_to_path buffer too small, "
-				"should be %d bytes\n", rlenp);
+				"should be %zd bytes\n", rlenp);
 		} else {
 			fprintf(stderr, "dm_handle_to_path failed, (%d) %s\n",
 				errno, strerror(errno));
 		}
 		return(1);
 	}
-	fprintf(stderr, "rlenp is %d, pathbufp is %s\n", rlenp, (char*)pathbufp);
+	fprintf(stderr, "rlenp is %zd, pathbufp is %s\n", rlenp, (char*)pathbufp);
 	if (strlen(pathbufp) + 1 != rlenp) {
-		fprintf(stderr, "rlenp is %d, should be %d\n", rlenp,
+		fprintf(stderr, "rlenp is %zd, should be %zd\n", rlenp,
 			strlen(pathbufp) + 1);
 		return(1);
 	}
Index: b/dmapi/src/suite1/cmd/init_service.c
===================================================================
--- a/dmapi/src/suite1/cmd/init_service.c
+++ b/dmapi/src/suite1/cmd/init_service.c
@@ -47,7 +47,8 @@ main(
 {
 	char		*name;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/link_test.c
===================================================================
--- a/dmapi/src/suite1/cmd/link_test.c
+++ b/dmapi/src/suite1/cmd/link_test.c
@@ -36,37 +36,44 @@ main(
 	int	argc,
 	char	**argv)
 {
-	dm_sessid_t	sid, oldsid, targetsid, *newsidp, *sidbufp;
-	dm_token_t	token, *tokenp, *rtokenp, *tokenbufp;
-	dm_attrname_t	*attrnamep;
-	dm_off_t	off, *offp, *roffp;
-	dm_extent_t	*extentp;
-	dm_inherit_t	*inheritbufp;
-	dm_stat_t	*statp;
-	dm_size_t	len, *dmrlenp, *retvalp;
-	dm_attrloc_t	*locp;
-	dm_eventset_t	*eventsetp;
-	dm_config_t	flagname;
-	dm_region_t	*regbufp;
-	dm_response_t	response;
-	dm_right_t	right, *rightp;
-	dm_igen_t	igen, *igenp;
-	dm_msgtype_t	msgtype;
-	dm_fileattr_t	*attrp;
-	dm_boolean_t	enable, *exactflagp;
-	dm_timestruct_t	*delay;
-	mode_t		mode;
-	size_t		hlen, dirhlen, hlen1, hlen2, targhlen, *fshlenp, *hlenp;
-	size_t		msglen, buflen, *rlenp;
-	u_int		nelem, mask, maxmsgs, uflags, *nelemp, maxevent;
-	void		*hanp, *dirhanp, *hanp1, *hanp2, *targhanp;
-	void		*msgdatap, *bufp, **hanpp, *respbufp, **fshanpp;
-	dm_fsid_t	fsid, *fsidp;
-	dm_ino_t	ino, *inop;
-	char		*cname, *sessinfop, *path, *pathbufp, **versionstrpp;
-	int		flags, fd, setdtime, reterror;
-	u_int	urc;
-	int	rc;
+	dm_sessid_t	sid = 0, oldsid = 0, targetsid = 0;
+	dm_sessid_t	*newsidp = NULL, *sidbufp = NULL;
+	dm_token_t	token = 0, *tokenp = NULL;
+	dm_token_t	*rtokenp = NULL, *tokenbufp = NULL;
+	dm_attrname_t	*attrnamep = NULL;
+	dm_off_t	off = 0, *offp = NULL, *roffp = NULL;
+	dm_extent_t	*extentp = NULL;
+	dm_inherit_t	*inheritbufp = NULL;
+	dm_stat_t	*statp = NULL;
+	dm_size_t	len = 0, *dmrlenp = NULL, *retvalp = NULL;
+	dm_attrloc_t	*locp = NULL;
+	dm_eventset_t	*eventsetp = NULL;
+	dm_config_t	flagname = DM_CONFIG_INVALID;
+	dm_region_t	*regbufp = NULL;
+	dm_response_t	response = DM_RESP_INVALID;
+	dm_right_t	right = DM_RIGHT_NULL, *rightp = NULL;
+	dm_igen_t	igen, *igenp = NULL;
+	dm_msgtype_t	msgtype = DM_MSGTYPE_INVALID;
+	dm_fileattr_t	*attrp = NULL;
+	dm_boolean_t	enable = 0, *exactflagp = NULL;
+	dm_timestruct_t	*delay = NULL;
+	mode_t		mode = 0;
+	size_t		hlen = 0, dirhlen = 0, hlen1 = 0, hlen2 = 0;
+	size_t		targhlen = 0, *fshlenp = NULL, *hlenp = NULL;
+	size_t		msglen = 0, buflen = 0, *rlenp = NULL;
+	u_int		nelem = 0, mask = 0, maxmsgs = 0, uflags = 0;
+	u_int		*nelemp = NULL, maxevent = 0;
+	void		*hanp = NULL, *dirhanp = NULL;
+	void		*hanp1 = NULL, *hanp2 = NULL, *targhanp = NULL;
+	void		*msgdatap = NULL, *bufp = NULL, **hanpp = NULL;
+	void		*respbufp = NULL, **fshanpp = NULL;
+	dm_fsid_t	fsid, *fsidp = NULL;
+	dm_ino_t	ino, *inop = NULL;
+	char		*cname = NULL, *sessinfop = NULL;
+	char		*path = NULL, *pathbufp = NULL, **versionstrpp = NULL;
+	int		flags = 0, fd = 0, setdtime = 0, reterror = 0;
+	u_int		urc;
+	int		rc;
 	dm_ssize_t	ssrc;
 
 /* Definitions per the prototypes in dmport.h, in the same order. */
Index: b/dmapi/src/suite1/cmd/make_sparse.c
===================================================================
--- a/dmapi/src/suite1/cmd/make_sparse.c
+++ b/dmapi/src/suite1/cmd/make_sparse.c
@@ -82,18 +82,18 @@ main(
 	for (i = 0; i < 200; i += 2) {
 		offset = i * 65536;
 		if (lseek(fd, offset, SEEK_SET) < 0) {
-			fprintf(stderr, "seek to %d failed, %s\n", offset,
+			fprintf(stderr, "seek to %zd failed, %s\n", offset,
 				strerror(errno));
 			exit(1);
 		}
 		if ((count = write(fd, buf, buflen)) < 0) {
 			fprintf(stderr, "write of %d bytes failed at offset "
-				"%d, , %s\n", buflen, offset, strerror(errno));
+				"%zd, , %s\n", buflen, offset, strerror(errno));
 			exit(1);
 		}
 		if (count != buflen) {
 			fprintf(stderr, "expected to write %d bytes at offset "
-				"%d, actually wrote %d\n", buflen, offset,
+				"%zd, actually wrote %zd\n", buflen, offset,
 				count);
 			exit(1);
 		}
Index: b/dmapi/src/suite1/cmd/obj_ref_hold.c
===================================================================
--- a/dmapi/src/suite1/cmd/obj_ref_hold.c
+++ b/dmapi/src/suite1/cmd/obj_ref_hold.c
@@ -76,7 +76,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/obj_ref_query.c
===================================================================
--- a/dmapi/src/suite1/cmd/obj_ref_query.c
+++ b/dmapi/src/suite1/cmd/obj_ref_query.c
@@ -77,7 +77,8 @@ main(
 	int		error;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/obj_ref_rele.c
===================================================================
--- a/dmapi/src/suite1/cmd/obj_ref_rele.c
+++ b/dmapi/src/suite1/cmd/obj_ref_rele.c
@@ -76,7 +76,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/path_to_fshandle.c
===================================================================
--- a/dmapi/src/suite1/cmd/path_to_fshandle.c
+++ b/dmapi/src/suite1/cmd/path_to_fshandle.c
@@ -55,7 +55,8 @@ main(
 	size_t		fshlen;
 	char		buffer[100];
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/path_to_handle.c
===================================================================
--- a/dmapi/src/suite1/cmd/path_to_handle.c
+++ b/dmapi/src/suite1/cmd/path_to_handle.c
@@ -55,7 +55,8 @@ main(
 	size_t		hlen;
 	char		buffer[100];
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/pending.c
===================================================================
--- a/dmapi/src/suite1/cmd/pending.c
+++ b/dmapi/src/suite1/cmd/pending.c
@@ -58,7 +58,8 @@ main(
 	char		*name;
 	dm_token_t	token;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
