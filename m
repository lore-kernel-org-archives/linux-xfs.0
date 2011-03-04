Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24JZKPR184631 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 13:35:20 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103041938.p24JcC1J004861@stout.americas.sgi.com>
Date: Fri, 04 Mar 2011 13:38:12 -0600
Subject: [PATCH 4/5] xfstests: eliminate warnings under
	dmapi/src/suite1/cmd (3)
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
dmapi/src/suite1/cmd/ (third of three).

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 dmapi/src/suite1/cmd/print_event.c             |   30 ++++++++++++++-----------
 dmapi/src/suite1/cmd/probe_hole.c              |    6 +++--
 dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c |    9 +++++--
 dmapi/src/suite1/cmd/punch_hole.c              |    3 +-
 dmapi/src/suite1/cmd/query_right.c             |    3 +-
 dmapi/src/suite1/cmd/randomize_file.c          |    4 +--
 dmapi/src/suite1/cmd/release_right.c           |    3 +-
 dmapi/src/suite1/cmd/remove_dmattr.c           |    3 +-
 dmapi/src/suite1/cmd/request_right.c           |    3 +-
 dmapi/src/suite1/cmd/respond_event.c           |    3 +-
 dmapi/src/suite1/cmd/rwt.c                     |   15 ++++++------
 dmapi/src/suite1/cmd/security_hole.c           |    3 +-
 dmapi/src/suite1/cmd/security_hole2.c          |    3 +-
 dmapi/src/suite1/cmd/set_disp.c                |    3 +-
 dmapi/src/suite1/cmd/set_dmattr.c              |    5 ++--
 dmapi/src/suite1/cmd/set_eventlist.c           |    3 +-
 dmapi/src/suite1/cmd/set_fileattr.c            |    3 +-
 dmapi/src/suite1/cmd/struct_test.c             |    4 +--
 dmapi/src/suite1/cmd/sync_by_handle.c          |    3 +-
 dmapi/src/suite1/cmd/test_assumption.c         |    4 +--
 dmapi/src/suite1/cmd/upgrade_right.c           |    3 +-
 21 files changed, 70 insertions(+), 46 deletions(-)

Index: b/dmapi/src/suite1/cmd/print_event.c
===================================================================
--- a/dmapi/src/suite1/cmd/print_event.c
+++ b/dmapi/src/suite1/cmd/print_event.c
@@ -331,31 +331,31 @@ print_one_mount_event(
 	if (hanp1 && hlen1) {
 		hantoa(hanp1, hlen1, hans1);
 	} else {
-		sprintf(hans1, "<BAD HANDLE, hlen %d>", hlen1);
+		sprintf(hans1, "<BAD HANDLE, hlen %zd>", hlen1);
 	}
 	if (hanp2 && hlen2) {
 		hantoa(hanp2, hlen2, hans2);
 	} else {
-		sprintf(hans2, "<BAD HANDLE, hlen %d>", hlen2);
+		sprintf(hans2, "<BAD HANDLE, hlen %zd>", hlen2);
 	}
 	if (hanp3 && hlen3) {
 		hantoa(hanp3, hlen3, hans3);
 	} else {
-		sprintf(hans3, "<BAD HANDLE, hlen %d>", hlen3);
+		sprintf(hans3, "<BAD HANDLE, hlen %zd>", hlen3);
 	}
 	if (namp1 && nlen1) {
 		strncpy(nams1, namp1, nlen1);
 		if (nlen1 != sizeof(nams1))
 			nams1[nlen1] = '\0';
 	} else {
-		sprintf(nams1, "<BAD STRING, nlen %d>", nlen1);
+		sprintf(nams1, "<BAD STRING, nlen %zd>", nlen1);
 	}
 	if (namp2 && nlen2) {
 		strncpy(nams2, namp2, nlen2);
 		if (nlen2 != sizeof(nams2))
 			nams2[nlen2] = '\0';
 	} else {
-		sprintf(nams2, "<BAD STRING, nlen %d>", nlen2);
+		sprintf(nams2, "<BAD STRING, nlen %zd>", nlen2);
 	}
 
 	printf(VALS VALS VALS VALS VALS VALD,
@@ -475,6 +475,10 @@ handle_message(
 		case DM_EVENT_TRUNCATE:
 			rgflag = DM_REGION_TRUNCATE;
 			break;
+		default:
+			err_msg("unexpected event type (%d)\n", msg->ev_type);
+			rgflag = DM_REGION_NOEVENT;
+			break;
 	      }
 	      clear_region_event(sid, rgflag, hanp1, hlen1, hans1);
       }
@@ -488,24 +492,24 @@ handle_message(
       printf(HDR VALS VALLLD VALLLD,
 	     "read", msg->ev_token, msg->ev_sequence,
 	     "file handle",	hans1,
-	     "offset",		msg_de->de_offset,
-	     "length",		msg_de->de_length);
+	     "offset",		(long long) msg_de->de_offset,
+	     "length",		(long long) msg_de->de_length);
       break;
 
     case DM_EVENT_WRITE:
       printf(HDR VALS VALLLD VALLLD,
 	     "write", msg->ev_token, msg->ev_sequence,
 	     "file handle",	hans1,
-	     "offset",		msg_de->de_offset,
-	     "length",		msg_de->de_length);
+	     "offset",		(long long) msg_de->de_offset,
+	     "length",		(long long) msg_de->de_length);
       break;
 
     case DM_EVENT_TRUNCATE:
       printf(HDR VALS VALLLD VALLLD,
 	     "truncate", msg->ev_token, msg->ev_sequence,
 	     "file handle",	hans1,
-	     "offset",		msg_de->de_offset,
-	     "length",		msg_de->de_length);
+	     "offset",		(long long) msg_de->de_offset,
+	     "length",		(long long) msg_de->de_length);
       break;
     default: break;
     }
