Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24JZAHI184597 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 13:35:10 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103041938.p24Jc2m7004848@stout.americas.sgi.com>
Date: Fri, 04 Mar 2011 13:38:01 -0600
Subject: [PATCH 2/5] xfstests: eliminate warnings under
	dmapi/src/suite1/cmd (1)
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
dmapi/src/suite1/cmd/ (first of three).

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 dmapi/src/suite1/cmd/create_userevent.c  |    3 ++-
 dmapi/src/suite1/cmd/dm_handle.c         |    3 ++-
 dmapi/src/suite1/cmd/downgrade_right.c   |    3 ++-
 dmapi/src/suite1/cmd/get_allocinfo.c     |   25 ++++++++++++++-----------
 dmapi/src/suite1/cmd/get_config_events.c |    5 +++--
 dmapi/src/suite1/cmd/get_dirattrs.c      |   10 ++++------
 dmapi/src/suite1/cmd/get_dmattr.c        |    9 +++++----
 dmapi/src/suite1/cmd/get_eventlist.c     |    9 +++------
 dmapi/src/suite1/cmd/get_events.c        |    9 +++++----
 dmapi/src/suite1/cmd/get_fileattr.c      |    3 ++-
 dmapi/src/suite1/cmd/get_mountinfo.c     |    9 +++++----
 dmapi/src/suite1/cmd/get_region.c        |   12 +++++-------
 dmapi/src/suite1/cmd/getall_disp.c       |   13 +++++++------
 13 files changed, 59 insertions(+), 54 deletions(-)

