Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9EEqirF024491 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 09:52:44 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B60E1304077
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 07:53:51 -0700 (PDT)
Subject: [PATCH 04/11] xfstests: randholes: rearrange fns and drop their
	declarations
From: Alex Elder <aelder@sgi.com>
Date: Thu, 14 Oct 2010 09:50:08 -0500
Message-ID: <1287067808.2362.216.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

Rearrange the functions in the file so they no longer need to be
declared at the top.  (This change involves only wholesale moves
of these blocks of code.)

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 src/randholes.c |  371 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 183 insertions(+), 188 deletions(-)

Index: b/src/randholes.c
===================================================================
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -46,12 +46,6 @@ struct fsxattr rtattr;
 
 #define	READ_XFER	10	/* block to read at a time when checking */
 
-void usage(char *progname);
-int findblock(void);
-void writeblks(char *fname, int fd);
-int readblks(int fd);
-void dumpblock(int *buffer, __uint64_t offset, int blocksize);
-
 void
 usage(char *progname)
 {
@@ -72,171 +66,36 @@ usage(char *progname)
 }
 
 int
-main(int argc, char *argv[])
+findblock(void)
 {
-	int seed, ch, fd, oflags;
-	char *filename = NULL;
-        int r;
+	int block, numblocks;
 
-	filesize = DEFAULT_FILESIZE;
-	blocksize = DEFAULT_BLOCKSIZE;
-	count = (int) filesize / blocksize;
-	verbose = 0;
-	wsync = 0;
-	seed = time(NULL);
-        test = 0;
-	while ((ch = getopt(argc, argv, "b:l:s:c:o:x:vwdrapt")) != EOF) {
-		switch(ch) {
-		case 'b':	blocksize  = atoi(optarg);	break;
-		case 'l':	filesize   = strtoull(optarg, NULL, 16); break;
-		case 's':	seed       = atoi(optarg);	break;
-		case 'c':	count      = atoi(optarg);	break;
-		case 'o':	fileoffset = strtoull(optarg, NULL, 16); break;
-		case 'x':	extsize    = atoi(optarg);	break;
-		case 'v':	verbose++;			break;
-		case 'w':	wsync++;			break;
-		case 'd':	direct++;			break;
-		case 'r':	rt++;				break;
-		case 'a':	alloconly++;			break;
-		case 'p':	preserve++;			break;
-                case 't':       test++; preserve++;             break;
-		default:	usage(argv[0]);			break;
-		}
-	}
-	if (optind == argc-1)
-		filename = argv[optind];
-	else
-		usage(argv[0]);
-	if ((filesize % blocksize) != 0) {
-		filesize -= filesize % blocksize;
-		printf("filesize not a multiple of blocksize, reducing filesize to %llu\n",
-		       (unsigned long long)filesize);
-	}
-	if ((fileoffset % blocksize) != 0) {
-		fileoffset -= fileoffset % blocksize;
-		printf("fileoffset not a multiple of blocksize, reducing fileoffset to %llu\n",
-		       (unsigned long long)fileoffset);
-	}
-	if (count > (filesize/blocksize)) {
-		count = (filesize/blocksize);
-		printf("count of blocks written is too large, setting to %d\n",
-			      count);
-	} else if (count < 1) {
-		count = 1;
-		printf("count of blocks written is too small, setting to %d\n",
-			      count);
-	}
-	printf("randholes: Seed = %d (use \"-s %d\" to re-execute this test)\n", seed, seed);
-	srandom(seed);
-        
-        printf("randholes: blocksize=%d, filesize=%llu, seed=%d\n"
-               "randholes: count=%d, offset=%llu, extsize=%d\n",
-                blocksize, (unsigned long long)filesize, seed,
-	       count, (unsigned long long)fileoffset, extsize);
-        printf("randholes: verbose=%d, wsync=%d, direct=%d, rt=%d, alloconly=%d, preserve=%d, test=%d\n",
-                verbose, wsync, direct, rt, alloconly, preserve, test);
-        
-	/*
-	 * Open the file, write rand block in random places, read them all
-	 * back to check for correctness, then close the file.
-	 */
-	nvalid = (filesize / blocksize) / 8 + 1;
-	if ((valid = (unsigned char *)calloc(1, (unsigned)nvalid)) == NULL) {
-		perror("malloc");
-		return 1;
-	}
-	if (rt)
-		direct++;
-        
-        oflags=test?(O_RDONLY):(O_RDWR | O_CREAT);
-	oflags |=   (preserve ? 0 : O_TRUNC) |
-		    (wsync ? O_SYNC : 0) |
-		    (direct ? O_DIRECT : 0);
-        
-	if ((fd = open(filename, oflags, 0666)) < 0) {
-		perror("open");
-		return 1;
-	}
+	numblocks = filesize / blocksize;
+	block = random() % numblocks;
+	if (BITVAL(valid, block) == 0)
+		return(block);
 
-	if (rt) {
-#ifdef XFS_IOC_FSGETXATTR
-		if (xfsctl(filename, fd, XFS_IOC_FSGETXATTR, &rtattr) < 0) {
-			perror("xfsctl(XFS_IOC_FSGETXATTR)");
-			return 1;
-		}
-		if ((rtattr.fsx_xflags & XFS_XFLAG_REALTIME) == 0 ||
-		    (extsize && rtattr.fsx_extsize != extsize * blocksize)) {
-			rtattr.fsx_xflags |= XFS_XFLAG_REALTIME;
-			if (extsize)
-				rtattr.fsx_extsize = extsize * blocksize;
-			if (xfsctl(filename, fd, XFS_IOC_FSSETXATTR, &rtattr) < 0) {
-				perror("xfsctl(XFS_IOC_FSSETXATTR)");
-				return 1;
-			}
-		}
-#else
-#ifdef F_FSGETXATTR
-                if (fcntl(fd, F_FSGETXATTR, &rtattr) < 0) {
-                        perror("fcntl(F_FSGETXATTR)");
-                        return 1;
-                }
-                if ((rtattr.fsx_xflags & XFS_XFLAG_REALTIME) == 0 ||
-                    (extsize && rtattr.fsx_extsize != extsize * blocksize)) {
-                        rtattr.fsx_xflags |= XFS_XFLAG_REALTIME;
-                        if (extsize)
-                                rtattr.fsx_extsize = extsize * blocksize;
-                        if (fcntl(fd, F_FSSETXATTR, &rtattr) < 0) {
-                                perror("fcntl(F_FSSETXATTR)");
-                                return 1;
-                        }
-                }
-#else
-bozo!
-#endif
-#endif
+	for (  ; BITVAL(valid, block) != 0; block++) {
+		if (block == (numblocks-1))
+			block = -1;
 	}
+	if (block == -1)
+		printf("returning block -1\n");
+	return(block);
+}
 
-	if (direct) {
-#ifdef XFS_IOC_DIOINFO
-		if (xfsctl(filename, fd, XFS_IOC_DIOINFO, &diob) < 0) {
-			perror("xfsctl(XFS_IOC_FIOINFO)");
-			return 1;
-		}
-#else
-#ifdef F_DIOINFO
-                if (fcntl(fd, F_DIOINFO, &diob) < 0) {
-                        perror("fcntl(F_FIOINFO)");
-                        return 1;
-                }
-#else
-bozo!
-#endif
-#endif
-		if (blocksize % diob.d_miniosz) {
-			fprintf(stderr,
-				"blocksize %d must be a multiple of %d for direct I/O\n",
-				blocksize,
-				diob.d_miniosz);
-			return 1;
-		}
-	}
-        printf(test?"write (skipped)\n":"write\n");
-	writeblks(filename, fd);
-        printf("readback\n");
-	r=readblks(fd);
-	if (close(fd) < 0) {
-		perror("close");
-		return 1;
+void
+dumpblock(int *buffer, __uint64_t offset, int blocksize)
+{
+	int	i;
+
+	for (i = 0; i < (blocksize / 16); i++) {
+		printf("%llx: 0x%08x 0x%08x 0x%08x 0x%08x\n",
+		       (unsigned long long)offset, *buffer, *(buffer + 1), *(buffer + 2),
+		       *(buffer + 3));
+		offset += 16;
+		buffer += 4;
 	}
-	free(valid);
-        
-        if (r) {
-            printf("randholes: %d errors found during readback\n", r);
-            return 2;
-        } else {
-            printf("randholes: ok\n");
-            return 0;
-        }
 }
 
 void
@@ -407,34 +266,170 @@ readblks(int fd)
 }
 
 int
-findblock(void)
+main(int argc, char *argv[])
 {
-	int block, numblocks;
+	int seed, ch, fd, oflags;
+	char *filename = NULL;
+        int r;
 
-	numblocks = filesize / blocksize;
-	block = random() % numblocks;
-	if (BITVAL(valid, block) == 0)
-		return(block);
+	filesize = DEFAULT_FILESIZE;
+	blocksize = DEFAULT_BLOCKSIZE;
+	count = (int) filesize / blocksize;
+	verbose = 0;
+	wsync = 0;
+	seed = time(NULL);
+        test = 0;
+	while ((ch = getopt(argc, argv, "b:l:s:c:o:x:vwdrapt")) != EOF) {
+		switch(ch) {
+		case 'b':	blocksize  = atoi(optarg);	break;
+		case 'l':	filesize   = strtoull(optarg, NULL, 16); break;
+		case 's':	seed       = atoi(optarg);	break;
+		case 'c':	count      = atoi(optarg);	break;
+		case 'o':	fileoffset = strtoull(optarg, NULL, 16); break;
+		case 'x':	extsize    = atoi(optarg);	break;
+		case 'v':	verbose++;			break;
+		case 'w':	wsync++;			break;
+		case 'd':	direct++;			break;
+		case 'r':	rt++;				break;
+		case 'a':	alloconly++;			break;
+		case 'p':	preserve++;			break;
+                case 't':       test++; preserve++;             break;
+		default:	usage(argv[0]);			break;
+		}
+	}
+	if (optind == argc-1)
+		filename = argv[optind];
+	else
+		usage(argv[0]);
+	if ((filesize % blocksize) != 0) {
+		filesize -= filesize % blocksize;
+		printf("filesize not a multiple of blocksize, reducing filesize to %llu\n",
+		       (unsigned long long)filesize);
+	}
+	if ((fileoffset % blocksize) != 0) {
+		fileoffset -= fileoffset % blocksize;
+		printf("fileoffset not a multiple of blocksize, reducing fileoffset to %llu\n",
+		       (unsigned long long)fileoffset);
+	}
+	if (count > (filesize/blocksize)) {
+		count = (filesize/blocksize);
+		printf("count of blocks written is too large, setting to %d\n",
+			      count);
+	} else if (count < 1) {
+		count = 1;
+		printf("count of blocks written is too small, setting to %d\n",
+			      count);
+	}
+	printf("randholes: Seed = %d (use \"-s %d\" to re-execute this test)\n", seed, seed);
+	srandom(seed);
 
-	for (  ; BITVAL(valid, block) != 0; block++) {
-		if (block == (numblocks-1))
-			block = -1;
+        printf("randholes: blocksize=%d, filesize=%llu, seed=%d\n"
+               "randholes: count=%d, offset=%llu, extsize=%d\n",
+                blocksize, (unsigned long long)filesize, seed,
+	       count, (unsigned long long)fileoffset, extsize);
+        printf("randholes: verbose=%d, wsync=%d, direct=%d, rt=%d, alloconly=%d, preserve=%d, test=%d\n",
+                verbose, wsync, direct, rt, alloconly, preserve, test);
+
+	/*
+	 * Open the file, write rand block in random places, read them all
+	 * back to check for correctness, then close the file.
+	 */
+	nvalid = (filesize / blocksize) / 8 + 1;
+	if ((valid = (unsigned char *)calloc(1, (unsigned)nvalid)) == NULL) {
+		perror("malloc");
+		return 1;
 	}
-	if (block == -1)
-		printf("returning block -1\n");
-	return(block);
-}
+	if (rt)
+		direct++;
 
-void
-dumpblock(int *buffer, __uint64_t offset, int blocksize)
-{
-	int	i;
+        oflags=test?(O_RDONLY):(O_RDWR | O_CREAT);
+	oflags |=   (preserve ? 0 : O_TRUNC) |
+		    (wsync ? O_SYNC : 0) |
+		    (direct ? O_DIRECT : 0);
 
-	for (i = 0; i < (blocksize / 16); i++) {
-		printf("%llx: 0x%08x 0x%08x 0x%08x 0x%08x\n",
-		       (unsigned long long)offset, *buffer, *(buffer + 1), *(buffer + 2),
-		       *(buffer + 3));
-		offset += 16;
-		buffer += 4;
+	if ((fd = open(filename, oflags, 0666)) < 0) {
+		perror("open");
+		return 1;
+	}
+
+	if (rt) {
+#ifdef XFS_IOC_FSGETXATTR
+		if (xfsctl(filename, fd, XFS_IOC_FSGETXATTR, &rtattr) < 0) {
+			perror("xfsctl(XFS_IOC_FSGETXATTR)");
+			return 1;
+		}
+		if ((rtattr.fsx_xflags & XFS_XFLAG_REALTIME) == 0 ||
+		    (extsize && rtattr.fsx_extsize != extsize * blocksize)) {
+			rtattr.fsx_xflags |= XFS_XFLAG_REALTIME;
+			if (extsize)
+				rtattr.fsx_extsize = extsize * blocksize;
+			if (xfsctl(filename, fd, XFS_IOC_FSSETXATTR, &rtattr) < 0) {
+				perror("xfsctl(XFS_IOC_FSSETXATTR)");
+				return 1;
+			}
+		}
+#else
+#ifdef F_FSGETXATTR
+                if (fcntl(fd, F_FSGETXATTR, &rtattr) < 0) {
+                        perror("fcntl(F_FSGETXATTR)");
+                        return 1;
+                }
+                if ((rtattr.fsx_xflags & XFS_XFLAG_REALTIME) == 0 ||
+                    (extsize && rtattr.fsx_extsize != extsize * blocksize)) {
+                        rtattr.fsx_xflags |= XFS_XFLAG_REALTIME;
+                        if (extsize)
+                                rtattr.fsx_extsize = extsize * blocksize;
+                        if (fcntl(fd, F_FSSETXATTR, &rtattr) < 0) {
+                                perror("fcntl(F_FSSETXATTR)");
+                                return 1;
+                        }
+                }
+#else
+bozo!
+#endif
+#endif
 	}
+
+	if (direct) {
+#ifdef XFS_IOC_DIOINFO
+		if (xfsctl(filename, fd, XFS_IOC_DIOINFO, &diob) < 0) {
+			perror("xfsctl(XFS_IOC_FIOINFO)");
+			return 1;
+		}
+#else
+#ifdef F_DIOINFO
+                if (fcntl(fd, F_DIOINFO, &diob) < 0) {
+                        perror("fcntl(F_FIOINFO)");
+                        return 1;
+                }
+#else
+bozo!
+#endif
+#endif
+		if (blocksize % diob.d_miniosz) {
+			fprintf(stderr,
+				"blocksize %d must be a multiple of %d for direct I/O\n",
+				blocksize,
+				diob.d_miniosz);
+			return 1;
+		}
+	}
+        printf(test?"write (skipped)\n":"write\n");
+	writeblks(filename, fd);
+        printf("readback\n");
+	r=readblks(fd);
+	if (close(fd) < 0) {
+		perror("close");
+		return 1;
+	}
+	free(valid);
+
+        if (r) {
+            printf("randholes: %d errors found during readback\n", r);
+            return 2;
+        } else {
+            printf("randholes: ok\n");
+            return 0;
+        }
 }
+


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
