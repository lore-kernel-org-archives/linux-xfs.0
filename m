Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9Dd3v0112041 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 07:39:03 -0600
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3F8DA30404E
	for <xfs@oss.sgi.com>; Fri,  9 Nov 2012 05:41:03 -0800 (PST)
Message-Id: <20121109132714.002714897@sgi.com>
Date: Fri, 09 Nov 2012 07:24:00 -0600
From: rjohnston@sgi.com
Subject: [PATCH 2/3] xfstests: remove unused conditional NO_XFS
References: <20121109132358.256359544@sgi.com>
Content-Disposition: inline;
	filename=xfstests-remove-unused-conditional-NO_XFS.patch
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

This patch removes the unused conditional NO_XFS which was added with
commit 332ee29d1ab7a8690ca8f6d06b0d116e3a4a4f0f: 
  "xfstests updates - rework build to be like other xfs packages ..."

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---
 ltp/doio.c      |   70 --------------------------------------------------------
 ltp/growfiles.c |   20 ----------------
 ltp/iogen.c     |   30 ------------------------
 3 files changed, 120 deletions(-)

Index: b/ltp/doio.c
===================================================================
--- a/ltp/doio.c
+++ b/ltp/doio.c
@@ -37,10 +37,8 @@
 #include <sys/time.h>	/* for delays */
 #include <ctype.h>
 
-#ifndef NO_XFS
 struct io_req;
 int do_xfsctl(struct io_req *);
-#endif
 
 #include "doio.h"
 #include "pattern.h"
@@ -172,11 +170,9 @@ struct fd_cache {
 	int	c_oflags;
 	int	c_fd;
 	long    c_rtc;
-#ifndef NO_XFS
 	int	c_memalign;	/* from xfsctl(XFS_IOC_DIOINFO) */
 	int	c_miniosz;
 	int	c_maxiosz;
-#endif
 	void	*c_memaddr;	/* mmapped address */
 	int	c_memlen;	/* length of above region */
 };
@@ -777,12 +773,10 @@ doio()
 		case LEWRITEA:
 			rval = do_rw(&ioreq);
 			break;
-#ifndef NO_XFS
 		case RESVSP:
 		case UNRESVSP:
 			rval = do_xfsctl(&ioreq);
 			break;
-#endif
 		case FSYNC2:
 		case FDATASYNC:
 			rval = do_sync(&ioreq);
@@ -1056,9 +1050,7 @@ struct io_req	*req;
 {
 	int	    	    	fd, offset, nbytes, oflags, rval;
 	char    	    	*addr, *file;
-#ifndef NO_XFS
 	struct fd_cache		*fdc;
-#endif
 
 	/*
 	 * Initialize common fields - assumes r_oflags, r_file, r_offset, and
@@ -1090,7 +1082,6 @@ struct io_req	*req;
 #define wtob(x)	(x * sizeof(UINT64_T))
 #endif
 
-#ifndef NO_XFS
 	/* get memory alignment for using DIRECT I/O */
 	fdc = alloc_fdcache(file, oflags);
 
@@ -1111,14 +1102,6 @@ struct io_req	*req;
 	} else {
 		addr += random_range(0, wtob(1) - 1, 1, NULL);
 	}
-#else
-	if ((rval = alloc_mem(nbytes + wtob(1) * 2)) < 0) {
-		return rval;
-	}
-
-	addr = Memptr;
-#endif	/* !NO_XFS */
-
 
 	switch (req->r_type) {
 	case READ:
@@ -1167,9 +1150,7 @@ struct io_req	*req;
 	long    	    	offset, woffset = 0;
 	char    	    	*addr, pattern, *file, *msg;
 	struct wlog_rec		wrec;
-#ifndef NO_XFS
 	struct fd_cache		*fdc;
-#endif
 
 	/*
 	 * Misc variable setup
@@ -1206,7 +1187,6 @@ struct io_req	*req;
 	 * Allocate SDS space for backdoor write if desired
 	 */
 
-#ifndef NO_XFS
 	/* get memory alignment for using DIRECT I/O */
 	fdc = alloc_fdcache(file, oflags);
 
@@ -1231,18 +1211,6 @@ struct io_req	*req;
 	if( addr != Memptr )
 		memmove( addr, Memptr, nbytes);
 
-#else /* sgi */
-	if ((rval = alloc_mem(nbytes + wtob(1) * 2)) < 0) {
-		return rval;
-	}
-
-	addr = Memptr;
-
-	(*Data_Fill)(Memptr, nbytes, Pattern, Pattern_Length, 0);
-	if( addr != Memptr )
-		memmove( addr, Memptr, nbytes);
-#endif /* sgi */
-
 	rval = -1;
 	got_lock = 0;
 	logged_write = 0;
@@ -1312,7 +1280,6 @@ struct io_req	*req;
 				     "write() failed:  %s (%d)\n%s\n",
 				     SYSERR, errno,
 				     format_rw(req, fd, addr, -1, Pattern, NULL));
