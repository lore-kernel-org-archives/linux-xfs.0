Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24JZPs7184644 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 13:35:25 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103041938.p24JcHUh004871@stout.americas.sgi.com>
Date: Fri, 04 Mar 2011 13:38:17 -0600
Subject: [PATCH 5/5] xfstests: eliminate warnings under
 dmapi/src/suite2/src
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
dmapi/src/suite2/src/.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 dmapi/src/suite2/src/dm_test_daemon.c |   30 +++++++++++++++---------------
 dmapi/src/suite2/src/invis_test.c     |   32 +++++++++++++++++++++-----------
 dmapi/src/suite2/src/mmap.c           |    4 +++-
 dmapi/src/suite2/src/region_test.c    |    3 ++-
 dmapi/src/suite2/src/send_msg.c       |    3 ++-
 dmapi/src/suite2/src/test_bulkall.c   |    9 +++++----
 dmapi/src/suite2/src/test_bulkattr.c  |    7 ++++---
 dmapi/src/suite2/src/test_dmattr.c    |    5 +++--
 dmapi/src/suite2/src/test_efault.c    |    7 ++++---
 dmapi/src/suite2/src/test_eventlist.c |    3 ++-
 dmapi/src/suite2/src/test_fileattr.c  |   10 ++++++----
 dmapi/src/suite2/src/test_hole.c      |    3 ++-
 dmapi/src/suite2/src/test_invis.c     |   10 ++++++----
 dmapi/src/suite2/src/test_region.c    |    3 ++-
 dmapi/src/suite2/src/test_rights.c    |    3 ++-
 15 files changed, 79 insertions(+), 53 deletions(-)

