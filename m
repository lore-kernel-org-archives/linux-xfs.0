Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793811249;
	b=m1IgsHo0oAQYd7Hx4WklGQM9MEpxeYTdKj9bkWwbKOlR3/I18/5S/rJN/c4tWa4uznGK
	 fLYfPECTrhCeFzi9BSjE1Z2+QlWFAcsBXC+NL+bplgryxniXpFziW7+J/RGi3tz2cJ71D
	 OSb7IKKqmrFxhqV008874jrRz+PgUyfj0A+rQNN6idckZLpK8fBqMLGYVitFaUdwEmeyH
	 7XfWF5ZeN0rhnPXDULSpElSj8ZVYG2k/sIZTQtuICcA6y3rPILq6i8krCIq767PKneh+2
	 8jr8h59mnxnK3s0CRYH//ElNLCJ3uHLV1cqcUSZLEBubEGPn633T3LQEF2uUtMYnP7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793811249;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=ta0YKC1Y9tLQCPa9StPGB82XrJOeEAKNBXFfeZJ282Q=;
	b=PHiXayQd5A/l/fj+StSRq8RKRpkL1XWcm47ndUBJ64i1txkxG5gUSt8Vo0Ju4NUp1p0F
	 MpXn+TTQZWPomPQIxUGzpYspplasgpgcoBWYZ19uwvUSujiHSGS3Zk437opvCo9ximeu0
	 O+nv9s74yVAQGLpSs67B8i1u+cM14u0P+olQbrmVvpg7d2AgueASIyoUhGuS7nN7Nncjk
	 Mp1vTADfLgh0YKUsC3LXO+AambIiUSJvtO2IT8tiZZtfjijg3H1Cz72dCXmbvjE8hK9dq
	 neMb0Dey55ZxeZ4/8M+MuiVoR5LY0eVmmCooIeSevSDSCCvvvmYhwI3R9ITrCssN+Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nk+94HdO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2CA606A32F;
	Wed,  4 Nov 2026 16:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nk+94HdO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5921F00919;
	Wed,  4 Nov 2026 16:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793811248;
	bh=ta0YKC1Y9tLQCPa9StPGB82XrJOeEAKNBXFfeZJ282Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Nk+94HdOy69o+pBgCU6rjCgTlGarXipWretnsoILCda+Rtc0vR611Uumc0U9F6n5Z
	 e43gSzWHhaWrQqG7L52O0P5lfuZOZduTBzIvPBxaiQKOJhypeNMXoojc/2pPtce+2n
	 PK1hX+LiUfG1/tzFJUMVHjrH/Vsfjo17opaKDE8OR7UFN4ubLutnuBOqGQoyiiyp87
	 ZUXeJuIla2tNVjmknJ3pyc1/dsDJ+wI33iH971qc59ndYuanfGiFYw/gSyvs5wPvhs
	 2VDX64ioLSNKAmeNfFVsel9F2FFgYCv6AVo8syp0jVCIPF7jfzqHCkEjE2b8+sHcDH
	 NQfBouXpuzXlQ==
Date: Thu, 5 Nov 2026 00:54:00 +0800
From: Zorro Lang <zlang@kernel.org>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: fstests@vger.kernel.org, fdmanana@kernel.org, 
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, djwong@kernel.org, 
	amir73il@gmail.com
Subject: Re: [PATCH v3] generic: test FIDEDUPERANGE result reporting with
 REPORT_PROGRESS
Message-ID: <ausEel6ipFsEAtpg@zlang-mailbox>
Mail-Followup-To: Matthias Goergens <matthias.goergens@gmail.com>, 
	fstests@vger.kernel.org, fdmanana@kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com
References: <20260817095017.948979-1-matthias.goergens@gmail.com>
 <20261030083403.3041196-1-matthias.goergens@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030083403.3041196-1-matthias.goergens@gmail.com>

