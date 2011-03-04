Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24JZ5Sr184578 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 13:35:05 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103041937.p24Jbudi004842@stout.americas.sgi.com>
Date: Fri, 04 Mar 2011 13:37:56 -0600
Subject: [PATCH 1/5] xfstests: eliminate some warnings under dmapi/src
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
dmapi/src/common/cmd/, dmapi/src/common/lib/ dmapi/src/sample_hsm/
and dmapi/src/simple/.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 dmapi/src/common/cmd/read_invis.c            |   21 +++++---
 dmapi/src/common/cmd/set_region.c            |    3 -
 dmapi/src/common/cmd/set_return_on_destroy.c |    3 -
 dmapi/src/common/cmd/write_invis.c           |   19 +++++--
 dmapi/src/common/lib/find_session.c          |    8 +--
 dmapi/src/common/lib/print.c                 |   16 +++---
 dmapi/src/common/lib/util.c                  |   68 ++++++++++++---------------
 dmapi/src/sample_hsm/migfind.c               |    6 +-
 dmapi/src/sample_hsm/mls.c                   |    8 +--
 dmapi/src/simple/dm_find_eventmsg.c          |    4 -
 dmapi/src/simple/dm_query_session.c          |    2 
 11 files changed, 85 insertions(+), 73 deletions(-)