-#ifndef NO_XFS
 			doio_fprintf(stderr,
 				     "write() failed:  %s\n\twrite(%d, %#o, %d)\n\toffset %d, nbytes%%miniou(%d)=%d, oflags=%#o memalign=%d, addr%%memalign=%d\n",
 				     strerror(errno),
@@ -1320,13 +1287,6 @@ struct io_req	*req;
 				     offset,
 				     fdc->c_miniosz, nbytes%fdc->c_miniosz,
 				     oflags, fdc->c_memalign, (long)addr%fdc->c_memalign);
-#else
-			doio_fprintf(stderr,
-				     "write() failed:  %s\n\twrite(%d, %#o, %d)\n\toffset %d, nbytes%%1B=%d, oflags=%#o\n",
-				     strerror(errno),
-				     fd, addr, nbytes,
-				     offset, nbytes%4096, oflags);
-#endif
 			doio_upanic(U_RVAL);
 		} else if (rval != nbytes) {
 			doio_fprintf(stderr,
@@ -1511,7 +1471,6 @@ fmt_ioreq(struct io_req *ioreq, struct s
 	cp += sprintf(cp, "          memory alignment is %s\n",
 		      (io->r_uflags & F_WORD_ALIGNED) ? "aligned" : "unaligned");
 
-#ifndef NO_XFS
 	if(io->r_oflags & O_DIRECT) {
 		struct dioattr	finfo;
 		
@@ -1531,8 +1490,6 @@ fmt_ioreq(struct io_req *ioreq, struct s
 		cp += sprintf(cp, "          mem alignment 0x%x xfer size: small: %d large: %d\n",
 			      finfo.d_mem, finfo.d_miniosz, finfo.d_maxiosz);
 	}
-#endif
-
 	return(errbuf);
 }
 
@@ -1846,9 +1803,7 @@ do_rw(req)
 	struct status		*s;
 	struct wlog_rec		wrec;
 	struct syscall_info	*sy;
-#ifndef NO_XFS
 	struct fd_cache		*fdc;
-#endif
 
 	/*
 	 * Initialize common fields - assumes r_oflags, r_file, r_offset, and
@@ -1907,18 +1862,12 @@ do_rw(req)
 		mem_needed = nbytes;
 	}
 
-#ifndef NO_XFS
 	/* get memory alignment for using DIRECT I/O */
 	fdc = alloc_fdcache(file, oflags);
 
 	if ((rval = alloc_mem(mem_needed + wtob(1) * 2 + fdc->c_memalign)) < 0) {
 		return rval;
 	}
-#else
-	if ((rval = alloc_mem(mem_needed + wtob(1) * 2)) < 0) {
-		return rval;
-	}
-#endif
 
 	Pattern[0] = pattern;
 
@@ -1945,14 +1894,12 @@ do_rw(req)
 			addr += random_range(0, wtob(1) - 1, 1, NULL);
 		}
 
-#ifndef NO_XFS
 		/*
 		 * Force memory alignment for Direct I/O
 		 */
 		if( (oflags & O_DIRECT) && ((long)addr % fdc->c_memalign != 0) ) {
 			addr += fdc->c_memalign - ((long)addr % fdc->c_memalign);
 		}
-#endif
 
 		/*
 		 * FILL must be done on a word-aligned buffer.
@@ -2141,7 +2088,6 @@ do_rw(req)
  *   - XFS_IOC_RESVSP
  *   - XFS_IOC_UNRESVSP
  */
-#ifndef NO_XFS
 int
 do_xfsctl(req)
 	struct io_req	*req;
@@ -2232,7 +2178,6 @@ do_xfsctl(req)
 
 	return (rval == -1) ? -1 : 0;
 }
-#endif
 
 /*
  *  fsync(2) and fdatasync(2)
@@ -2379,9 +2324,7 @@ int	fsa;
 	static char	errbuf[4096];
 	int	    	fd, nb, flags;
 	char		*buf, *em, *ep;
-#ifndef NO_XFS
 	struct fd_cache *fdc;
-#endif
 
 	buf = Memptr;
 
@@ -2406,27 +2349,18 @@ int	fsa;
 		return errbuf;
 	}
 
-#ifndef NO_XFS
 	/* Guarantee a properly aligned address on Direct I/O */
 	fdc = alloc_fdcache(file, flags);
 	if( (flags & O_DIRECT) && ((long)buf % fdc->c_memalign != 0) ) {
 		buf += fdc->c_memalign - ((long)buf % fdc->c_memalign);
 	}
-#endif
 
 	if ((nb = read(fd, buf, length)) == -1) {
-#ifndef NO_XFS
 		sprintf(errbuf,
 			"Could not read %d bytes from %s for verification:  %s (%d)\n\tread(%d, 0x%p, %d)\n\tbuf %% alignment(%d) = %ld\n",
 			length, file, SYSERR, errno,
 			fd, buf, length,
 			fdc->c_memalign, (long)buf % fdc->c_memalign);
-#else
-		sprintf(errbuf,
-			"Could not read %d bytes from %s for verification:  %s (%d)\n",
-			length, file, SYSERR, errno);
-
-#endif
 		return errbuf;
 	}
 
@@ -2722,9 +2656,7 @@ int	oflags;
 	struct fd_cache		*free_slot, *oldest_slot, *cp;
 	static int		cache_size = 0;
 	static struct fd_cache	*cache = NULL;
-#ifndef NO_XFS
 	struct dioattr	finfo;
-#endif
 
 	/*
 	 * If file is NULL, it means to free up the fd cache.
@@ -2846,7 +2778,6 @@ int	oflags;
 	strcpy(free_slot->c_file, file);
 	free_slot->c_rtc = Reqno;
 
-#ifndef NO_XFS
 	if (oflags & O_DIRECT) {
 		if (xfsctl(file, fd, XFS_IOC_DIOINFO, &finfo) == -1) {
 			finfo.d_mem = 1;
@@ -2862,7 +2793,6 @@ int	oflags;
 	free_slot->c_memalign = finfo.d_mem;
 	free_slot->c_miniosz = finfo.d_miniosz;
 	free_slot->c_maxiosz = finfo.d_maxiosz;
-#endif
 	free_slot->c_memaddr = NULL;
 	free_slot->c_memlen = 0;
 
Index: b/ltp/growfiles.c
===================================================================
--- a/ltp/growfiles.c
+++ b/ltp/growfiles.c
@@ -89,9 +89,7 @@ void prt_examples();
 int set_sig();
 void sig_handler();
 static void notify_others();
-#ifndef NO_XFS
 int pre_alloc();
-#endif
 
 
 #define NEWIO	1	/* Use the tlibio.c functions */
@@ -293,9 +291,7 @@ int tmp;
 char chr;
 int ret;
 int pre_alloc_space = 0;
-#ifndef NO_XFS
 int total_grow_value = 0;	/* used in pre-allocations */
-#endif
 int backgrnd = 1;		/* return control to user */
 struct stat statbuf;
 int time_iterval = -1;
@@ -564,13 +560,9 @@ extern int Forker_npids;	/* num of forke
 
 
 		case 'p' :	/* pre allocate space */
-#ifdef NO_XFS
 			printf("%s%s: --p is illegal option on this system\n",
 				Progname, TagName);
 			exit(1);
-#else
-			pre_alloc_space++;
-#endif
 			break;
 
 		case 'P':
@@ -1147,7 +1139,6 @@ no whole file checking will be performed
 			Progname, Pid, num_files);
 	}
 
