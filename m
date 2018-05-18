Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59818 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbeEROhQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 May 2018 10:37:16 -0400
Date: Fri, 18 May 2018 07:37:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 5/5] generic: test invalid swap file activation
Message-ID: <20180518143707.GG4910@magnolia>
References: <cover.1526503000.git.osandov@fb.com>
 <e8f4a838934823615c8cd7814a64e2230f9d6ae9.1526503000.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8f4a838934823615c8cd7814a64e2230f9d6ae9.1526503000.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: fstests@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, kernel-team@fb.com

On Wed, May 16, 2018 at 01:38:49PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Swap files cannot have holes, and they must at least two pages.
> swapon(8) and mkswap(8) have stricter restrictions, so add versions of
> those commands without any restrictions.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  .gitignore            |  2 ++
>  src/Makefile          |  2 +-
>  src/mkswap.c          | 83 +++++++++++++++++++++++++++++++++++++++++++
>  src/swapon.c          | 24 +++++++++++++
>  tests/generic/490     | 77 +++++++++++++++++++++++++++++++++++++++
>  tests/generic/490.out |  5 +++
>  tests/generic/group   |  1 +
>  7 files changed, 193 insertions(+), 1 deletion(-)
>  create mode 100644 src/mkswap.c
>  create mode 100644 src/swapon.c
>  create mode 100755 tests/generic/490
>  create mode 100644 tests/generic/490.out
> 
> diff --git a/.gitignore b/.gitignore
> index 53029e24..efc73a7c 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -92,6 +92,7 @@
>  /src/lstat64
>  /src/makeextents
>  /src/metaperf
> +/src/mkswap
>  /src/mmapcat
>  /src/multi_open_unlink
>  /src/nametest
> @@ -111,6 +112,7 @@
>  /src/seek_sanity_test
>  /src/stale_handle
>  /src/stat_test
> +/src/swapon
>  /src/t_access_root
>  /src/t_dir_offset
>  /src/t_dir_offset2
> diff --git a/src/Makefile b/src/Makefile
> index c42d3bb1..01fe99ef 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -26,7 +26,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
>  	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
>  	dio-invalidate-cache stat_test t_encrypted_d_revalidate \
> -	attr_replace_test
> +	attr_replace_test swapon mkswap
>  
>  SUBDIRS = log-writes perf
>  
> diff --git a/src/mkswap.c b/src/mkswap.c
> new file mode 100644
> index 00000000..d0bce2bd
> --- /dev/null
> +++ b/src/mkswap.c
> @@ -0,0 +1,83 @@
> +/* mkswap(8) without any sanity checks */
> +
> +#include <stdint.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +
> +struct swap_header {
> +	char		bootbits[1024];
> +	uint32_t	version;
> +	uint32_t	last_page;
> +	uint32_t	nr_badpages;
> +	unsigned char	sws_uuid[16];
> +	unsigned char	sws_volume[16];
> +	uint32_t	padding[117];
> +	uint32_t	badpages[1];
> +};
> +
> +int main(int argc, char **argv)
> +{
> +	struct swap_header *hdr;
> +	FILE *file;
> +	struct stat st;
> +	long page_size;
> +	int ret;
> +
> +	if (argc != 2) {
> +		fprintf(stderr, "usage: %s PATH\n", argv[0]);
> +		return EXIT_FAILURE;
> +	}
> +
> +	page_size = sysconf(_SC_PAGESIZE);
> +	if (page_size == -1) {
> +		perror("sysconf");
> +		return EXIT_FAILURE;
> +	}
> +
> +	hdr = calloc(1, page_size);
> +	if (!hdr) {
> +		perror("calloc");
> +		return EXIT_FAILURE;
> +	}
> +
> +	file = fopen(argv[1], "r+");
> +	if (!file) {
> +		perror("fopen");
> +		free(hdr);
> +		return EXIT_FAILURE;
> +	}
> +
> +	ret = fstat(fileno(file), &st);
> +	if (ret) {
> +		perror("fstat");
> +		free(hdr);
> +		fclose(file);
> +		return EXIT_FAILURE;
> +	}
> +
> +	hdr->version = 1;
> +	hdr->last_page = st.st_size / page_size - 1;
> +	memset(&hdr->sws_uuid, 0x99, sizeof(hdr->sws_uuid));
> +	memcpy((char *)hdr + page_size - 10, "SWAPSPACE2", 10);
> +
> +	if (fwrite(hdr, page_size, 1, file) != 1) {
> +		perror("fwrite");
> +		free(hdr);
> +		fclose(file);
> +		return EXIT_FAILURE;
> +	}
> +
> +	if (fclose(file) == EOF) {
> +		perror("fwrite");
> +		free(hdr);
> +		return EXIT_FAILURE;
> +	}
> +
> +	free(hdr);
> +
> +	return EXIT_SUCCESS;
> +}
> diff --git a/src/swapon.c b/src/swapon.c
> new file mode 100644
> index 00000000..0cb7108a
> --- /dev/null
> +++ b/src/swapon.c
> @@ -0,0 +1,24 @@
> +/* swapon(8) without any sanity checks; simply calls swapon(2) directly. */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <sys/swap.h>
> +
> +int main(int argc, char **argv)
> +{
> +	int ret;
> +
> +	if (argc != 2) {
> +		fprintf(stderr, "usage: %s PATH\n", argv[0]);
> +		return EXIT_FAILURE;
> +	}
> +
> +	ret = swapon(argv[1], 0);
> +	if (ret) {
> +		perror("swapon");
> +		return EXIT_FAILURE;
> +	}
> +
> +	return EXIT_SUCCESS;
> +}
> diff --git a/tests/generic/490 b/tests/generic/490
> new file mode 100755
> index 00000000..6ba2ecb3
> --- /dev/null
> +++ b/tests/generic/490
> @@ -0,0 +1,77 @@
> +#! /bin/bash
> +# FS QA Test 490
> +#
> +# Test invalid swap files.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2018 Facebook.  All Rights Reserved.
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
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch_swapfile
> +_require_test_program mkswap
> +_require_test_program swapon
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +
> +echo "File with holes"
> +# We can't use _format_swapfile because we're using our custom mkswap and
> +# swapon.
> +touch "$SCRATCH_MNT/swap"
> +$CHATTR_PROG +C "$SCRATCH_MNT/swap"

