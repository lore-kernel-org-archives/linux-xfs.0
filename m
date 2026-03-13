Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D9B346FB8
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 18:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773424876; cv=none; b=LkyjsiXCc6BMJbrunpv8fbTg+fxCkBtF043sXSm0pMwcvEWq9Xx616P+y2tOO9CeCT/Fh4mGmPPLAmATfLsbvYzgZIKMrBiH1DEBzZanhVcA3LPs5kz5fi++1z5Nn+pfN16CqT6CwXs7wahjqLk5LIR2M77Xkyzkh1I29JPfRlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773424876; c=relaxed/simple;
	bh=K3ueN2ynEMLdPkUUz/L1/1gws64MxJVYOgfOROK9bVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gGP/A9JuT9hjcsVRVQrLxbjJts50BTkYzZ7XA49A87OWSYy4VCnZu5UReZEFFXRzRYqRUz2ePmWAjxv1AinHkVxyRc8l9/W8tLUQcP20E/iviuqK/ehAISwwunL9pLxW+xFLwgFlgHh+v3rfoGZ7ILLFIX2yFBkwFvMYun7oabI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XhQc9+aH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mP6jzkIh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XhQc9+aH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mP6jzkIh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773424871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kxlvtRu2GCyKP60R4M61GEbEmBeWLZKVhHwCuaFNTE8=;
	b=XhQc9+aHqlBSctNqyqQNRuuGbI9/ir5ug0dyS/xa5KEwkuY/cXTuhGqakTUIpwBRZ5eH62
	YhJgrcE/WOnfMUL1cv3MoSx27p0GI0CAcD8GXHy397FpoBt+RQWsTbIAMw7BD77fPly3u2
	9eOyWqg9N0r1aqttB3BIJ9dMtNG2ctQ=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-etU7MlvMPr2ddNIbMHi2CQ-1; Fri, 13 Mar 2026 14:01:10 -0400
X-MC-Unique: etU7MlvMPr2ddNIbMHi2CQ-1
X-Mimecast-MFC-AGG-ID: etU7MlvMPr2ddNIbMHi2CQ_1773424869
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aeb90532f6so29764855ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 11:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773424869; x=1774029669; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kxlvtRu2GCyKP60R4M61GEbEmBeWLZKVhHwCuaFNTE8=;
        b=mP6jzkIhpCETGnIhtziN3yscxNBHpYeJ+b1Uigpd01zwPffLg+DmqOr3To1X8b3zJv
         C66H7QzxU8jbK58c4ADSfd6MF/r2fYpsW/kk/tmVjIj9G++5Muj4BOj0smY7WsghhT8e
         ELQahDzIhRdtsl0Q0vIsNiv46BeSX5wggV75PUkBfsv8H8uGFESRaM+5KihbnKCTm0KY
         TwaudaYyLaK2A2xFHe2FB+2IDkKYpa4D67Pj7nMazU9mZNXhmAdnoDqSq3/5bgSQmb1i
         iku138n/N6l2y4J632CZ7tZcRAb94a8I3zSTFqLwV8ArUwpW47PxG/wvDUZ6eT5237H2
         ZEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773424869; x=1774029669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kxlvtRu2GCyKP60R4M61GEbEmBeWLZKVhHwCuaFNTE8=;
        b=Rx8mcu+iyB9mEUOdCEykojVHcwBtNjQkvF8WQIEm4dD7ojMoG9NpBWznxXKjWtS7MD
         24r5k/u6nUmitChMIVWvJfAcHZ9g/rQXBJS+tLrxPqvd38FjvGurpm+J+m8pei9gDJxL
         M9T/3MasYr1dO9zSoy5ZkW5AswJPSN/n4u0oDe5hplSo+3F5RQEfVdEOPe6bZ2bz/ybT
         t9tdQ23m4j8gXwjS0ZKdvxoEydHJYwQCmkrVdnz9zETS+woT1EpPFiy48vXASyHnWxD7
         Pm9x+8IMkJnc+nLvpxbjEfU3zCUSLn0/lUbcDxF9BSoDcbJI0cyeoO51oVeZzQQ7M5Yg
         C2eA==