Index: b/dmapi/src/suite2/src/dm_test_daemon.c
===================================================================
--- a/dmapi/src/suite2/src/dm_test_daemon.c
+++ b/dmapi/src/suite2/src/dm_test_daemon.c
@@ -324,31 +324,31 @@ print_one_mount_event(
 	if (hanp1 && hlen1) {
 		hantoa(hanp1, hlen1, hans1);
 	} else {
-		sprintf(hans1, "<BAD_HANDLE_hlen_%d>", hlen1);
+		sprintf(hans1, "<BAD_HANDLE_hlen_%zd>", hlen1);
 	}
 	if (hanp2 && hlen2) {
 		hantoa(hanp2, hlen2, hans2);
 	} else {
-		sprintf(hans2, "<BAD_HANDLE_hlen_%d>", hlen2);
+		sprintf(hans2, "<BAD_HANDLE_hlen_%zd>", hlen2);
 	}
 	if (hanp3 && hlen3) {
 		hantoa(hanp3, hlen3, hans3);
 	} else {
-		sprintf(hans3, "<BAD_HANDLE_hlen_%d>", hlen3);
+		sprintf(hans3, "<BAD_HANDLE_hlen_%zd>", hlen3);
 	}
 	if (namp1 && nlen1) {
 		strncpy(nams1, namp1, nlen1);
 		if (nlen1 != sizeof(nams1))
 			nams1[nlen1] = '\0';
 	} else {
-		sprintf(nams1, "<BAD STRING_nlen_%d>", nlen1);
+		sprintf(nams1, "<BAD STRING_nlen_%zd>", nlen1);
 	}
 	if (namp2 && nlen2) {
 		strncpy(nams2, namp2, nlen2);
 		if (nlen2 != sizeof(nams2))
 			nams2[nlen2] = '\0';
 	} else {
-		sprintf(nams2, "<BAD_STRING_nlen_%d>", nlen2);
+		sprintf(nams2, "<BAD_STRING_nlen_%zd>", nlen2);
 	}
 
 	printf(VALS VALS VALS VALS VALS VALD,
@@ -373,8 +373,8 @@ handle_message(
 {
   int			pkt_error = 0;
   int			error;
-  dm_response_t		response;
-  int			respond, respcode;
+  dm_response_t		response = DM_RESP_INVALID;
+  int			respond, respcode = 0;
   dm_namesp_event_t	*msg_ne;
 #if	!VERITAS
     dm_mount_event_t	*msg_me;
@@ -578,24 +578,24 @@ handle_message(
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
@@ -658,7 +658,7 @@ handle_message(
   /***** NAMESPACE EVENTS *****/
 
   else {
-    char	*type;
+    char	*type = NULL;
 
     msg_ne = DM_GET_VALUE(msg, ev_data, dm_namesp_event_t *);
     hanp1  = DM_GET_VALUE(msg_ne, ne_handle1, void *);
@@ -1168,7 +1168,7 @@ finish_responding(
   int		error = 0;
   u_int		nbytes, ntokens = 0, ret_ntokens, i;
   dm_token_t	*tokenbuf = NULL, *tokenptr;
-  size_t	buflen, ret_buflen;
+  size_t	buflen = 0, ret_buflen;
   char		*msgbuf = NULL;
   dm_eventmsg_t	*msg;
 
Index: b/dmapi/src/suite2/src/invis_test.c
===================================================================
--- a/dmapi/src/suite2/src/invis_test.c
+++ b/dmapi/src/suite2/src/invis_test.c
@@ -100,7 +100,8 @@ main(
 	int		i;
 	int		reuse_file = 0;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -157,9 +158,10 @@ main(
 	}
 
 	if( Vflag )
-		printf("using length = %llu\n", length );
+		printf("using length = %llu\n", (unsigned long long) length);
 	if( length > BUFSZ ){
-		fprintf(stderr, "length(%llu) > BUFSZ(%d)\n", length, BUFSZ);
+		fprintf(stderr, "length(%llu) > BUFSZ(%d)\n",
+			(unsigned long long) length, BUFSZ);
 		exit(1);
 	}
 
@@ -174,13 +176,15 @@ main(
 			exit(1);
 		}
 		if( rc != length ){
-			fprintf(stderr, "dm_read_invis read %lld bytes, wanted to write %lld bytes\n",
-				rc, length );
+			fprintf(stderr, "dm_read_invis read %llu bytes, "
+				"wanted to write %lld bytes\n",
+				(long long) rc, (unsigned long long) length);
 			dm_handle_free(hanp, hlen);
 			exitstat++;
 		}
 		else {
-			printf("dm_read_invis read %lld bytes\n", rc);
+			printf("dm_read_invis read %lld bytes\n",
+				(long long) rc);
 		}
 		
 		in_err_block = 0;
@@ -193,7 +197,10 @@ main(
 				}
 				else {
 					/* end of bad block */
-					fprintf(stderr, "read err block: byte %lld to %lld\n", errblockstart, errblockend);
+					fprintf(stderr, "read err block: "
+						"byte %lld to %lld\n",
+						(long long) errblockstart,
+						(long long) errblockend);
 					in_err_block = 0;
 				}
 			}
@@ -205,7 +212,9 @@ main(
 		}
 		if( in_err_block ){
 			/* end of bad block */
-			fprintf(stderr, "read err block: byte %lld to %lld\n", errblockstart, errblockend);
+			fprintf(stderr, "read err block: byte %lld to %lld\n",
+				(long long) errblockstart,
+				(long long) errblockend);
 			in_err_block = 0;
 		}
 	}
@@ -221,12 +230,13 @@ main(
 			exit(1);
 		}
 		if( rc != length ){
-			fprintf(stderr, "dm_write_invis wrote %lld bytes, wanted to write %lld bytes\n",
-				rc, length );
+			fprintf(stderr, "dm_write_invis wrote %lld bytes, "
+				"wanted to write %lld bytes\n",
+				(long long) rc, (long long) length );
 			dm_handle_free(hanp, hlen);
 			exit(1);
 		}
-		printf("dm_write_invis wrote %lld bytes\n", rc);
+		printf("dm_write_invis wrote %lld bytes\n", (long long) rc);
 	}
 
 	dm_handle_free(hanp, hlen);
Index: b/dmapi/src/suite2/src/mmap.c
===================================================================
--- a/dmapi/src/suite2/src/mmap.c
+++ b/dmapi/src/suite2/src/mmap.c
@@ -121,11 +121,13 @@ static int mfile_opt(char * s, mfile_t *
 static	void print_flags(char *s, mfile_t *f);
 static void Usage(void);
 
+int
 main(int argc, char * argv[])
 {
 	int	opt;
 
-	if ((Progname = strrchr(argv[0], '/')) == NULL)
+	Progname = strrchr(argv[0], '/');
+	if (Progname == NULL)
 		Progname = argv[0];
 	else
 		Progname++;
Index: b/dmapi/src/suite2/src/region_test.c
===================================================================
--- a/dmapi/src/suite2/src/region_test.c
+++ b/dmapi/src/suite2/src/region_test.c
@@ -83,7 +83,8 @@ main(
 	size_t	 	 hlen;
 	dm_boolean_t	exactflag;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite2/src/send_msg.c
===================================================================
--- a/dmapi/src/suite2/src/send_msg.c
+++ b/dmapi/src/suite2/src/send_msg.c
@@ -70,7 +70,8 @@ main(
 	int		opt;
 	dm_msgtype_t    msgtype = DM_MSGTYPE_SYNC;
 	
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite2/src/test_bulkall.c
===================================================================
--- a/dmapi/src/suite2/src/test_bulkall.c
+++ b/dmapi/src/suite2/src/test_bulkall.c
@@ -172,14 +172,14 @@ my_print_victim(
 	else {
 		char handle_str[HANDLE_STR];
 		if (verbose & V_PRINT) {
-			printf("%d\t", hlen);
+			printf("%zd\t", hlen);
 			hantoa(hanp, hlen, handle_str);
 			printf("%s ", handle_str);
 			if (extras) {
 				printf("size=%lld ",
-				       (int64_t)sbuf->dt_size);
+				       (long long) sbuf->dt_size);
 				printf("ino=%lld ",
-				       (int64_t)sbuf->dt_ino);
+				       (long long) sbuf->dt_ino);
 			}
 		}
 
@@ -271,7 +271,8 @@ scan_fs(
 				      mask, dmattr, &locp, buflen,
 				      dm_xstatbuf, &rlenp);
 		if (verbose & V_VERBOSE)
-			fprintf(stderr, "BULKALL more=%d, rlen=%d\n", more, rlenp);
+			fprintf(stderr, "BULKALL more=%d, rlen=%zd\n",
+				more, rlenp);
 		if (more == -1) {
 			errno_msg("%s/%d: Can't get bulkall for filesystem", __FILE__, __LINE__, errno);
 			break;
Index: b/dmapi/src/suite2/src/test_bulkattr.c
===================================================================
--- a/dmapi/src/suite2/src/test_bulkattr.c
+++ b/dmapi/src/suite2/src/test_bulkattr.c
@@ -164,7 +164,7 @@ my_print_victim(
 	else {
 		char handle_str[HANDLE_STR];
 		if (verbose & V_PRINT) {
-			printf("%d\t", hlen);
+			printf("%zd\t", hlen);
 			hantoa(hanp, hlen, handle_str);
 			printf("%s ", handle_str);
 		}
@@ -187,7 +187,7 @@ my_print_victim(
 			if( isalpha(buf[0]) )
 				printf("(%s)\n", buf);
 			else
-				printf("<len=%d>\n",rlen);
+				printf("<len=%zd>\n",rlen);
 		}
 	}
 }
@@ -251,7 +251,8 @@ scan_fs(
 		more = dm_get_bulkattr(sid, fs_hanp, fs_hlen, DM_NO_TOKEN,
 				       mask, &locp, buflen, dm_statbuf, &rlenp);
 		if (verbose & V_VERBOSE)
-			fprintf(stderr, "BULKATTR more=%d, rlen=%d\n", more, rlenp);
+			fprintf(stderr, "BULKATTR more=%d, rlen=%zd\n",
+				more, rlenp);
 		if (more == -1) {
 			errno_msg("%s/%d: Can't get bulkattr for filesystem", __FILE__, __LINE__, errno);
 			break;
Index: b/dmapi/src/suite2/src/test_dmattr.c
===================================================================
--- a/dmapi/src/suite2/src/test_dmattr.c
+++ b/dmapi/src/suite2/src/test_dmattr.c
@@ -101,7 +101,8 @@ main(
 	struct stat    *statbuf;
 	struct stat    *checkbuf;
 
-        if (Progname = strrchr(argv[0], '/')) {
+        Progname = strrchr(argv[0], '/');
+        if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -224,7 +225,7 @@ main(
 			      bufp, &rlenp)) {
 	      if (errno == E2BIG) {
 		fprintf(stderr, "dm_get_dmattr buffer too small, "
-			"should be %d bytes\n", rlenp);
+			"should be %zd bytes\n", rlenp);
 	      } else {
 		fprintf(stderr, "dm_get_dmattr failed (%s) for test file %d\n",
 			ERR_NAME, i);
Index: b/dmapi/src/suite2/src/test_efault.c
===================================================================
--- a/dmapi/src/suite2/src/test_efault.c
+++ b/dmapi/src/suite2/src/test_efault.c
@@ -84,7 +84,8 @@ main(int argc, char **argv) {
 	char            command[100];
 	int		opt;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -170,7 +171,7 @@ main(int argc, char **argv) {
 	 */
 	{ 
 	  u_int         nelem=5;
-	  u_int         *nelemp;
+	  u_int         *nelemp = NULL;
 	  dm_eventset_t *eventsetp;
 	  eventsetp = (dm_eventset_t *)malloc(nelem*sizeof(dm_eventset_t));
 	  if (eventsetp == NULL) {
@@ -198,7 +199,7 @@ main(int argc, char **argv) {
 	{ 
 	  size_t buflen = 5;
 	  void   *bufp  = (void *)malloc(buflen*sizeof(dm_attrlist_t));
-	  size_t *rlenp;
+	  size_t *rlenp = NULL;
 	  ERRTEST(EFAULT, "getall_dmattr (NULL handle)", 
 		  dm_getall_dmattr(sid, NULL, hlen, DM_NO_TOKEN,
 				   buflen, bufp, rlenp))
Index: b/dmapi/src/suite2/src/test_eventlist.c
===================================================================
--- a/dmapi/src/suite2/src/test_eventlist.c
+++ b/dmapi/src/suite2/src/test_eventlist.c
@@ -93,7 +93,8 @@ main(
 	void           *test_vp;
 	u_int           nelemp;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite2/src/test_fileattr.c
===================================================================
--- a/dmapi/src/suite2/src/test_fileattr.c
+++ b/dmapi/src/suite2/src/test_fileattr.c
@@ -123,7 +123,7 @@ comp_stat ( dm_stat_t expected,
    if (found.dt_size != expected.dt_size) {
      fprintf(stderr, 
 	     "ERROR: get #%d, expected size %lld, but found %lld\n",
-	     i, expected.dt_size, found.dt_size);
+	     i, (long long) expected.dt_size, (long long) found.dt_size);
    }
    else good++;
    if (Vflag){
@@ -183,7 +183,8 @@ main(
 	char            *chk_name_p;
 	int             chk_num;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -405,7 +406,8 @@ main(
 	    }
 	    else {
 	      /* Put JUST name (not path) from check_name into chk_name_p */
-	      if (chk_name_p = strrchr(check_name, '/')) chk_name_p++;
+	      chk_name_p = strrchr(check_name, '/');
+	      if (chk_name_p) chk_name_p++;
 	      else chk_name_p = check_name;
 	      /* Verify that check_name_p holds a testfile name */
 	      if (strncmp(chk_name_p, "DMAPI_fileattr_test.",20)==0) {
@@ -679,7 +681,7 @@ main(
 	     ERRTEST(EFAULT, "get_bulk (bad rlenp)", 
 		     dm_get_bulkattr(sid, fs_hanp, fs_hlen, DM_NO_TOKEN,
 				     GET_MASK, &loc, buflen, bufp,
-				     (u_int*)(-1000)))
+				     (size_t *) (-1000)))
 	     ERRTEST(EFAULT, "get_bulk (bad bufp)",
 		     dm_get_bulkattr(sid, fs_hanp, fs_hlen, DM_NO_TOKEN,
 				     GET_MASK, &loc, buflen, p, &rlen))
Index: b/dmapi/src/suite2/src/test_hole.c
===================================================================
--- a/dmapi/src/suite2/src/test_hole.c
+++ b/dmapi/src/suite2/src/test_hole.c
@@ -90,7 +90,8 @@ main(
 	struct stat    checkbuf;
 
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite2/src/test_invis.c
===================================================================
--- a/dmapi/src/suite2/src/test_invis.c
+++ b/dmapi/src/suite2/src/test_invis.c
@@ -102,7 +102,8 @@ main(
 	int		cont;
 	int		error_reported;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -180,7 +181,8 @@ main(
 	      if(curlength>0)
 		free(bufp);
 	      if ((bufp = malloc(length)) == NULL) {
-		fprintf(stderr, "malloc of %llu bytes failed\n", length);
+		fprintf(stderr, "malloc of %llu bytes failed\n",
+			(unsigned long long) length);
 		continue;
 	      }
 	      curlength = length;
@@ -195,7 +197,7 @@ main(
 	      cont=1;
 	    } else if (rc != length) {
 	      fprintf(stderr, "expected to write %lld bytes, actually "
-		      "wrote %lld\n", length, rc);
+		      "wrote %lld\n", (long long) length, (long long) rc);
 	      cont=1;
 	    }
 	    if(cont)
@@ -238,7 +240,7 @@ main(
 	    } 
 	    else if (rc != length) {
 	      fprintf(stderr, "expected to read %lld bytes, actually "
-		      "wrote %lld\n", length, rc);
+		      "wrote %lld\n", (long long) length, (long long) rc);
 	      continue;
 	    }
 	    else {
Index: b/dmapi/src/suite2/src/test_region.c
===================================================================
--- a/dmapi/src/suite2/src/test_region.c
+++ b/dmapi/src/suite2/src/test_region.c
@@ -95,7 +95,8 @@ main(
 	int             Vflag = 0;
 	dm_token_t	test_token = DM_NO_TOKEN;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/suite2/src/test_rights.c
===================================================================
--- a/dmapi/src/suite2/src/test_rights.c
+++ b/dmapi/src/suite2/src/test_rights.c
@@ -91,7 +91,8 @@ main(int argc, char **argv) {
 	int		opt;
 	int             i=0;
 
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
