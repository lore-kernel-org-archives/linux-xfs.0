Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2V4uL0x236282 for <xfs@oss.sgi.com>; Tue, 30 Mar 2010 23:56:21 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E267E1BCCE2B
	for <xfs@oss.sgi.com>; Tue, 30 Mar 2010 21:58:06 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id u76A5lH1tgxyNwXb for
	<xfs@oss.sgi.com>; Tue, 30 Mar 2010 21:58:06 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 9F43CD882BE
	for <xfs@oss.sgi.com>; Tue, 30 Mar 2010 23:58:05 -0500 (CDT)
Message-ID: <4BB2D65D.5000402@sandeen.net>
Date: Tue, 30 Mar 2010 23:58:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfstests: random fallocate calls in fsx
References: <4A0B420E.3070908@sandeen.net>
In-Reply-To: <4A0B420E.3070908@sandeen.net>
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
To: xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Seems to work for me.  Any comments/suggestions?
> 
> I can probably make it fall back to the xfs ioctl if fallocate
> isn't supported, if strongly desired.

Anybody feel like reviewing this?  Seems like having fallocate in the mix
would be good.

(apologies if it's bitrotted since initial email but it should be generally
ok)

-Eric

> diff --git a/aclocal.m4 b/aclocal.m4
> index 52f1c7d..120c1e0 100644
> --- a/aclocal.m4
> +++ b/aclocal.m4
> @@ -511,3 +511,14 @@ AC_DEFUN([AC_PACKAGE_NEED_XFSCTL_MACRO],
>        ])
>    ])
>  
> +AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
> +  [ AC_MSG_CHECKING([for fallocate])
> +    AC_TRY_COMPILE([
> +#include <linux/falloc.h>
> +    ], [
> +         fallocate(0, 0, 0, 0);
> +    ], have_fallocate=true
> +       AC_MSG_RESULT(true),
> +       AC_MSG_RESULT(false))
> +    AC_SUBST(have_fallocate)
> +  ])
> diff --git a/configure.in b/configure.in
> index 32a2496..61adac7 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -62,6 +62,7 @@ in
>  		AC_PACKAGE_WANT_GDBM
>  		AC_PACKAGE_WANT_AIO
>  		AC_PACKAGE_WANT_DMAPI
> +		AC_PACKAGE_WANT_FALLOCATE
>  		;;
>  esac
>  
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 636f632..6a51b99 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -56,6 +56,7 @@ RPM_VERSION     = @rpm_version@
>  ENABLE_SHARED = @enable_shared@
>  HAVE_DB = @have_db@
>  HAVE_AIO = @have_aio@
> +HAVE_FALLOCATE = @have_fallocate@
>  HAVE_DMAPI = @have_dmapi@
>  HAVE_ATTR_LIST = @have_attr_list@
>  
> diff --git a/ltp/Makefile b/ltp/Makefile
> index bcdac84..3b81101 100644
> --- a/ltp/Makefile
> +++ b/ltp/Makefile
> @@ -25,6 +25,10 @@ LCFLAGS += -DAIO
>  LIBAIO = -laio -lpthread
>  endif
>  
> +ifeq ($(HAVE_FALLOCATE), true)
> +LCFLAGS += -DFALLOCATE
> +endif
> +
>  default: $(TARGETS)
>  
>  include $(BUILDRULES)
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index e4c528d..fe01f6e 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -32,6 +32,9 @@
>  #ifdef AIO
>  #include <libaio.h>
>  #endif
> +#ifdef FALLOCATE
> +#include <linux/falloc.h>
> +#endif
>  
>  #ifndef MAP_FILE
>  # define MAP_FILE 0
> @@ -65,6 +68,7 @@ int			logcount = 0;	/* total ops */
>  #define OP_MAPREAD	5
>  #define OP_MAPWRITE	6
>  #define OP_SKIPPED	7
> +#define OP_FALLOCATE	8
>  
>  #undef PAGE_SIZE
>  #define PAGE_SIZE       getpagesize()
> @@ -105,6 +109,11 @@ long	numops = -1;			/* -N flag */
>  int	randomoplen = 1;		/* -O flag disables it */
>  int	seed = 1;			/* -S flag */
>  int     mapped_writes = 1;              /* -W flag disables */
> +#ifdef FALLOCATE
> +int     fallocate_calls = 1;            /* -F flag disables */
> +#else
> +int     fallocate_calls = 0;            /* -F flag disables */
> +#endif
>  int 	mapped_reads = 1;		/* -R flag disables it */
>  int	fsxgoodfd = 0;
>  int	o_direct;			/* -Z */
> @@ -202,6 +211,7 @@ logdump(void)
>  {
>  	int	i, count, down;
>  	struct log_entry	*lp;
> +	char *falloc_type[3] = {"PAST_EOF", "EXTENDING", "INTERIOR"};
>  
>  	prt("LOG DUMP (%d total operations):\n", logcount);
>  	if (logcount < LOGSIZE) {
> @@ -265,6 +275,14 @@ logdump(void)
>  			    badoff < lp->args[!!down])
>  				prt("\t******WWWW");
>  			break;
> +		case OP_FALLOCATE:
> +			/* 0: offset 1: length 2: where alloced */
> +			prt("FALLOCATE %s\tfrom 0x%x to 0x%x",
> +			    falloc_type[lp->args[2]], lp->args[0], lp->args[0] + lp->args[1]);
> +			if (badoff >= lp->args[0] &&
> +			    badoff < lp->args[0] + lp->args[1])
> +				prt("\t******FFFF");
> +			break;
>  		case OP_SKIPPED:
>  			prt("SKIPPED (no operation)");
>  			break;
> @@ -770,6 +788,64 @@ dotruncate(unsigned size)
>  	}
>  }
>  
> +#ifdef FALLOCATE
> +/* fallocate is basically a no-op unless extending, then a lot like a truncate */
> +void
> +dofallocate(unsigned offset, unsigned length)
> +{
> +	unsigned end_offset;
> +	int keep_size;
> +
> +        if (length == 0) {
> +                if (!quiet && testcalls > simulatedopcount)
> +                        prt("skipping zero length fallocate\n");
> +                log4(OP_SKIPPED, OP_FALLOCATE, offset, length);
> +                return;
> +        }
> +
> +	keep_size = random() % 2;
> +
> +	end_offset = keep_size ? 0 : offset + length;
> +
> +	if (end_offset > biggest) {
> +		biggest = end_offset;
> +		if (!quiet && testcalls > simulatedopcount)
> +			prt("fallocating to largest ever: 0x%x\n", end_offset);
> +	}
> +
> +	/*
> +	 * last arg:
> +	 * 	1: allocate past EOF
> +	 * 	2: extending prealloc
> +	 * 	3: interior prealloc
> +	 */
> +	log4(OP_FALLOCATE, offset, length, (end_offset > file_size) ? (keep_size ? 1 : 2) : 3);
> +
> +	if (end_offset > file_size) {
> +		memset(good_buf + file_size, '\0', end_offset - file_size);
> +		file_size = end_offset;
> +	}
> +
> +	if (testcalls <= simulatedopcount)
> +		return;
> +	
> +	if ((progressinterval && testcalls % progressinterval == 0) ||
> +	    (debug && (monitorstart == -1 || monitorend == -1 ||
> +		      end_offset <= monitorend)))
> +		prt("%lu falloc\tfrom 0x%x to 0x%x\n", testcalls, offset, length);
> +	if (fallocate(fd, keep_size ? FALLOC_FL_KEEP_SIZE : 0, (loff_t)offset, (loff_t)length) == -1) {
> +	        prt("fallocate: %x to %x\n", offset, length);
> +		prterr("dofallocate: fallocate");
> +		report_failure(161);
> +	}
> +}
> +#else
> +void
> +dofallocate(unsigned offset, unsigned length)
> +{
> +	return;
> +}
> +#endif
>  
>  void
>  writefileimage()
> @@ -823,7 +899,7 @@ test(void)
>  	unsigned long	offset;
>  	unsigned long	size = maxoplen;
>  	unsigned long	rv = random();
> -	unsigned long	op = rv % (3 + !lite + mapped_writes);
> +	unsigned long	op = rv % (3 + !lite + mapped_writes + fallocate_calls);
>  
>          /* turn off the map read if necessary */
>  
> @@ -845,22 +921,33 @@ test(void)
>  		prt("%lu...\n", testcalls);
>  
>  	/*
> -	 * READ:	op = 0
> -	 * WRITE:	op = 1
> -	 * MAPREAD:     op = 2
> -	 * TRUNCATE:	op = 3
> -	 * MAPWRITE:    op = 3 or 4
> +	 *                 lite  !lite
> +	 * READ:	op = 0	   0
> +	 * WRITE:	op = 1     1
> +	 * MAPREAD:     op = 2     2
> +	 * TRUNCATE:	op = -     3
> +	 * MAPWRITE:    op = 3     4
> +	 * FALLOCATE:   op = -     5
>  	 */
>  	if (lite ? 0 : op == 3 && (style & 1) == 0) /* vanilla truncate? */
>  		dotruncate(random() % maxfilelen);
>  	else {
>  		if (randomoplen)
>  			size = random() % (maxoplen+1);
> +
> +		/* truncate */
>  		if (lite ? 0 : op == 3)
>  			dotruncate(size);
>  		else {
>  			offset = random();
> -			if (op == 1 || op == (lite ? 3 : 4)) {
> +			/* fallocate */
> +			if (op == 5) {
> +				offset %= maxfilelen;
> +				if (offset + size > maxfilelen)
> +					size = maxfilelen - offset;
> +				dofallocate(offset, size);
> +			/* write / mapwrite */
> +			} else if (op == 1 || op == (lite ? 3 : 4)) {
>  				offset %= maxfilelen;
>  				if (offset + size > maxfilelen)
>  					size = maxfilelen - offset;
> @@ -868,6 +955,7 @@ test(void)
>  					domapwrite(offset, size);
>  				else
>  					dowrite(offset, size);
> +			/* read / mapread */
>  			} else {
>  				if (file_size)
>  					offset %= file_size;
> @@ -904,7 +992,7 @@ void
>  usage(void)
>  {
>  	fprintf(stdout, "usage: %s",
> -		"fsx [-dnqxALOWZ] [-b opnum] [-c Prob] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
> +		"fsx [-dnqxAFLOWZ] [-b opnum] [-c Prob] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
>  	-b opnum: beginning operation number (default 1)\n\
>  	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
>  	-d: debug output for all operations\n\
> @@ -925,8 +1013,11 @@ usage(void)
>  #ifdef AIO
>  "	-A: Use the AIO system calls\n"
>  #endif
> -"	-D startingop: debug output starting at specified operation\n\
> -	-L: fsxLite - no file creations & no file size changes\n\
> +"	-D startingop: debug output starting at specified operation\n"
> +#ifdef FALLOCATE
> +"	-F: Do not use fallocate (preallocation) calls\n"
> +#endif
> +"	-L: fsxLite - no file creations & no file size changes\n\
>  	-N numops: total # operations to do (default infinity)\n\
>  	-O: use oplen (see -o flag) for every op (default random)\n\
>  	-P: save .fsxlog and .fsxgood files in dirpath (default ./)\n\
> @@ -1092,7 +1183,7 @@ main(int argc, char **argv)
>  
>  	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
>  
> -	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:LN:OP:RS:WZ"))
> +	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FLN:OP:RS:WZ"))
>  	       != EOF)
>  		switch (ch) {
>  		case 'b':
> @@ -1186,6 +1277,9 @@ main(int argc, char **argv)
>  			if (debugstart < 1)
>  				usage();
>  			break;
> +		case 'F':
> +			fallocate_calls = 0;
> +			break;
>  		case 'L':
>  		        lite = 1;
>  			break;
> @@ -1331,6 +1425,16 @@ main(int argc, char **argv)
>  	} else 
>  		check_trunc_hack();
>  
> +#ifdef FALLOCATE
> +	if (!lite && fallocate_calls) {
> +		if (fallocate(fd, 0, 0, 1) && errno == EOPNOTSUPP) {
> +			warn("main: filesystem does not support fallocate, disabling");
> +			fallocate_calls = 0;
> +		} else
> +			ftruncate(fd, 0);
> +	}
> +#endif
> +
>  	while (numops == -1 || numops--)
>  		test();
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
