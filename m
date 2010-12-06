Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB6AIwUj228103 for <xfs@oss.sgi.com>; Mon, 6 Dec 2010 04:18:58 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1689D1C9876B
	for <xfs@oss.sgi.com>; Mon,  6 Dec 2010 02:20:44 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0LZDVRkFeaPSlfd2 for
	<xfs@oss.sgi.com>; Mon, 06 Dec 2010 02:20:44 -0800 (PST)
Date: Mon, 6 Dec 2010 11:20:31 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] Add test 248: Check filesystem FITRIM implementation
In-Reply-To: <1290780743-12112-1-git-send-email-lczerner@redhat.com>
Message-ID: <alpine.LFD.2.00.1012061117570.2876@dhcp-lab-213.englab.brq.redhat.com>
References: <1290780743-12112-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: hch@infradead.org, esandeen@redhat.com, xfs@oss.sgi.com

On Fri, 26 Nov 2010, Lukas Czerner wrote:

> FITRIM ioctl  is used on a mounted filesystem to discard (or "trim")
> blocks which are not in use by the filesystem.  This is useful for
> solid-state drives (SSDs) and thinly-provi-sioned storage. This test
> helps to verify filesystem FITRIM implementation to assure that it
> does not corrupts data.
> 
> This test creates checksums of all files in /usr/share/doc directory and
> run several processes which clear its working directory on SCRATCH_MNT,
> then copy everything from /usr/share/doc into its working directory, create
> list of files in working directory and its checksums and compare it with the
> original list of checksums. Every process works in the loop so it repeat
> remove->copy->check, while fstrim tool is running simultaneously.
> 
> Fstrim is just a helper tool which uses FITRIM ioctl to actually do the
> filesystem discard.
> 
> I found this very useful because when the FITRIM is really buggy (thus
> data-destroying) the 248 test will notice, because checksums will most
> likely change.

Hello, what is the status of this patch ? It would be nice to get some
response before someone add a new test and the patch becomes obsolete
:).

Thanks!