Index: b/dmapi/src/suite1/cmd/create_userevent.c
===================================================================
--- a/dmapi/src/suite1/cmd/create_userevent.c
+++ b/dmapi/src/suite1/cmd/create_userevent.c
@@ -61,7 +61,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/dm_handle.c
===================================================================
--- a/dmapi/src/suite1/cmd/dm_handle.c
+++ b/dmapi/src/suite1/cmd/dm_handle.c
@@ -80,7 +80,8 @@ main(
 	char		fsbuffer3[100];
 	int		fd;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/downgrade_right.c
===================================================================
--- a/dmapi/src/suite1/cmd/downgrade_right.c
+++ b/dmapi/src/suite1/cmd/downgrade_right.c
@@ -75,7 +75,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/get_allocinfo.c
===================================================================
--- a/dmapi/src/suite1/cmd/get_allocinfo.c
+++ b/dmapi/src/suite1/cmd/get_allocinfo.c
@@ -155,7 +155,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -236,7 +237,8 @@ print_alloc(
 	char		*type = NULL;
 	int		rc;
 
-	fprintf(stdout, "%s: starting offset %lld\n", pathname, startoff);
+	fprintf(stdout, "%s: starting offset %lld\n", pathname,
+		(long long) startoff);
 
 	/* Allocate space for the number of extents requested by the user. */
 
@@ -283,21 +285,21 @@ print_alloc(
 
 			if (!Dflag) {
 				fprintf(stdout, "\t%d: [%lld..%lld]: %s", num,
-					extent[i].ex_offset / 512,
-					(extent[i].ex_offset +
+					(long long) extent[i].ex_offset / 512,
+					(long long) (extent[i].ex_offset +
 					extent[i].ex_length - 1) / 512, type);
 				if ((extent[i].ex_offset % 512 != 0) ||
 				    (endoff % 512 != 0)) {
 					fprintf(stdout, "\t[%lld..%lld]\n",
-						extent[i].ex_offset % 512,
-						(endoff-1) % 512);
+						(long long) extent[i].ex_offset % 512,
+						(long long) (endoff-1) % 512);
 				} else {
 					fprintf(stdout, "\n");
 				}
 			} else {
 				fprintf(stdout, "%5s	%13lld	%13lld\n",
-					type, extent[i].ex_offset,
-					extent[i].ex_length);
+					type, (long long) extent[i].ex_offset,
+					(long long) extent[i].ex_length);
 			}
 
 			/* The ex_offset of the first extent should match the
@@ -310,13 +312,14 @@ print_alloc(
 			if (extent[i].ex_offset != endoff) {
 				fprintf(stderr, "new extent (%lld)is not "
 					"adjacent to previous one (%lld)\n",
-					extent[i].ex_offset, endoff);
+					(long long) extent[i].ex_offset,
+					(long long) endoff);
 				return(1);
 			}
 			if (num && (extent[i].ex_offset % 512) != 0) {
 				fprintf(stderr, "non-initial ex_offset (%lld) "
 					"is not a 512-byte multiple\n",
-					extent[i].ex_offset);
+					(long long) extent[i].ex_offset);
 				return(1);
 			}
 
@@ -343,7 +346,7 @@ print_alloc(
 
 		if (rc && startoff != endoff) {
 			fprintf(stderr, "startoff is %lld, should be %lld\n",
-				startoff, endoff);
+				(long long) startoff, (long long) endoff);
 			return(1);
 		}
 
Index: b/dmapi/src/suite1/cmd/get_config_events.c
===================================================================
--- a/dmapi/src/suite1/cmd/get_config_events.c
+++ b/dmapi/src/suite1/cmd/get_config_events.c
@@ -65,7 +65,8 @@ main(
 	int		opt;
 	int		i;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -104,7 +105,7 @@ main(
 	}
 
 	fprintf(stdout, "Events supported (0x%llx), nelemp %d:\n",
-		eventset, nelemp);
+		(unsigned long long) eventset, nelemp);
 
 	for (i = 0; i < nelemp; i++) {
 		if (!DMEV_ISSET(i, eventset))
Index: b/dmapi/src/suite1/cmd/get_dirattrs.c
===================================================================
--- a/dmapi/src/suite1/cmd/get_dirattrs.c
+++ b/dmapi/src/suite1/cmd/get_dirattrs.c
@@ -43,8 +43,6 @@ char	*Progname;
 static void
 usage(void)
 {
-	int	i;
-
 	fprintf(stderr, "usage:\t%s [-b buflen] [-l loc] [-s sid] [-1] [-q] dirpath\n",
 		Progname);
 	exit(1);
@@ -68,12 +66,12 @@ main(
 	size_t		hlen;
 	char		*name;
 	int		opt;
-	int		i;
 	int		ret;
 	int		oneline = 0;
 	int		quiet = 0;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -137,8 +135,8 @@ main(
 			exit(1);
 		}
 		if (!quiet) {
-			fprintf(stdout, "ret = %d, rlenp is %d, loc is %lld\n", ret,
-				rlenp, loc);
+			fprintf(stdout, "ret = %d, rlenp is %zd, loc is %lld\n",
+				ret, rlenp, (long long) loc);
 		}
 		if (rlenp > 0) {
 			dm_stat_t	*statp;
Index: b/dmapi/src/suite1/cmd/get_dmattr.c
===================================================================
--- a/dmapi/src/suite1/cmd/get_dmattr.c
+++ b/dmapi/src/suite1/cmd/get_dmattr.c
@@ -61,7 +61,7 @@ main(
 	dm_token_t	token = DM_NO_TOKEN;
 	char		*object;
 	dm_attrname_t	*attrnamep;
-	void		*bufp;
+	void		*bufp = NULL;
 	size_t		buflen = 10000;
 	size_t		rlenp;
 	void		*hanp;
@@ -69,7 +69,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -122,14 +123,14 @@ main(
 	    bufp, &rlenp)) {
 		if (errno == E2BIG) {
 			fprintf(stderr, "dm_get_dmattr buffer too small, "
-				"should be %d bytes\n", rlenp);
+				"should be %zd bytes\n", rlenp);
 		} else {
 			fprintf(stderr, "dm_get_dmattr failed, %s\n",
 				strerror(errno));
 		}
 		exit(1);
 	}
-	fprintf(stdout, "rlenp is %d, value is '%s'\n", rlenp, (char*)bufp);
+	fprintf(stdout, "rlenp is %zd, value is '%s'\n", rlenp, (char*)bufp);
 
 	dm_handle_free(hanp, hlen);
 	exit(0);
Index: b/dmapi/src/suite1/cmd/get_eventlist.c
===================================================================
--- a/dmapi/src/suite1/cmd/get_eventlist.c
+++ b/dmapi/src/suite1/cmd/get_eventlist.c
@@ -80,7 +80,8 @@ main(
 	int		opt;
 	int		i;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -147,12 +148,8 @@ main(
 		return(1);
 	}
 
-#ifdef	VERITAS_21
-	fprintf(stdout, "Events on object %s (0x%x), nelemp %d:\n",
-#else
 	fprintf(stdout, "Events on object %s (0x%llx), nelemp %d:\n",
-#endif
-		object, eventset, nelemp);
+		object, (unsigned long long) eventset, nelemp);
 
 	for (i = 0; i < nelemp; i++) {
 		if (!DMEV_ISSET(i, eventset))
Index: b/dmapi/src/suite1/cmd/get_events.c
===================================================================
--- a/dmapi/src/suite1/cmd/get_events.c
+++ b/dmapi/src/suite1/cmd/get_events.c
@@ -60,14 +60,15 @@ main(
 	dm_eventmsg_t	*msg;
 	dm_sessid_t	sid;
 	u_int		flags = 0;
-	void		*bufp;
+	void		*bufp = NULL;
 	size_t		buflen = 10000;
 	u_int		maxmsgs = 1;
 	size_t		rlenp;
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -109,14 +110,14 @@ main(
 	if (dm_get_events(sid, maxmsgs, flags, buflen, bufp, &rlenp)) {
 		if (errno == E2BIG) {
 			fprintf(stderr, "dm_get_events buffer too small, "
-				"should be %d bytes\n", rlenp);
+				"should be %zd bytes\n", rlenp);
 		} else {
 			fprintf(stderr, "dm_get_events failed, (%d)%s\n",
 				errno, strerror(errno));
 		}
 		exit(1);
 	}
-	fprintf(stdout, "rlenp=%d\n", rlenp);
+	fprintf(stdout, "rlenp=%zd\n", rlenp);
 
 	if (rlenp == 0)
 		return(0);
Index: b/dmapi/src/suite1/cmd/get_fileattr.c
===================================================================
--- a/dmapi/src/suite1/cmd/get_fileattr.c
+++ b/dmapi/src/suite1/cmd/get_fileattr.c
@@ -59,7 +59,8 @@ main(
 	int		opt;
 	int		validate = 0;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/get_mountinfo.c
===================================================================
--- a/dmapi/src/suite1/cmd/get_mountinfo.c
+++ b/dmapi/src/suite1/cmd/get_mountinfo.c
@@ -76,7 +76,7 @@ main(
 {
 	dm_sessid_t	sid = DM_NO_SESSION;
 	char		*pathname;
-	void		*bufp;
+	void		*bufp = NULL;
 	size_t		buflen = 10000;
 	size_t		rlenp;
 	void		*fshanp;
@@ -84,7 +84,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -134,14 +135,14 @@ main(
 	    bufp, &rlenp)) {
 		if (errno == E2BIG) {
 			fprintf(stderr, "dm_get_mountinfo buffer too small, "
-				"should be %d bytes\n", rlenp);
+				"should be %zd bytes\n", rlenp);
 		} else {
 			fprintf(stderr, "dm_get_mountinfo failed, %s\n",
 				strerror(errno));
 		}
 		exit(1);
 	}
-	fprintf(stdout, "rlenp is %d\n", rlenp);
+	fprintf(stdout, "rlenp is %zd\n", rlenp);
 	print_one_mount_event(bufp);
 
 	dm_handle_free(fshanp, fshlen);
Index: b/dmapi/src/suite1/cmd/get_region.c
===================================================================
--- a/dmapi/src/suite1/cmd/get_region.c
+++ b/dmapi/src/suite1/cmd/get_region.c
@@ -67,7 +67,8 @@ main(
 	int		opt;
 	int		i;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -121,12 +122,9 @@ main(
 	fprintf(stdout, "%d regions\n", nelemp);
 
 	for (i = 0; i < nelemp; i++) {
-#ifdef	VERITAS_21
-		fprintf(stdout, "offset %d, size %d, flags 0x%x\n",
-#else
-		fprintf(stdout, "offset %lld, size %lld, flags 0x%x\n",
-#endif
-			regbufp[i].rg_offset, regbufp[i].rg_size,
+		fprintf(stdout, "offset %lld, size %llu, flags 0x%x\n",
+			(long long) regbufp[i].rg_offset,
+			(unsigned long long) regbufp[i].rg_size,
 			regbufp[i].rg_flags);
 	}
 
Index: b/dmapi/src/suite1/cmd/getall_disp.c
===================================================================
--- a/dmapi/src/suite1/cmd/getall_disp.c
+++ b/dmapi/src/suite1/cmd/getall_disp.c
@@ -58,7 +58,7 @@ main(
 {
 	dm_dispinfo_t	*disp;
 	dm_sessid_t	sid;
-	void		*bufp;
+	void		*bufp = NULL;
 	size_t		buflen = 10000;
 	void		*hanp;
 	size_t		hlen;
@@ -67,7 +67,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -103,14 +104,14 @@ main(
 	if (dm_getall_disp(sid, buflen, bufp, &rlenp)) {
 		if (errno == E2BIG) {
 			fprintf(stderr, "dm_getall_disp buffer too small, "
-				"should be %d bytes\n", rlenp);
+				"should be %zd bytes\n", rlenp);
 		} else {
 			fprintf(stderr, "dm_getall_disp failed, %s\n",
 				strerror(errno));
 		}
 		exit(1);
 	}
-	fprintf(stdout, "rlenp is %d\n", rlenp);
+	fprintf(stdout, "rlenp is %zd\n", rlenp);
 	if (rlenp == 0)
 		return(0);
 
@@ -121,11 +122,11 @@ main(
 		if (hanp && hlen) {
 			hantoa(hanp, hlen, hans1);
 		} else {
-			sprintf(hans1, "<BAD HANDLE, hlen %d>", hlen);
+			sprintf(hans1, "<BAD HANDLE, hlen %zd>", hlen);
 		}
 		printf("%-15s %s dm_eventset_t 0%llo\n",
 			"fshandle", hans1,
-			disp->di_eventset);
+			(unsigned long long) disp->di_eventset);
 
 		disp = DM_STEP_TO_NEXT(disp, dm_dispinfo_t *);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
