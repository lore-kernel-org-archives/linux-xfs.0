Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p28Jloo9256233 for <xfs@oss.sgi.com>; Tue, 8 Mar 2011 13:47:50 -0600
Subject: Re: [PATCH] xfstests: add fallocate calls to fsx
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4D6BDC2A.4020308@redhat.com>
References: <4D6BDC2A.4020308@redhat.com>
Date: Tue, 08 Mar 2011 13:50:41 -0600
Message-ID: <1299613841.2716.13.camel@doink>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, 2011-02-28 at 11:32 -0600, Eric Sandeen wrote:
> (Sending one more time, hoping for a real reviewed-by) :)
> 
> Add random runtime fallocate calls to fsx (vs. the existing
> preallocate file at start of run).
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/aclocal.m4 b/aclocal.m4
> index 6457d39..70ea0f3 100644
> --- a/aclocal.m4
> +++ b/aclocal.m4
> @@ -18,6 +18,17 @@ AC_DEFUN([AC_PACKAGE_WANT_LINUX_FIEMAP_H],
>  
>  AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
>    [ AC_MSG_CHECKING([for fallocate])
> +    AC_TRY_COMPILE([
> +#include <linux/falloc.h>
> +    ], [
> +         fallocate(0, 0, 0, 0);
> +    ], have_fallocate=true
> +       AC_MSG_RESULT(true),
> +       AC_MSG_RESULT(false))
> +    AC_SUBST(have_fallocate)
> +  ])
> +AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
> +  [ AC_MSG_CHECKING([for fallocate])
>      AC_TRY_LINK([
>  #define _GNU_SOURCE
>  #define _FILE_OFFSET_BITS 64
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 3bea050..0d51715 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -58,6 +58,7 @@ RPM_VERSION     = @rpm_version@
>  ENABLE_SHARED = @enable_shared@
>  HAVE_DB = @have_db@
>  HAVE_AIO = @have_aio@
> +HAVE_FALLOCATE = @have_fallocate@
>  HAVE_DMAPI = @have_dmapi@
>  HAVE_ATTR_LIST = @have_attr_list@
>  HAVE_FIEMAP = @have_fiemap@
> diff --git a/ltp/Makefile b/ltp/Makefile
> index d74a9df..f3899e1 100644
> --- a/ltp/Makefile
> +++ b/ltp/Makefile
> @@ -27,6 +27,10 @@ LCFLAGS += -DAIO
>  LLDLIBS += -laio -lpthread
>  endif
>  
> +ifeq ($(HAVE_FALLOCATE), true)
> +LCFLAGS += -DFALLOCATE
> +endif
> +
>  default: depend $(TARGETS)
>  
>  include $(BUILDRULES)
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 1167d72..b95431e 100644
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

... and "write / mapwrite" would go here ...
>  				offset %= maxfilelen;
>  				if (offset + size > maxfilelen)
>  					size = maxfilelen - offset;
> @@ -868,6 +955,7 @@ test(void)
>  					domapwrite(offset, size);
>  				else
>  					dowrite(offset, size);
> +			/* read / mapread */
>  			} else {

... and "read / mapread" would go here.

>  				if (file_size)
>  					offset %= file_size;

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
