Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28BE3D75AD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 07:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773126463; cv=pass; b=XA//Tiv5nBayX5k4dVifift8BYpzQDd2g/13f8V2elS9EPv/2Yv884NFvOaytkCQhz/Z07kSwg6S9C+GHx3y6DFntnmPCAKy1kiu3Xx0YnzGXsBfq6XQ0zRgFjKNWet+VNgDBBEO0ChiPAXSt2rx2fVaJ11VMf+fjGHoDfK1UhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773126463; c=relaxed/simple;
	bh=j43F2oN+8bKY9mZk2JpvRoT9Ca1qAg+AkSJkR/QFU3g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EITkgctxmqZpfmKLWxPCRTVuoEJ2DiVCHzXKzdhh25IqT2+AHRz8KnbrEN5rc+OMkRQPCXY9m/rSa8HMcj45VL9JEIN80xzdVn6y7wkPldvQdiy8or48vXpwZ4D6gLfAZaRQT7N3Dp0SPuOIQVxlpSCBlxWkwMYmK6D5fb8rsT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bu3Np2yf; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bu3Np2yf"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b936331786dso1373922366b.3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 00:07:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773126457; cv=none;
        d=google.com; s=arc-20240605;
        b=ViUQZru27rrJIZ3aR1az2PV2jBK7KZRQqoclb9I2WPXfE+yehRGKRJNhCZyOmB+Ld2
         lDC4NT8H/wEqD9hVfKXDGX0qUoCatRzJ61Q97/UBNiGwB0PTPAKEyP9iPBclGHpQn2VX
         iNIU8vsz5hsUrdWFbX6zN2WP+aazIf+NtrUl1+1SG5BSbs453R1gRRKqssfrX6bKv1Fg
         u/FEKlUTIzj5j18zViyOvGNXQOqTm3C+AgqnCrKvTpJ8FLmzb0uNc5nN1Xi63EM3f4rM
         xKI04pn4K1jtUlhKcveEB79LZBH0ZBYZqOzbCyBaz4CKmAjOeBPP2r69kTumDiRMNgCr
         Cbfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gsz7YMjyQRLyKuCL16GqxHe/rHr875sqVI8xQ7Gfri4=;
        fh=GckkkOlOQe9SVVWtNxliA75ogMweHpGyPYYanHDyJGw=;
        b=PmW9c/Nn29T17jmfG5pg3MnsRi0FVgi/zZFV0JY6MqbO7Ddnc85NwiGqdcuHXRoym/
         sZG1k/EIWEchW8aIbQZpojAdVLAb9LGVBzERzQxsq58UsN6s4uGgv7RaZysyzv/jO2hL
         KF6OsY966actxFPCQ6rPBzTQXNVoqS4huvQLQ1G9AAHoQtEJOnC5hUxCyn033OGD2B60
         3HHDKF2UYqZugpiI3Wb0WV58D+XEYv+DRtq2bQ9WzzOI8YTgrQbThH+1IfxeHqanrryc
         2JdUATgz/OeA+T/EsWUctGwk0XPQDaVQe17uWPaCcuQAXkm0z+Wo8UhgnHKfhsSG377z
         w4Dw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773126457; x=1773731257; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gsz7YMjyQRLyKuCL16GqxHe/rHr875sqVI8xQ7Gfri4=;
        b=bu3Np2yf789m1MVijbX4pnpH7duzmkgGqb7W57QAzcQ9CqKgekvZfbmxvGfFl301OP
         PjHrRYYJQbwYEfBVwusjwjYMfHQ/jukt9WlVYEVxBAug23SdGGASjHgv5hZWEZ43ewPG
         RBpNKzpwyYlRdJd06NwG5z8fJs2h4A498wTgHKxRs+doy/mJRihF+KaVApWom7BUlKiR
         gKmzi/3sdBAzlVn4p3Lq6onI0Ksm6TOqJTnV5MDz38frconTxdBDoF9jJlJ+0jSI6ovF
         FRzTjPEwAUHog8PyD1Z5gN8LDlXn1y64ULcp6C6UCgNioelGaYNuxBPqr6Fq1LOqvvsA
         WJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773126457; x=1773731257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gsz7YMjyQRLyKuCL16GqxHe/rHr875sqVI8xQ7Gfri4=;
        b=Eza7lggerWdBj8DDkE516elXQ/0Kfbfvy0PVyfU8jYafaGh9A3VXhuu3A2K+PglYQ+
         OOAslbtCYus3nXlfI0fftJ32r9Bl+wGFXoLIVD4nqLAX1dZz1mA8B1VWr9Jf4yCPcZnV
         hPzLXnXHNI09dF2aZ+BcfLSiUNuVqBHI7ufOmD041NEANgvHHRn32QG4fSjWOZ2+d/ll
         96Xb+pkH+8sL8xVKZZQdHjhKBX0tBTKItTwM3AVQCD2xZwrMXzb6dW8iaLi8+iei2wdx
         6hZZVonOcN6teFMPVoq5u+aPy+tPlzgNhi+kymi2WpGsNf/u87KLh2HcIFvBtXfocJBD
         3LAQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6XFORUgGeEg+8m9ZKJv2OHXuqJ83td69KHZdeWZjWCFYOkXzJXL4HuUr+2JMzdSynCTs89IWkVTM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1Wx2hIcGcB0p6lWiL55ZBXNWOeuhvwGimqpL/fxbkm1SWQh99
	Uo976TbNOin7HzJ4Cdyp42U5dxzrbg7sfLVNEzQXaW0tZAfJQkFkirnC//3lY6CQAe4cYKoOlHd
	eodnl/lEUe756psUW5w1P0xOGOkXNHnE=