On Fri, Oct 30, 2026 at 04:34:03PM +0800, Matthias Goergens wrote:
> Add a raw FIDEDUPERANGE helper that reports each destination's
> bytes_deduped and status, and a test for the new
> FILE_DEDUPE_RANGE_REPORT_PROGRESS flag: explicit zero-length success, a
> request shortened for an interior destination but not for one ending at
> EOF, a sub-block request that makes no progress, differing contents
> (status DIFFERS, zero bytes), a per-destination error, rejection of an
> unknown flag bit, and one unflagged case pinning the legacy reporting of
> the requested length.  The test is skipped on kernels that reject the
> flag.
> 
> xfs_io retries shortened dedupe operations, so its output cannot verify
> one raw multi-destination ioctl or distinguish an explicit zero-length
> request from a nonzero request shortened to zero; hence the helper.
> 
> Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
> ---
> Christian Brauner applied the kernel series to vfs-7.5.misc on
> 21 October.  Reference the flag commit in _wants_kernel_commit:
> 847f74d6293b (vfs: add FILE_DEDUPE_RANGE_REPORT_PROGRESS flag to
> FIDEDUPERANGE).
> https://lore.kernel.org/all/20261021-rente-privat-mitfiebern-1b76f4650038@brauner/

Now that the implementation of this feature is clear, let's proceed with
merging this test case.

>
> v3:
> - reference the applied kernel flag commit
> - renumber 806 to 810: for-next already uses 806 for an xattr test
> - use _get_file_block_size instead of _get_block_size (Zorro, on v1)
> - the kernel side (v5) now has Reviewed-by from Amir and Darrick, the
>   acks Zorro asked to wait for; it reports bytes_deduped = 0 on DIFFERS
>   (the advance hint tested in v2 was dropped), so both DIFFERS cases
>   expect zero
> - new case: an unknown flag bit is rejected with EINVAL (helper -F)
> - new case: two small differing files ending at EOF report 0 bytes,
>   status DIFFERS
> - _notrun on kernels that reject the flag, rather than failing
> - .gitignore entry moved into alphabetical order
> 
> Previously tested on 2 October as generic/806 under QEMU on v7.3-rc4
> with and without the v5 series, on btrfs, XFS (4k and 1k blocks) and
> ext4.  With the series generic/517 and
> generic/806 pass on btrfs and both XFS configurations; without it 806 is
> not run ("kernel does not support FILE_DEDUPE_RANGE_REPORT_PROGRESS")
> and 517 passes.  On ext4 both are not run (no dedupe).
> 
> Validation refreshed on 30 October against fstests for-next d07dca72:
> helper builds with -Wall -Wextra -Werror -O2; bash -n passes.  The
> filesystem tests have not been rerun on that base.
> 
>  .gitignore            |   1 +
>  src/Makefile          |   2 +-
>  src/fideduperange.c   | 172 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/810     | 144 +++++++++++++++++++++++++++++++++++
>  tests/generic/810.out |   9 +++
>  5 files changed, 327 insertions(+), 1 deletion(-)
>  create mode 100644 src/fideduperange.c
>  create mode 100755 tests/generic/810
>  create mode 100644 tests/generic/810.out
> 
> diff --git a/.gitignore b/.gitignore
> index cdcfa06..418ef7c 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -86,6 +86,7 @@ tags
>  /src/fake-dump-rootino
>  /src/fault
>  /src/feature
> +/src/fideduperange
>  /src/fiemap-tester
>  /src/fill
>  /src/fill2
> diff --git a/src/Makefile b/src/Makefile
> index eaf0621..774447e 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -25,7 +25,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
>  
>  LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
> -	locktest unwritten_mmap bulkstat_unlink_test deduperace \
> +	locktest unwritten_mmap bulkstat_unlink_test deduperace fideduperange \