X-Forwarded-Encrypted: i=1; AJvYcCVq30e9aBwDHIYHQGnG7vFwsSM4c8DGK7e+Fn8NOt6HGr373GC5p2UzcJLnIWInuDl4MJuMimn+HdA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMtXluFa6aioY8rvyH2TRizIVPn+LUmQ/uBKOCeGhRkdMmR5BF
	FV3zECQoU1es1q0roxHkWvsY30hLfn5Gz+CPjAn9bZ/TtS74A3VbL8Fbfiv3vc7c/OEKRJAFlol
	6FBBmfHPZ9hKDyl1j2nd8QlS1JrOxzIfzCQYd1yps8qfduHEHw8JhKbo0t2mxTQ==
X-Gm-Gg: ATEYQzwBGAojhYGCx6ESVffaS7PUh0yh2zfd1c1eLRADdcuc6it+Nt2f+bjgqx0AEC/
	3oCAQIrtp5kcGrJcsodyRkY7/ns49C942JWCMLmo3X0xunO93hQT+fjqIitDh2K86RBOJumh8vl
	w94OUW2Q7bXDNdQJG9pwNxn8Cph+dpSmEkyuoeLzrArL4hajkg6pou6kRxx1gzNeUBeM6s4ObNW
	0KF3/HEFiblEOtUoG/k+MPYo9ltj9Pl1CRgJqCvkiEnlEQq468x8SrXJJPrA9HgFCvS4BPezd9p
	dGMW5+Jsh6r+lAJcie042VSWnZdjN7QDFLcjBOG2xAApvAO0oB+kmlm7q4KDdeleHzzQbyOyqQX
	G05YOa175iLa4xh1v0obxv7XgnQr2w04nbGAbRmFuH60354JDZKFC8z4oF+Z3TQ==
X-Received: by 2002:a17:903:ac7:b0:2ae:47f9:de12 with SMTP id d9443c01a7336-2aecac84e7fmr39851295ad.46.1773424868649;
        Fri, 13 Mar 2026 11:01:08 -0700 (PDT)
X-Received: by 2002:a17:903:ac7:b0:2ae:47f9:de12 with SMTP id d9443c01a7336-2aecac84e7fmr39850845ad.46.1773424868120;
        Fri, 13 Mar 2026 11:01:08 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece56cb7fsm35710685ad.6.2026.03.13.11.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 11:01:07 -0700 (PDT)
Date: Sat, 14 Mar 2026 02:01:02 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: jack@suse.cz, fstests@vger.kernel.org, amir73il@gmail.com,
	gabriel@krisman.be, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/1] generic: test fsnotify filesystem error reporting
Message-ID: <20260313180102.afyzstsgzjioa56j@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177311403420.1186306.10503664469609309721.stgit@frogsfrogsfrogs>
 <177311403440.1186306.11707487947646813883.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311403440.1186306.11707487947646813883.stgit@frogsfrogsfrogs>

On Mon, Mar 09, 2026 at 08:50:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Test the fsnotify filesystem error reporting.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/rc              |   25 ++++++
>  doc/group-names.txt    |    1 
>  src/Makefile           |    2 
>  src/fs-monitor.c       |  153 ++++++++++++++++++++++++++++++++++