X-Gm-Gg: ATEYQzxXAG1n+M7Re77egOf58Ie16ql1roz4jF207UGZv3y60tE/0Vt7hVM8AcakSOl
	BkDNCvmAUGkM9Qz4ms7+F1EbTnuevzLrkVh5vACnc5C3VphgI9l/39znvjRXlE1Z28ojeqTlpe4
	FV/5avOZ/V+XVRoZZUyCoS6RH6By0No51KoDqNlTpomnvq4szi8rAebfSOqmYVhoQB+1wny4RFg
	YN539tJM1Wb7Dzy17eCusAMubkf7ji62pj1MgLSrGCPbfBV7uXIMOKo/nLLxQ1RexNJe6ynNd2I
	xbQFeiS8FqzUzqJjV5dNCnyX4RcfulUCEzw19Mtx
X-Received: by 2002:a17:907:3d11:b0:b8d:ce06:8a25 with SMTP id
 a640c23a62f3a-b942dfb40dfmr754528566b.35.1773126456614; Tue, 10 Mar 2026
 00:07:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <177311403420.1186306.10503664469609309721.stgit@frogsfrogsfrogs> <177311403440.1186306.11707487947646813883.stgit@frogsfrogsfrogs>
In-Reply-To: <177311403440.1186306.11707487947646813883.stgit@frogsfrogsfrogs>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Mar 2026 08:07:25 +0100
X-Gm-Features: AaiRm505qD_kHuhRWRePi-1Ctcx8jpDVILLu1qezKyr9kG5luITmX2H8lsGgMy8
Message-ID: <CAOQ4uxh8K1kSjbEuEp=h04cAUd7HpdijHsTETaey40Y+2kV0QQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] generic: test fsnotify filesystem error reporting
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, jack@suse.cz, fstests@vger.kernel.org, 
	gabriel@krisman.be, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	hch@lst.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 4:50=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Test the fsnotify filesystem error reporting.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Feel free to add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  common/rc              |   25 ++++++
