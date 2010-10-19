Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9J929uJ134759 for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 04:02:10 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B87401E7D392
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 02:03:19 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	wTLEzz2HvtfXrysR for <xfs@oss.sgi.com>;
	Tue, 19 Oct 2010 02:03:19 -0700 (PDT)
Date: Tue, 19 Oct 2010 20:03:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Add test 244: Check filesystem FITRIM
Message-ID: <20101019090303.GD11284@dastard>
References: <1285863641-1894-1-git-send-email-lczerner@redhat.com>
	<1287395946-6890-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1287395946-6890-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On Mon, Oct 18, 2010 at 11:59:06AM +0200, Lukas Czerner wrote:
> Check filesystem FITRIM implementation. FITRIM is ioctl that uses
> filesystem new super_operation->trim_fs. Its purpose is to provide
> a way to discard free space on mounted filesystem in more efficient
> manner. More details here:
> 
> http://www.spinics.net/lists/linux-ext4/msg21050.html
> 
> This test creates checksums of all files in /usr/share/doc directory and
> run several processes which clear its working directory, then copy
> everything from /usr/share/doc into its working directory, create list of
> files in working directory and its checksums and compare it with the
> original list of checksums. Every process works in the loop so it repeat
> remove->copy->check, while fstrim tool is running simultaneously.
> 
> Fstrim is just a helper tool which uses FITRIM ioctl to actually do the
> filesystem discard.
> 
> I found this very useful because when the FITRIM is really buggy (thus
> data-destroying) the 244 test will notice, because checksums will most
> likely change.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  244          |  163 +++++++++++++++++++++++++++++++++++++
>  244.out      |    4 +
>  group        |    1 +
>  src/Makefile |    2 +-
>  src/fstrim.c |  251 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 420 insertions(+), 1 deletions(-)
>  create mode 100755 244
>  create mode 100644 244.out
>  create mode 100644 src/fstrim.c
> 
> diff --git a/244 b/244
> new file mode 100755
> index 0000000..01e7545
> --- /dev/null
> +++ b/244
> @@ -0,0 +1,163 @@
> +#!/bin/bash -
> +# -*- Shell-script -*-

That comment can be killed. ;)

> +#
> +# Copyright (C) 1999 Bibliotech Ltd., 631-633 Fulham Rd., London SW6 5UQ.

Ah, where does the code under that copyright come from? What license
did it originally have?

> +# Copyright 2010 (C) Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
> +#
> +# $Id: stress.sh,v 1.2 1999/02/10 10:58:04 rich Exp $
> +#
> +# Change log:
> +#
> +# $Log: stress.sh,v $
> +# Revision 1.2  1999/02/10 10:58:04  rich
> +# Use cp instead of tar to copy.
> +#
> +# Revision 1.1  1999/02/09 15:13:38  rich
> +# Added first version of stress test program.
> +#
> +# 2010/09/30 Lukas Czerner
> +# Changed to comply with other xfstests tests.

Change logs don't belong in files.

What should be here is a license statement (GPLv2 preferably)....