-#ifndef NO_XFS
 	if ( pre_alloc_space ) {
 		if ( iterations == 0 ) {
 		    fprintf(stderr, "%s%s: %d %s/%d: can NOT pre-alloc and grow forever\n",
@@ -1170,7 +1161,6 @@ no whole file checking will be performed
 			total_grow_value=bytes_to_consume;
 		}
 	}
-#endif
 
 	/*
 	 * If delaying between iterations, get amount time to
@@ -1254,7 +1244,6 @@ no whole file checking will be performed
 
 		lkfile(fd, LOCK_EX, LKLVL1);   /* lock if lockfile is LKLVL1 */
 
-#ifndef NO_XFS
 		/*
 		 * preallocation is only done once, if specified.
 		 */
@@ -1272,7 +1261,6 @@ no whole file checking will be performed
 			Iter_cnt=0;	/* reset outside loop to restart from one */
 			continue;
 		}
-#endif
 
 		/*
 		 * grow file by desired amount.
@@ -1348,7 +1336,6 @@ no whole file checking will be performed
 		    }
 	        }
 	    }
-#ifndef NO_XFS
 	    /*
 	     * if Iter_cnt == 0, then we pre allocated space to all files
 	     * and we are starting outside loop over.  Set pre_alloc_space
@@ -1357,9 +1344,6 @@ no whole file checking will be performed
 	    if ( Iter_cnt == 0 ) {
 		pre_alloc_space=0;
 	    }
-#endif
-
-
 	}   /* end iteration for loop */
 
 