>  doc/group-names.txt    |    1
>  src/Makefile           |    2
>  src/fs-monitor.c       |  153 ++++++++++++++++++++++++++++++++++
>  tests/generic/1838     |  214 ++++++++++++++++++++++++++++++++++++++++++=
++++++
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
>                 echo $testio | grep -q "Inappropriate ioctl" && \
>                         _notrun "xfs_io $command support is missing"
>                 ;;
> +       "healthmon")
> +               test -z "$param" && param=3D"-p"
> +               testio=3D`$XFS_IO_PROG -c "healthmon $param" $TEST_DIR 2>=
&1`
> +               param_checked=3D"$param"
> +               ;;
>         "label")
>                 testio=3D`$XFS_IO_PROG -c "label" $TEST_DIR 2>&1`
>                 ;;
> @@ -6149,6 +6154,26 @@ _require_max_file_range_blocks()
>         esac
>  }
>
> +_require_fanotify_ioerrors()
> +{
> +       local x
> +
> +       case "$FSTYP" in
> +       xfs)
> +               # added as a part of xfs health monitoring
> +               _require_xfs_io_command healthmon
> +               return 0
> +               ;;
> +       ext4)
> +               # added at the same time as err_report_sec
> +               x=3D"$(_get_fs_sysfs_attr $TEST_DEV err_report_sec)"
> +               test -n "$x" && return 0
> +               ;;
> +       esac
> +
> +       _notrun "$FSTYP does not support fanotify ioerrors"
> +}
> +
>  ########################################################################=
########
>  # make sure this script returns success
>  /bin/true
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> index 10b49e50517797..158f84d36d3154 100644
> --- a/doc/group-names.txt
> +++ b/doc/group-names.txt
> @@ -117,6 +117,7 @@ samefs                      overlayfs when all layers=
 are on the same fs
>  scrub                  filesystem metadata scrubbers
>  seed                   btrfs seeded filesystems
>  seek                   llseek functionality
> +selfhealing            self healing filesystem code
>  selftest               tests with fixed results, used to validate testin=
g setup
>  send                   btrfs send/receive
>  shrinkfs               decreasing the size of a filesystem
> diff --git a/src/Makefile b/src/Makefile
> index 577d816ae859b6..1c761da0ccff20 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -36,7 +36,7 @@ LINUX_TARGETS =3D xfsctl bstat t_mtab getdevicesize pre=
allo_rw_pattern_reader \
>         fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail=
 \