FWIW I see:

/djwong/e2fsprogs/build-x64/misc/chattr: Operation not supported while setting flags on /opt/swap

on XFS (we don't support the nocow flag), so the stdout/stderr need to
be redirected elsewhere.

--D

> +chmod 0600 "$SCRATCH_MNT/swap"
> +$XFS_IO_PROG -c "truncate $(($(get_page_size) * 10))" "$SCRATCH_MNT/swap"
> +"$here/src/mkswap" "$SCRATCH_MNT/swap"
> +"$here/src/swapon" "$SCRATCH_MNT/swap"
> +swapoff "$SCRATCH_MNT/swap" >/dev/null 2>&1
> +
> +echo "Empty swap file (only swap header)"
> +rm -f "$SCRATCH_MNT/swap"
> +touch "$SCRATCH_MNT/swap"
> +$CHATTR_PROG +C "$SCRATCH_MNT/swap"
> +chmod 0600 "$SCRATCH_MNT/swap"
> +_pwrite_byte 0x61 0 $(get_page_size) "$SCRATCH_MNT/swap" >> $seqres.full
> +"$here/src/mkswap" "$SCRATCH_MNT/swap"
> +"$here/src/swapon" "$SCRATCH_MNT/swap"
> +swapoff "$SCRATCH_MNT/swap" >/dev/null 2>&1
> +
> +status=0
> +exit
> diff --git a/tests/generic/490.out b/tests/generic/490.out
> new file mode 100644
> index 00000000..96226c64
> --- /dev/null
> +++ b/tests/generic/490.out
> @@ -0,0 +1,5 @@
> +QA output created by 490
> +File with holes
> +swapon: Invalid argument
> +Empty swap file (only swap header)
> +swapon: Invalid argument
> diff --git a/tests/generic/group b/tests/generic/group
> index a5252aeb..422e21e2 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -492,3 +492,4 @@
>  487 auto quick
>  488 auto quick swap
>  489 auto quick swap
> +490 auto quick swap
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