@@ -2594,7 +2578,6 @@ lkfile(int fd, int operation, int lkleve
    return 0;
 }
 
-#ifndef NO_XFS
 /***********************************************************************
  *
  ***********************************************************************/
@@ -2605,7 +2588,6 @@ int fd;
 int size;
 {
 
-#ifndef NO_XFS
 #ifdef XFS_IOC_RESVSP
     struct xfs_flock64 f;
 
@@ -2635,8 +2617,6 @@ int size;
 		return -1;
 	}
 #endif
-#endif
 
 	return 0;
 }
-#endif
Index: b/ltp/iogen.c
===================================================================
--- a/ltp/iogen.c
+++ b/ltp/iogen.c
@@ -182,12 +182,10 @@ struct strmap	Syscall_Map[] = {
 	{ "write",		WRITE,		SY_WRITE		},
 	{ "pread",		PREAD   				},
 	{ "pwrite",		PWRITE,		SY_WRITE		},
-#ifndef NO_XFS
 	{ "resvsp",		RESVSP, 	SY_WRITE		},
 	{ "unresvsp",		UNRESVSP, 	SY_WRITE		},
 	{ "reserve",		RESVSP, 	SY_WRITE		},
 	{ "unreserve",		UNRESVSP, 	SY_WRITE		},
-#endif
 	{ "readv",		READV					},
 	{ "writev",		WRITEV,		SY_WRITE		},
 	{ "mmread",		MMAPR					},
@@ -744,10 +742,8 @@ get_file_info(rec)
 struct file_info    *rec;
 {
     struct stat			sbuf;
-#ifndef NO_XFS
     int				fd;
     struct dioattr		finfo;
-#endif
 
     /*
      * Figure out if the files is regular, block or character special.  Any
@@ -784,7 +780,6 @@ struct file_info    *rec;
 	}
 
 	rec->f_riou = BSIZE;
-#ifndef NO_XFS
 	if( (fd = open(rec->f_path, O_RDWR|O_DIRECT, 0)) != -1 ) {
 #ifdef XFS_IOC_DIOINFO
 	    if(xfsctl(rec->f_path, fd, XFS_IOC_DIOINFO, &finfo) != -1) {
@@ -805,7 +800,6 @@ bozo!
 	} else {
 	    rec->f_riou = BBSIZE;
 	}
-#endif
     } else {
 
 	rec->f_riou = BSIZE;
@@ -829,13 +823,11 @@ int 	nbytes;
     int	    	fd, rval;
     char    	c;
     struct stat	sbuf;
-#ifndef NO_XFS
     int		nb;
     struct flock64 f;
     struct fsxattr xattr;
     struct dioattr finfo;
     char	*b, *buf;
-#endif
 
     errno = 0;
     rval = stat(path, &sbuf);
@@ -883,7 +875,6 @@ int 	nbytes;
 	}
     } else {
 
-#ifndef NO_XFS
 	/*
 	 *  The file must be designated as Real-Time before any data
 	 *  is allocated to it.
@@ -926,7 +917,6 @@ bozo!
 		fprintf(stderr, "get: fsx_xflags = 0x%x\n", 
 			xattr.fsx_xflags);
 	    }
-#endif
 	}
 
 	/*
@@ -1008,7 +998,6 @@ bozo!
 	 * file size.
 	 */
 
-#ifndef NO_XFS
 	if(Owrite == 2) {
 	    close(fd);
 	    if( (fd = open(path, O_CREAT|O_RDWR|O_DIRECT, 0)) != -1 ) {
@@ -1081,7 +1070,6 @@ bozo!
 	    }
 	    free(b);
 	} else
-#endif
 	    if(Owrite) {
 	    /*fprintf(stderr,
 		    "create_file_Owrite: lseek(%d, %d {%d}, SEEK_SET)\n",
@@ -1286,7 +1274,6 @@ char	*opts;
 	case 'O':
 
 	    nopenargs = string_to_tokens(optarg, openargs, 4, ":/");
-#ifndef NO_XFS
 	    if(!strcmp(openargs[0], "realtime")) {
 		/*
 		 * -O realtime:extsize
@@ -1323,14 +1310,6 @@ char	*opts;
 			TagName, openargs[0]);
 		exit(1);
 	    }
-#else
-	    Oflags = parse_open_flags(openargs[0], &errmsg);
-	    if(Oflags == -1) {
-		fprintf(stderr, "iogen%s: -O %s error: %s\n", TagName, optarg, errmsg);
-		exit(1);
-	    }
-#endif
-
 	    O_opt++;
 	    break;
 
@@ -1629,13 +1608,8 @@ FILE	*stream;
     fprintf(stream, "\t-a               (Not used on Linux).\n");
 #endif /* !linux */
     fprintf(stream, "\t-f flag,...      Flags to use for file IO.  Supported flags are\n");
-#ifndef NO_XFS
     fprintf(stream, "\t                 buffered, direct, sync.\n");
     fprintf(stream, "\t                 Default is 'buffered,sync'.\n");
-#else
-    fprintf(stream, "\t                 buffered, sync.\n");
-    fprintf(stream, "\t                 Default is 'buffered,sync'.\n");
-#endif /* sgi */
     fprintf(stream, "\t-h               This help.\n");
     fprintf(stream, "\t-i iterations[s] # of requests to generate.  0 means causes iogen\n");
     fprintf(stream, "\t                 to run until it's killed.  If iterations is suffixed\n");
@@ -1650,15 +1624,11 @@ FILE	*stream;
     fprintf(stream, "\t-N tagname       Tag name, for Monster.\n");
     fprintf(stream, "\t-o               Form overlapping consecutive requests.\n");
     fprintf(stream, "\t-O               Open flags for creating files\n");
-#ifndef NO_XFS
     fprintf(stream, "\t                 realtime:extsize - put file on real-time volume\n");
     fprintf(stream, "\t                 allocate - allocate space with F_ALLOCSP\n");
     fprintf(stream, "\t                 reserve - reserve space with F_RESVSP (default)\n");
     fprintf(stream, "\t                 noreserve - do not reserve with F_RESVSP\n");
     fprintf(stream, "\t                 direct - use O_DIRECT I/O to write to the file\n");
-#else
-    fprintf(stream, "\t                 {O_SYNC,etc}\n");
-#endif
     fprintf(stream, "\t-p               Output pipe.  Default is stdout.\n");
     fprintf(stream, "\t-q               Quiet mode.  Normally iogen spits out info\n");
     fprintf(stream, "\t                 about test files, options, etc. before starting.\n");

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