I'll add "src/fs-monitor" into .gitignore file when I merge this patch.
Others look good to me.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/1838     |  214 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/1838.out |   20 ++++
>  6 files changed, 414 insertions(+), 1 deletion(-)
>  create mode 100644 src/fs-monitor.c
>  create mode 100755 tests/generic/1838
>  create mode 100644 tests/generic/1838.out
> 
> 
> diff --git a/common/rc b/common/rc
> index fd4ca9641822cf..ccb78baf5bd41a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3013,6 +3013,11 @@ _require_xfs_io_command()
>  		echo $testio | grep -q "Inappropriate ioctl" && \
>  			_notrun "xfs_io $command support is missing"
>  		;;
> +	"healthmon")
> +		test -z "$param" && param="-p"
> +		testio=`$XFS_IO_PROG -c "healthmon $param" $TEST_DIR 2>&1`
> +		param_checked="$param"
> +		;;
>  	"label")
>  		testio=`$XFS_IO_PROG -c "label" $TEST_DIR 2>&1`
>  		;;
> @@ -6149,6 +6154,26 @@ _require_max_file_range_blocks()
>  	esac
>  }
>  
> +_require_fanotify_ioerrors()
> +{
> +	local x
> +
> +	case "$FSTYP" in
> +	xfs)
> +		# added as a part of xfs health monitoring
> +		_require_xfs_io_command healthmon
> +		return 0
> +		;;
> +	ext4)
> +		# added at the same time as err_report_sec
> +		x="$(_get_fs_sysfs_attr $TEST_DEV err_report_sec)"
> +		test -n "$x" && return 0
> +		;;
> +	esac
> +
> +	_notrun "$FSTYP does not support fanotify ioerrors"
> +}
> +
>  ################################################################################
>  # make sure this script returns success
>  /bin/true
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> index 10b49e50517797..158f84d36d3154 100644
> --- a/doc/group-names.txt
> +++ b/doc/group-names.txt
> @@ -117,6 +117,7 @@ samefs			overlayfs when all layers are on the same fs
>  scrub			filesystem metadata scrubbers
>  seed			btrfs seeded filesystems
>  seek			llseek functionality
> +selfhealing		self healing filesystem code
>  selftest		tests with fixed results, used to validate testing setup
>  send			btrfs send/receive
>  shrinkfs		decreasing the size of a filesystem
> diff --git a/src/Makefile b/src/Makefile
> index 577d816ae859b6..1c761da0ccff20 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -36,7 +36,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
>  	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
>  	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
> -	rw_hint
> +	rw_hint fs-monitor
>  
>  EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
>  	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
> diff --git a/src/fs-monitor.c b/src/fs-monitor.c
> new file mode 100644
> index 00000000000000..0cf09677a3efda
> --- /dev/null
> +++ b/src/fs-monitor.c
> @@ -0,0 +1,153 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright 2021, Collabora Ltd.
> + * Copied from https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/samples/fanotify/fs-monitor.c
> + */
> +
> +#include <errno.h>
> +#include <err.h>
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <fcntl.h>
> +#include <sys/fanotify.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +
> +#ifndef FAN_FS_ERROR
> +#define FAN_FS_ERROR		0x00008000
> +#define FAN_EVENT_INFO_TYPE_ERROR	5
> +
> +struct fanotify_event_info_error {
> +	struct fanotify_event_info_header hdr;
> +	__s32 error;
> +	__u32 error_count;
> +};
> +#endif
> +
> +#ifndef FILEID_INO32_GEN
> +#define FILEID_INO32_GEN	1
> +#endif
> +
> +#ifndef FILEID_INVALID
> +#define	FILEID_INVALID		0xff
> +#endif
> +
> +static void print_fh(struct file_handle *fh)
> +{
> +	int i;
> +	uint32_t *h = (uint32_t *) fh->f_handle;
> +
> +	printf("\tfh: ");
> +	for (i = 0; i < fh->handle_bytes; i++)
> +		printf("%hhx", fh->f_handle[i]);
> +	printf("\n");
> +
> +	printf("\tdecoded fh: ");
> +	if (fh->handle_type == FILEID_INO32_GEN)
> +		printf("inode=%u gen=%u\n", h[0], h[1]);
> +	else if (fh->handle_type == FILEID_INVALID && !fh->handle_bytes)
> +		printf("Type %d (Superblock error)\n", fh->handle_type);
> +	else
> +		printf("Type %d (Unknown)\n", fh->handle_type);
> +
> +}
> +
> +static void handle_notifications(char *buffer, int len)
> +{
> +	struct fanotify_event_metadata *event =
> +		(struct fanotify_event_metadata *) buffer;
> +	struct fanotify_event_info_header *info;
> +	struct fanotify_event_info_error *err;
> +	struct fanotify_event_info_fid *fid;
> +	int off;
> +
> +	for (; FAN_EVENT_OK(event, len); event = FAN_EVENT_NEXT(event, len)) {
> +
> +		if (event->mask != FAN_FS_ERROR) {
> +			printf("unexpected FAN MARK: %llx\n",
> +							(unsigned long long)event->mask);
> +			goto next_event;
> +		}
> +
> +		if (event->fd != FAN_NOFD) {
> +			printf("Unexpected fd (!= FAN_NOFD)\n");
> +			goto next_event;
> +		}
> +
> +		printf("FAN_FS_ERROR (len=%d)\n", event->event_len);
> +
> +		for (off = sizeof(*event) ; off < event->event_len;
> +		     off += info->len) {
> +			info = (struct fanotify_event_info_header *)
> +				((char *) event + off);
> +
> +			switch (info->info_type) {
> +			case FAN_EVENT_INFO_TYPE_ERROR:
> +				err = (struct fanotify_event_info_error *) info;
> +
> +				printf("\tGeneric Error Record: len=%d\n",
> +				       err->hdr.len);
> +				printf("\terror: %d\n", err->error);
> +				printf("\terror_count: %d\n", err->error_count);
> +				break;
> +
> +			case FAN_EVENT_INFO_TYPE_FID:
> +				fid = (struct fanotify_event_info_fid *) info;
> +
> +				printf("\tfsid: %x%x\n",
> +#if defined(__GLIBC__)
> +				       fid->fsid.val[0], fid->fsid.val[1]);
> +#else
> +				       fid->fsid.__val[0], fid->fsid.__val[1]);
> +#endif
> +				print_fh((struct file_handle *) &fid->handle);
> +				break;
> +
> +			default:
> +				printf("\tUnknown info type=%d len=%d:\n",
> +				       info->info_type, info->len);
> +			}
> +		}
> +next_event:
> +		printf("---\n\n");
> +		fflush(stdout);
> +	}
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	int fd;
> +
> +	char buffer[BUFSIZ];
> +
> +	if (argc < 2) {
> +		printf("Missing path argument\n");
> +		return 1;
> +	}
> +
> +	fd = fanotify_init(FAN_CLASS_NOTIF|FAN_REPORT_FID, O_RDONLY);
> +	if (fd < 0) {
> +		perror("fanotify_init");
> +		errx(1, "fanotify_init");
> +	}
> +
> +	if (fanotify_mark(fd, FAN_MARK_ADD|FAN_MARK_FILESYSTEM,
> +			  FAN_FS_ERROR, AT_FDCWD, argv[1])) {
> +		perror("fanotify_mark");
> +		errx(1, "fanotify_mark");
> +	}
> +
> +	printf("fanotify active\n");
> +	fflush(stdout);
> +
> +	while (1) {
> +		int n = read(fd, buffer, BUFSIZ);
> +
> +		if (n < 0)
> +			errx(1, "read");
> +
> +		handle_notifications(buffer, n);
> +	}
> +
> +	return 0;
> +}
> diff --git a/tests/generic/1838 b/tests/generic/1838
> new file mode 100755
> index 00000000000000..940811baae3a6e
> --- /dev/null
> +++ b/tests/generic/1838
> @@ -0,0 +1,214 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 1838
> +#
> +# Check that fsnotify can report file IO errors.
> +
> +. ./common/preamble
> +_begin_fstest auto quick eio selfhealing
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	test -n "$fsmonitor_pid" && kill -TERM $fsmonitor_pid
> +	rm -f $tmp.*
> +	_dmerror_cleanup
> +}
> +
> +# Import common functions.
> +. ./common/fuzzy
> +. ./common/filter
> +. ./common/dmerror
> +. ./common/systemd
> +
> +_require_scratch
> +_require_dm_target error
> +_require_test_program fs-monitor
> +_require_xfs_io_command "fiemap"
> +_require_odirect
> +_require_fanotify_ioerrors
> +
> +# no out of place writes
> +test "$FSTYP" = "xfs" && _require_no_xfs_always_cow
> +
> +# fsnotify only gives us a file handle, the error number, and the number of
> +# times it was seen in between event deliveries.   The handle is mostly useless
> +# since we have no generic way to map that to a file path.  Therefore we can
> +# only coalesce all the I/O errors into one report.
> +filter_fsnotify_errors() {
> +	_filter_scratch | \
> +		grep -E '(FAN_FS_ERROR|Generic Error Record|error: 5)' | \
> +		sed -e "s/len=[0-9]*/len=XXX/g" | \
> +		sort | \
> +		uniq
> +}
> +
> +_scratch_mkfs >> $seqres.full
> +
> +#
> +# The dm-error map added by this test doesn't work on zoned devices because
> +# table sizes need to be aligned to the zone size, and even for zoned on
> +# conventional this test will get confused because of the internal RT device.
> +#
> +# That check requires a mounted file system, so do a dummy mount before setting
> +# up DM.
> +#
> +_scratch_mount
> +test $FSTYP = xfs && _require_xfs_scratch_non_zoned
> +_scratch_unmount
> +
> +_dmerror_init
> +_dmerror_mount >> $seqres.full 2>&1
> +
> +test $FSTYP = xfs && _xfs_force_bdev data $SCRATCH_MNT
> +
> +# Write a file with 4 file blocks worth of data, figure out the LBA to target
> +victim=$SCRATCH_MNT/a
> +file_blksz=$(_get_file_block_size $SCRATCH_MNT)
> +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c "fsync" $victim >> $seqres.full
> +
> +awk_len_prog='{print $4}'
> +bmap_str="$($XFS_IO_PROG -c "fiemap -v" $victim | grep "^[[:space:]]*0:")"
> +echo "$bmap_str" >> $seqres.full
> +
> +phys="$(echo "$bmap_str" | $AWK_PROG '{print $3}')"
> +len="$(echo "$bmap_str" | $AWK_PROG "$awk_len_prog")"
> +
> +fs_blksz=$(_get_block_size $SCRATCH_MNT)
> +echo "file_blksz:$file_blksz:fs_blksz:$fs_blksz" >> $seqres.full
> +kernel_sectors_per_fs_block=$((fs_blksz / 512))
> +
> +# Did we get at least 4 fs blocks worth of extent?
> +min_len_sectors=$(( 4 * kernel_sectors_per_fs_block ))
> +test "$len" -lt $min_len_sectors && \
> +	_fail "could not format a long enough extent on an empty fs??"
> +
> +phys_start=$(echo "$phys" | sed -e 's/\.\..*//g')
> +
> +echo "$phys:$len:$fs_blksz:$phys_start" >> $seqres.full
> +echo "victim file:" >> $seqres.full
> +od -tx1 -Ad -c $victim >> $seqres.full
> +
> +# Set the dmerror table so that all IO will pass through.
> +_dmerror_reset_table
> +
> +cat >> $seqres.full << ENDL
> +dmerror before:
> +$DMERROR_TABLE
> +$DMERROR_RTTABLE
> +<end table>
> +ENDL
> +
> +# All sector numbers that we feed to the kernel must be in units of 512b, but
> +# they also must be aligned to the device's logical block size.
> +logical_block_size=`$here/src/min_dio_alignment $SCRATCH_MNT $SCRATCH_DEV`
> +kernel_sectors_per_device_lba=$((logical_block_size / 512))
> +
> +# Mark as bad one of the device LBAs in the middle of the extent.  Target the
> +# second LBA of the third block of the four-block file extent that we allocated
> +# earlier, but without overflowing into the fourth file block.
> +bad_sector=$(( phys_start + (2 * kernel_sectors_per_fs_block) ))
> +bad_len=$kernel_sectors_per_device_lba
> +if (( kernel_sectors_per_device_lba < kernel_sectors_per_fs_block )); then
> +	bad_sector=$((bad_sector + kernel_sectors_per_device_lba))
> +fi
> +if (( (bad_sector % kernel_sectors_per_device_lba) != 0)); then
> +	echo "bad_sector $bad_sector not congruent with device logical block size $logical_block_size"
> +fi
> +
> +# Remount to flush the page cache, start fsnotify, and make the LBA bad
> +_dmerror_unmount
> +_dmerror_mount
> +
> +$here/src/fs-monitor $SCRATCH_MNT > $tmp.fsmonitor &
> +fsmonitor_pid=$!
> +sleep 1
> +
> +_dmerror_mark_range_bad $bad_sector $bad_len
> +
> +cat >> $seqres.full << ENDL
> +dmerror after marking bad:
> +$DMERROR_TABLE
> +$DMERROR_RTTABLE
> +<end table>
> +ENDL
> +
> +_dmerror_load_error_table
> +
> +# See if buffered reads pick it up
> +echo "Try buffered read"
> +$XFS_IO_PROG -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
> +
> +# See if directio reads pick it up
> +echo "Try directio read"
> +$XFS_IO_PROG -d -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
> +
> +# See if directio writes pick it up
> +echo "Try directio write"
> +$XFS_IO_PROG -d -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
> +
> +# See if buffered writes pick it up
> +echo "Try buffered write"
> +$XFS_IO_PROG -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
> +
> +# Now mark the bad range good so that unmount won't fail due to IO errors.
> +echo "Fix device"
> +_dmerror_mark_range_good $bad_sector $bad_len
> +_dmerror_load_error_table
> +
> +cat >> $seqres.full << ENDL
> +dmerror after marking good:
> +$DMERROR_TABLE
> +$DMERROR_RTTABLE
> +<end table>
> +ENDL
> +
> +# Unmount filesystem to start fresh
> +echo "Kill fsnotify"
> +_dmerror_unmount
> +sleep 1
> +kill -TERM $fsmonitor_pid
> +unset fsmonitor_pid
> +echo fsnotify log >> $seqres.full
> +cat $tmp.fsmonitor >> $seqres.full
> +cat $tmp.fsmonitor | filter_fsnotify_errors
> +
> +# Start fsnotify again so that can verify that the errors don't persist after
> +# we flip back to the good dm table.
> +echo "Remount and restart fsnotify"
> +_dmerror_mount
> +$here/src/fs-monitor $SCRATCH_MNT > $tmp.fsmonitor &
> +fsmonitor_pid=$!
> +sleep 1
> +
> +# See if buffered reads pick it up
> +echo "Try buffered read again"
> +$XFS_IO_PROG -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
> +
> +# See if directio reads pick it up
> +echo "Try directio read again"
> +$XFS_IO_PROG -d -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
> +
> +# See if directio writes pick it up
> +echo "Try directio write again"
> +$XFS_IO_PROG -d -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
> +
> +# See if buffered writes pick it up
> +echo "Try buffered write again"
> +$XFS_IO_PROG -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
> +
> +# Unmount fs and kill fsnotify, then wait for it to finish
> +echo "Kill fsnotify again"
> +_dmerror_unmount
> +sleep 1
> +kill -TERM $fsmonitor_pid
> +unset fsmonitor_pid
> +cat $tmp.fsmonitor >> $seqres.full
> +cat $tmp.fsmonitor | filter_fsnotify_errors
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1838.out b/tests/generic/1838.out
> new file mode 100644
> index 00000000000000..adae590fe0b2ea
> --- /dev/null
> +++ b/tests/generic/1838.out
> @@ -0,0 +1,20 @@
> +QA output created by 1838
> +Try buffered read
> +pread: Input/output error
> +Try directio read
> +pread: Input/output error
> +Try directio write
> +pwrite: Input/output error
> +Try buffered write
> +fsync: Input/output error
> +Fix device
> +Kill fsnotify
> +	Generic Error Record: len=XXX
> +	error: 5
> +FAN_FS_ERROR (len=XXX)
> +Remount and restart fsnotify
> +Try buffered read again
> +Try directio read again
> +Try directio write again
> +Try buffered write again
> +Kill fsnotify again
> 