-Lukas

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  248          |  163 +++++++++++++++++++++++++++++++++++++
>  248.out      |    3 +
>  group        |    1 +
>  src/Makefile |    2 +-
>  src/fstrim.c |  257 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 425 insertions(+), 1 deletions(-)
>  create mode 100755 248
>  create mode 100644 248.out
>  create mode 100644 src/fstrim.c
> 
> diff --git a/248 b/248
> new file mode 100755
> index 0000000..0d2f17f
> --- /dev/null
> +++ b/248
> @@ -0,0 +1,163 @@
> +#!/bin/bash
> +# FS QA Test No. 248
> +#
> +# This test was created in order to verify filesystem FITRIM implementation.
> +# By many concurrent copy and remove operations and checking that files
> +# does not change after copied into SCRATCH_MNT test if FITIM implementation
> +# corrupts the filesystem (data/metadata).
> +#
> +#-----------------------------------------------------------------------
> +# Copyright 2010 (C) Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
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
> +mypid=$$
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
> +
> +	while true ; do
> +		step=1048576
> +		start=0
> +		$here/src/fstrim $SCRATCH_MNT &
> +		fpid=$!
> +		wait $fpid
> +		while [ $start -lt $fsize ] ; do
> +			$here/src/fstrim -s ${start}k -l ${step}k $SCRATCH_MNT &
> +			fpid=$!
> +			wait $fpid
> +			start=$(( $start + $step ))
> +		done
> +	done
> +}
> +
> +function check_sums() {
> +	dir=$1
> +
> +	(
> +	cd $SCRATCH_MNT/$p
> +	find -P . -xdev -type f -print0 | xargs -0 md5sum | sort -o $tmp/stress.$$.$p
> +	)
> +
> +	diff $tmp/content.sums $tmp/stress.$$.$p
> +	if [ $? -ne 0 ]; then
> +		echo "!!!Checksums has changed - Filesystem possibly corrupted!!!\n"
> +		kill $mypid
> +	fi
> +	rm -f $tmp/stress.$$.$p
> +}
> +
> +function run_process() {
> +	local p=$1
> +	repeat=10
> +
> +	sleep $((5*$p))s &
> +	export chpid=$! && wait $chpid &> /dev/null
> +	chpid=0
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
> +		export chpid=$! && wait $chpid &> /dev/null
> +
> +		check_sums
> +		repeat=$(( $repeat - 1 ))
> +	done
> +}
> +
> +nproc=20
> +content=/usr/share/doc
> +
> +# Check for FITRIM support
> +echo -n "Checking FITRIM support: "
> +$here/src/fstrim -l 10M $SCRATCH_MNT
> +[ $? -ne 0 ] && exit
> +echo "done."
> +
> +mkdir -p $tmp
> +
> +(
> +cd $content
> +find -P . -xdev -type f -print0 | xargs -0 md5sum | sort -o $tmp/content.sums
> +)
> +
> +echo -n "Running the test: "
> +pids=""
> +fstrim_loop &
> +fstrim_pid=$!
> +p=1
> +while [ $p -le $nproc ]; do
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
> +
> +exit
> diff --git a/248.out b/248.out
> new file mode 100644
> index 0000000..880d9c7
> --- /dev/null
> +++ b/248.out
> @@ -0,0 +1,3 @@
> +QA output created by 248
> +Checking FITRIM support: done.
> +Running the test: done.
> diff --git a/group b/group
> index 0f94dd9..fea84ed 100644
> --- a/group
> +++ b/group
> @@ -361,3 +361,4 @@ deprecated
>  245 auto quick dir
>  246 auto quick rw
>  247 auto quick rw
> +248 ioctl
> diff --git a/src/Makefile b/src/Makefile
> index b827bd0..885fd65 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -17,7 +17,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
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
> index 0000000..6686c99
> --- /dev/null
> +++ b/src/fstrim.c
> @@ -0,0 +1,257 @@
> +/*
> + * fstrim.c -- discard the part (or whole) of mounted filesystem.
> + *
> + * Copyright (C) 2009 Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + *
> + * This program uses FITRIM ioctl to discard parts or the whole filesystem
> + * online (mounted). You can specify range (start and lenght) to be
> + * discarded, or simply discard while filesystem.
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
> +#include <getopt.h>
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
> +	if (*opt == '-') {
> +		err_exit("%s: %s (%s)\n", program_name,
> +			 strerror(ERANGE), *optarg);
> +	}
> +
> +	errno = 0;
> +	number = strtoul(opt, &end , 0);
> +	if (errno)
> +		err_exit("%s: %s (%s)\n", program_name,
> +			 strerror(errno), *optarg);
> +
> +	/*
> +	 * Convert units to numbers. Fall-through stack is used for units
> +	 * so absence of breaks is intentional.
> +	 */
> +	switch (*end) {
> +	case 'T': /* terabytes */
> +	case 't':
> +		if (number > max)
> +			err_exit("%s: %s (%s)\n", program_name,
> +				 strerror(ERANGE), *optarg);
> +		number *= 1024;
> +	case 'G': /* gigabytes */
> +	case 'g':
> +		if (number > max)
> +			err_exit("%s: %s (%s)\n", program_name,
> +				 strerror(ERANGE), *optarg);
> +		number *= 1024;
> +	case 'M': /* megabytes */
> +	case 'm':
> +		if (number > max)
> +			err_exit("%s: %s (%s)\n", program_name,
> +				 strerror(ERANGE), *optarg);
> +		number *= 1024;
> +	case 'K': /* kilobytes */
> +	case 'k':
> +		if (number > max)
> +			err_exit("%s: %s (%s)\n", program_name,
> +				 strerror(ERANGE), *optarg);
> +		number *= 1024;
> +		end++;
> +	case '\0': /* end of the string */
> +		break;
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
> +int main(int argc, char **argv)
> +{
> +	struct options *opts;
> +	struct stat sb;
> +	int fd, err = 0, ret = EXIT_FAILURE;
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
> +	opts->range = calloc(1, sizeof(struct fstrim_range));
> +	if (!opts->range) {
> +		fprintf(stderr, "%s: calloc(): %s\n", program_name,
> +			strerror(errno));
> +		goto free_opts;
> +	}
> +
> +	opts->range->len = ULLONG_MAX;
> +
> +	if (argc > 2)
> +		err = parse_opts(argc, argv, opts);
> +
> +	if (err) {
> +		usage();
> +		goto free_opts;
> +	}
> +
> +	if (strnlen(opts->mpoint, 1) < 1) {
> +		fprintf(stderr, "%s: You have to specify mount point.\n",
> +			program_name);
> +		usage();
> +		goto free_opts;
> +	}
> +
> +	if (stat(opts->mpoint, &sb) == -1) {
> +		fprintf(stderr, "%s: %s: %s\n", program_name,
> +			opts->mpoint, strerror(errno));
> +		usage();
> +		goto free_opts;
> +	}
> +
> +	if (!S_ISDIR(sb.st_mode)) {
> +		fprintf(stderr, "%s: %s: (%s)\n", program_name,
> +			opts->mpoint, strerror(ENOTDIR));
> +		usage();
> +		goto free_opts;
> +	}
> +
> +	fd = open(opts->mpoint, O_RDONLY);
> +	if (fd < 0) {
> +		fprintf(stderr, "%s: open(%s): %s\n", program_name,
> +			opts->mpoint, strerror(errno));
> +		goto free_opts;
> +	}
> +
> +	if (ioctl(fd, FITRIM, opts->range)) {
> +		fprintf(stderr, "%s: FSTRIM: %s\n", program_name,
> +			strerror(errno));
> +		goto free_opts;
> +	}
> +
> +	if ((opts->verbose) && (opts->range))
> +		fprintf(stdout, "%llu Bytes was trimmed\n", opts->range->len);
> +
> +	ret = EXIT_SUCCESS;
> +
> +free_opts:
> +	if (opts) {
> +		if (opts->range)
> +			free(opts->range);
> +		free(opts);
> +	}
> +
> +	return ret;
> +}
> 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