> +#
> +
> +# Stress-test a file system by doing multiple
> +# parallel disk operations. This does everything
> +# in SCRATCH_MNT/stress.
> +
> +owner=lczerner@redhat.com
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=`mktemp -d`
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 3
> +trap "_destroy; exit \$status" 2 15
> +chpid=0
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +_cleanup()
> +{
> +	rm -rf $tmp
> +}
> +
> +_destroy()
> +{
> +	kill $pids $fstrim_pid
> +	wait $pids $fstrim_pid
> +	rm -rf $tmp
> +}
> +
> +_destroy_fstrim()
> +{
> +	kill $fpid
> +	wait $fpid
> +}
> +
> +fstrim_loop()
> +{
> +	trap "_destroy_fstrim; exit \$status" 2 15
> +	fsize=$(df | grep $SCRATCH_MNT | grep $SCRATCH_DEV  | awk '{print $2}')

That awk statement won't work on all awk implemenations. Some
require an explicit match rule. awk '// {print $2}' should work,
though.

> +
> +	while true ; do
> +		step=1048576
> +		start=0
> +		$here/src/fstrim $SCRATCH_MNT &
> +		fpid=$!
> +		wait $fpid

Why put it in the background, only to wait for it immediately? I'm
assuming this trims the entire device, right? Perhaps a comment on
what the loop is trying to do?

> +		while [ $start -lt $fsize ] ; do
> +			$here/src/fstrim -s ${start}k -l ${step}k $SCRATCH_MNT &
> +			fpid=$!
> +			wait $fpid

Ditto - why the background and wait?

> +			start=$(( $start + $step ))
> +		done
> +		sleep 1
> +	done
> +}
> +
> +function run_process() {
> +	local p=$1
> +	repeat=10
> +
> +	# Wait for all processes to start up.
> +	if [ "$stagger" = "yes" ]; then
> +	    sleep $((10*$p)) &
> +		export chpid=$! && wait $chpid &> /dev/null
> +		chpid=0
> +	else
> +	    sleep 10 &
> +		export chpid=$! && wait $chpid &> /dev/null
> +		chpid=0
> +	fi

why bother with $stagger when itis only ever defined to "yes"?

Also, with 10 processes, that means it takes 100s just to start up?
What's the typical runtime of this test?

> +
> +	while [ $repeat -gt 0 ]; do
> +
> +		# Remove old directories.
> +		rm -rf $SCRATCH_MNT/$p
> +		export chpid=$! && wait $chpid &> /dev/null
> +
> +		# Copy content -> partition.
> +		mkdir $SCRATCH_MNT/$p
> +		cp -ax $content/* $SCRATCH_MNT/$p
> +		sync
> +
> +		# Compare the content and the copy.
> +		( cd $SCRATCH_MNT/$p && find . -type f -print0 | xargs -0 md5sum | sort -k 2 -o $tmp/stress.$$.$p )

		find $SCRATCH_MNT/$p .... ?

> +		diff $tmp/content.sums $tmp/stress.$$.$p
> +		rm -f $tmp/stress.$$.$p
> +		repeat=$(( $repeat - 1 ))
> +	done
> +}
> +
> +nconcurrent=10

"nprocs" is the usual terminology for the number of processes to
run in parallel...

> +content=/usr/share/doc
> +stagger=yes
> +
> +# Check for FITRIM support
> +echo -n "Checking FITRIM support: "
> +$here/src/fstrim -l 1G $SCRATCH_MNT
> +[ $? -ne 0 ] && exit
> +echo "done."

This should be a `_notrun "FITRIM not supported"` so the test
doesn't actually count as a failure if the fs does not support
FITRIM.

> +
> +mkdir -p $tmp
> +
> +# Construct MD5 sums over the content directory.
> +
> +echo -n "Computing MD5 sums over content directory: "
> +( cd $content && find . -type f -print0 | xargs -0 md5sum | sort -k 2 -o $tmp/content.sums )

find $content ....

> +echo "done."
> +
> +# Start the stressing processes.
> +
> +echo -n "Starting stress test processes: "
> +
> +pids=""
> +fstrim_loop &
> +fstrim_pid=$!
> +
> +p=1
> +while [ $p -le $nconcurrent ]; do
> +	run_process $p &
> +	pids="$pids $!"
> +	p=$(($p+1))
> +done
> +echo "done."
> +
> +wait $pids
> +kill $fstrim_pid
> +wait $fstrim_pid
> +
> +status=0
> +_check_scratch_fs

No need to check the filesystem - the test harness does that for
you once the test exits.

> +
> +exit
> diff --git a/244.out b/244.out
> new file mode 100644
> index 0000000..5b94eab
> --- /dev/null
> +++ b/244.out
> @@ -0,0 +1,4 @@
> +QA output created by 244
> +Checking FITRIM support: done.
> +Computing MD5 sums over content directory: done.
> +Starting stress test processes: done.
> diff --git a/group b/group
> index e6dab13..a94e423 100644
> --- a/group
> +++ b/group
> @@ -357,3 +357,4 @@ deprecated
>  241 auto
>  242 auto quick prealloc
>  243 auto quick prealloc
> +244 ioctl
> diff --git a/src/Makefile b/src/Makefile
> index e878cff..8bba5d6 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -16,7 +16,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
>  	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
>  	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
> -	stale_handle
> +	stale_handle fstrim
>  
>  SUBDIRS =
>  
> diff --git a/src/fstrim.c b/src/fstrim.c
> new file mode 100644
> index 0000000..da596a3
> --- /dev/null
> +++ b/src/fstrim.c
> @@ -0,0 +1,251 @@
> +/*
> + * fstrim.c -- discard the part (or whole) of mounted filesystem.
> + *
> + * Copyright (C) 2009 Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
> + *
> + * %Begin-Header%
> + * This file may be redistributed under the terms of the GNU Public
> + * License.
> + * %End-Header%

Kill the %...% stuff, and best to put the entire GPL license header
here, espcially one that contains the version of the license ;)

> + *
> + * Usage: fstrim [options] <mount point>
> + */
> +
> +#include <string.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <errno.h>
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <fcntl.h>
> +#include <limits.h>
> +#include <stdarg.h>
> +
> +#ifdef HAVE_GETOPT_H
> +#include <getopt.h>
> +#else
> +extern char *optarg;
> +extern int optind;
> +#endif

No need for the HAVE_GETOPT_H - all the other test code uses it and
none of them have an autoconf test for it.

> +
> +#include <sys/ioctl.h>
> +#include <sys/stat.h>
> +#include <linux/fs.h>
> +
> +#ifndef FITRIM
> +struct fstrim_range {
> +	uint64_t start;
> +	uint64_t len;
> +	uint64_t minlen;
> +};
> +#define FITRIM		_IOWR('X', 121, struct fstrim_range)
> +#endif
> +
> +const char *program_name = "fstrim";
> +
> +struct options {
> +	struct fstrim_range *range;
> +	char mpoint[PATH_MAX];
> +	char verbose;
> +};
> +
> +static void usage(void)
> +{
> +	fprintf(stderr,
> +		"Usage: %s [-s start] [-l length] [-m minimum-extent]"
> +		" [-v] {mountpoint}\n\t"
> +		"-s Starting Byte to discard from\n\t"
> +		"-l Number of Bytes to discard from the start\n\t"
> +		"-m Minimum extent length to discard\n\t"
> +		"-v Verbose - number of discarded bytes\n",
> +		program_name);
> +}
> +
> +static void err_exit(const char *fmt, ...)
> +{
> +	va_list pvar;
> +	va_start(pvar, fmt);
> +	vfprintf(stderr, fmt, pvar);
> +	va_end(pvar);
> +	usage();
> +	exit(EXIT_FAILURE);
> +}
> +
> +static void err_range(const char *optarg)
> +{
> +	err_exit("%s: %s (%s)\n", program_name, strerror(ERANGE), optarg);
> +}

just hard code the strerror(ERANGE) call into an err_exit call.
> +
> +/**
> + * Get the number from argument. It can be number followed by
> + * units: k|K, m|M, g|G, t|T
> + */
> +static unsigned long long get_number(char **optarg)
> +{
> +	char *opt, *end;
> +	unsigned long long number, max;
> +
> +	/* get the max to avoid overflow */
> +	max = ULLONG_MAX / 1024;
> +	number = 0;
> +	opt = *optarg;
> +
> +	errno = 0;
> +	number = strtoul(opt, &end , 0);
> +	if (errno)
> +		err_exit("%s: %s (%s)\n", program_name,
> +			 strerror(errno), *optarg);
> +
> +	/* determine if units are defined */
> +	switch (*end) {
> +	case 'T': /* terabytes */
> +	case 't':
> +		if (number > max)
> +			err_range(*optarg);
> +		number *= 1024;
> +	case 'G': /* gigabytes */
> +	case 'g':
> +		if (number > max)
> +			err_range(*optarg);
> +		number *= 1024;
> +	case 'M': /* megabytes */
> +	case 'm':
> +		if (number > max)
> +			err_range(*optarg);
> +		number *= 1024;
> +	case 'K': /* kilobytes */
> +	case 'k':
> +		if (number > max)
> +			err_range(*optarg);
> +		number *= 1024;
> +		end++;
> +	case '\0': /* end of the string */
> +		break;

it took me a few minutes to notice that this is a fallthrough
stack. Please comment that. i.e. instead of just leaving the
"break;" line out, replace it with /* fall through */ to indicate
that is intentional.

> +	default:
> +		err_exit("%s: %s (%s)\n", program_name,
> +			 strerror(EINVAL), *optarg);
> +		return 0;
> +	}
> +
> +	if (*end != '\0') {
> +		err_exit("%s: %s (%s)\n", program_name,
> +			 strerror(EINVAL), *optarg);
> +	}
> +
> +	return number;
> +}
> +
> +static int parse_opts(int argc, char **argv, struct options *opts)
> +{
> +	int c;
> +
> +	while ((c = getopt(argc, argv, "s:l:m:v")) != EOF) {
> +		switch (c) {
> +		case 's': /* starting point */
> +			opts->range->start = get_number(&optarg);
> +			break;
> +		case 'l': /* length */
> +			opts->range->len = get_number(&optarg);
> +			break;
> +		case 'm': /* minlen */
> +			opts->range->minlen = get_number(&optarg);
> +			break;
> +		case 'v': /* verbose */
> +			opts->verbose = 1;
> +			break;
> +		default:
> +			return EXIT_FAILURE;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void free_opts(struct options *opts)
> +{
> +	if (opts) {
> +		if (opts->range)
> +			free(opts->range);
> +		free(opts);
> +	}
> +}
> +
> +static void free_opts_and_exit(struct options *opts)
> +{
> +	free_opts(opts);
> +	exit(EXIT_FAILURE);
> +}
> +
> +static void print_usage_and_exit(struct options *opts)
> +{
> +	usage();
> +	free_opts_and_exit(opts);
> +}

Way too much pointless indirection. Kill these three functions and
use a simple error unwind stack.

> +
> +int main(int argc, char **argv)
> +{
> +	struct options *opts;
> +	struct stat sb;
> +	int fd, ret = 0;
	int exit_val = EXIT_FAILURE;
> +
> +	opts = malloc(sizeof(struct options));
> +	if (!opts)
> +		err_exit("%s: malloc(): %s\n", program_name, strerror(errno));
> +
> +	opts->range = NULL;
> +	opts->verbose = 0;
> +
> +	if (argc > 1)
> +		strncpy(opts->mpoint, argv[argc - 1], sizeof(opts->mpoint));
> +
> +	if (argc > 2) {
> +		opts->range = calloc(1, sizeof(struct fstrim_range));
> +		if (!opts->range) {
> +			fprintf(stderr, "%s: calloc(): %s\n", program_name,
> +				strerror(errno));
> +			free_opts_and_exit(opts);
> +		}
> +		opts->range->len = ULLONG_MAX;
> +		ret = parse_opts(argc, argv, opts);
> +	}
> +
> +	if (ret)
		usage();
		goto free_opts;
	}

> +		print_usage_and_exit(opts);
> +
> +	if (strnlen(opts->mpoint, 1) < 1) {
> +		fprintf(stderr, "%s: You have to specify mount point.\n",
> +			program_name);
> +		print_usage_and_exit(opts);
		usage();
		goto free_opts;
> +	}
> +
> +	if (stat(opts->mpoint, &sb) == -1) {
> +		fprintf(stderr, "%s: %s: %s\n", program_name,
> +			opts->mpoint, strerror(errno));
> +		print_usage_and_exit(opts);
		usage();
		goto free_opts;
> +	}
> +
> +	if (!S_ISDIR(sb.st_mode)) {
> +		fprintf(stderr, "%s: %s: (%s)\n", program_name,
> +			opts->mpoint, strerror(ENOTDIR));
> +		print_usage_and_exit(opts);
		usage();
		goto free_opts;
> +	}
> +
> +	fd = open(opts->mpoint, O_RDONLY);
> +	if (fd < 0) {
> +		fprintf(stderr, "%s: open(%s): %s\n", program_name,
> +			opts->mpoint, strerror(errno));
> +		free_opts_and_exit(opts);
		goto free_opts;
> +	}
> +
> +	if (ioctl(fd, FITRIM, opts->range)) {
> +		fprintf(stderr, "%s: FSTRIM: %s\n", program_name,
> +			strerror(errno));
> +		free_opts_and_exit(opts);
		goto free_opts;
> +	}

	exit_val = EXIT_SUCCESS;
> +
> +	if ((opts->verbose) && (opts->range))
> +		fprintf(stdout, "%lu Bytes was trimmed\n", opts->range->len);
> +
> +	free_opts(opts);
> +	return ret;

free_opts:
	if (opts) {
		if (opts->range)
			free(opts->range);
		free(opts);
	}
	exit(exit_val)
}

> +}
> -- 
> 1.7.2.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