Index: b/dmapi/src/common/cmd/read_invis.c
===================================================================
--- a/dmapi/src/common/cmd/read_invis.c
+++ b/dmapi/src/common/cmd/read_invis.c
@@ -73,7 +73,9 @@ main(
 	dm_sessid_t	sid = DM_NO_SESSION;
 	char		*object = NULL;
 	dm_off_t	offset = 0;
+	long long	lltemp;
 	dm_size_t	length = 1;
+	unsigned long long	ulltemp;
 	char		*bufp = NULL;
 	void		*hanp;
 	size_t		hlen;
@@ -82,10 +84,11 @@ main(
 	int		opt;
 	int		i;
 	char		*storefile = NULL;
-	int		storefd;
+	int		storefd = 0;
 	int		exit_status = 0;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -96,10 +99,12 @@ main(
 	while ((opt = getopt(argc, argv, "o:l:s:c:S:")) != EOF) {
 		switch (opt) {
 		case 'o':
-			sscanf(optarg, "%lld", &offset);
+			sscanf(optarg, "%lld", &lltemp);
+			offset = (dm_off_t) lltemp;
 			break;
 		case 'l':
-			sscanf(optarg, "%llu", &length);
+			sscanf(optarg, "%llu", &ulltemp);
+			length = (dm_size_t) ulltemp;
 			break;
 		case 's':
 			sid = atol(optarg);
@@ -141,7 +146,8 @@ main(
 		   sufficiently big boundary.
 		*/
 		if ((bufp = memalign(4096, length)) == NULL) {
-			fprintf(stderr, "malloc of %llu bytes failed\n", length);
+			fprintf(stderr, "malloc of %llu bytes failed\n",
+				(unsigned long long) length);
 			exit(1);
 		}
 		memset(bufp, '\0', length);
@@ -168,8 +174,9 @@ main(
 		fprintf(stderr, "dm_read_invis failed, %s\n", strerror(errno));
 		exit_status++;
 	} else if (rc != length) {
-		fprintf(stderr, "dm_read_invis expected to read %lld bytes, actually "
-			"read %lld\n", length, rc);
+		fprintf(stderr, "dm_read_invis expected to read %llu bytes, actually "
+			"read %lld\n", (unsigned long long) length,
+			(long long) rc);
 		exit_status++;
 	}
 
Index: b/dmapi/src/common/cmd/set_region.c
===================================================================
--- a/dmapi/src/common/cmd/set_region.c
+++ b/dmapi/src/common/cmd/set_region.c
@@ -86,7 +86,8 @@ main(
 	int		opt;
 	int		i;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/common/cmd/set_return_on_destroy.c
===================================================================
--- a/dmapi/src/common/cmd/set_return_on_destroy.c
+++ b/dmapi/src/common/cmd/set_return_on_destroy.c
@@ -70,7 +70,8 @@ main(
 	int		opt;
 	int		Fflag = 0;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
Index: b/dmapi/src/common/cmd/write_invis.c
===================================================================
--- a/dmapi/src/common/cmd/write_invis.c
+++ b/dmapi/src/common/cmd/write_invis.c
@@ -71,7 +71,9 @@ main(
 	dm_sessid_t	sid = DM_NO_SESSION;
 	char		*object = NULL;
 	dm_off_t	offset = 0;
+	long long	lltemp;
 	dm_size_t	length = 1;
+	unsigned long long	ulltemp;
 	u_char		ch = 'X';
 	void		*bufp = NULL;
 	void		*hanp;
@@ -83,7 +85,8 @@ main(
 	int		storefd;
 	int		exit_status = 0;
 
-	if (Progname = strrchr(argv[0], '/')) {
+	Progname = strrchr(argv[0], '/');
+	if (Progname) {
 		Progname++;
 	} else {
 		Progname = argv[0];
@@ -97,10 +100,12 @@ main(
 			ch = *optarg;
 			break;
 		case 'o':
-			sscanf(optarg, "%lld", &offset);
+			sscanf(optarg, "%lld", &lltemp);
+			offset = (dm_off_t) offset;
 			break;
 		case 'l':
-			sscanf(optarg, "%llu", &length);
+			sscanf(optarg, "%llu", &ulltemp);
+			length = (dm_size_t) ulltemp;
 			break;
 		case 's':
 			sid = atol(optarg);
@@ -135,7 +140,8 @@ main(
 		   sufficiently big boundary.
 		*/
 		if ((bufp = memalign(4096, length)) == NULL) {
-			fprintf(stderr, "malloc of %llu bytes failed\n", length);
+			fprintf(stderr, "malloc of %llu bytes failed\n",
+				(unsigned long long) length);
 			exit(1);
 		}
 		memset(bufp, ch, length);
@@ -170,8 +176,9 @@ main(
 		fprintf(stderr, "dm_write_invis failed, %s\n", strerror(errno));
 		exit_status++;
 	} else if (rc != length) {
-		fprintf(stderr, "dm_write_invis expected to write %lld bytes, actually "
-			"wrote %lld\n", length, rc);
+		fprintf(stderr, "dm_write_invis expected to write %llu bytes, "
+			"actually wrote %lld\n",
+			(unsigned long long) length, (long long)rc);
 		exit_status++;
 	}
 	dm_handle_free(hanp, hlen);
Index: b/dmapi/src/common/lib/find_session.c
===================================================================
--- a/dmapi/src/common/lib/find_session.c
+++ b/dmapi/src/common/lib/find_session.c
@@ -81,8 +81,8 @@ find_test_session(
 			allocelem = nelem;
 			sidbuf = realloc(sidbuf, nelem * sizeof(*sidbuf));
 			if (sidbuf == NULL) {
-				fprintf(stderr, "realloc of %d bytes failed\n",
-					nelem * sizeof(*sidbuf));
+				fprintf(stderr, "realloc of %lu bytes failed\n",
+					(unsigned long) nelem * sizeof(*sidbuf));
 				exit(1);
 			}
 		}
@@ -142,8 +142,8 @@ find_test_session(
 			allocelem = nelem;
 			sidbuf = realloc(sidbuf, nelem * sizeof(*sidbuf));
 			if (sidbuf == NULL) {
-				fprintf(stderr, "realloc of %d bytes failed\n",
-					nelem * sizeof(*sidbuf));
+				fprintf(stderr, "realloc of %lu bytes failed\n",
+					(unsigned long) nelem * sizeof(*sidbuf));
 				exit(1);
 			}
 		}
Index: b/dmapi/src/common/lib/print.c
===================================================================
--- a/dmapi/src/common/lib/print.c
+++ b/dmapi/src/common/lib/print.c
@@ -132,31 +132,31 @@ print_one_mount_event(
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
@@ -183,13 +183,13 @@ print_one_data_event(
 	if (hanp && hlen) {
 		hantoa(hanp, hlen, handle);
 	} else {
-		sprintf(handle, "<BAD HANDLE, hlen %d>", hlen);
+		sprintf(handle, "<BAD HANDLE, hlen %zd>", hlen);
 	}
 
 	printf(VALS VALLLD VALLLD,
 		"file_handle",	handle,
-		"offset", msg_de->de_offset,
-		"length", msg_de->de_length);
+		"offset", (long long) msg_de->de_offset,
+		"length", (long long) msg_de->de_length);
 
 	return(0);
 }
Index: b/dmapi/src/common/lib/util.c
===================================================================
--- a/dmapi/src/common/lib/util.c
+++ b/dmapi/src/common/lib/util.c
@@ -234,12 +234,12 @@ print_handle(
 	char	handle_str[HANDLE_STR];
 
 	if (hlen > HANDLE_LEN)  {
-		printf("-- invalid hlen length %d --\n", hlen);
+		printf("-- invalid hlen length %zd --\n", hlen);
 		return;
 	}
 
 	printf("print_handle: ");
-	printf("%d\t", hlen);
+	printf("%zd\t", hlen);
 	hantoa(hanp, hlen, handle_str);
 	printf("%s\n ", handle_str);
 }
@@ -257,10 +257,10 @@ print_victim(
 		return;
 	}
 
-	printf("%d\t", hlen);   
+	printf("%zd\t", hlen);
 	hantoa(hanp, hlen, handle_str);
 	printf("%s ", handle_str);
-	printf("\t%lld \n", fsize);
+	printf("\t%lld \n", (long long) fsize);
 }
 
 
@@ -583,20 +583,17 @@ validate_state(
 		if (report_errors) {
 			fprintf(stdout, "ERROR:dmstat->dt_dev 0x%llx, "
 				"statb.st_dev 0x%llx\n",
-				(uint64_t)dmstat->dt_dev,
-				(uint64_t)statb.st_dev);
+				(unsigned long long) dmstat->dt_dev,
+				(unsigned long long) statb.st_dev);
 		}
 		errors++;
 	}
 	if (dmstat->dt_ino != statb.st_ino) {
 		if (report_errors) {
 			fprintf(stdout, "ERROR:dmstat->dt_ino %llx, "
-#if	defined(linux) || (defined(__sgi) && (_MIPS_SIM != _MIPS_SIM_ABI32))
 				"statb.st_ino %llx\n",
-#else
-				"statb.st_ino %x\n",
-#endif
-				dmstat->dt_ino, statb.st_ino);
+				(unsigned long long) dmstat->dt_ino,
+				(unsigned long long) statb.st_ino);
 		}
 		errors++;
 	}
@@ -620,9 +617,10 @@ validate_state(
 	}
 	if (dmstat->dt_nlink != statb.st_nlink) {
 		if (report_errors) {
-			fprintf(stdout, "ERROR:dmstat->dt_nlink %d, "
-				"statb.st_nlink %d\n", dmstat->dt_nlink,
-				statb.st_nlink);
+			fprintf(stdout, "ERROR:dmstat->dt_nlink %u, "
+				"statb.st_nlink %u\n",
+				(unsigned int) dmstat->dt_nlink,
+				(unsigned int) statb.st_nlink);
 		}
 		errors++;
 	}
@@ -646,20 +644,17 @@ validate_state(
 		if (report_errors) {
 			fprintf(stdout, "ERROR:dmstat->dt_rdev 0x%llx, "
 				"statb.st_rdev 0x%llx\n",
-				(uint64_t)dmstat->dt_rdev,
-				(uint64_t)statb.st_rdev);
+				(unsigned long long) dmstat->dt_rdev,
+				(unsigned long long) statb.st_rdev);
 		}
 		errors++;
 	}
 	if (dmstat->dt_size != statb.st_size) {
 		if (report_errors) {
 			fprintf(stdout, "ERROR:dmstat->dt_size %lld, "
-#if defined(linux) || (defined(__sgi) && (_MIPS_SIM != _MIPS_SIM_ABI32))
 				"statb.st_size %lld\n",
-#else
-				"statb.st_size %d\n",
-#endif
-				dmstat->dt_size, statb.st_size);
+				(long long) dmstat->dt_size,
+				(long long) statb.st_size);
 		}
 		errors++;
 	}
@@ -706,12 +701,9 @@ validate_state(
 	if (dmstat->dt_blocks != statb.st_blocks) {
 		if (report_errors) {
 			fprintf(stdout, "ERROR:dmstat->dt_blocks %lld, "
-#if defined(linux) || (defined(__sgi) && (_MIPS_SIM != _MIPS_SIM_ABI32))
 				"statb.st_blocks %lld\n",
-#else
-				"statb.st_blocks %d\n",
-#endif
-				dmstat->dt_blocks, statb.st_blocks);
+				(long long) dmstat->dt_blocks,
+				(long long) statb.st_blocks);
 		}
 		errors++;
 	}
@@ -896,16 +888,20 @@ print_state(
 {
 	/* Print all the stat block fields. */
 
-	fprintf(stdout, "dt_dev         0x%llx\n",  (uint64_t)dmstat->dt_dev);
-	fprintf(stdout, "dt_ino         %llx\n",  dmstat->dt_ino);
+	fprintf(stdout, "dt_dev         0x%llx\n",
+		(unsigned long long) dmstat->dt_dev);
+	fprintf(stdout, "dt_ino         %llx\n",
+		(unsigned long long) dmstat->dt_ino);
 	fprintf(stdout, "dt_mode (type) %s\n",
 		mode_to_string(dmstat->dt_mode));
 	fprintf(stdout, "dt_mode (perm) 0%o\n", dmstat->dt_mode & S_MASK);
 	fprintf(stdout, "dt_nlink       %d\n",  dmstat->dt_nlink);
 	fprintf(stdout, "dt_uid         %d\n",  dmstat->dt_uid);
 	fprintf(stdout, "dt_gid         %d\n", dmstat->dt_gid);
-	fprintf(stdout, "dt_rdev        0x%llx\n", (uint64_t)dmstat->dt_rdev);
-	fprintf(stdout, "dt_size        %lld\n", dmstat->dt_size);
+	fprintf(stdout, "dt_rdev        0x%llx\n",
+		(unsigned long long) dmstat->dt_rdev);
+	fprintf(stdout, "dt_size        %lld\n",
+		(unsigned long long) dmstat->dt_size);
 
 	fprintf(stdout, "dt_atime       %s\n",
 		date_to_string(dmstat->dt_atime));
@@ -915,7 +911,7 @@ print_state(
 		date_to_string(dmstat->dt_ctime));
 
 	fprintf(stdout, "dt_blksize     %d\n", dmstat->dt_blksize);
-	fprintf(stdout, "dt_blocks      %lld\n", dmstat->dt_blocks);
+	fprintf(stdout, "dt_blocks      %lld\n", (long long) dmstat->dt_blocks);
 
 #if defined(__sgi) || defined(linux)
 	fprintf(stdout, "dt_xfs_igen    %d\n",  dmstat->dt_xfs_igen);
@@ -945,22 +941,22 @@ extern void
 print_line(
 	dm_stat_t	*dmstat)
 {
-	fprintf(stdout, "0x%llx|",  (uint64_t)dmstat->dt_dev);
-	fprintf(stdout, "%llx|",  dmstat->dt_ino);
+	fprintf(stdout, "0x%llx|",  (unsigned long long) dmstat->dt_dev);
+	fprintf(stdout, "%llx|",  (unsigned long long) dmstat->dt_ino);
 	fprintf(stdout, "%s|", mode_to_string(dmstat->dt_mode));
 	fprintf(stdout, "0%o|", dmstat->dt_mode & S_MASK);
 	fprintf(stdout, "%d|",  dmstat->dt_nlink);
 	fprintf(stdout, "%d|",  dmstat->dt_uid);
 	fprintf(stdout, "%d|", dmstat->dt_gid);
-	fprintf(stdout, "0x%llx|", (uint64_t)dmstat->dt_rdev);
-	fprintf(stdout, "%lld|", dmstat->dt_size);
+	fprintf(stdout, "0x%llx|", (unsigned long long) dmstat->dt_rdev);
+	fprintf(stdout, "%lld|", (long long) dmstat->dt_size);
 
 	fprintf(stdout, "%s|", date_to_string(dmstat->dt_atime));
 	fprintf(stdout, "%s|", date_to_string(dmstat->dt_mtime));
 	fprintf(stdout, "%s|", date_to_string(dmstat->dt_ctime));
 
 	fprintf(stdout, "%d|", dmstat->dt_blksize);
-	fprintf(stdout, "%lld|", dmstat->dt_blocks);
+	fprintf(stdout, "%lld|", (long long) dmstat->dt_blocks);
 
 	fprintf(stdout, "%d|",  dmstat->dt_xfs_igen);
 	fprintf(stdout, "%s|", xflags_to_string(dmstat->dt_xfs_xflags));
Index: b/dmapi/src/sample_hsm/migfind.c
===================================================================
--- a/dmapi/src/sample_hsm/migfind.c
+++ b/dmapi/src/sample_hsm/migfind.c
@@ -78,7 +78,7 @@ verify_size(
 
         size = strtol(str,0,0); 
         if (size < 0 || size >= LONG_MAX ) {
-                printf("Size %lld is invalid \n", size);
+                printf("Size %lld is invalid \n", (long long) size);
                 return(1);
         }
 
@@ -87,13 +87,13 @@ verify_size(
                 cp++;
         if (*cp == 'k' || *cp == 'K') {
                 if ( size >= (u_int) MAX_K) {
-                        printf("Size %lld is invalid\n", size);
+                        printf("Size %lld is invalid\n", (long long) size);
                         return(1);
                 }
                 size *= 1024;
         } else if (*cp == 'm' || *cp == 'M') {
                 if ( size >= (u_int) MAX_M) {
-                        printf("Size %lld is invalid\n", size);
+                        printf("Size %lld is invalid\n", (long long) size);
                         return(1);
                 }
                 size *= (1024*1024);
Index: b/dmapi/src/sample_hsm/mls.c
===================================================================
--- a/dmapi/src/sample_hsm/mls.c
+++ b/dmapi/src/sample_hsm/mls.c
@@ -183,8 +183,8 @@ mr_info(
 	printf("\n");
 	for (i=0; i<ret; i++) {
 		printf("\tRegion %d:\n", i);
-		printf("\t\toffset %lld, ", rgn[i].rg_offset);
-		printf("size %lld, ", rgn[i].rg_size);
+		printf("\t\toffset %lld, ", (long long) rgn[i].rg_offset);
+		printf("size %llu, ", (unsigned long long) rgn[i].rg_size);
 		printf("flags 0x%x", rgn[i].rg_flags);
 		printf(" ( ");
 		if (rgn[i].rg_flags & DM_REGION_NOEVENT)
@@ -312,8 +312,8 @@ alloc_info(
 				printf("(resident): ");
 			if (ext[i].ex_type == DM_EXTENT_HOLE)
 				printf("(hole): ");
-			printf("offset %lld, ", ext[i].ex_offset);
-			printf("len %lld\n", ext[i].ex_length);
+			printf("offset %lld, ", (long long) ext[i].ex_offset);
+			printf("len %llu\n", (unsigned long long) ext[i].ex_length);
 		}
 	} while (more == 1);
 	return(0);
Index: b/dmapi/src/simple/dm_find_eventmsg.c
===================================================================
--- a/dmapi/src/simple/dm_find_eventmsg.c
+++ b/dmapi/src/simple/dm_find_eventmsg.c
@@ -51,7 +51,7 @@ main( int argc, char **argv )
 			buflen = atoi( optarg );
 			break;
 		case 'q':
-			printf("dm_eventmsg_t=%d\n", sizeof(dm_eventmsg_t) );
+			printf("dm_eventmsg_t=%zd\n", sizeof(dm_eventmsg_t) );
 			exit(0);
 		case 'h':
 			fprintf(stderr, "Usage: %s <-s sid> <-t token> [-l buflen]\n", argv[0]);
@@ -75,6 +75,6 @@ main( int argc, char **argv )
 
 	ret = dm_find_eventmsg( sid, token, buflen, &msg, &rlen );
 	printf( "ret=%d\n", ret );
-	printf( "rlen=%d\n", rlen );
+	printf( "rlen=%zd\n", rlen );
 	exit(0);
 }
Index: b/dmapi/src/simple/dm_query_session.c
===================================================================
--- a/dmapi/src/simple/dm_query_session.c
+++ b/dmapi/src/simple/dm_query_session.c
@@ -67,7 +67,7 @@ main( int argc, char **argv )
 
 	ret = dm_query_session( sid, buflen, sessinfo, &rlen );
 	printf( "ret=%d\n", ret );
-	printf( "rlen=%d\n", rlen );
+	printf( "rlen=%zd\n", rlen );
 	if( ret != -1 )
 		printf( "sessinfo=%s\n", sessinfo );
 	exit(0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
