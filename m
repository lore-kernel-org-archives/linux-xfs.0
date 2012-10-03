Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q93B2eGH193690 for <xfs@oss.sgi.com>; Wed, 3 Oct 2012 06:02:40 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9NCG4ysoGcb912hc for
	<xfs@oss.sgi.com>; Wed, 03 Oct 2012 04:04:04 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q93B44Gk016468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 3 Oct 2012 07:04:04 -0400
Date: Wed, 3 Oct 2012 13:03:59 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v3] xfstests: Use upstream version of fstrim instead of
	the local one
In-Reply-To: <1345035645-6356-1-git-send-email-tracek@redhat.com>
Message-ID: <alpine.LFD.2.00.1210031241110.18540@localhost>
References: <1345035645-6356-1-git-send-email-tracek@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On Wed, 15 Aug 2012, Tomas Racek wrote:

> Date: Wed, 15 Aug 2012 15:00:45 +0200
> From: Tomas Racek <tracek@redhat.com>
> To: xfs@oss.sgi.com
> Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>
> Subject: [PATCH v3] xfstests: Use upstream version of fstrim instead of the
>     local one
> 
> Local version of fstrim was dropped so that we depend on upstream
> version which is now available via $FSTRIM_PROG. _require_fstrim was
> added to check if fstrim is available in the system and
> _test_batched_discard to check if we can run fstrim on certain
> mountpoint.
> 
> Also tests 251 and 260 were modified to reflect this change.
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>
> ---
>  .gitignore    |    1 -
>  251           |   14 +--
>  260           |   36 +++++----
>  260.out       |    8 +-
>  common.config |    1 +
>  common.rc     |   13 +++
>  src/Makefile  |    2 +-
>  src/fstrim.c  |  257 ---------------------------------------------------------
>  8 files changed, 45 insertions(+), 287 deletions(-)
>  delete mode 100644 src/fstrim.c
> 
> diff --git a/.gitignore b/.gitignore
> index 900ff95..c0e0e4c 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -37,7 +37,6 @@ src/fill
>  src/fill2
>  src/fs_perms
>  src/fstest
> -src/fstrim
>  src/ftrunc
>  src/genhashnames
>  src/getdevicesize
> diff --git a/251 b/251
> index f46b6e2..dbb6ba7 100755
> --- a/251
> +++ b/251
> @@ -44,6 +44,7 @@ mypid=$$
>  _supported_fs generic
>  _supported_os Linux
>  _require_scratch
> +_require_fstrim
>  _scratch_mkfs >/dev/null 2>&1
>  _scratch_mount
>  
> @@ -71,16 +72,11 @@ _fail()
>  	kill $mypid 2> /dev/null
>  }
>  
> -_check_fstrim_support()
> -{
> -	$here/src/fstrim -l 10M $SCRATCH_MNT &> /dev/null
> -}

Good to see that you've replaced this with generic check.