>         detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
>         uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alig=
nment \
> -       rw_hint
> +       rw_hint fs-monitor
>
>  EXTRA_EXECS =3D dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
>               btrfs_crc32c_forged_name.py popdir.pl popattr.py \
> diff --git a/src/fs-monitor.c b/src/fs-monitor.c
> new file mode 100644
> index 00000000000000..0cf09677a3efda
> --- /dev/null
> +++ b/src/fs-monitor.c
> @@ -0,0 +1,153 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright 2021, Collabora Ltd.
> + * Copied from https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/=
linux.git/tree/samples/fanotify/fs-monitor.c
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
> +#define FAN_FS_ERROR           0x00008000
> +#define FAN_EVENT_INFO_TYPE_ERROR      5
> +
> +struct fanotify_event_info_error {
> +       struct fanotify_event_info_header hdr;
> +       __s32 error;
> +       __u32 error_count;
> +};
> +#endif
> +
> +#ifndef FILEID_INO32_GEN
> +#define FILEID_INO32_GEN       1
> +#endif
> +
> +#ifndef FILEID_INVALID
> +#define        FILEID_INVALID          0xff
> +#endif
> +
> +static void print_fh(struct file_handle *fh)
> +{
> +       int i;
> +       uint32_t *h =3D (uint32_t *) fh->f_handle;
> +
> +       printf("\tfh: ");
> +       for (i =3D 0; i < fh->handle_bytes; i++)
> +               printf("%hhx", fh->f_handle[i]);
> +       printf("\n");
> +
> +       printf("\tdecoded fh: ");
> +       if (fh->handle_type =3D=3D FILEID_INO32_GEN)
> +               printf("inode=3D%u gen=3D%u\n", h[0], h[1]);
> +       else if (fh->handle_type =3D=3D FILEID_INVALID && !fh->handle_byt=
es)
> +               printf("Type %d (Superblock error)\n", fh->handle_type);
> +       else
> +               printf("Type %d (Unknown)\n", fh->handle_type);
> +
> +}
> +
> +static void handle_notifications(char *buffer, int len)
> +{
> +       struct fanotify_event_metadata *event =3D
> +               (struct fanotify_event_metadata *) buffer;
> +       struct fanotify_event_info_header *info;
> +       struct fanotify_event_info_error *err;
> +       struct fanotify_event_info_fid *fid;
> +       int off;
> +
> +       for (; FAN_EVENT_OK(event, len); event =3D FAN_EVENT_NEXT(event, =
len)) {
> +
> +               if (event->mask !=3D FAN_FS_ERROR) {
> +                       printf("unexpected FAN MARK: %llx\n",
> +                                                       (unsigned long lo=
ng)event->mask);
> +                       goto next_event;
> +               }
> +
> +               if (event->fd !=3D FAN_NOFD) {
> +                       printf("Unexpected fd (!=3D FAN_NOFD)\n");
> +                       goto next_event;
> +               }
> +
> +               printf("FAN_FS_ERROR (len=3D%d)\n", event->event_len);
> +
> +               for (off =3D sizeof(*event) ; off < event->event_len;
> +                    off +=3D info->len) {
> +                       info =3D (struct fanotify_event_info_header *)
> +                               ((char *) event + off);
> +
> +                       switch (info->info_type) {
> +                       case FAN_EVENT_INFO_TYPE_ERROR:
> +                               err =3D (struct fanotify_event_info_error=
 *) info;
> +
> +                               printf("\tGeneric Error Record: len=3D%d\=
n",
> +                                      err->hdr.len);
> +                               printf("\terror: %d\n", err->error);
> +                               printf("\terror_count: %d\n", err->error_=
count);
> +                               break;
> +
> +                       case FAN_EVENT_INFO_TYPE_FID:
> +                               fid =3D (struct fanotify_event_info_fid *=
) info;
> +
> +                               printf("\tfsid: %x%x\n",
> +#if defined(__GLIBC__)
> +                                      fid->fsid.val[0], fid->fsid.val[1]=
);
> +#else
> +                                      fid->fsid.__val[0], fid->fsid.__va=
l[1]);
> +#endif
> +                               print_fh((struct file_handle *) &fid->han=
dle);
> +                               break;
> +
> +                       default:
> +                               printf("\tUnknown info type=3D%d len=3D%d=
:\n",
> +                                      info->info_type, info->len);
> +                       }
> +               }
> +next_event:
> +               printf("---\n\n");
> +               fflush(stdout);
> +       }
> +}
> +
> +int main(int argc, char **argv)
> +{
> +       int fd;
> +
> +       char buffer[BUFSIZ];
> +
> +       if (argc < 2) {
> +               printf("Missing path argument\n");
> +               return 1;
> +       }
> +
> +       fd =3D fanotify_init(FAN_CLASS_NOTIF|FAN_REPORT_FID, O_RDONLY);
> +       if (fd < 0) {
> +               perror("fanotify_init");
> +               errx(1, "fanotify_init");
> +       }
> +
> +       if (fanotify_mark(fd, FAN_MARK_ADD|FAN_MARK_FILESYSTEM,
> +                         FAN_FS_ERROR, AT_FDCWD, argv[1])) {
> +               perror("fanotify_mark");
> +               errx(1, "fanotify_mark");
> +       }
> +
> +       printf("fanotify active\n");
> +       fflush(stdout);
> +
> +       while (1) {
> +               int n =3D read(fd, buffer, BUFSIZ);
> +
> +               if (n < 0)
> +                       errx(1, "read");
> +
> +               handle_notifications(buffer, n);
> +       }
> +
> +       return 0;
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
> +       cd /
> +       test -n "$fsmonitor_pid" && kill -TERM $fsmonitor_pid
> +       rm -f $tmp.*
> +       _dmerror_cleanup
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
> +test "$FSTYP" =3D "xfs" && _require_no_xfs_always_cow
> +
> +# fsnotify only gives us a file handle, the error number, and the number=
 of
> +# times it was seen in between event deliveries.   The handle is mostly =
useless
> +# since we have no generic way to map that to a file path.  Therefore we=
 can
> +# only coalesce all the I/O errors into one report.
> +filter_fsnotify_errors() {
> +       _filter_scratch | \
> +               grep -E '(FAN_FS_ERROR|Generic Error Record|error: 5)' | =
\
> +               sed -e "s/len=3D[0-9]*/len=3DXXX/g" | \
> +               sort | \
> +               uniq
> +}
> +
> +_scratch_mkfs >> $seqres.full
> +
> +#
> +# The dm-error map added by this test doesn't work on zoned devices beca=
use
> +# table sizes need to be aligned to the zone size, and even for zoned on
> +# conventional this test will get confused because of the internal RT de=
vice.
> +#
> +# That check requires a mounted file system, so do a dummy mount before =
setting
> +# up DM.
> +#
> +_scratch_mount
> +test $FSTYP =3D xfs && _require_xfs_scratch_non_zoned
> +_scratch_unmount
> +
> +_dmerror_init
> +_dmerror_mount >> $seqres.full 2>&1
> +
> +test $FSTYP =3D xfs && _xfs_force_bdev data $SCRATCH_MNT
> +
> +# Write a file with 4 file blocks worth of data, figure out the LBA to t=
arget
> +victim=3D$SCRATCH_MNT/a
> +file_blksz=3D$(_get_file_block_size $SCRATCH_MNT)
> +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c "fsync" $vi=
ctim >> $seqres.full
> +
> +awk_len_prog=3D'{print $4}'
> +bmap_str=3D"$($XFS_IO_PROG -c "fiemap -v" $victim | grep "^[[:space:]]*0=
:")"
> +echo "$bmap_str" >> $seqres.full
> +
> +phys=3D"$(echo "$bmap_str" | $AWK_PROG '{print $3}')"
> +len=3D"$(echo "$bmap_str" | $AWK_PROG "$awk_len_prog")"
> +
> +fs_blksz=3D$(_get_block_size $SCRATCH_MNT)
> +echo "file_blksz:$file_blksz:fs_blksz:$fs_blksz" >> $seqres.full
> +kernel_sectors_per_fs_block=3D$((fs_blksz / 512))
> +
> +# Did we get at least 4 fs blocks worth of extent?
> +min_len_sectors=3D$(( 4 * kernel_sectors_per_fs_block ))
> +test "$len" -lt $min_len_sectors && \
> +       _fail "could not format a long enough extent on an empty fs??"
> +
> +phys_start=3D$(echo "$phys" | sed -e 's/\.\..*//g')
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
> +# All sector numbers that we feed to the kernel must be in units of 512b=
, but
> +# they also must be aligned to the device's logical block size.
> +logical_block_size=3D`$here/src/min_dio_alignment $SCRATCH_MNT $SCRATCH_=
DEV`
> +kernel_sectors_per_device_lba=3D$((logical_block_size / 512))
> +
> +# Mark as bad one of the device LBAs in the middle of the extent.  Targe=
t the
> +# second LBA of the third block of the four-block file extent that we al=
located
> +# earlier, but without overflowing into the fourth file block.
> +bad_sector=3D$(( phys_start + (2 * kernel_sectors_per_fs_block) ))
> +bad_len=3D$kernel_sectors_per_device_lba
> +if (( kernel_sectors_per_device_lba < kernel_sectors_per_fs_block )); th=
en
> +       bad_sector=3D$((bad_sector + kernel_sectors_per_device_lba))
> +fi
> +if (( (bad_sector % kernel_sectors_per_device_lba) !=3D 0)); then
> +       echo "bad_sector $bad_sector not congruent with device logical bl=
ock size $logical_block_size"
> +fi
> +
> +# Remount to flush the page cache, start fsnotify, and make the LBA bad
> +_dmerror_unmount
> +_dmerror_mount
> +
> +$here/src/fs-monitor $SCRATCH_MNT > $tmp.fsmonitor &
> +fsmonitor_pid=3D$!
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
> +$XFS_IO_PROG -d -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $vict=
im >> $seqres.full
> +
> +# See if buffered writes pick it up
> +echo "Try buffered write"
> +$XFS_IO_PROG -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim =
>> $seqres.full
> +
> +# Now mark the bad range good so that unmount won't fail due to IO error=
s.
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
> +# Start fsnotify again so that can verify that the errors don't persist =
after
> +# we flip back to the good dm table.
> +echo "Remount and restart fsnotify"
> +_dmerror_mount
> +$here/src/fs-monitor $SCRATCH_MNT > $tmp.fsmonitor &
> +fsmonitor_pid=3D$!
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
> +$XFS_IO_PROG -d -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $vict=
im >> $seqres.full
> +
> +# See if buffered writes pick it up
> +echo "Try buffered write again"
> +$XFS_IO_PROG -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim =
>> $seqres.full
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
> +status=3D0
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
> +       Generic Error Record: len=3DXXX
> +       error: 5
> +FAN_FS_ERROR (len=3DXXX)
> +Remount and restart fsnotify
> +Try buffered read again
> +Try directio read again
> +Try directio write again
> +Try buffered write again
> +Kill fsnotify again
>