This part might conflict with a patch ready to be merged ('xfstests: Unify the
build targets under LINUX_TARGET'). Could you try rebasing onto the
'patches-in-queue' branch in your next version? That way, I can merge it
directly later.

>  	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
>  	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
>  	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
> diff --git a/src/fideduperange.c b/src/fideduperange.c
> new file mode 100644
> index 0000000..d8aef98
> --- /dev/null
> +++ b/src/fideduperange.c
> @@ -0,0 +1,172 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Issue a raw FIDEDUPERANGE ioctl and report each destination's result.
> + */
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <getopt.h>
> +#include <inttypes.h>
> +#include <linux/fs.h>
> +#include <stdint.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +#include <unistd.h>
> +
> +/*
> + * Local copies of the UAPI types: the system linux/fs.h may predate the
> + * FILE_DEDUPE_RANGE_REPORT_PROGRESS flag.  The layout matches the kernel
> + * UAPI.
> + */
> +#ifndef FILE_DEDUPE_RANGE_REPORT_PROGRESS
> +#define FILE_DEDUPE_RANGE_REPORT_PROGRESS (1U << 0)
> +#endif
> +#define FILE_DEDUPE_RANGE_SAME		0
> +#define FILE_DEDUPE_RANGE_DIFFERS	1

Perhaps these two definitions could be moved into the "#ifndef FIDEDUPERANGE"
block below.

> +
> +struct file_dedupe_range_info_local {
> +	__s64 dest_fd;
> +	__u64 dest_offset;
> +	__u64 bytes_deduped;
> +	__s32 status;
> +	__u32 reserved;
> +};
> +
> +struct file_dedupe_range_local {
> +	__u64 src_offset;
> +	__u64 src_length;
> +	__u16 dest_count;
> +	__u16 reserved1;
> +	__u32 flags;
> +	struct file_dedupe_range_info_local info[0];

How about replacing this GCC zero-length array "info[0]" with C standard
flexible array "info[]" ?

> +};

Regarding these two *_local structures, I've considered a few alternatives,
such as:
  AC_CHECK_MEMBER([struct file_dedupe_range.flags],
                [AC_DEFINE([HAVE_FILE_DEDUPE_RANGE_FLAGS] ...

What do you or others think?

Thanks,
Zorro

> +
> +#ifndef FIDEDUPERANGE
> +#define FIDEDUPERANGE _IOWR(0x94, 54, struct file_dedupe_range_local)
> +#endif
> +
> +static __u32 range_flags;
> +
> +static void
> +usage(const char *progname)
> +{
> +	fprintf(stderr,
> +		"Usage: %s [-f] [-F flags] src src_offset length dest dest_offset "
> +		"[dest dest_offset ...]\n"
> +		"  -f: set FILE_DEDUPE_RANGE_REPORT_PROGRESS\n"
> +		"  -F: set the raw flags value (e.g. 0x2 for an unknown bit)\n",
> +		progname);
> +	exit(EXIT_FAILURE);
> +}
> +
> +static uint64_t
> +parse_u64(const char *arg, const char *name)
> +{
> +	char *end;
> +	unsigned long long value;
> +
> +	errno = 0;
> +	value = strtoull(arg, &end, 0);
> +	if (errno || end == arg || *end != '\0') {
> +		fprintf(stderr, "Invalid %s: %s\n", name, arg);
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	return value;
> +}
> +
> +int
> +main(int argc, char **argv)
> +{
> +	struct file_dedupe_range_local *range;
> +	size_t range_size;
> +	unsigned int dest_count;
> +	unsigned int i;
> +	int src_fd;
> +	int ret;
> +	int c;
> +
> +	const char *progname = argv[0];
> +
> +	while ((c = getopt(argc, argv, "fF:")) != -1) {
> +		switch (c) {
> +		case 'f':
> +			range_flags |= FILE_DEDUPE_RANGE_REPORT_PROGRESS;
> +			break;
> +		case 'F':
> +			range_flags |= (__u32)parse_u64(optarg, "flags");
> +			break;
> +		default:
> +			usage(progname);
> +		}
> +	}
> +	argc -= optind;
> +	argv += optind;
> +
> +	if (argc < 5 || (argc - 3) % 2 != 0)
> +		usage(progname);
> +
> +	dest_count = (argc - 3) / 2;
> +	if (dest_count > UINT16_MAX) {
> +		fprintf(stderr, "Too many destinations: %u\n", dest_count);
> +		return EXIT_FAILURE;
> +	}
> +
> +	range_size = sizeof(*range) +
> +		dest_count * sizeof(struct file_dedupe_range_info_local);
> +	range = calloc(1, range_size);
> +	if (!range) {
> +		perror("calloc");
> +		return EXIT_FAILURE;
> +	}
> +
> +	src_fd = open(argv[0], O_RDONLY);
> +	if (src_fd < 0) {
> +		perror(argv[0]);
> +		free(range);
> +		return EXIT_FAILURE;
> +	}
> +
> +	range->src_offset = parse_u64(argv[1], "source offset");
> +	range->src_length = parse_u64(argv[2], "length");
> +	range->dest_count = dest_count;
> +	range->flags = range_flags;
> +
> +	for (i = 0; i < dest_count; i++) {
> +		const char *dest_path = argv[3 + i * 2];
> +
> +		range->info[i].dest_fd = open(dest_path, O_RDWR);
> +		if (range->info[i].dest_fd < 0) {
> +			perror(dest_path);
> +			ret = EXIT_FAILURE;
> +			goto close_destinations;
> +		}
> +		range->info[i].dest_offset =
> +			parse_u64(argv[4 + i * 2], "destination offset");
> +		/* Sentinels: the kernel must overwrite both output fields. */
> +		range->info[i].bytes_deduped = ~0ULL;
> +		range->info[i].status = INT32_MIN;
> +	}
> +
> +	if (ioctl(src_fd, FIDEDUPERANGE, range) < 0) {
> +		perror("FIDEDUPERANGE");
> +		ret = EXIT_FAILURE;
> +		goto close_destinations;
> +	}
> +
> +	for (i = 0; i < dest_count; i++)
> +		printf("destination %u: bytes=%" PRIu64 " status=%d\n", i,
> +		       (uint64_t)range->info[i].bytes_deduped,
> +		       range->info[i].status);
> +	ret = EXIT_SUCCESS;
> +
> +close_destinations:
> +	while (i > 0) {
> +		i--;
> +		close(range->info[i].dest_fd);
> +	}
> +	close(src_fd);
> +	free(range);
> +	return ret;
> +}
> diff --git a/tests/generic/810 b/tests/generic/810
> new file mode 100755
> index 0000000..2c09315
> --- /dev/null
> +++ b/tests/generic/810
> @@ -0,0 +1,144 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Matthias Goergens. All Rights Reserved.
> +#
> +# FS QA Test No. 810
> +#
> +# Check FIDEDUPERANGE result reporting with FILE_DEDUPE_RANGE_REPORT_PROGRESS:
> +# bytes_deduped is the length actually deduplicated for zero-length,
> +# shortened and zero-progress requests, and zero for differing requests and
> +# errors; unknown flag bits are rejected; one unflagged case pins the legacy
> +# reporting.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick dedupe clone
> +
> +. ./common/reflink
> +
> +_require_scratch_dedupe
> +_require_test_program "fideduperange"
> +
> +_wants_kernel_commit 847f74d6293b \
> +	"vfs: add FILE_DEDUPE_RANGE_REPORT_PROGRESS flag to FIDEDUPERANGE"
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +block_size=$(_get_file_block_size "$SCRATCH_MNT")
> +short_length=$((2 * block_size))
> +full_length=$((short_length + 100))
> +
> +src=$SCRATCH_MNT/src
> +src_short=$SCRATCH_MNT/src-short
> +src_diff=$SCRATCH_MNT/src-diff
> +dest_interior=$SCRATCH_MNT/dest-interior
> +dest_eof=$SCRATCH_MNT/dest-eof
> +dest_short_eof=$SCRATCH_MNT/dest-short-eof
> +dest_diff=$SCRATCH_MNT/dest-diff
> +
> +$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 $full_length" "$src" \
> +	>>$seqres.full 2>&1
> +$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 100" "$src_short" \
> +	>>$seqres.full 2>&1
> +$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 $((full_length + block_size))" \
> +	"$dest_interior" >>$seqres.full 2>&1
> +$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 $full_length" "$dest_eof" \
> +	>>$seqres.full 2>&1
> +$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 100" "$dest_short_eof" \
> +	>>$seqres.full 2>&1
> +$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $full_length" "$src_diff" \
> +	>>$seqres.full 2>&1
> +$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $full_length" "$dest_diff" \
> +	>>$seqres.full 2>&1
> +
> +# Kernels without the flag reject it with EINVAL before looking at any
> +# destination.
> +result=$($here/src/fideduperange -f "$src" 0 0 "$dest_interior" 0 2>&1)
> +echo "flag probe: $result" >>$seqres.full
> +if echo "$result" | grep -q "Invalid argument"; then
> +	_notrun "kernel does not support FILE_DEDUPE_RANGE_REPORT_PROGRESS"
> +fi
> +
> +check_results()
> +{
> +	local description="$1"
> +	local expected="$2"
> +	shift 2
> +	local result
> +	local ret
> +
> +	result=$($here/src/fideduperange "$@" 2>&1)
> +	ret=$?
> +	{
> +		echo "$description"
> +		echo "$result"
> +	} >>$seqres.full
> +
> +	if [ $ret -ne 0 ]; then
> +		_fail "$description: ioctl helper failed"
> +	fi
> +	if [ "$result" != "$expected" ]; then
> +		_fail "$description: unexpected ioctl result"
> +	fi
> +
> +	echo "$description"
> +}
> +
> +# With the flag, bytes_deduped is the length the filesystem reports as
> +# deduplicated on SAME, and zero on DIFFERS or an error.
> +
> +expected="destination 0: bytes=0 status=0"
> +check_results "zero length: 0 bytes, SAME" "$expected" \
> +	-f "$src" 0 0 "$dest_interior" 0
> +
> +expected="destination 0: bytes=$short_length status=0
> +destination 1: bytes=$full_length status=0"
> +check_results "mixed partial request: shortened, full" "$expected" \
> +	-f "$src" 0 "$full_length" "$dest_interior" 0 "$dest_eof" 0
> +
> +expected="destination 0: bytes=0 status=0
> +destination 1: bytes=100 status=0"
> +check_results "sub-block request: zero progress, full" "$expected" \
> +	-f "$src_short" 0 100 "$dest_interior" 0 "$dest_short_eof" 0
> +
> +expected="destination 0: bytes=0 status=1"
> +check_results "differing contents: DIFFERS, zero bytes" "$expected" \
> +	-f "$src_diff" 0 "$full_length" "$dest_diff" 0
> +
> +# Small differing files ending at EOF: still zero, not the request length.
> +
> +$XFS_IO_PROG -f -c "pwrite -S 0x41 0 512" "$SCRATCH_MNT/tiny-src" >>$seqres.full 2>&1
> +$XFS_IO_PROG -f -c "pwrite -S 0x42 0 512" "$SCRATCH_MNT/tiny-dst" >>$seqres.full 2>&1
> +
> +expected="destination 0: bytes=0 status=1"
> +check_results "small-file DIFFERS: zero bytes" "$expected" \
> +	-f "$SCRATCH_MNT/tiny-src" 0 512 "$SCRATCH_MNT/tiny-dst" 0
> +
> +# On a per-destination error, status carries the errno and bytes_deduped
> +# is zero (the huge offset fails VFS validation with EINVAL).
> +
> +expected="destination 0: bytes=0 status=-22"
> +check_results "error: bytes zero on EINVAL" "$expected" \
> +	-f "$src" 0 "$full_length" "$dest_interior" 9223372036854775807
> +
> +# An unknown flag bit is rejected before any destination is processed.
> +
> +result=$($here/src/fideduperange -F 0x2 "$src" 0 "$full_length" "$dest_interior" 0 2>&1)
> +echo "unknown flag bit: $result" >>$seqres.full
> +if echo "$result" | grep -q "Invalid argument"; then
> +	echo "unknown flag bit: EINVAL"
> +else
> +	_fail "unknown flag bit: expected EINVAL, got: $result"
> +fi
> +
> +# Without the flag, the legacy reporting is unchanged: the requested
> +# length is reported even when the VFS shortens the range.
> +
> +expected="destination 0: bytes=$full_length status=0
> +destination 1: bytes=$full_length status=0"
> +check_results "unflagged legacy reporting: full length" "$expected" \
> +	"$src" 0 "$full_length" "$dest_interior" 0 "$dest_eof" 0
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/810.out b/tests/generic/810.out
> new file mode 100644
> index 0000000..f88ac62
> --- /dev/null
> +++ b/tests/generic/810.out
> @@ -0,0 +1,9 @@
> +QA output created by 810
> +zero length: 0 bytes, SAME
> +mixed partial request: shortened, full
> +sub-block request: zero progress, full
> +differing contents: DIFFERS, zero bytes
> +small-file DIFFERS: zero bytes
> +error: bytes zero on EINVAL
> +unknown flag bit: EINVAL
> +unflagged legacy reporting: full length
> 
> base-commit: d07dca72d2455f4ba8c660ad4c008541ccccb707
> -- 
> 2.56.0
> 
