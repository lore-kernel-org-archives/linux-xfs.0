Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1SJT6Dr155071 for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 13:29:07 -0600
Received: from idcmail-mo1so.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CED4630452A
	for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 11:31:54 -0800 (PST)
Received: from idcmail-mo1so.shaw.ca (idcmail-mo1so.shaw.ca [24.71.223.10]) by
	cuda.sgi.com with ESMTP id HFXSCtOlGgcA0Qgt for
	<xfs@oss.sgi.com>; Mon, 28 Feb 2011 11:31:54 -0800 (PST)
Subject: Re: [PATCH] xfstests: add fallocate calls to fsx
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: multipart/mixed; boundary=Apple-Mail-20-639248842
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <4D6BDC2A.4020308@redhat.com>
Date: Mon, 28 Feb 2011 12:31:52 -0700
Message-Id: <3176C445-FF4F-4DF3-B759-E848EDF0AD55@dilger.ca>
References: <4D6BDC2A.4020308@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>


--Apple-Mail-20-639248842
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On 2011-02-28, at 10:32 AM, Eric Sandeen wrote:
> (Sending one more time, hoping for a real reviewed-by) :)
>=20
> Add random runtime fallocate calls to fsx (vs. the existing
> preallocate file at start of run).

Sorry, don't have a chance to look at this today, but just for reference =
here is the patched fsx that I have.  I have never tested the fallocate =
support in my version (when I was merging your patch the kernel I was =
testing on didn't have it), so it may be patched incorrectly, but I =
thought you may be interested in the other changes.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>=20
> diff --git a/aclocal.m4 b/aclocal.m4
> index 6457d39..70ea0f3 100644
> --- a/aclocal.m4
> +++ b/aclocal.m4
> @@ -18,6 +18,17 @@ AC_DEFUN([AC_PACKAGE_WANT_LINUX_FIEMAP_H],
>=20
> AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
>   [ AC_MSG_CHECKING([for fallocate])
> +    AC_TRY_COMPILE([
> +#include <linux/falloc.h>
> +    ], [
> +         fallocate(0, 0, 0, 0);
> +    ], have_fallocate=3Dtrue
> +       AC_MSG_RESULT(true),
> +       AC_MSG_RESULT(false))
> +    AC_SUBST(have_fallocate)
> +  ])
> +AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
> +  [ AC_MSG_CHECKING([for fallocate])
>     AC_TRY_LINK([
> #define _GNU_SOURCE
> #define _FILE_OFFSET_BITS 64
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 3bea050..0d51715 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -58,6 +58,7 @@ RPM_VERSION     =3D @rpm_version@
> ENABLE_SHARED =3D @enable_shared@
> HAVE_DB =3D @have_db@
> HAVE_AIO =3D @have_aio@
> +HAVE_FALLOCATE =3D @have_fallocate@
> HAVE_DMAPI =3D @have_dmapi@
> HAVE_ATTR_LIST =3D @have_attr_list@
> HAVE_FIEMAP =3D @have_fiemap@
> diff --git a/ltp/Makefile b/ltp/Makefile
> index d74a9df..f3899e1 100644
> --- a/ltp/Makefile
> +++ b/ltp/Makefile
> @@ -27,6 +27,10 @@ LCFLAGS +=3D -DAIO
> LLDLIBS +=3D -laio -lpthread
> endif
>=20
> +ifeq ($(HAVE_FALLOCATE), true)
> +LCFLAGS +=3D -DFALLOCATE
> +endif
> +
> default: depend $(TARGETS)
>=20
> include $(BUILDRULES)
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 1167d72..b95431e 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -32,6 +32,9 @@
> #ifdef AIO
> #include <libaio.h>
> #endif
> +#ifdef FALLOCATE
> +#include <linux/falloc.h>
> +#endif
>=20
> #ifndef MAP_FILE
> # define MAP_FILE 0
> @@ -65,6 +68,7 @@ int			logcount =3D 0;	/* total ops */
> #define OP_MAPREAD	5
> #define OP_MAPWRITE	6
> #define OP_SKIPPED	7
> +#define OP_FALLOCATE	8
>=20
> #undef PAGE_SIZE
> #define PAGE_SIZE       getpagesize()
> @@ -105,6 +109,11 @@ long	numops =3D -1;			/* -N =
flag */
> int	randomoplen =3D 1;		/* -O flag disables it */
> int	seed =3D 1;			/* -S flag */
> int     mapped_writes =3D 1;              /* -W flag disables */
> +#ifdef FALLOCATE
> +int     fallocate_calls =3D 1;            /* -F flag disables */
> +#else
> +int     fallocate_calls =3D 0;            /* -F flag disables */
> +#endif
> int 	mapped_reads =3D 1;		/* -R flag disables it */
> int	fsxgoodfd =3D 0;
> int	o_direct;			/* -Z */
> @@ -202,6 +211,7 @@ logdump(void)
> {
> 	int	i, count, down;
> 	struct log_entry	*lp;
> +	char *falloc_type[3] =3D {"PAST_EOF", "EXTENDING", "INTERIOR"};
>=20
> 	prt("LOG DUMP (%d total operations):\n", logcount);
> 	if (logcount < LOGSIZE) {
> @@ -265,6 +275,14 @@ logdump(void)
> 			    badoff < lp->args[!!down])
> 				prt("\t******WWWW");
> 			break;
> +		case OP_FALLOCATE:
> +			/* 0: offset 1: length 2: where alloced */
> +			prt("FALLOCATE %s\tfrom 0x%x to 0x%x",
> +			    falloc_type[lp->args[2]], lp->args[0], =
lp->args[0] + lp->args[1]);
> +			if (badoff >=3D lp->args[0] &&
> +			    badoff < lp->args[0] + lp->args[1])
> +				prt("\t******FFFF");
> +			break;
> 		case OP_SKIPPED:
> 			prt("SKIPPED (no operation)");
> 			break;
> @@ -770,6 +788,64 @@ dotruncate(unsigned size)
> 	}
> }
>=20
> +#ifdef FALLOCATE
> +/* fallocate is basically a no-op unless extending, then a lot like a =
truncate */
> +void
> +dofallocate(unsigned offset, unsigned length)
> +{
> +	unsigned end_offset;
> +	int keep_size;
> +
> +        if (length =3D=3D 0) {
> +                if (!quiet && testcalls > simulatedopcount)
> +                        prt("skipping zero length fallocate\n");
> +                log4(OP_SKIPPED, OP_FALLOCATE, offset, length);
> +                return;
> +        }
> +
> +	keep_size =3D random() % 2;
> +
> +	end_offset =3D keep_size ? 0 : offset + length;
> +
> +	if (end_offset > biggest) {
> +		biggest =3D end_offset;
> +		if (!quiet && testcalls > simulatedopcount)
> +			prt("fallocating to largest ever: 0x%x\n", =
end_offset);
> +	}
> +
> +	/*
> +	 * last arg:
> +	 * 	1: allocate past EOF
> +	 * 	2: extending prealloc
> +	 * 	3: interior prealloc
> +	 */
> +	log4(OP_FALLOCATE, offset, length, (end_offset > file_size) ? =
(keep_size ? 1 : 2) : 3);
> +
> +	if (end_offset > file_size) {
> +		memset(good_buf + file_size, '\0', end_offset - =
file_size);
> +		file_size =3D end_offset;
> +	}
> +
> +	if (testcalls <=3D simulatedopcount)
> +		return;
> +=09
> +	if ((progressinterval && testcalls % progressinterval =3D=3D 0) =
||
> +	    (debug && (monitorstart =3D=3D -1 || monitorend =3D=3D -1 ||
> +		      end_offset <=3D monitorend)))
> +		prt("%lu falloc\tfrom 0x%x to 0x%x\n", testcalls, =
offset, length);
> +	if (fallocate(fd, keep_size ? FALLOC_FL_KEEP_SIZE : 0, =
(loff_t)offset, (loff_t)length) =3D=3D -1) {
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
>=20
> void
> writefileimage()
> @@ -823,7 +899,7 @@ test(void)
> 	unsigned long	offset;
> 	unsigned long	size =3D maxoplen;
> 	unsigned long	rv =3D random();
> -	unsigned long	op =3D rv % (3 + !lite + mapped_writes);
> +	unsigned long	op =3D rv % (3 + !lite + mapped_writes + =
fallocate_calls);
>=20
>         /* turn off the map read if necessary */
>=20
> @@ -845,22 +921,33 @@ test(void)
> 		prt("%lu...\n", testcalls);
>=20
> 	/*
> -	 * READ:	op =3D 0
> -	 * WRITE:	op =3D 1
> -	 * MAPREAD:     op =3D 2
> -	 * TRUNCATE:	op =3D 3
> -	 * MAPWRITE:    op =3D 3 or 4
> +	 *                 lite  !lite
> +	 * READ:	op =3D 0	   0
> +	 * WRITE:	op =3D 1     1
> +	 * MAPREAD:     op =3D 2     2
> +	 * TRUNCATE:	op =3D -     3
> +	 * MAPWRITE:    op =3D 3     4
> +	 * FALLOCATE:   op =3D -     5
> 	 */
> 	if (lite ? 0 : op =3D=3D 3 && (style & 1) =3D=3D 0) /* vanilla =
truncate? */
> 		dotruncate(random() % maxfilelen);
> 	else {
> 		if (randomoplen)
> 			size =3D random() % (maxoplen+1);
> +
> +		/* truncate */
> 		if (lite ? 0 : op =3D=3D 3)
> 			dotruncate(size);
> 		else {
> 			offset =3D random();
> -			if (op =3D=3D 1 || op =3D=3D (lite ? 3 : 4)) {
> +			/* fallocate */
> +			if (op =3D=3D 5) {
> +				offset %=3D maxfilelen;
> +				if (offset + size > maxfilelen)
> +					size =3D maxfilelen - offset;
> +				dofallocate(offset, size);
> +			/* write / mapwrite */
> +			} else if (op =3D=3D 1 || op =3D=3D (lite ? 3 : =
4)) {
> 				offset %=3D maxfilelen;
> 				if (offset + size > maxfilelen)
> 					size =3D maxfilelen - offset;
> @@ -868,6 +955,7 @@ test(void)
> 					domapwrite(offset, size);
> 				else
> 					dowrite(offset, size);
> +			/* read / mapread */
> 			} else {
> 				if (file_size)
> 					offset %=3D file_size;
> @@ -904,7 +992,7 @@ void
> usage(void)
> {
> 	fprintf(stdout, "usage: %s",
> -		"fsx [-dnqxALOWZ] [-b opnum] [-c Prob] [-l flen] [-m =
start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t =
truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S =
seed] fname\n\
> +		"fsx [-dnqxAFLOWZ] [-b opnum] [-c Prob] [-l flen] [-m =
start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t =
truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S =
seed] fname\n\
> 	-b opnum: beginning operation number (default 1)\n\
> 	-c P: 1 in P chance of file close+open at each op (default =
infinity)\n\
> 	-d: debug output for all operations\n\
> @@ -925,8 +1013,11 @@ usage(void)
> #ifdef AIO
> "	-A: Use the AIO system calls\n"
> #endif
> -"	-D startingop: debug output starting at specified operation\n\
> -	-L: fsxLite - no file creations & no file size changes\n\
> +"	-D startingop: debug output starting at specified operation\n"
> +#ifdef FALLOCATE
> +"	-F: Do not use fallocate (preallocation) calls\n"
> +#endif
> +"	-L: fsxLite - no file creations & no file size changes\n\
> 	-N numops: total # operations to do (default infinity)\n\
> 	-O: use oplen (see -o flag) for every op (default random)\n\
> 	-P: save .fsxlog and .fsxgood files in dirpath (default ./)\n\
> @@ -1092,7 +1183,7 @@ main(int argc, char **argv)
>=20
> 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout =
*/
>=20
> -	while ((ch =3D getopt(argc, argv, =
"b:c:dfl:m:no:p:qr:s:t:w:xyAD:LN:OP:RS:WZ"))
> +	while ((ch =3D getopt(argc, argv, =
"b:c:dfl:m:no:p:qr:s:t:w:xyAD:FLN:OP:RS:WZ"))
> 	       !=3D EOF)
> 		switch (ch) {
> 		case 'b':
> @@ -1186,6 +1277,9 @@ main(int argc, char **argv)
> 			if (debugstart < 1)
> 				usage();
> 			break;
> +		case 'F':
> +			fallocate_calls =3D 0;
> +			break;
> 		case 'L':
> 		        lite =3D 1;
> 			break;
> @@ -1331,6 +1425,16 @@ main(int argc, char **argv)
> 	} else=20
> 		check_trunc_hack();
>=20
> +#ifdef FALLOCATE
> +	if (!lite && fallocate_calls) {
> +		if (fallocate(fd, 0, 0, 1) && errno =3D=3D EOPNOTSUPP) {
> +			warn("main: filesystem does not support =
fallocate, disabling");
> +			fallocate_calls =3D 0;
> +		} else
> +			ftruncate(fd, 0);
> +	}
> +#endif
> +
> 	while (numops =3D=3D -1 || numops--)
> 		test();
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





--Apple-Mail-20-639248842
Content-Disposition: attachment;
	filename=fsx.c
Content-Type: application/octet-stream;
	name="fsx.c"
Content-Transfer-Encoding: 7bit

/*
 * Copyright (C) 1991, NeXT Computer, Inc.  All Rights Reserverd.
 * Copyright (c) 1998-2001 Apple Computer, Inc. All rights reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 *
 * The contents of this file constitute Original Code as defined in and
 * are subject to the Apple Public Source License Version 1.1 (the
 * "License").  You may not use this file except in compliance with the
 * License.  Please obtain a copy of the License at
 * http://www.apple.com/publicsource and read it before using this file.
 *
 * This Original Code and all software distributed under the License are
 * distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE OR NON-INFRINGEMENT.  Please see the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * @APPLE_LICENSE_HEADER_END@
 *
 *	File:	fsx.c
 *	Author:	Avadis Tevanian, Jr.
 *
 *	File system exerciser.
 *
 *	Rewrite and enhancements 1998-2001 Conrad Minshall -- conrad@mac.com
 *
 *	Various features from Joe Sokol, Pat Dirks, and Clark Warner.
 *
 *	Small changes to work under Linux -- davej@suse.de
 *
 *	Sundry porting patches from Guy Harris 12/2001
 *
 *	Checks for mmap last-page zero fill.
 *
 *	Add multi-file testing feature -- Zach Brown <zab@clusterfs.com>
 *
 *	Add random preallocation calls - Eric Sandeen <sandeen@redhat.com>
 *
 * $FreeBSD: src/tools/regression/fsx/fsx.c,v 1.2 2003/04/23 23:42:23 jkh Exp $
 * $DragonFly: src/test/stress/fsx/fsx.c,v 1.2 2005/05/02 19:31:56 dillon Exp $
 *
 */
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include <sys/types.h>
#include <sys/stat.h>
#if defined(_UWIN) || defined(__linux__)
# include <sys/param.h>
# include <limits.h>
# include <strings.h>
#endif
#include <time.h>
#include <sys/time.h>
#include <fcntl.h>
#include <sys/mman.h>
#ifndef MAP_FILE
# define MAP_FILE 0
#endif
#include <limits.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdarg.h>
#include <errno.h>
#include <setjmp.h>

/*
 *	A log entry is an operation and a bunch of arguments.
 */

struct log_entry {
	int	operation;
	int	args[3];
	struct timeval tv;
};

#define	LOGSIZE	100000

struct log_entry	oplog[LOGSIZE];	/* the log */
int			logptr = 0;	/* current position in log */
int			logcount = 0;	/* total ops */
int			jmpbuf_good;
jmp_buf			jmpbuf;

/*
 *	Define operations
 */

#define	OP_READ		1
#define OP_WRITE	2
#define OP_TRUNCATE	3
#define OP_CLOSEOPEN	4
#define OP_MAPREAD	5
#define OP_MAPWRITE	6
#define OP_SKIPPED	7
#define OP_FALLOCATE	8

#ifdef O_DIRECT
#define OP_DIRECT	O_DIRECT
#else
#define OP_DIRECT	0
#endif

int page_size;
int page_mask;

char	*original_buf;			/* a pointer to the original data */
char	*good_buf;			/* a pointer to the correct data */
char	*temp_buf;			/* a pointer to the current data */
char	*fname;				/* name of our test file */
char	logfile[1024];			/* name of our log file */
char	goodfile[1024];			/* name of our test file */

off_t		file_size = 0;
off_t		biggest = 0;
char		state[256];
unsigned long	testcalls = 0;		/* calls to function "test" */

unsigned long	simulatedopcount = 0;	/* -b flag */
int	closeprob = 0;			/* -c flag */
int	debug = 0;			/* -d flag */
unsigned long	debugstart = 0;		/* -D flag */
int	do_fsync = 0;			/* -f flag */
unsigned long	maxfilelen = 256 * 1024;	/* -l flag */
int	sizechecks = 1;			/* -n flag disables them */
int	maxoplen = 64 * 1024;		/* -o flag */
int	quiet = 0;			/* -q flag */
unsigned long progressinterval = 0;	/* -p flag */
int	readbdy = 1;			/* -r flag */
int	style = 0;			/* -s flag */
int	truncbdy = 1;			/* -t flag */
int	writebdy = 1;			/* -w flag */
long	monitorstart = -1;		/* -m flag */
long	monitorend = -1;		/* -m flag */
int	fallocate_calls = 1;		/* -F flag disables */
int	lite = 0;			/* -L flag */
long	numops = -1;			/* -N flag */
int	randomoplen = 1;		/* -O flag disables it */
int	seed = 1;			/* -S flag */
int	mapped_writes = 1;		/* -W flag disables */
int	mapped_reads = 1;		/* -R flag disables it */
int	o_direct = 0;			/* -Z flag */
int	fsxgoodfd = 0;
FILE	*fsxlogf = NULL;
int	badoff = -1;


void
vwarnc(code, fmt, ap)
	int code;
	const char *fmt;
	va_list ap;
{
	fprintf(stderr, "fsx: ");
	if (fmt != NULL) {
		vfprintf(stderr, fmt, ap);
		fprintf(stderr, ": ");
	}
	fprintf(stderr, "%s\n", strerror(code));
}


void
warn(const char * fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	vwarnc(errno, fmt, ap);
	va_end(ap);
}

static void *round_up(void *ptr, unsigned long align)
{
	unsigned long ret = (unsigned long)ptr;

	ret = ((ret + align - 1) & ~(align - 1));
	return (void *)ret;
}

void
__attribute__((format(printf, 1, 2)))
prt(char *fmt, ...)
{
	va_list args;

	va_start(args, fmt);
	vfprintf(stdout, fmt, args);
	va_end(args);

	if (fsxlogf) {
		va_start(args, fmt);
		vfprintf(fsxlogf, fmt, args);
		va_end(args);
	}
}

void
prterr(char *prefix)
{
	prt("%s%s%s\n", prefix, prefix ? ": " : "", strerror(errno));
}


void
log4(int operation, int arg0, int arg1, int arg2, struct timeval *tv)
{
	struct log_entry *le;

	le = &oplog[logptr];
	le->tv = *tv;
	le->operation = operation;
	le->args[0] = arg0;
	le->args[1] = arg1;
	le->args[2] = arg2;
	logptr++;
	logcount++;
	if (logptr >= LOGSIZE)
		logptr = 0;
}


void
logdump(void)
{
	int	i, count, down;
	struct log_entry	*lp;
	char *falloc_type[3] = {"PAST_EOF", "EXTENDING", "INTERIOR"};

	prt("LOG DUMP (%d total operations):\n", logcount);
	if (logcount < LOGSIZE) {
		i = 0;
		count = logcount;
	} else {
		i = logptr;
		count = LOGSIZE;
	}
	for ( ; count > 0; count--) {
		int opnum;

		opnum = i+1 + (logcount/LOGSIZE)*LOGSIZE;
		lp = &oplog[i];
		prt("%d: %llu.%06llu ", opnum,
		    (long long)lp->tv.tv_sec, (long long)lp->tv.tv_usec);

		switch (lp->operation) {
		case OP_MAPREAD:
			prt("MAPREAD  0x%05x thru 0x%05x (0x%05x bytes)",
			    lp->args[0], lp->args[0] + lp->args[1] - 1,
			    lp->args[1]);
			if (badoff >= lp->args[0] &&
			    badoff < lp->args[0] + lp->args[1])
				prt("\t***RRRR***");
			break;
		case OP_MAPWRITE:
			prt("MAPWRITE 0x%05x thru 0x%05x (0x%05x bytes)",
			    lp->args[0], lp->args[0] + lp->args[1] - 1,
			    lp->args[1]);
			if (badoff >= lp->args[0] &&
			    badoff < lp->args[0] + lp->args[1])
				prt("\t******WWWW");
			break;
		case OP_READ:
#ifdef O_DIRECT
		case OP_READ + O_DIRECT:
#endif
			prt("READ%s  0x%05x thru 0x%05x (0x%05x bytes)",
			    lp->operation & OP_DIRECT ? "_OD" : "   ",
			    lp->args[0], lp->args[0] + lp->args[1] - 1,
			    lp->args[1]);
			if (badoff >= lp->args[0] &&
			    badoff < lp->args[0] + lp->args[1])
				prt("\t***RRRR***");
			break;
		case OP_WRITE:
#ifdef O_DIRECT
		case OP_WRITE + O_DIRECT:
#endif
			prt("WRITE%s 0x%05x thru 0x%05x (0x%05x bytes)",
			    lp->operation & OP_DIRECT ? "_OD" : "   ",
			    lp->args[0], lp->args[0] + lp->args[1] - 1,
			    lp->args[1]);
			if (lp->args[0] > lp->args[2])
				prt(" HOLE");
			else if (lp->args[0] + lp->args[1] > lp->args[2])
				prt(" EXTEND");
			if ((badoff >= lp->args[0] || badoff >=lp->args[2]) &&
			    badoff < lp->args[0] + lp->args[1])
				prt("\t***WWWW");
			break;
		case OP_TRUNCATE:
			down = lp->args[0] < lp->args[1];
			prt("TRUNCATE %s\tfrom 0x%05x to 0x%05x",
			    down ? "DOWN" : "UP", lp->args[1], lp->args[0]);
			if (badoff >= lp->args[!down] &&
			    badoff < lp->args[!!down])
				prt("\t******WWWW");
			break;
		case OP_CLOSEOPEN:
#ifdef O_DIRECT
		case OP_CLOSEOPEN + O_DIRECT:
#endif
			prt("CLOSE/OPEN%s",
			    lp->operation & OP_DIRECT ? "_OD" : "   ");
			break;
		case OP_FALLOCATE:
			/* 0: offset 1: length 2: where alloced */
			prt("FALLOCATE %s\tfrom 0x%05x to 0x%05x",
			    falloc_type[lp->args[2]], lp->args[0],
			    lp->args[0] + lp->args[1]);
			if (badoff >= lp->args[0] &&
			    badoff < lp->args[0] + lp->args[1])
				prt("\t******FFFF");
			break;
		case OP_SKIPPED:
			prt("SKIPPED (no operation)");
			break;
		default:
			prt("BOGUS LOG ENTRY (operation code = %d)!",
			    lp->operation);
		}
		prt("\n");
		i++;
		if (i == LOGSIZE)
			i = 0;
	}
}


void
save_buffer(char *buffer, off_t bufferlength, int fd)
{
	off_t ret;
	ssize_t byteswritten;

	if (fd <= 0 || bufferlength == 0)
		return;

	if (bufferlength > INT_MAX) {
		prt("fsx flaw: overflow in save_buffer\n");
		exit(67);
	}
	if (lite) {
		off_t size_by_seek = lseek(fd, (off_t)0, SEEK_END);
		if (size_by_seek == (off_t)-1)
			prterr("save_buffer: lseek eof");
		else if (bufferlength > size_by_seek) {
			warn("save_buffer: .fsxgood file too short... will"
				"save 0x%llx bytes instead of 0x%llx\n",
				(unsigned long long)size_by_seek,
				(unsigned long long)bufferlength);
			bufferlength = size_by_seek;
		}
	}

	ret = lseek(fd, (off_t)0, SEEK_SET);
	if (ret == (off_t)-1)
		prterr("save_buffer: lseek 0");

	byteswritten = write(fd, buffer, (size_t)bufferlength);
	if (byteswritten != bufferlength) {
		if (byteswritten == -1)
			prterr("save_buffer write");
		else
			warn("save_buffer: short write, 0x%x bytes instead"
				"of 0x%llx\n",
			     (unsigned)byteswritten,
			     (unsigned long long)bufferlength);
	}
}


void
report_failure(int status)
{
	logdump();

	if (fsxgoodfd) {
		if (good_buf) {
			save_buffer(good_buf, file_size, fsxgoodfd);
			prt("Correct content saved for comparison\n");
			prt("(maybe hexdump \"%s\" vs \"%s\")\n",
			    fname, goodfile);
		}
		close(fsxgoodfd);
	}
	exit(status);
}


#define short_at(cp) ((unsigned short)((*((unsigned char *)(cp)) << 8) | \
				        *(((unsigned char *)(cp)) + 1)))

void
check_buffers(unsigned offset, unsigned size)
{
	unsigned char c, t;
	unsigned i = 0;
	unsigned n = 0;
	unsigned op = 0;
	unsigned bad = 0;

	if (memcmp(good_buf + offset, temp_buf, size) != 0) {
		prt("READ BAD DATA: offset = 0x%x, size = 0x%x\n",
		    offset, size);
		prt("OFFSET\tGOOD\tBAD\tRANGE\n");
		while (size > 0) {
			c = good_buf[offset];
			t = temp_buf[i];
			if (c != t) {
			        if (n == 0) {
					bad = short_at(&temp_buf[i]);
				        prt("%#07x\t%#06x\t%#06x", offset,
				            short_at(&good_buf[offset]), bad);
					op = temp_buf[offset & 1 ? i+1 : i];
				}
				n++;
				badoff = offset;
			}
			offset++;
			i++;
			size--;
		}
		if (n) {
		        prt("\t%#7x\n", n);
			if (bad)
				prt("operation# (mod 256) for the bad data"
					"may be %u\n", ((unsigned)op & 0xff));
			else
				prt("operation# (mod 256) for the bad data"
					"unknown, check HOLE and EXTEND ops\n");
		} else
		        prt("????????????????\n");
		report_failure(110);
	}
}

struct test_file {
	char *path;
	int fd;
	int o_direct;
} *test_files = NULL;

int num_test_files = 0;
enum fd_iteration_policy {
	FD_SINGLE,
	FD_ROTATE,
	FD_RANDOM,
};
int fd_policy = FD_RANDOM;
int fd_last = 0;

struct test_file *
get_tf(void)
{
	unsigned index = 0;

	switch (fd_policy) {
		case FD_ROTATE:
			index = fd_last++;
			break;
		case FD_RANDOM:
			index = random();
			break;
		case FD_SINGLE:
			index = 0;
			break;
		default:
			prt("unknown policy");
			exit(1);
			break;
	}
	return &test_files[ index % num_test_files ];
}

void
assign_fd_policy(char *policy)
{
	if (!strcmp(policy, "random"))
		fd_policy = FD_RANDOM;
	else if (!strcmp(policy, "rotate"))
		fd_policy = FD_ROTATE;
	else {
		prt("unknown -I policy: '%s'\n", policy);
		exit(1);
	}
}

int
get_fd(void)
{
	struct test_file *tf = get_tf();
	return tf->fd;
}

static const char *my_basename(const char *path)
{
	char *c = strrchr(path, '/');

	return c ? c++ : path;
}

int do_fallocate(int fd, int mode, long long offset, long long length)
{
#ifdef FALLOC_FL_KEEP_SIZE
	return fallocate(fd, mode, offset, length);
#else
#define FALLOC_FL_KEEP_SIZE 0x01

#ifdef __linux__
#if defined(__x86_64__)
#define __NR_fallocate		285
#elif defined(__i386__)
#define __NR_fallocate		324
#elif defined(__powerpc__)
#define __NR_fallocate          309
#elif defined(__s390__)
#define __NR_fallocate		314
#else
	warn("do_fallocate: fallocate not supported on this arch");
	errno = ENOSYS;
	return -1;
#endif

#if defined(__x86_64__) || defined(__powerpc64__) || defined(__s390x__)
	/* 64-bit: pass the 64-bit offset and length arguments directly */
	return syscall(__NR_fallocate, fd, mode, offset, length);
#elif defined(__i386__)
	/* 32-bit x86: offset and length are split into high- and low- words
	 *		order is offsetLo, offsetHi, lengthLo, lengthHi */
	return syscall(__NR_fallocate, fd, mode,
		       (unsigned int)offset, (unsigned int)(offset >> 32),
		       (unsigned int)length, (unsigned int)(length >> 32));
#elif defined(__powerpc__)
	/* 32-bit PPC: offset and length are split into high- and low- words
	 *		order is offsetHi, offsetLo, lengthHi, lengthLo */
	return syscall(__NR_fallocate, fd, mode,
		       (unsigned int)(offset >> 32), (unsigned int)offset,
		       (unsigned int)(length >> 32), (unsigned int)length);
#elif defined(__s390__)
	/* 31-bit s390: length is split into high- and low- words, offset not
	 *		order is offset, lengthHi, lengthLo */
	return syscall(__NR_fallocate, fd, mode, offset,
		       (unsigned int)(length >> 32), (unsigned int)length);
#endif
#else /* !__linux__ */
	warn("do_fallocate: fallocate not supported on this kernel");
	errno = ENOSYS;
	return -1;
#endif /* __linux__ */
#endif /* FALLOC_FL_KEEP_SIZE */
}

void
open_test_files(char **argv, int argc)
{
	struct test_file *tf;
	int i;

	num_test_files = argc;
	if (num_test_files == 1)
		fd_policy = FD_SINGLE;

	test_files = calloc(num_test_files, sizeof(*test_files));
	if (test_files == NULL) {
		prterr("reallocating space for test files");
		exit(1);
	}

	for (i = 0, tf = test_files; i < num_test_files; i++, tf++) {
		tf->path = argv[i];
		tf->o_direct = (o_direct && (random() % o_direct == 0)) ?
			OP_DIRECT : 0;
		tf->fd = open(tf->path, O_RDWR | (lite ? 0 : O_CREAT|O_TRUNC) |
			                tf->o_direct, 0666);
		if (tf->fd < 0) {
			prterr(tf->path);
			exit(91);
		}
	}

	if (quiet || fd_policy == FD_SINGLE)
		return;

	for (i = 0, tf = test_files; i < num_test_files; i++, tf++)
		prt("fd %d: %s\n", i, tf->path);
}

void
close_test_files(void)
{
	int i;
	struct test_file *tf;

	for (i = 0, tf = test_files; i < num_test_files; i++, tf++) {
		if (close(tf->fd)) {
			prterr("close");
			report_failure(99);
		}
	}
}


void
check_size(void)
{
	struct stat	statbuf;
	off_t	size_by_seek;
	int fd = get_fd();

	if (fstat(fd, &statbuf)) {
		prterr("check_size: fstat");
		statbuf.st_size = -1;
	}
	size_by_seek = lseek(fd, (off_t)0, SEEK_END);
	if (file_size != statbuf.st_size || file_size != size_by_seek) {
		prt("Size error: expected 0x%llx stat 0x%llx seek 0x%llx\n",
		    (unsigned long long)file_size,
		    (unsigned long long)statbuf.st_size,
		    (unsigned long long)size_by_seek);
		report_failure(120);
	}
}


void
check_trunc_hack(void)
{
	struct stat statbuf;
	int fd = get_fd();

        /* should not ignore ftruncate(2)'s return value */
        if (ftruncate(fd, (off_t)0) < 0) {
                prterr("trunc_hack: ftruncate(0)");
                exit(1);
        }
        if (ftruncate(fd, (off_t)100000) < 0) {
                prterr("trunc_hack: ftruncate(100000)");
                exit(1);
        }
	if (fstat(fd, &statbuf)) {
		prterr("trunc_hack: fstat");
		statbuf.st_size = -1;
	}
	if (statbuf.st_size != (off_t)100000) {
		prt("no extend on truncate! not posix!\n");
		exit(130);
	}
        if (ftruncate(fd, 0) < 0) {
                prterr("trunc_hack: ftruncate(0) (2nd call)");
                exit(1);
        }
}

static char *tf_buf = NULL;
static int max_tf_len = 0;

void
alloc_tf_buf(void)
{
	char dummy = '\0';
	int highest = num_test_files - 1;
	int len;

	len = snprintf(&dummy, 0, "%u ", highest);
	if (len < 1) {
		prterr("finding max tf_buf");
		exit(1);
	}
	len++;
	tf_buf = malloc(len);
	if (tf_buf == NULL) {
		prterr("allocating tf_buf");
		exit(1);
	}
	max_tf_len = snprintf(tf_buf, len, "%u ", highest);
	if (max_tf_len < 1) {
		prterr("fiding max_tv_len\n");
		exit(1);
	}
	if (max_tf_len != len - 1) {
		warn("snprintf() gave %d instead of %d?\n",
				max_tf_len, len - 1);
		exit(1);
	}
}

char *
fill_tf_buf(struct test_file *tf)
{
	if (tf_buf == NULL)
		alloc_tf_buf();

	sprintf(tf_buf,"%lu ", (unsigned long)(tf - test_files));
	return tf_buf;
}

void
output_line(struct test_file *tf, int op, unsigned offset,
	    unsigned size, struct timeval *tv)
{
	char *tf_num = "";

	char *ops[] = {
		[OP_READ] = "read",
		[OP_WRITE] = "write",
		[OP_TRUNCATE] = "trunc from",
		[OP_MAPREAD] = "mapread",
		[OP_MAPWRITE] = "mapwrite",
		[OP_FALLOCATE] = "fallocate",
#ifdef O_DIRECT
		[OP_READ + OP_DIRECT] = "read_OD",
		[OP_WRITE + OP_DIRECT] = "write_OD",
#endif
	};

	if (fd_policy != FD_SINGLE)
		tf_num = fill_tf_buf(tf);

	/* W. */
	if (!(!quiet && ((progressinterval &&
			testcalls % progressinterval == 0) ||
		       (debug &&
		        (monitorstart == -1 ||
			 (offset + size > monitorstart &&
			  (monitorend == -1 || offset <= monitorend)))))))
		return;

	prt("%06lu %llu.%06llu %.*s%-10s %#08x %s %#08x\t(0x%05x bytes)\n",
		testcalls, (long long)tv->tv_sec, (long long)tv->tv_usec,
		max_tf_len, tf_num, ops[op],
		offset, op == OP_TRUNCATE ? " to " : "thru",
		offset + size - 1, (int)size < 0 ? -(int)size : size);
}

void output_debug(unsigned offset, unsigned size, const char *what)
{
	if (!quiet && (debug > 1 &&
		        (monitorstart == -1 ||
			 (offset + size >= monitorstart &&
			  (monitorend == -1 || offset <= monitorend))))) {
		struct timeval t;

		gettimeofday(&t, NULL);
		prt("       %llu.%06llu %s\n",
		    (long long)t.tv_sec, (long long)t.tv_usec, what);
	}
}

void
doread(unsigned offset, unsigned size)
{
	struct timeval t;
	off_t ret;
	unsigned iret;
	struct test_file *tf = get_tf();
	int fd = tf->fd;

	if (tf->o_direct) {
		offset -= offset % (readbdy == 1 ? page_size : readbdy);
		size += page_size - size % (readbdy == 1 ? page_size : readbdy);
	} else {
		offset -= offset % readbdy;
	}
	gettimeofday(&t, NULL);
	if (size == 0) {
		if (!quiet && testcalls > simulatedopcount && !tf->o_direct)
			prt("skipping zero size read\n");
		log4(OP_SKIPPED, OP_READ, offset, size, &t);
		return;
	}
	if (size + offset > file_size) {
		if (!quiet && testcalls > simulatedopcount)
			prt("skipping seek/read past end of file\n");
		log4(OP_SKIPPED, OP_READ, offset, size, &t);
		return;
	}

	log4(OP_READ + tf->o_direct, offset, size, 0, &t);

	if (testcalls <= simulatedopcount)
		return;

	output_line(tf, OP_READ + tf->o_direct, offset, size, &t);

	ret = lseek(fd, (off_t)offset, SEEK_SET);
	if (ret == (off_t)-1) {
		prterr("doread: lseek");
		report_failure(140);
	}
	iret = read(fd, temp_buf, size);
	output_debug(offset, size, "read done");
	if (iret != size) {
		if (iret == -1)
			prterr("doread: read");
		else
			prt("short read: 0x%x bytes instead of 0x%x\n",
			    iret, size);
		report_failure(141);
	}
	check_buffers(offset, size);
}


void
check_eofpage(char *s, unsigned offset, char *p, int size)
{
	long last_page, should_be_zero;

	if (offset + size <= (file_size & ~page_mask))
		return;
	/*
	 * we landed in the last page of the file
	 * test to make sure the VM system provided 0's
	 * beyond the true end of the file mapping
	 * (as required by mmap def in 1996 posix 1003.1)
	 */
	last_page = ((long)p + (offset & page_mask) + size) & ~page_mask;

	for (should_be_zero = last_page + (file_size & page_mask);
	     should_be_zero < last_page + page_size;
	     should_be_zero++)
		if (*(char *)should_be_zero) {
			prt("non-zero mmap past EOF %#llx page @ %#lx is %#x\n",
			    (long long)file_size -1, should_be_zero & page_mask,
			    short_at(should_be_zero));
			report_failure(205);
		}
}


void
domapread(unsigned offset, unsigned size)
{
	struct timeval t;
	unsigned pg_offset;
	unsigned map_size;
	char    *p;
	struct test_file *tf = get_tf();
	int fd = tf->fd;

	if (tf->o_direct) {
		doread(offset, size);
		return;
	}

	offset -= offset % readbdy;
	gettimeofday(&t, NULL);
	if (size == 0) {
		if (!quiet && testcalls > simulatedopcount)
			prt("skipping zero size read\n");
		log4(OP_SKIPPED, OP_MAPREAD, offset, size, &t);
		return;
	}
	if (size + offset > file_size) {
		if (!quiet && testcalls > simulatedopcount)
			prt("skipping seek/read past end of file\n");
		log4(OP_SKIPPED, OP_MAPREAD, offset, size, &t);
		return;
	}

	log4(OP_MAPREAD, offset, size, 0, &t);

	if (testcalls <= simulatedopcount)
		return;

	output_line(tf, OP_MAPREAD, offset, size, &t);

	pg_offset = offset & page_mask;
	map_size  = pg_offset + size;

	if ((p = mmap(0, map_size, PROT_READ, MAP_FILE | MAP_SHARED, fd,
		      (off_t)(offset - pg_offset))) == MAP_FAILED) {
	        prterr("domapread: mmap");
		report_failure(190);
	}
	output_debug(offset, size, "mmap done");
	if (setjmp(jmpbuf) == 0) {
		jmpbuf_good = 1;
		memcpy(temp_buf, p + pg_offset, size);
		check_eofpage("Read", offset, p, size);
		jmpbuf_good = 0;
	} else {
		report_failure(1901);
	}
	output_debug(offset, size, "memcpy done");
	if (munmap(p, map_size) != 0) {
		prterr("domapread: munmap");
		report_failure(191);
	}
	output_debug(offset, size, "munmap done");

	check_buffers(offset, size);
}


void
gendata(char *original_buf, char *good_buf, unsigned offset, unsigned size)
{
	while (size--) {
		good_buf[offset] = testcalls % 256;
		if (offset % 2)
			good_buf[offset] += original_buf[offset];
		offset++;
	}
}


void
dowrite(unsigned offset, unsigned size)
{
	struct timeval t;
	off_t ret;
	unsigned iret;
	struct test_file *tf = get_tf();
	int fd = tf->fd;

	if (tf->o_direct) {
		offset -= offset % (writebdy == 1 ? page_size : writebdy);
		size += page_size - (size % (writebdy == 1 ? page_size : writebdy));
	} else {
		offset -= offset % writebdy;
	}
	gettimeofday(&t, NULL);
	if (size == 0) {
		if (!quiet && testcalls > simulatedopcount && !tf->o_direct)
			prt("skipping zero size write\n");
		log4(OP_SKIPPED, OP_WRITE, offset, size, &t);
		return;
	}

	log4(OP_WRITE + tf->o_direct, offset, size, file_size, &t);

	gendata(original_buf, good_buf, offset, size);
	if (file_size < offset + size) {
		if (file_size < offset)
			memset(good_buf + file_size, '\0', offset - file_size);
		file_size = offset + size;
		if (lite) {
			warn("Lite file size bug in fsx!");
			report_failure(149);
		}
	}

	if (testcalls <= simulatedopcount)
		return;

	output_line(tf, OP_WRITE + tf->o_direct, offset, size, &t);

	ret = lseek(fd, (off_t)offset, SEEK_SET);
	if (ret == (off_t)-1) {
		prterr("dowrite: lseek");
		report_failure(150);
	}
	iret = write(fd, good_buf + offset, size);
	output_debug(offset, size, "write done");
	if (iret != size) {
		if (iret == -1)
			prterr("dowrite: write");
		else
			prt("short write: 0x%x bytes instead of 0x%x\n",
			    iret, size);
		report_failure(151);
	}
	if (do_fsync) {
		if (fsync(fd)) {
			prt("fsync() failed: %s\n", strerror(errno));
			report_failure(152);
		}
		output_debug(offset, size, "fsync done");
	}
}


void
domapwrite(unsigned offset, unsigned size)
{
	struct timeval t;
	unsigned pg_offset;
	unsigned map_size;
	off_t    cur_filesize;
	char    *p;
	struct test_file *tf = get_tf();
	int fd = tf->fd;

	if (tf->o_direct) {
		dowrite(offset, size);
		return;
	}

	offset -= offset % writebdy;
	gettimeofday(&t, NULL);
	if (size == 0) {
		if (!quiet && testcalls > simulatedopcount)
			prt("skipping zero size write\n");
		log4(OP_SKIPPED, OP_MAPWRITE, offset, size, &t);
		return;
	}
	cur_filesize = file_size;

	log4(OP_MAPWRITE, offset, size, 0, &t);

	gendata(original_buf, good_buf, offset, size);
	if (file_size < offset + size) {
		if (file_size < offset)
			memset(good_buf + file_size, '\0', offset - file_size);
		file_size = offset + size;
		if (lite) {
			warn("Lite file size bug in fsx!");
			report_failure(200);
		}
	}

	if (testcalls <= simulatedopcount)
		return;

	output_line(tf, OP_MAPWRITE, offset, size, &t);

	if (file_size > cur_filesize) {
	        if (ftruncate(fd, file_size) == -1) {
		        prterr("domapwrite: ftruncate");
			exit(201);
		}
		output_debug(offset, size, "truncate done");
	}
	pg_offset = offset & page_mask;
	map_size  = pg_offset + size;

	if ((p = mmap(0, map_size, PROT_READ | PROT_WRITE, MAP_FILE|MAP_SHARED,
		      fd, (off_t)(offset - pg_offset))) == MAP_FAILED) {
	        prterr("domapwrite: mmap");
		report_failure(202);
	}
	output_debug(offset, map_size, "mmap done");
	if (setjmp(jmpbuf) == 0) {
		jmpbuf_good = 1;
		memcpy(p + pg_offset, good_buf + offset, size);
		if (msync(p, map_size, 0) != 0) {
			prterr("domapwrite: msync");
			report_failure(203);
		}
		check_eofpage("Write", offset, p, size);
		jmpbuf_good = 0;
	} else {
		report_failure(2021);
	}

	output_debug(offset, size, "memcpy done");
	if (msync(p, map_size, 0) != 0) {
		prterr("domapwrite: msync");
		report_failure(203);
	}
	output_debug(offset, map_size, "msync done");
	if (munmap(p, map_size) != 0) {
		prterr("domapwrite: munmap");
		report_failure(204);
	}
	output_debug(offset, map_size, "munmap done");
}


void
dotruncate(unsigned size)
{
	struct timeval t;
	int oldsize = file_size;
	struct test_file *tf = get_tf();
	int fd = tf->fd;

	size -= size % truncbdy;
	gettimeofday(&t, NULL);
	if (size > biggest) {
		biggest = size;
		if (!quiet && testcalls > simulatedopcount)
			prt("truncating to largest ever: 0x%x\n", size);
	}

	log4(OP_TRUNCATE, size, (unsigned)file_size, 0, &t);

	if (size > file_size)
		memset(good_buf + file_size, '\0', size - file_size);
	file_size = size;

	if (testcalls <= simulatedopcount)
		return;

	output_line(tf, OP_TRUNCATE, oldsize, size - oldsize, &t);

	if (ftruncate(fd, (off_t)size) == -1) {
	        prt("ftruncate1: %x\n", size);
		prterr("dotruncate: ftruncate");
		report_failure(160);
	}
	output_debug(size, 0, "truncate done");
}

/* fallocate is basically a no-op unless extending, then a lot like a truncate */
void
dofallocate(unsigned offset, unsigned length)
{
	struct timeval t;
	unsigned end_offset;
	int keep_size;
	struct test_file *tf = get_tf();
	int fd = tf->fd;

	gettimeofday(&t, NULL);
	if (length == 0) {
		if (!quiet && testcalls > simulatedopcount)
			prt("skipping zero length fallocate\n");
		log4(OP_SKIPPED, OP_FALLOCATE, offset, length, &t);
		return;
	}

	keep_size = random() % 2;

	end_offset = keep_size ? 0 : offset + length;

	if (end_offset > biggest) {
		biggest = end_offset;
		if (!quiet && testcalls > simulatedopcount)
			prt("fallocating to largest ever: 0x%x\n", end_offset);
	}

	/*
	 * last arg:
	 *	1: allocate past EOF
	 *	2: extending prealloc
	 *	3: interior prealloc
	 */
	log4(OP_FALLOCATE, offset, length,
	     (end_offset > file_size) ? (keep_size ? 1 : 2) : 3, &t);

	if (end_offset > file_size) {
		memset(good_buf + file_size, '\0', end_offset - file_size);
		file_size = end_offset;
	}

	if (testcalls <= simulatedopcount)
		return;

	output_line(tf, OP_FALLOCATE, offset, length, &t);

	if (do_fallocate(fd, keep_size ? FALLOC_FL_KEEP_SIZE : 0,
			 (long long)offset, (long long)length) == -1) {
	        prt("fallocate: %x to %x\n", offset, length);
		prterr("do_fallocate: fallocate");
		report_failure(161);
	}
	output_debug(offset, length, "fallocate done");
}

void
writefileimage()
{
	ssize_t iret;
	int fd = get_fd();

	if (lseek(fd, (off_t)0, SEEK_SET) == (off_t)-1) {
		prterr("writefileimage: lseek");
		report_failure(171);
	}
	iret = write(fd, good_buf, file_size);
	if ((off_t)iret != file_size) {
		if (iret == -1)
			prterr("writefileimage: write");
		else
			prt("short write: 0x%lx bytes instead of 0x%llx\n",
			    (unsigned long)iret,
			    (unsigned long long)file_size);
		report_failure(172);
	}
	if (lite ? 0 : ftruncate(fd, file_size) == -1) {
	        prt("ftruncate2: %llx\n", (unsigned long long)file_size);
		prterr("writefileimage: ftruncate");
		report_failure(173);
	}
}


void
docloseopen(void)
{
	struct timeval t;
	struct test_file *tf = get_tf();
	int direct = (o_direct && (random() % o_direct == 0)) ? OP_DIRECT : 0;
	char *tf_num = "";

	if (testcalls <= simulatedopcount)
		return;

	gettimeofday(&t, NULL);
	log4(OP_CLOSEOPEN + direct, file_size, (unsigned)file_size, 0, &t);

	if (fd_policy != FD_SINGLE)
		tf_num = fill_tf_buf(tf);

	if (debug)
		prt("%06lu %llu.%06llu %sclose/open%s\n", testcalls,
		    (long long)t.tv_sec, (long long)t.tv_usec,
		    tf_num, direct ? "(O_DIRECT)" : "");
	if (close(tf->fd)) {
		prterr(tf->o_direct ?
		       "docloseopen: close(O_DIRECT)" : "docloseopen: close");
		report_failure(180);
	}
	output_debug(monitorstart, 0, "close done");
	tf->o_direct = direct;
	tf->fd = open(tf->path, O_RDWR | direct, 0);
	if (tf->fd < 0) {
		prterr(tf->o_direct ?
		       "docloseopen: open(O_DIRECT)" : "docloseopen: open");
		report_failure(181);
	}
	output_debug(monitorstart, 0,
		     tf->o_direct ? "open done" : "open(O_DIRECT) done");
}


void
test(void)
{
	unsigned long	offset;
	unsigned long	size = maxoplen;
	unsigned long	rv = random();
	unsigned long	op = rv % (3 + !lite + mapped_writes + fallocate_calls);

        /* turn off the map read if necessary */

        if (op == 2 && !mapped_reads)
            op = 0;

	if (simulatedopcount > 0 && testcalls == simulatedopcount)
		writefileimage();

	testcalls++;

	if (debugstart > 0 && testcalls >= debugstart)
		debug = 1;

	if (!quiet && testcalls < simulatedopcount && testcalls % 100000 == 0)
		prt("%lu...\n", testcalls);

	/*
	 *                 lite  !lite
	 * READ:	op = 0	   0
	 * WRITE:	op = 1     1
	 * MAPREAD:     op = 2     2
	 * TRUNCATE:	op = -     3
	 * MAPWRITE:    op = 3     4
	 * FALLOCATE:   op = -     5
	 */
	if (lite ? 0 : op == 3 && (style & 1) == 0) /* vanilla truncate? */
		dotruncate(random() % maxfilelen);
	else {
		if (randomoplen)
			size = random() % (maxoplen+1);
		/* truncate */
		if (lite ? 0 : op == 3)
			dotruncate(size);
		else {
			offset = random();
			/* fallocate */
			if (op == 5) {
				offset %= maxfilelen;
				if (offset + size > maxfilelen)
					size = maxfilelen - offset;
				dofallocate(offset, size);
			/* write / mapwrite */
			} else if (op == 1 || op == (lite ? 3 : 4)) {
				offset %= maxfilelen;
				if (offset + size > maxfilelen)
					size = maxfilelen - offset;
				if (op != 1)
					domapwrite(offset, size);
				else
					dowrite(offset, size);
			/* read / mapread */
			} else {
				if (file_size)
					offset %= file_size;
				else
					offset = 0;
				if (offset + size > file_size)
					size = file_size - offset;
				if (op != 0)
					domapread(offset, size);
				else
					doread(offset, size);
			}
		}
	}
	if (sizechecks && testcalls > simulatedopcount)
		check_size();
	if (closeprob && (rv >> 3) < (1 << 28) / closeprob)
		docloseopen();
}

void
segv(int sig)
{
	if (jmpbuf_good) {
		jmpbuf_good = 0;
		longjmp(jmpbuf, 1);
	}
	report_failure(9999);
}

void
cleanup(sig)
	int	sig;
{
	if (sig)
		prt("signal %d\n", sig);
	prt("testcalls = %lu\n", testcalls);
	exit(sig);
}


void
usage(void)
{
	fprintf(stdout, "usage: fsx [-dfnqFLOW] [-b opnum] [-c Prob] [-l flen]\n"
"\t\t[-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style]\n"
"\t\t[-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath]\n"
"\t\t[-S seed] [-Z [prob]] [ -I random|rotate ] fname [more paths to fname..]\n"
"	-b opnum: beginning operation number (default 1)\n"
"	-c P: 1 in P chance of file close+open at each op (default infinity)\n"
"	-d: debug output for all operations [-d -d = more debugging]\n"
/* OSX: -d duration: number of hours for the tool to run\n" */
/* OSX: -e: tests using an extended attribute rather than a file\n" */
"	-f: fsync after every write operation\n"
/* OSX: -f forkname: test the named fork of fname\n" */
/* OSX: -g logpath: path for .fsxlog file\n" */
/* OSX: -h: write 0s instead of creating holes (i.e. sparse file)\n" */
/* OSX: -i: interactive mode, hit return before performing each operation\n" */
"	-l flen: the upper bound on file size (default 262144)\n"
/* OSX: -l logpath: path for XILog file\n" */
"	-m startop:endop: monitor (print debug output) specified byte rang"
"(default 0:infinity)\n"
"	-n: no verifications of file size\n"
"	-o oplen: the upper bound on operation size (default 65536)\n"
"	-p progressinterval: debug output at specified operation interval\n"
"	-q: quieter operation\n"
"	-r readbdy: %u would make reads page aligned (default 1)\n"
"	-s style: 1 gives smaller truncates (default 0)\n"
"	-t truncbdy: %u would make truncates page aligned (default 1)\n"
/* OSX: -v: debug output for all operations\n" */
"	-w writebdy: %u would make writes page aligned (default 1)\n"
/* old: -x[1|2]: preallocate file space (2 does no size update)\n" */
/* OSX: -x: write output in XML (XILOG)\n" */
/* OSX: -y: call fsync before closing the file\n" */
/* AKPM:-A: Use the AIO system calls\n" */
/* OSX: -C mix cached and un-cached read/write ops\n" */
"	-D startingop: debug output starting at specified operation\n"
"	-F: Do not use fallocate (preallocation) calls\n"
/* OSX: -F flen: the upper bound on file size (default 262144)\n" */
/* OSX: -G logsize: #entries in oplog (default 1024)\n" */
"	-I {rotate|random}: When multiple paths to the file are given,\n"
"	    each operation uses a different path.  Iterate through them in\n"
"	    order with 'rotate' or chose them at 'random'.  (defaults random)\n"
/* OSX: -I: start interactive mode since operation opnum\n" */
"	-L: fsxLite - no file creations & no file size changes\n"
/* OSX: -M: slow motion mode, wait 1 second before each op\n" */
"	-N numops: total # operations to do (default infinity)\n"
"	-O: use oplen (see -o flag) for every op (default random)\n"
"	-P: save .fsxlog and .fsxgood files in dirpath (default ./)\n"
"	-R: read() system calls only (mapped reads disabled)\n"
"	-S seed: for random # generator (default 1) 0 gets timestamp\n"
/* OSX: -T datasize: size of atomic data element writes [1,2,4] (default 4)\n" */
"	-W: mapped write operations DISabled\n"
"	-Z[P]: O_DIRECT file IO [1 in P chance for each open] (default off)\n"
"	fname: this filename is REQUIRED (no default)\n",
	page_size, page_size, page_size);
	exit(90);
}


int
getnum(char *s, char **e)
{
	int ret = -1;

	*e = (char *) 0;
	ret = strtol(s, e, 0);
	if (*e)
		switch (**e) {
		case 'b':
		case 'B':
			ret *= 512;
			*e = *e + 1;
			break;
		case 'k':
		case 'K':
			ret *= 1024;
			*e = *e + 1;
			break;
		case 'm':
		case 'M':
			ret *= 1024*1024;
			*e = *e + 1;
			break;
		case 'w':
		case 'W':
			ret *= 4;
			*e = *e + 1;
			break;
		}
	return (ret);
}

int
main(int argc, char **argv)
{
	int	i, style, ch;
	char    *orig_good_buf, *orig_temp_buf;
	char	*endp;
	int  dirpath = 0;

	goodfile[0] = 0;
	logfile[0] = 0;

	page_size = getpagesize();
	page_mask = page_size - 1;

	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */

	while ((ch = getopt(argc, argv,
			    "b:c:dfl:m:no:p:qr:s:t:w:D:FI:LN:OP:RS:WZ::"))
	       != EOF)
		switch (ch) {
		case 'b':
			simulatedopcount = getnum(optarg, &endp);
			if (!quiet)
				fprintf(stdout, "Will begin at operation %ld\n",
					simulatedopcount);
			if (simulatedopcount == 0)
				usage();
			simulatedopcount -= 1;
			break;
		case 'c':
			closeprob = getnum(optarg, &endp);
			if (!quiet)
				fprintf(stdout,
					"Chance of close/open is 1 in %d\n",
					closeprob);
			if (closeprob <= 0)
				usage();
			break;
		case 'd':
			debug++;
			break;
		case 'f':
			do_fsync = 1;
			break;
		case 'l':
			maxfilelen = getnum(optarg, &endp);
			if (maxfilelen <= 0)
				usage();
			break;
		case 'm':
			monitorstart = getnum(optarg, &endp);
			if (monitorstart < 0)
				usage();
			if (!endp || *endp++ != ':')
				usage();
			monitorend = getnum(endp, &endp);
			if (monitorend < 0)
				usage();
			if (monitorend == 0)
				monitorend = -1; /* aka infinity */
			debug = 1;
		case 'n':
			sizechecks = 0;
			break;
		case 'o':
			maxoplen = getnum(optarg, &endp);
			if (maxoplen <= 0)
				usage();
			break;
		case 'p':
			progressinterval = getnum(optarg, &endp);
			if (progressinterval < 0)
				usage();
			break;
		case 'q':
			quiet = 1;
			break;
		case 'r':
			readbdy = getnum(optarg, &endp);
			if (readbdy <= 0)
				usage();
			break;
		case 's':
			style = getnum(optarg, &endp);
			if (style < 0 || style > 1)
				usage();
			break;
		case 't':
			truncbdy = getnum(optarg, &endp);
			if (truncbdy <= 0)
				usage();
			break;
		case 'w':
			writebdy = getnum(optarg, &endp);
			if (writebdy <= 0)
				usage();
			break;
		case 'x':
			/* deprecated */
			break;
		case 'D':
			debugstart = getnum(optarg, &endp);
			if (debugstart < 1)
				usage();
			break;
		case 'F':
			fallocate_calls = 0;
			break;
		case 'I':
			assign_fd_policy(optarg);
			break;
		case 'L':
		        lite = 1;
			break;
		case 'N':
			numops = getnum(optarg, &endp);
			if (numops < 0)
				usage();
			break;
		case 'O':
			randomoplen = 0;
			break;
		case 'P':
			strncpy(goodfile, optarg, sizeof(goodfile));
			strcat(goodfile, "/");
			strncpy(logfile, optarg, sizeof(logfile));
			strcat(logfile, "/");
			dirpath = 1;
			break;
                case 'R':
                        mapped_reads = 0;
                        break;
		case 'S':
                        seed = getnum(optarg, &endp);
			if (seed == 0)
				seed = time(0) % 10000;
			if (!quiet)
				fprintf(stdout, "Seed set to %d\n", seed);
			if (seed < 0)
				usage();
			break;
		case 'W':
		        mapped_writes = 0;
			if (!quiet)
				fprintf(stdout, "mapped writes DISABLED\n");
			break;
		case 'Z':
#ifdef O_DIRECT
			if (optarg == NULL ||
			    (o_direct = getnum(optarg, &endp)) == 0)
				o_direct = 1;
#else
			fprintf(stderr, "O_DIRECT not supported\n");
#endif
			break;
		default:
			usage();
			/* NOTREACHED */
		}
	argc -= optind;
	argv += optind;
	if (argc < 1)
		usage();
	fname = argv[0];

	signal(SIGHUP,	cleanup);
	signal(SIGINT,	cleanup);
	signal(SIGPIPE,	cleanup);
	signal(SIGALRM,	cleanup);
	signal(SIGTERM,	cleanup);
	signal(SIGXCPU,	cleanup);
	signal(SIGXFSZ,	cleanup);
	signal(SIGVTALRM,	cleanup);
	signal(SIGUSR1,	cleanup);
	signal(SIGUSR2,	cleanup);
	signal(SIGBUS,	segv);
	signal(SIGSEGV,	segv);

	initstate(seed, state, 256);
	setstate(state);

	open_test_files(argv, argc);

	strncat(goodfile, dirpath ? my_basename(fname) : fname, 256);
	strcat (goodfile, ".fsxgood");
	fsxgoodfd = open(goodfile, O_RDWR|O_CREAT|O_TRUNC, 0666);
	if (fsxgoodfd < 0) {
		prterr(goodfile);
		exit(92);
	}
	strncat(logfile, dirpath ? my_basename(fname) : fname, 256);
	strcat (logfile, ".fsxlog");
	fsxlogf = fopen(logfile, "w");
	if (fsxlogf == NULL) {
		prterr(logfile);
		exit(93);
	}
	if (lite) {
		off_t ret;
		int fd = get_fd();
		file_size = maxfilelen = lseek(fd, (off_t)0, SEEK_END);
		if (file_size == (off_t)-1) {
			prterr(fname);
			warn("main: lseek eof");
			exit(94);
		}
		ret = lseek(fd, (off_t)0, SEEK_SET);
		if (ret == (off_t)-1) {
			prterr(fname);
			warn("main: lseek 0");
			exit(95);
		}
	}
	original_buf = (char *) malloc(maxfilelen);
	if (original_buf == NULL)
		exit(96);
	for (i = 0; i < maxfilelen; i++)
		original_buf[i] = random() % 256;

	orig_good_buf = malloc(maxfilelen + page_size);
	if (orig_good_buf == NULL)
		exit(97);
	good_buf = round_up(orig_good_buf, page_size);
	memset(good_buf, '\0', maxfilelen);

	orig_temp_buf = malloc(maxoplen + page_size);
	if (orig_temp_buf == NULL)
		exit(99);
	temp_buf = round_up(orig_temp_buf, page_size);
	memset(temp_buf, '\0', maxoplen);

	if (lite) {	/* zero entire existing file */
		ssize_t written;
		int fd = get_fd();

		written = write(fd, good_buf, (size_t)maxfilelen);
		if (written != maxfilelen) {
			if (written == -1) {
				prterr(fname);
				warn("main: error on write");
			} else
				warn("main: short write, 0x%x bytes instead"
					"of 0x%x\n",
				     (unsigned)written, maxfilelen);
			exit(98);
		}
	} else {
		check_trunc_hack();
	}

	if (!lite && fallocate_calls) {
		int fd = get_fd();
		if (do_fallocate(fd, 0, 0, 1) &&
		    (errno == EOPNOTSUPP || errno == ENOSYS)) {
			warn("main: disabling fallocate");
			fallocate_calls = 0;
		} else {
			ftruncate(fd, 0);
		}
	}

	while (numops == -1 || numops--)
		test();

	close_test_files();
	prt("All operations completed A-OK!\n");

	if (tf_buf)
		free(tf_buf);

	free(original_buf);
	free(orig_good_buf);
	free(orig_temp_buf);

	return 0;
}

--Apple-Mail-20-639248842
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--Apple-Mail-20-639248842--