@@ -578,7 +582,7 @@ handle_message(
   /***** NAMESPACE EVENTS *****/
 
   else {
-    char	*type;
+    char	*type = NULL;
 
     msg_ne = DM_GET_VALUE(msg, ev_data, dm_namesp_event_t *);
     hanp1  = DM_GET_VALUE(msg_ne, ne_handle1, void *);
@@ -1150,7 +1154,7 @@ finish_responding(
   int		error = 0;
   u_int		nbytes, ntokens = 0, ret_ntokens, i;
   dm_token_t	*tokenbuf = NULL, *tokenptr;
-  size_t	buflen, ret_buflen;
+  size_t	buflen = 0, ret_buflen;
   char		*msgbuf = NULL;
   dm_eventmsg_t	*msg;
 
Index: b/dmapi/src/suite1/cmd/probe_hole.c
===================================================================
--- a/dmapi/src/suite1/cmd/probe_hole.c
+++ b/dmapi/src/suite1/cmd/probe_hole.c
@@ -70,7 +70,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -117,7 +118,8 @@ main(
 			strerror(errno));
 		exit(1);
 	}
-	fprintf(stdout, "roffp is %lld, rlenp is %lld\n", roffp, rlenp);
+	fprintf(stdout, "roffp is %lld, rlenp is %llu\n",
+		(long long) roffp, (unsigned long long) rlenp);
 	dm_handle_free(hanp, hlen);
 	exit(0);
 }
Index: b/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c
===================================================================
--- a/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c
+++ b/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c
@@ -108,7 +108,8 @@ main(
 	int		opt;
 	int		method = METHOD_DMAPI_PROBE;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -149,7 +150,8 @@ main(
 		usage();
 
 	printf("Running %s on %s with settings:\n", methodmap[method], pathname);
-	printf("  offset = '%lld', length = '%lld', sid = '%lld'\n", offset, length, sid);
+	printf("  offset = '%lld', length = '%lld', sid = '%lld'\n",
+		(long long) offset, (unsigned long long) length, (long long) sid);
 	
 	if (method ==  METHOD_XFSCTL) 
 		return xfsctl_punch_hole(pathname, offset, length);
@@ -176,7 +178,8 @@ main(
 				strerror(errno));
 			exit(1);
 		}
-		fprintf(stdout, "roffp is %lld, rlenp is %lld\n", roffp, rlenp);
+		fprintf(stdout, "roffp is %lld, rlenp is %llu\n",
+			(long long) roffp, (unsigned long long) rlenp);
 		break;
 	case METHOD_DMAPI_PUNCH:
 		if (dm_punch_hole(sid, hanp, hlen, DM_NO_TOKEN, offset, length)) {
Index: b/dmapi/src/suite1/cmd/punch_hole.c
===================================================================
--- a/dmapi/src/suite1/cmd/punch_hole.c
+++ b/dmapi/src/suite1/cmd/punch_hole.c
@@ -68,7 +68,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/query_right.c
===================================================================
--- a/dmapi/src/suite1/cmd/query_right.c
+++ b/dmapi/src/suite1/cmd/query_right.c
@@ -77,7 +77,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/randomize_file.c
===================================================================
--- a/dmapi/src/suite1/cmd/randomize_file.c
+++ b/dmapi/src/suite1/cmd/randomize_file.c
@@ -43,7 +43,7 @@ main(
 {
 	FILE	*infile;
 	FILE	*tmpfile;
-	char	*path;
+	char	path[] = "file_XXXXXX";
 	int	line_count = 0;
 	int	i;
 	int	j;
@@ -77,7 +77,7 @@ main(
 	   to each line copied.
 	*/
 
-	path = tmpnam(NULL);
+	(void) mkstemp(path);
 	if ((tmpfile = fopen(path, "w")) == NULL) {
 		fprintf(stderr, "error opening temp file %s\n", path);
 		exit(1);
Index: b/dmapi/src/suite1/cmd/release_right.c
===================================================================
--- a/dmapi/src/suite1/cmd/release_right.c
+++ b/dmapi/src/suite1/cmd/release_right.c
@@ -76,7 +76,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/remove_dmattr.c
===================================================================
--- a/dmapi/src/suite1/cmd/remove_dmattr.c
+++ b/dmapi/src/suite1/cmd/remove_dmattr.c
@@ -65,7 +65,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/request_right.c
===================================================================
--- a/dmapi/src/suite1/cmd/request_right.c
+++ b/dmapi/src/suite1/cmd/request_right.c
@@ -91,7 +91,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/respond_event.c
===================================================================
--- a/dmapi/src/suite1/cmd/respond_event.c
+++ b/dmapi/src/suite1/cmd/respond_event.c
@@ -65,7 +65,8 @@ main(
 	dm_response_t	response;
 	int		reterror;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/rwt.c
===================================================================
--- a/dmapi/src/suite1/cmd/rwt.c
+++ b/dmapi/src/suite1/cmd/rwt.c
@@ -89,7 +89,8 @@ main(
 	ssize_t		rc;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -131,7 +132,7 @@ main(
 	}
 	if (length > 0) {
 		if ((bufp = malloc(length)) == NULL) {
-			fprintf(stderr, "malloc of %d bytes failed\n", length);
+			fprintf(stderr, "malloc of %zd bytes failed\n", length);
 			exit(1);
 		}
 		if (wflag)
@@ -147,7 +148,7 @@ main(
 			fprintf(stderr,
 				"seeked to offset %lld, actually "
 				"arrived at %lld\n",
-				(int64_t)offset, (int64_t)seek_off);
+				(long long) offset, (long long) seek_off);
 			exit(1);
 		}
 	}
@@ -158,8 +159,8 @@ main(
 			exit(1);
 		}
 		if (rc != length) {
-			fprintf(stderr, "expected to write %d bytes, actually "
-				"wrote %d bytes\n", length, rc);
+			fprintf(stderr, "expected to write %zd bytes, actually "
+				"wrote %zd bytes\n", length, rc);
 			exit(1);
 		}
 	} else if (tflag) {
@@ -174,8 +175,8 @@ main(
 			exit(1);
 		}
 		if (rc != length) {
-			fprintf(stderr, "expected to read %d bytes, actually "
-				"read %d bytes\n", length, rc);
+			fprintf(stderr, "expected to read %zd bytes, actually "
+				"read %zd bytes\n", length, rc);
 			exit(1);
 		}
 	}
Index: b/dmapi/src/suite1/cmd/security_hole.c
===================================================================
--- a/dmapi/src/suite1/cmd/security_hole.c
+++ b/dmapi/src/suite1/cmd/security_hole.c
@@ -63,7 +63,8 @@ main(
 	int	opt;
 	int	fd;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/security_hole2.c
===================================================================
--- a/dmapi/src/suite1/cmd/security_hole2.c
+++ b/dmapi/src/suite1/cmd/security_hole2.c
@@ -59,7 +59,8 @@ main(
 	int	opt;
 	int	fd;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/set_disp.c
===================================================================
--- a/dmapi/src/suite1/cmd/set_disp.c
+++ b/dmapi/src/suite1/cmd/set_disp.c
@@ -89,7 +89,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/set_dmattr.c
===================================================================
--- a/dmapi/src/suite1/cmd/set_dmattr.c
+++ b/dmapi/src/suite1/cmd/set_dmattr.c
@@ -63,7 +63,7 @@ main(
 	char		*object;
 	dm_attrname_t	*attrnamep;
 	char		*bufp;
-	size_t		buflen;
+	size_t		buflen = 0;
 	int		bflag = 0;
 	int		setdtime = 0;
 	void		*hanp;
@@ -71,7 +71,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/set_eventlist.c
===================================================================
--- a/dmapi/src/suite1/cmd/set_eventlist.c
+++ b/dmapi/src/suite1/cmd/set_eventlist.c
@@ -85,7 +85,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/set_fileattr.c
===================================================================
--- a/dmapi/src/suite1/cmd/set_fileattr.c
+++ b/dmapi/src/suite1/cmd/set_fileattr.c
@@ -323,7 +323,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/struct_test.c
===================================================================
--- a/dmapi/src/suite1/cmd/struct_test.c
+++ b/dmapi/src/suite1/cmd/struct_test.c
@@ -51,7 +51,7 @@
 	if (offsetof(struct_name, field_name) != offset) { \
 		printf("ERROR: field %s should be %d\n", \
 			#struct_name "." #field_name, \
-			offsetof(struct_name, field_name)); \
+			(int) offsetof(struct_name, field_name)); \
 	} \
 	offset = offsetof(struct_name, field_name) + sizeof(X.field_name); \
 }
@@ -60,7 +60,7 @@
 { \
 	printf("struct %s size is %d\n", s_name, offset); \
 	if (sizeof(struct_name) != offset) { \
-		printf("ERROR: struct %s should be %d\n", \
+		printf("ERROR: struct %s should be %zd\n", \
 			s_name, sizeof(struct_name)); \
 	} \
 }
Index: b/dmapi/src/suite1/cmd/sync_by_handle.c
===================================================================
--- a/dmapi/src/suite1/cmd/sync_by_handle.c
+++ b/dmapi/src/suite1/cmd/sync_by_handle.c
@@ -65,7 +65,8 @@ main(
 	char		*name;
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite1/cmd/test_assumption.c
===================================================================
--- a/dmapi/src/suite1/cmd/test_assumption.c
+++ b/dmapi/src/suite1/cmd/test_assumption.c
@@ -88,7 +88,7 @@ main(
                 exit(1);
         }
 	fprintf(stdout, "Initial session ID: %d\n", sid);
-	fprintf(stdout, "Initial session message length: '%d'\n", rlen);
+	fprintf(stdout, "Initial session message length: '%zd'\n", rlen);
 	if (rlen > 0) {
 		fprintf(stdout, "Initial session message: '%s'\n", buffer);
 	}
@@ -108,7 +108,7 @@ main(
                 exit(1);
         }
 	fprintf(stdout, "Assumed session ID: %d\n", newsid);
-	fprintf(stdout, "Assumed session message length: '%d'\n", rlen);
+	fprintf(stdout, "Assumed session message length: '%zd'\n", rlen);
 	if (rlen > 0) {
 		fprintf(stdout, "Assumed session message: '%s'\n", buffer);
 	}
Index: b/dmapi/src/suite1/cmd/upgrade_right.c
===================================================================
--- a/dmapi/src/suite1/cmd/upgrade_right.c
+++ b/dmapi/src/suite1/cmd/upgrade_right.c
@@ -76,7 +76,8 @@ main(
 	char		*name;
 	int		opt;
 
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