> -
>  _guess_max_minlen()
>  {
>  	mmlen=100000
>  	while [ $mmlen -gt 1 ]; do
> -		$here/src/fstrim -l $(($mmlen*2))k -m ${mmlen}k $SCRATCH_MNT &> /dev/null && break
> +		$FSTRIM_PROG -l $(($mmlen*2))k -m ${mmlen}k $SCRATCH_MNT &> /dev/null && break
>  		mmlen=$(($mmlen/2))
>  	done
>  	echo $mmlen
> @@ -102,12 +98,12 @@ fstrim_loop()
>  		minlen=$(((RANDOM*($RANDOM%2+1))%$mmlen))
>  		start=$RANDOM
>  		if [ $((RANDOM%10)) -gt 7 ]; then
> -			$here/src/fstrim $SCRATCH_MNT &
> +			$FSTRIM_PROG $SCRATCH_MNT &
>  			fpid=$!
>  			wait $fpid
>  		fi
>  		while [ $start -lt $fsize ] ; do
> -			$here/src/fstrim -m ${minlen}k -s ${start}k -l ${step}k $SCRATCH_MNT &
> +			$FSTRIM_PROG -m ${minlen}k -o ${start}k -l ${step}k $SCRATCH_MNT &
>  			fpid=$!
>  			wait $fpid
>  			start=$(( $start + $step ))
> @@ -157,7 +153,7 @@ content=$here
>  
>  # Check for FITRIM support
>  echo -n "Checking FITRIM support: "
> -_check_fstrim_support || _notrun "FSTRIM is not supported"
> +_test_batched_discard $SCRATCH_MNT || _notrun "FITRIM not supported on $SCRATCH_DEV"

good

>  echo "done."
>  
>  mkdir -p $tmp
> diff --git a/260 b/260
> index b005cd3..21aa866 100755
> --- a/260
> +++ b/260
> @@ -41,13 +41,13 @@ mypid=$$
>  _supported_fs generic
>  _supported_os Linux
>  _require_math
> +_require_fstrim
>  
>  _require_scratch
>  _scratch_mkfs >/dev/null 2>&1
>  _scratch_mount
>  
> -FSTRIM="$here/src/fstrim"
> -"$FSTRIM" -l 10M $SCRATCH_MNT &> /dev/null || _notrun "FSTRIM is not supported"
> +_test_batched_discard $SCRATCH_MNT || _notrun "FITRIM not supported on $SCRATCH_DEV"
>  
>  fssize=$(df -k | grep "$SCRATCH_MNT" | grep "$SCRATCH_DEV"  | awk '{print $2}')
>  
> @@ -59,20 +59,24 @@ max_64bit=$(_math "2^64 - 1")
>  # the file system
>  
>  echo "[+] Start beyond the end of fs (should fail)"
> -"$FSTRIM" -s $beyond_eofs $SCRATCH_MNT
> +out=$($FSTRIM_PROG -o $beyond_eofs $SCRATCH_MNT 2>&1)
>  [ $? -eq 0 ] && status=1
> +echo -n $out | cut -d ":" -f3-

I am not sure what is the point of this change ? Simply
s/FSTRIM/FSTRIM_PROG/ should be fine right ? Also you change some of
it but not all of it.

>  
>  echo "[+] Start beyond the end of fs with len set (should fail)"
> -"$FSTRIM" -s $beyond_eofs -l1M $SCRATCH_MNT
> +out=$($FSTRIM_PROG -o $beyond_eofs -l1M $SCRATCH_MNT 2>&1)
>  [ $? -eq 0 ] && status=1
> +echo -n $out | cut -d ":" -f3-

same here

>  
>  echo "[+] Start = 2^64-1 (should fail)"
> -"$FSTRIM" -s $max_64bit $SCRATCH_MNT
> +out=$($FSTRIM_PROG -o $max_64bit $SCRATCH_MNT 2>&1)
>  [ $? -eq 0 ] && status=1
> +echo -n $out | cut -d ":" -f3-

here

>  
>  echo "[+] Start = 2^64-1 and len is set (should fail)"
> -"$FSTRIM" -s $max_64bit -l1M $SCRATCH_MNT
> +out=$($FSTRIM_PROG -o $max_64bit -l1M $SCRATCH_MNT 2>&1)
>  [ $? -eq 0 ] && status=1
> +echo -n $out | cut -d ":" -f3-

and here.

>  
>  _scratch_unmount
>  _scratch_mkfs >/dev/null 2>&1
> @@ -82,16 +86,16 @@ _scratch_mount
>  # since the length should be truncated
>  
>  echo "[+] Default length (should succeed)"
> -"$FSTRIM" $SCRATCH_MNT
> +$FSTRIM_PROG $SCRATCH_MNT
>  [ $? -ne 0 ] && status=1
>  echo "[+] Default length with start set (should succeed)"
> -"$FSTRIM" -s10M $SCRATCH_MNT
> +$FSTRIM_PROG -o10M $SCRATCH_MNT
>  [ $? -ne 0 ] && status=1
>  echo "[+] Length beyond the end of fs (should succeed)"
> -"$FSTRIM" -l $beyond_eofs $SCRATCH_MNT
> +$FSTRIM_PROG -l $beyond_eofs $SCRATCH_MNT
>  [ $? -ne 0 ] && status=1
>  echo "[+] Length beyond the end of fs with start set (should succeed)"
> -"$FSTRIM" -s10M -l $beyond_eofs $SCRATCH_MNT
> +$FSTRIM_PROG -o10M -l $beyond_eofs $SCRATCH_MNT
>  [ $? -ne 0 ] && status=1
>  
>  _scratch_unmount
> @@ -101,8 +105,9 @@ _scratch_mount
>  # This is a bit fuzzy, but since the file system is fresh
>  # there should be at least (fssize/2) free space to trim.
>  # This is supposed to catch wrong FITRIM argument handling
> -out=$("$FSTRIM" -v -s10M $SCRATCH_MNT)
> -bytes=${out%% *}
> +out=$($FSTRIM_PROG -v -o10M $SCRATCH_MNT)
> +nopref=${out##*: }
> +bytes=${nopref%% *}
>  
>  if [ $bytes -gt $(_math "$fssize*1024") ]; then
>  	status=1
> @@ -155,7 +160,7 @@ _scratch_unmount
>  _scratch_mkfs >/dev/null 2>&1
>  _scratch_mount
>  # It should fail since $start is beyond the end of file system
> -"$FSTRIM" -s$start -l10M $SCRATCH_MNT &> /dev/null
> +$FSTRIM_PROG -o$start -l10M $SCRATCH_MNT &> /dev/null
>  if [ $? -eq 0 ]; then
>  	status=1
>  	echo "It seems that fs logic handling start"\
> @@ -173,8 +178,9 @@ _scratch_mount
>  # It is because btrfs does not have not-yet-used parts of the device
>  # mapped and since we got here right after the mkfs, there is not
>  # enough free extents in the root tree.
> -out=$("$FSTRIM" -v -l$len $SCRATCH_MNT)
> -bytes=${out%% *}
> +out=$($FSTRIM_PROG -v -l$len $SCRATCH_MNT)
> +nopref=${out##*: }
> +bytes=${nopref%% *}
>  if [ $bytes -le $(_math "$fssize*512") ] && [ $FSTYP != "btrfs" ]; then
>  	status=1
>  	echo "It seems that fs logic handling len argument overflows"
> diff --git a/260.out b/260.out
> index 199320a..cf0b14e 100644
> --- a/260.out
> +++ b/260.out
> @@ -1,12 +1,12 @@
>  QA output created by 260
>  [+] Start beyond the end of fs (should fail)
> -fstrim: FSTRIM: Invalid argument
> + FITRIM ioctl failed: Invalid argument
>  [+] Start beyond the end of fs with len set (should fail)
> -fstrim: FSTRIM: Invalid argument
> + FITRIM ioctl failed: Invalid argument
>  [+] Start = 2^64-1 (should fail)
> -fstrim: FSTRIM: Invalid argument
> + FITRIM ioctl failed: Invalid argument
>  [+] Start = 2^64-1 and len is set (should fail)
> -fstrim: FSTRIM: Invalid argument
> + FITRIM ioctl failed: Invalid argument
>  [+] Default length (should succeed)
>  [+] Default length with start set (should succeed)
>  [+] Length beyond the end of fs (should succeed)
> diff --git a/common.config b/common.config
> index 7bed1c5..57f505d 100644
> --- a/common.config
> +++ b/common.config
> @@ -158,6 +158,7 @@ export XFS_QUOTA_PROG="`set_prog_path xfs_quota`"
>  export KILLALL_PROG="`set_prog_path killall`"
>  export INDENT_PROG="`set_prog_path indent`"
>  export XFS_COPY_PROG="`set_prog_path xfs_copy`"
> +export FSTRIM_PROG="`set_prog_path fstrim`"
>  
>  # Generate a comparable xfsprogs version number in the form of
>  # major * 10000 + minor * 100 + release
> diff --git a/common.rc b/common.rc
> index 602513a..0d2f712 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -1778,6 +1778,19 @@ _devmgt_add()
>  	echo ${tdl} >  /sys/class/scsi_host/host${h}/scan || _fail "Add disk failed"
>  }
>  
> +_require_fstrim()
> +{
> +	if [ -z "$FSTRIM_PROG" ]; then
> +		_notrun "This test requires fstrim utility."
> +	fi
> +}
> +
> +_test_batched_discard()
> +{

Something like this should be here:

if [ $# -ne 1 ]
then
	echo "Usage: _test_batched_discard mount_point" 1>&2
	exit 1
fi

> +	_require_fstrim
> +	$FSTRIM_PROG ${1} &>/dev/null

It is ok I guess, we do not really need to specify the length argument
since it should not take too long to discard the whole file system.

Thanks!
-Lukas

> +}
> +
>  ################################################################################
>  
>  if [ "$iam" != new -a "$iam" != bench ]
> diff --git a/src/Makefile b/src/Makefile
> index 67250ee..9671a38 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -17,7 +17,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
>  	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
>  	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
> -	stale_handle pwrite_mmap_blocked fstrim t_dir_offset2
> +	stale_handle pwrite_mmap_blocked t_dir_offset2
>  
>  SUBDIRS =
>  
> diff --git a/src/fstrim.c b/src/fstrim.c
> deleted file mode 100644
> index e23bcb3..0000000
> --- a/src/fstrim.c
> +++ /dev/null
> @@ -1,257 +0,0 @@
> -/*
> - * fstrim.c -- discard the part (or whole) of mounted filesystem.
> - *
> - * Copyright (C) 2010 Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
> - *
> - * This program is free software: you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation, either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> - *
> - * This program uses FITRIM ioctl to discard parts or the whole filesystem
> - * online (mounted). You can specify range (start and lenght) to be
> - * discarded, or simply discard while filesystem.
> - *
> - * Usage: fstrim [options] <mount point>
> - */
> -
> -#include <string.h>
> -#include <unistd.h>
> -#include <stdlib.h>
> -#include <errno.h>
> -#include <stdio.h>
> -#include <stdint.h>
> -#include <fcntl.h>
> -#include <limits.h>
> -#include <stdarg.h>
> -#include <getopt.h>
> -
> -#include <sys/ioctl.h>
> -#include <sys/stat.h>
> -#include <linux/fs.h>
> -
> -#ifndef FITRIM
> -struct fstrim_range {
> -	uint64_t start;
> -	uint64_t len;
> -	uint64_t minlen;
> -};
> -#define FITRIM		_IOWR('X', 121, struct fstrim_range)
> -#endif
> -
> -const char *program_name = "fstrim";
> -
> -struct options {
> -	struct fstrim_range *range;
> -	char mpoint[PATH_MAX];
> -	char verbose;
> -};
> -
> -static void usage(void)
> -{
> -	fprintf(stderr,
> -		"Usage: %s [-s start] [-l length] [-m minimum-extent]"
> -		" [-v] {mountpoint}\n\t"
> -		"-s Starting Byte to discard from\n\t"
> -		"-l Number of Bytes to discard from the start\n\t"
> -		"-m Minimum extent length to discard\n\t"
> -		"-v Verbose - number of discarded bytes\n",
> -		program_name);
> -}
> -
> -static void err_exit(const char *fmt, ...)
> -{
> -	va_list pvar;
> -	va_start(pvar, fmt);
> -	vfprintf(stderr, fmt, pvar);
> -	va_end(pvar);
> -	usage();
> -	exit(EXIT_FAILURE);
> -}
> -
> -/**
> - * Get the number from argument. It can be number followed by
> - * units: k|K, m|M, g|G, t|T
> - */
> -static unsigned long long get_number(char **optarg)
> -{
> -	char *opt, *end;
> -	unsigned long long number, max;
> -
> -	/* get the max to avoid overflow */
> -	max = ULLONG_MAX / 1024;
> -	number = 0;
> -	opt = *optarg;
> -
> -	if (*opt == '-') {
> -		err_exit("%s: %s (%s)\n", program_name,
> -			 strerror(ERANGE), *optarg);
> -	}
> -
> -	errno = 0;
> -	number = strtoull(opt, &end , 0);
> -	if (errno)
> -		err_exit("%s: %s (%s)\n", program_name,
> -			 strerror(errno), *optarg);
> -
> -	/*
> -	 * Convert units to numbers. Fall-through stack is used for units
> -	 * so absence of breaks is intentional.
> -	 */
> -	switch (*end) {
> -	case 'T': /* terabytes */
> -	case 't':
> -		if (number > max)
> -			err_exit("%s: %s (%s)\n", program_name,
> -				 strerror(ERANGE), *optarg);
> -		number *= 1024;
> -	case 'G': /* gigabytes */
> -	case 'g':
> -		if (number > max)
> -			err_exit("%s: %s (%s)\n", program_name,
> -				 strerror(ERANGE), *optarg);
> -		number *= 1024;
> -	case 'M': /* megabytes */
> -	case 'm':
> -		if (number > max)
> -			err_exit("%s: %s (%s)\n", program_name,
> -				 strerror(ERANGE), *optarg);
> -		number *= 1024;
> -	case 'K': /* kilobytes */
> -	case 'k':
> -		if (number > max)
> -			err_exit("%s: %s (%s)\n", program_name,
> -				 strerror(ERANGE), *optarg);
> -		number *= 1024;
> -		end++;
> -	case '\0': /* end of the string */
> -		break;
> -	default:
> -		err_exit("%s: %s (%s)\n", program_name,
> -			 strerror(EINVAL), *optarg);
> -		return 0;
> -	}
> -
> -	if (*end != '\0') {
> -		err_exit("%s: %s (%s)\n", program_name,
> -			 strerror(EINVAL), *optarg);
> -	}
> -
> -	return number;
> -}
> -
> -static int parse_opts(int argc, char **argv, struct options *opts)
> -{
> -	int c;
> -
> -	while ((c = getopt(argc, argv, "s:l:m:v")) != EOF) {
> -		switch (c) {
> -		case 's': /* starting point */
> -			opts->range->start = get_number(&optarg);
> -			break;
> -		case 'l': /* length */
> -			opts->range->len = get_number(&optarg);
> -			break;
> -		case 'm': /* minlen */
> -			opts->range->minlen = get_number(&optarg);
> -			break;
> -		case 'v': /* verbose */
> -			opts->verbose = 1;
> -			break;
> -		default:
> -			return EXIT_FAILURE;
> -		}
> -	}
> -
> -	return 0;
> -}
> -
> -int main(int argc, char **argv)
> -{
> -	struct options *opts;
> -	struct stat sb;
> -	int fd, err = 0, ret = EXIT_FAILURE;
> -
> -	opts = malloc(sizeof(struct options));
> -	if (!opts)
> -		err_exit("%s: malloc(): %s\n", program_name, strerror(errno));
> -
> -	opts->range = NULL;
> -	opts->verbose = 0;
> -
> -	if (argc > 1)
> -		strncpy(opts->mpoint, argv[argc - 1], sizeof(opts->mpoint));
> -
> -	opts->range = calloc(1, sizeof(struct fstrim_range));
> -	if (!opts->range) {
> -		fprintf(stderr, "%s: calloc(): %s\n", program_name,
> -			strerror(errno));
> -		goto free_opts;
> -	}
> -
> -	opts->range->len = ULLONG_MAX;
> -
> -	if (argc > 2)
> -		err = parse_opts(argc, argv, opts);
> -
> -	if (err) {
> -		usage();
> -		goto free_opts;
> -	}
> -
> -	if (strnlen(opts->mpoint, 1) < 1) {
> -		fprintf(stderr, "%s: You have to specify mount point.\n",
> -			program_name);
> -		usage();
> -		goto free_opts;
> -	}
> -
> -	if (stat(opts->mpoint, &sb) == -1) {
> -		fprintf(stderr, "%s: %s: %s\n", program_name,
> -			opts->mpoint, strerror(errno));
> -		usage();
> -		goto free_opts;
> -	}
> -
> -	if (!S_ISDIR(sb.st_mode)) {
> -		fprintf(stderr, "%s: %s: (%s)\n", program_name,
> -			opts->mpoint, strerror(ENOTDIR));
> -		usage();
> -		goto free_opts;
> -	}
> -
> -	fd = open(opts->mpoint, O_RDONLY);
> -	if (fd < 0) {
> -		fprintf(stderr, "%s: open(%s): %s\n", program_name,
> -			opts->mpoint, strerror(errno));
> -		goto free_opts;
> -	}
> -
> -	if (ioctl(fd, FITRIM, opts->range)) {
> -		fprintf(stderr, "%s: FSTRIM: %s\n", program_name,
> -			strerror(errno));
> -		goto free_opts;
> -	}
> -
> -	if ((opts->verbose) && (opts->range))
> -		fprintf(stdout, "%llu Bytes were trimmed\n", (unsigned long long)opts->range->len);
> -
> -	ret = EXIT_SUCCESS;
> -
> -free_opts:
> -	if (opts) {
> -		if (opts->range)
> -			free(opts->range);
> -		free(opts);
> -	}
> -
> -	return ret;
> -}
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
