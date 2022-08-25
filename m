Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC98ECAAD1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Aug 2022 23:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243915AbiHYXrb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Aug 2022 19:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiHYXr3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Aug 2022 19:47:29 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC31BCCF7;
        Thu, 25 Aug 2022 16:47:27 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 142so2190040pfu.10;
        Thu, 25 Aug 2022 16:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=vzIG8wCzpzZDGdaWzRjKIlsqDIv5l/PtAYkhWLgCjBI=;
        b=dd06cV5C7xvZTJOQ2XkRnlG2bUaYiCSbNNt9LjDf7p49Y+KwWpNRBfGsGrF/lotz8v
         4tTg0EvShM28N0YwRPkh9uGSFDEmb9iPYr4zAszQDMsRqJ50Zoxa5oSo8pIaysRNh9QY
         39fbvsy9Am6EFdX+b7AyE47rCylIciUHXCozqcuMrvkinOKOLbt1sjLWV2Cb7mXh35JK
         i4toG5T5u6UJW2Lpo5JTOZfRhMHyAmRcaEZSUDPCwQBEfBA3otOUjqkFBytCCqjQz/y6
         6lTJygte+XQxKV93qZvWmsi/+wdOXx1PC/5hx5WZnjkHxhKklnlEHcIId8g4NOKFb74J
         c2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=vzIG8wCzpzZDGdaWzRjKIlsqDIv5l/PtAYkhWLgCjBI=;
        b=wVGZJzdFx6HC/z2fk1wnL2tyKTXfhsGLOOM7aCBQREzLR5TTNwm3qBHdPMoMadqvb+
         MPHS3BtKebAylCvQ6YgPpVQ68cHS6nvRnLg9fBJnIPQn8EhIhZ4v+2A8TCE1vZP5agVd
         LntEQ4k0hZUnk9AU+gRCfVdwHE4TJCSdxpXYkmQcUoL6eLcSleiX/0KvS45/XyfwW/PY
         o3bU0L//jLYs3dbdLJwORRzHV5H21pd/zQ5Xlu+znbJ8hid5M0aCjXelE+5i+z4cJENm
         +Euv8o2qafJZwOo824hh3lAzM/2qsLGX9gBEYRQK+rIjpRnadewLOcGsVLYZIDdQOeDp
         +Wpw==
X-Gm-Message-State: ACgBeo16YjTigHzFeooi//D3wPz8ZY/K04rSaAboIzr6hckrjwHJHiZT
        94A0MI8yPJ8ynSR75fAY5DzrOzSKPmAGJZZz5YC6gAebRqw=
X-Google-Smtp-Source: AA6agR7CRP05X73WhAncqPsM4vnVE9pOL8e7B13xDxLnhlHR7+/i5bDue4eSi99YGYmyVDnZMHd3vB1Z+iKkhCSEQKY=
X-Received: by 2002:a63:4e25:0:b0:41c:62a2:ecc3 with SMTP id
 c37-20020a634e25000000b0041c62a2ecc3mr1155152pgb.596.1661471246566; Thu, 25
 Aug 2022 16:47:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220825094348.1634751-1-xzhou@redhat.com>
In-Reply-To: <20220825094348.1634751-1-xzhou@redhat.com>
From:   Murphy Zhou <jencce.kernel@gmail.com>
Date:   Fri, 26 Aug 2022 07:47:13 +0800
Message-ID: <CADJHv_tD7HYC_-eBeL1MbAQjucKOr+tmdBR27uTwGgUHYe6f4Q@mail.gmail.com>
Subject: Re: [PATCH v2] tests: increase fs size for mkfs
To:     Murphy Zhou <xzhou@redhat.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 25, 2022 at 5:43 PM Murphy Zhou <xzhou@redhat.com> wrote:
>
> From: Murphy Zhou <jencce.kernel@gmail.com>
>
> Since this xfsprogs commit:
>         6e0ed3d19c54 mkfs: stop allowing tiny filesystems
> XFS requires filesystem size bigger then 300m, log size bigger
> then 64m(so does AG size), and single AG is not allowed.
>
> So testcases that do not meet these requirements are not working.
>
> Increase thoese numbers to 512M at least. There is no special
> reason for the magic number 512, just double it from original
> 256M and being reasonable small.
>
> Remove xfs/202 because it is testing single-AG filesystem.
>
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
> v2:
>         Fix more about 300m limit;
>         Fix about log size larger then 64m;
>         Remove xfs/202(maybe in a separated patch?)

Forgot to merge this part. Will send v3 with 3 separated patches
addressing fs size, log size and single-AG.

Thanks.
>
>  common/log        |  2 +-
>  common/xfs        |  4 ++--
>  tests/generic/015 |  2 +-
>  tests/generic/027 |  2 +-
>  tests/generic/077 |  2 +-
>  tests/generic/081 |  6 +++---
>  tests/generic/083 |  2 +-
>  tests/generic/085 |  2 +-
>  tests/generic/108 |  4 ++--
>  tests/generic/204 |  2 +-
>  tests/generic/226 |  2 +-
>  tests/generic/250 |  2 +-
>  tests/generic/252 |  2 +-
>  tests/generic/371 |  2 +-
>  tests/generic/387 |  2 +-
>  tests/generic/416 |  2 +-
>  tests/generic/427 |  2 +-
>  tests/generic/449 |  2 +-
>  tests/generic/511 |  2 +-
>  tests/generic/520 |  4 ++--
>  tests/generic/536 |  2 +-
>  tests/generic/619 |  2 +-
>  tests/generic/626 |  2 +-
>  tests/xfs/002     |  2 +-
>  tests/xfs/015     |  2 +-
>  tests/xfs/041     |  2 +-
>  tests/xfs/042     |  2 +-
>  tests/xfs/049     |  2 +-
>  tests/xfs/073     |  2 +-
>  tests/xfs/076     |  2 +-
>  tests/xfs/078     |  6 +++---
>  tests/xfs/104     |  2 +-
>  tests/xfs/107     |  4 ++--
>  tests/xfs/118     |  4 ++--
>  tests/xfs/148     |  2 +-
>  tests/xfs/149     |  2 +-
>  tests/xfs/168     |  2 +-
>  tests/xfs/170     |  8 ++++----
>  tests/xfs/174     |  4 ++--
>  tests/xfs/176     |  2 +-
>  tests/xfs/205     |  2 +-
>  tests/xfs/206     |  2 +-
>  tests/xfs/227     |  2 +-
>  tests/xfs/233     |  2 +-
>  tests/xfs/250     |  2 +-
>  tests/xfs/259     |  2 +-
>  tests/xfs/279     |  6 +++---
>  tests/xfs/289     | 22 +++++++++++-----------
>  tests/xfs/291     |  4 ++--
>  tests/xfs/306     |  2 +-
>  tests/xfs/445     |  2 +-
>  tests/xfs/514     |  2 +-
>  tests/xfs/520     |  2 +-
>  53 files changed, 79 insertions(+), 79 deletions(-)
>
> diff --git a/common/log b/common/log
> index 154f3959..5eb7802e 100644
> --- a/common/log
> +++ b/common/log
> @@ -334,7 +334,7 @@ _mkfs_log()
>  {
>      # create the FS
>      # mkfs options to append to log size otion can be specified ($*)
> -    export MKFS_OPTIONS="-l size=2000b -l lazy-count=1 $*"
> +    export MKFS_OPTIONS="-l size=64m -l lazy-count=1 $*"
>      _full "mkfs"
>      _scratch_mkfs_xfs >>$seqres.full 2>&1
>      if [ $? -ne 0 ] ; then
> diff --git a/common/xfs b/common/xfs
> index 9f84dffb..ac4cf8be 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -82,10 +82,10 @@ _scratch_find_xfs_min_logblocks()
>  {
>         local mkfs_cmd="`_scratch_mkfs_xfs_opts`"
>
> -       # The smallest log size we can specify is 2M (XFS_MIN_LOG_BYTES) so
> +       # The smallest log size we can specify is 64M (XFS_MIN_LOG_BYTES) so
>         # pass that in and see if mkfs succeeds or tells us what is the
>         # minimum log size.
> -       local XFS_MIN_LOG_BYTES=2097152
> +       local XFS_MIN_LOG_BYTES=67108864
>
>         # Try formatting the filesystem with all the options given and the
>         # minimum log size.  We hope either that this succeeds or that mkfs
> diff --git a/tests/generic/015 b/tests/generic/015
> index 10423a29..f6804897 100755
> --- a/tests/generic/015
> +++ b/tests/generic/015
> @@ -31,7 +31,7 @@ _require_no_large_scratch_dev
>
>  # btrfs needs at least 256MB (with upward round off) to create a non-mixed mode
>  # fs. Ref: btrfs-progs: btrfs_min_dev_size()
> -_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1 \
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1 \
>      || _fail "mkfs failed"
>  _scratch_mount
>  out=$SCRATCH_MNT/fillup.$$
> diff --git a/tests/generic/027 b/tests/generic/027
> index 47f1981d..ad8175c1 100755
> --- a/tests/generic/027
> +++ b/tests/generic/027
> @@ -35,7 +35,7 @@ _require_scratch
>
>  echo "Silence is golden"
>
> -_scratch_mkfs_sized $((256 * 1024 * 1024)) >>$seqres.full 2>&1
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >>$seqres.full 2>&1
>  _scratch_mount
>
>  echo "Reserve 2M space" >>$seqres.full
> diff --git a/tests/generic/077 b/tests/generic/077
> index 94d89fae..639564ed 100755
> --- a/tests/generic/077
> +++ b/tests/generic/077
> @@ -49,7 +49,7 @@ echo "*** create filesystem"
>  _scratch_unmount >/dev/null 2>&1
>  echo "*** MKFS ***"                         >>$seqres.full
>  echo ""                                     >>$seqres.full
> -fs_size=$((256 * 1024 * 1024))
> +fs_size=$((512 * 1024 * 1024))
>  _scratch_mkfs_sized $fs_size >> $seqres.full 2>&1 || _fail "mkfs failed"
>  _scratch_mount
>  mkdir $SCRATCH_MNT/subdir
> diff --git a/tests/generic/081 b/tests/generic/081
> index 22ac94de..4901ae2d 100755
> --- a/tests/generic/081
> +++ b/tests/generic/081
> @@ -62,13 +62,13 @@ snapname=snap_$seq
>  mnt=$TEST_DIR/mnt_$seq
>  mkdir -p $mnt
>
> -# make sure there's enough disk space for 256M lv, test for 300M here in case
> +# make sure there's enough disk space for 400 lv, test for 512M here in case
>  # lvm uses some space for metadata
> -_scratch_mkfs_sized $((300 * 1024 * 1024)) >>$seqres.full 2>&1
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >>$seqres.full 2>&1
>  $LVM_PROG vgcreate -f $vgname $SCRATCH_DEV >>$seqres.full 2>&1
>  # We use yes pipe instead of 'lvcreate --yes' because old version of lvm
>  # (like 2.02.95 in RHEL6) don't support --yes option
> -yes | $LVM_PROG lvcreate -L 256M -n $lvname $vgname >>$seqres.full 2>&1
> +yes | $LVM_PROG lvcreate -L 400M -n $lvname $vgname >>$seqres.full 2>&1
>  # wait for lvcreation to fully complete
>  $UDEV_SETTLE_PROG >>$seqres.full 2>&1
>
> diff --git a/tests/generic/083 b/tests/generic/083
> index 2a5af3cc..4c79538c 100755
> --- a/tests/generic/083
> +++ b/tests/generic/083
> @@ -62,7 +62,7 @@ workout()
>
>  echo "*** test out-of-space handling for random write operations"
>
> -filesize=`expr 256 \* 1024 \* 1024`
> +filesize=`expr 512 \* 1024 \* 1024`
>  agcount=6
>  numprocs=15
>  numops=1500
> diff --git a/tests/generic/085 b/tests/generic/085
> index 786d8e6f..006fcb5d 100755
> --- a/tests/generic/085
> +++ b/tests/generic/085
> @@ -50,7 +50,7 @@ setup_dmdev()
>
>  echo "Silence is golden"
>
> -size=$((256 * 1024 * 1024))
> +size=$((512 * 1024 * 1024))
>  size_in_sector=$((size / 512))
>  _scratch_mkfs_sized $size >>$seqres.full 2>&1
>
> diff --git a/tests/generic/108 b/tests/generic/108
> index efe66ba5..dc6614d2 100755
> --- a/tests/generic/108
> +++ b/tests/generic/108
> @@ -46,7 +46,7 @@ physical=`blockdev --getpbsz $SCRATCH_DEV`
>  logical=`blockdev --getss $SCRATCH_DEV`
>
>  # _get_scsi_debug_dev returns a scsi debug device with 128M in size by default
> -SCSI_DEBUG_DEV=`_get_scsi_debug_dev ${physical:-512} ${logical:-512} 0 300`
> +SCSI_DEBUG_DEV=`_get_scsi_debug_dev ${physical:-512} ${logical:-512} 0 512`
>  test -b "$SCSI_DEBUG_DEV" || _notrun "Failed to initialize scsi debug device"
>  echo "SCSI debug device $SCSI_DEBUG_DEV" >>$seqres.full
>
> @@ -55,7 +55,7 @@ $LVM_PROG pvcreate -f $SCSI_DEBUG_DEV $SCRATCH_DEV >>$seqres.full 2>&1
>  $LVM_PROG vgcreate -f $vgname $SCSI_DEBUG_DEV $SCRATCH_DEV >>$seqres.full 2>&1
>  # We use yes pipe instead of 'lvcreate --yes' because old version of lvm
>  # (like 2.02.95 in RHEL6) don't support --yes option
> -yes | $LVM_PROG lvcreate -i 2 -I 4m -L 275m -n $lvname $vgname \
> +yes | $LVM_PROG lvcreate -i 2 -I 4m -L 400m -n $lvname $vgname \
>         >>$seqres.full 2>&1
>  # wait for lv creation to fully complete
>  $UDEV_SETTLE_PROG >>$seqres.full 2>&1
> diff --git a/tests/generic/204 b/tests/generic/204
> index a33a090f..3589b084 100755
> --- a/tests/generic/204
> +++ b/tests/generic/204
> @@ -30,7 +30,7 @@ _require_scratch
>  # time solves this problem.
>  [ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=16m -i maxpct=50"
>
> -SIZE=`expr 115 \* 1024 \* 1024`
> +SIZE=`expr 512 \* 1024 \* 1024`
>  _scratch_mkfs_sized $SIZE 2> /dev/null > $tmp.mkfs.raw
>  cat $tmp.mkfs.raw | _filter_mkfs 2> $tmp.mkfs > /dev/null
>  _scratch_mount
> diff --git a/tests/generic/226 b/tests/generic/226
> index 34434730..d814b365 100755
> --- a/tests/generic/226
> +++ b/tests/generic/226
> @@ -19,7 +19,7 @@ _require_odirect
>
>  _scratch_unmount 2>/dev/null
>  echo "--> mkfs 256m filesystem"
> -_scratch_mkfs_sized `expr 256 \* 1024 \* 1024` >> $seqres.full 2>&1
> +_scratch_mkfs_sized `expr 512 \* 1024 \* 1024` >> $seqres.full 2>&1
>  _scratch_mount
>
>  loops=16
> diff --git a/tests/generic/250 b/tests/generic/250
> index 97e9522f..bd1c6ffd 100755
> --- a/tests/generic/250
> +++ b/tests/generic/250
> @@ -32,7 +32,7 @@ _require_odirect
>  # bitmap consuming all the free space in our small data device.
>  unset SCRATCH_RTDEV
>
> -fssize=$((196 * 1048576))
> +fssize=$((512 * 1048576))
>  echo "Format and mount"
>  $XFS_IO_PROG -d -c "pwrite -S 0x69 -b 1048576 0 $fssize" $SCRATCH_DEV >> $seqres.full
>  _scratch_mkfs_sized $fssize > $seqres.full 2>&1
> diff --git a/tests/generic/252 b/tests/generic/252
> index 8c5adb53..93ab5242 100755
> --- a/tests/generic/252
> +++ b/tests/generic/252
> @@ -33,7 +33,7 @@ AIO_TEST="$here/src/aio-dio-regress/aiocp"
>  # bitmap consuming all the free space in our small data device.
>  unset SCRATCH_RTDEV
>
> -fssize=$((196 * 1048576))
> +fssize=$((512 * 1048576))
>  echo "Format and mount"
>  $XFS_IO_PROG -d -c "pwrite -S 0x69 -b 1048576 0 $fssize" $SCRATCH_DEV >> $seqres.full
>  _scratch_mkfs_sized $fssize > $seqres.full 2>&1
> diff --git a/tests/generic/371 b/tests/generic/371
> index a2fdaf7b..538df647 100755
> --- a/tests/generic/371
> +++ b/tests/generic/371
> @@ -20,7 +20,7 @@ _require_scratch
>  _require_xfs_io_command "falloc"
>  test "$FSTYP" = "xfs" && _require_xfs_io_command "extsize"
>
> -_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
>  _scratch_mount
>
>  # Disable speculative post-EOF preallocation on XFS, which can grow fast enough
> diff --git a/tests/generic/387 b/tests/generic/387
> index 25ca86bb..0546b7de 100755
> --- a/tests/generic/387
> +++ b/tests/generic/387
> @@ -19,7 +19,7 @@ _supported_fs generic
>  _require_scratch_reflink
>
>  #btrfs needs 256mb to create default blockgroup fs
> -_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
>  _scratch_mount
>
>  testfile=$SCRATCH_MNT/testfile
> diff --git a/tests/generic/416 b/tests/generic/416
> index deb05f07..24fdb737 100755
> --- a/tests/generic/416
> +++ b/tests/generic/416
> @@ -21,7 +21,7 @@ _begin_fstest auto enospc
>  _supported_fs generic
>  _require_scratch
>
> -fs_size=$((128 * 1024 * 1024))
> +fs_size=$((512 * 1024 * 1024))
>  page_size=$(get_page_size)
>
>  # We will never reach this number though
> diff --git a/tests/generic/427 b/tests/generic/427
> index 26385d36..4f44c2ea 100755
> --- a/tests/generic/427
> +++ b/tests/generic/427
> @@ -27,7 +27,7 @@ _require_aiodio aio-dio-eof-race
>  _require_no_compress
>
>  # limit the filesystem size, to save the time of filling filesystem
> -_scratch_mkfs_sized $((256 * 1024 * 1024)) >>$seqres.full 2>&1
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >>$seqres.full 2>&1
>  _scratch_mount
>
>  # try to write more bytes than filesystem size to fill the filesystem,
> diff --git a/tests/generic/449 b/tests/generic/449
> index 2b77a6a4..aebb5620 100755
> --- a/tests/generic/449
> +++ b/tests/generic/449
> @@ -24,7 +24,7 @@ _require_test
>  _require_acls
>  _require_attrs trusted
>
> -_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
>  _scratch_mount || _fail "mount failed"
>
>  # This is a test of xattr behavior when we run out of disk space for xattrs,
> diff --git a/tests/generic/511 b/tests/generic/511
> index 058d8401..8b1209d3 100755
> --- a/tests/generic/511
> +++ b/tests/generic/511
> @@ -19,7 +19,7 @@ _require_scratch
>  _require_xfs_io_command "falloc" "-k"
>  _require_xfs_io_command "fzero"
>
> -_scratch_mkfs_sized $((1024 * 1024 * 256)) >>$seqres.full 2>&1
> +_scratch_mkfs_sized $((1024 * 1024 * 512)) >>$seqres.full 2>&1
>  _scratch_mount
>
>  $XFS_IO_PROG -fc "pwrite 0 256m" -c fsync $SCRATCH_MNT/file >>$seqres.full 2>&1
> diff --git a/tests/generic/520 b/tests/generic/520
> index ad6764c7..2a96dce1 100755
> --- a/tests/generic/520
> +++ b/tests/generic/520
> @@ -24,8 +24,8 @@ _cleanup()
>  . ./common/filter
>  . ./common/dmflakey
>
> -# 256MB in byte
> -fssize=$((2**20 * 256))
> +# 512MB in byte
> +fssize=$((2**20 * 512))
>
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/536 b/tests/generic/536
> index 986ea1ee..aac05587 100755
> --- a/tests/generic/536
> +++ b/tests/generic/536
> @@ -21,7 +21,7 @@ _require_scratch
>  _require_scratch_shutdown
>
>  # create a small fs and initialize free blocks with a unique pattern
> -_scratch_mkfs_sized $((1024 * 1024 * 100)) >> $seqres.full 2>&1
> +_scratch_mkfs_sized $((1024 * 1024 * 512)) >> $seqres.full 2>&1
>  _scratch_mount
>  $XFS_IO_PROG -f -c "pwrite -S 0xab 0 100m" -c fsync $SCRATCH_MNT/spc \
>         >> $seqres.full 2>&1
> diff --git a/tests/generic/619 b/tests/generic/619
> index 6e42d677..1e883394 100755
> --- a/tests/generic/619
> +++ b/tests/generic/619
> @@ -26,7 +26,7 @@
>  . ./common/preamble
>  _begin_fstest auto rw enospc
>
> -FS_SIZE=$((240*1024*1024)) # 240MB
> +FS_SIZE=$((512*1024*1024)) # 512MB
>  DEBUG=1 # set to 0 to disable debug statements in shell and c-prog
>  FACT=0.7
>
> diff --git a/tests/generic/626 b/tests/generic/626
> index 7e577798..a0411f01 100755
> --- a/tests/generic/626
> +++ b/tests/generic/626
> @@ -22,7 +22,7 @@ _supported_fs generic
>  _require_scratch
>  _require_renameat2 whiteout
>
> -_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
>  _scratch_mount
>
>  # Create lots of files, to help to trigger the bug easily
> diff --git a/tests/xfs/002 b/tests/xfs/002
> index 6c0bb4d0..53dc8b57 100755
> --- a/tests/xfs/002
> +++ b/tests/xfs/002
> @@ -27,7 +27,7 @@ _require_no_large_scratch_dev
>  # So we can explicitly turn it _off_:
>  _require_xfs_mkfs_crc
>
> -_scratch_mkfs_xfs -m crc=0 -d size=128m >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mkfs_xfs -m crc=0 -d size=512m >> $seqres.full 2>&1 || _fail "mkfs failed"
>
>  # Scribble past a couple V4 secondary superblocks to populate sb_crc
>  # (We can't write to the structure member because it doesn't exist
> diff --git a/tests/xfs/015 b/tests/xfs/015
> index 2bb7b8d5..1f487cae 100755
> --- a/tests/xfs/015
> +++ b/tests/xfs/015
> @@ -43,7 +43,7 @@ _scratch_mount
>  _require_fs_space $SCRATCH_MNT 131072
>  _scratch_unmount
>
> -_scratch_mkfs_sized $((32 * 1024 * 1024)) > $tmp.mkfs.raw || _fail "mkfs failed"
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) > $tmp.mkfs.raw || _fail "mkfs failed"
>  cat $tmp.mkfs.raw | _filter_mkfs >$seqres.full 2>$tmp.mkfs
>  # get original data blocks number and agcount
>  . $tmp.mkfs
> diff --git a/tests/xfs/041 b/tests/xfs/041
> index 05de5578..8532f5dc 100755
> --- a/tests/xfs/041
> +++ b/tests/xfs/041
> @@ -38,7 +38,7 @@ _fill()
>  }
>
>  _do_die_on_error=message_only
> -agsize=32
> +agsize=512
>  echo -n "Make $agsize megabyte filesystem on SCRATCH_DEV and mount... "
>  _scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2>&1 >/dev/null || _fail "mkfs failed"
>  bsize=`_scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2>&1 | _filter_mkfs 2>&1 \
> diff --git a/tests/xfs/042 b/tests/xfs/042
> index d62eb045..baa0f424 100755
> --- a/tests/xfs/042
> +++ b/tests/xfs/042
> @@ -52,7 +52,7 @@ _require_scratch
>  _do_die_on_error=message_only
>
>  echo -n "Make a 48 megabyte filesystem on SCRATCH_DEV and mount... "
> -_scratch_mkfs_xfs -dsize=48m,agcount=3 2>&1 >/dev/null || _fail "mkfs failed"
> +_scratch_mkfs_xfs -dsize=512m,agcount=3 2>&1 >/dev/null || _fail "mkfs failed"
>  _scratch_mount
>
>  echo "done"
> diff --git a/tests/xfs/049 b/tests/xfs/049
> index 69656a85..e04769bf 100755
> --- a/tests/xfs/049
> +++ b/tests/xfs/049
> @@ -57,7 +57,7 @@ mount -t ext2 $SCRATCH_DEV $SCRATCH_MNT >> $seqres.full 2>&1 \
>      || _fail "!!! failed to mount"
>
>  _log "Create xfs fs in file on scratch"
> -${MKFS_XFS_PROG} -f -dfile,name=$SCRATCH_MNT/test.xfs,size=40m \
> +${MKFS_XFS_PROG} -f -dfile,name=$SCRATCH_MNT/test.xfs,size=512m \
>      >> $seqres.full 2>&1 \
>      || _fail "!!! failed to mkfs xfs"
>
> diff --git a/tests/xfs/073 b/tests/xfs/073
> index c7616b9e..48c293e9 100755
> --- a/tests/xfs/073
> +++ b/tests/xfs/073
> @@ -110,7 +110,7 @@ _require_xfs_copy
>  _require_scratch
>  _require_loop
>
> -_scratch_mkfs_xfs -dsize=41m,agcount=2 >>$seqres.full 2>&1
> +_scratch_mkfs_xfs -dsize=512m,agcount=2 >>$seqres.full 2>&1
>  _scratch_mount
>
>  echo
> diff --git a/tests/xfs/076 b/tests/xfs/076
> index 8eef1367..b352cd04 100755
> --- a/tests/xfs/076
> +++ b/tests/xfs/076
> @@ -69,7 +69,7 @@ _require_xfs_sparse_inodes
>  # bitmap consuming all the free space in our small data device.
>  unset SCRATCH_RTDEV
>
> -_scratch_mkfs "-d size=50m -m crc=1 -i sparse" | tee -a $seqres.full |
> +_scratch_mkfs "-d size=512m -m crc=1 -i sparse" | tee -a $seqres.full |
>         _filter_mkfs > /dev/null 2> $tmp.mkfs
>  . $tmp.mkfs    # for isize
>
> diff --git a/tests/xfs/078 b/tests/xfs/078
> index 1f475c96..9a24086e 100755
> --- a/tests/xfs/078
> +++ b/tests/xfs/078
> @@ -103,9 +103,9 @@ _grow_loop()
>  _grow_loop $((168024*4096)) 1376452608 4096 1
>
>  # Some other blocksize cases...
> -_grow_loop $((168024*2048)) 1376452608 2048 1
> -_grow_loop $((168024*512)) 1376452608 512 1 16m
> -_grow_loop $((168024*1024)) 688230400 1024 1
> +_grow_loop $((168024*4096)) 1376452608 2048 1
> +_grow_loop $((168024*4096)) 1376452608 512 1 16m
> +_grow_loop $((168024*4096)) 688230400 1024 1
>
>  # Other corner cases suggested by dgc
>  # also the following doesn't check if the filesystem is consistent.
> diff --git a/tests/xfs/104 b/tests/xfs/104
> index d16f46d8..1dcac050 100755
> --- a/tests/xfs/104
> +++ b/tests/xfs/104
> @@ -60,7 +60,7 @@ modsize=`expr   4 \* $incsize`        # pause after this many increments
>  [ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
>
>  nags=4
> -size=`expr 125 \* 1048576`     # 120 megabytes initially
> +size=`expr 512 \* 1048576`     # 512 megabytes initially
>  sizeb=`expr $size / $dbsize`   # in data blocks
>  echo "*** creating scratch filesystem"
>  logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
> diff --git a/tests/xfs/107 b/tests/xfs/107
> index 1ea9c492..e1f9b537 100755
> --- a/tests/xfs/107
> +++ b/tests/xfs/107
> @@ -23,9 +23,9 @@ _require_scratch
>  _require_xfs_io_command allocsp                # detect presence of ALLOCSP ioctl
>  _require_test_program allocstale
>
> -# Create a 256MB filesystem to avoid running into mkfs problems with too-small
> +# Create a 512MB filesystem to avoid running into mkfs problems with too-small
>  # filesystems.
> -size_mb=256
> +size_mb=512
>
>  # Write a known pattern to the disk so that we can detect stale disk blocks
>  # being mapped into the file.  In the test author's experience, the bug will
> diff --git a/tests/xfs/118 b/tests/xfs/118
> index 03755b28..6fc3cdaa 100755
> --- a/tests/xfs/118
> +++ b/tests/xfs/118
> @@ -27,8 +27,8 @@ _require_scratch
>  _require_command "$XFS_FSR_PROG" "xfs_fsr"
>  _require_xfs_io_command "falloc"
>
> -# 50M
> -_scratch_mkfs_sized $((50 * 1024 * 1024)) >> $seqres.full 2>&1
> +# 512M
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
>  _scratch_mount
>
>  echo "Silence is golden"
> diff --git a/tests/xfs/148 b/tests/xfs/148
> index 5d0a0bf4..f64d10df 100755
> --- a/tests/xfs/148
> +++ b/tests/xfs/148
> @@ -44,7 +44,7 @@ rm -f $imgfile $imgfile.old
>  # We need to use 512 byte inodes to ensure the attr forks remain in short form
>  # even when security xattrs are present so we are always doing name matches on
>  # lookup and not name hash compares as leaf/node forms will do.
> -$XFS_IO_PROG -f -c 'truncate 40m' $imgfile
> +$XFS_IO_PROG -f -c 'truncate 512m' $imgfile
>  loopdev=$(_create_loop_device $imgfile)
>  MKFS_OPTIONS="-m crc=0 -i size=512" _mkfs_dev $loopdev >> $seqres.full
>
> diff --git a/tests/xfs/149 b/tests/xfs/149
> index 503eff65..d1929a8b 100755
> --- a/tests/xfs/149
> +++ b/tests/xfs/149
> @@ -45,7 +45,7 @@ echo "=== mkfs.xfs ==="
>  $MKFS_XFS_PROG -d file,name=$loopfile,size=16m -f >/dev/null 2>&1
>
>  echo "=== truncate ==="
> -$XFS_IO_PROG -fc "truncate 256m" $loopfile
> +$XFS_IO_PROG -fc "truncate 512m" $loopfile
>
>  echo "=== create loop device ==="
>  loop_dev=$(_create_loop_device $loopfile)
> diff --git a/tests/xfs/168 b/tests/xfs/168
> index ffcd0df8..f3d5193b 100755
> --- a/tests/xfs/168
> +++ b/tests/xfs/168
> @@ -51,7 +51,7 @@ _require_xfs_io_command "falloc"
>  _scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs >/dev/null
>  . $tmp.mkfs    # extract blocksize and data size for scratch device
>
> -endsize=`expr 125 \* 1048576`  # stop after shrinking this big
> +endsize=`expr 300 \* 1048576`  # stop after shrinking this big
>  [ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
>
>  nags=2
> diff --git a/tests/xfs/170 b/tests/xfs/170
> index b9ead341..0a9a6766 100755
> --- a/tests/xfs/170
> +++ b/tests/xfs/170
> @@ -32,10 +32,10 @@ _set_stream_timeout_centisecs 3000
>  # filestreams to encourage the allocator to skip whichever AG owns the log.
>  #
>  # Exercise 9x 22MB AGs, 4 filestreams, 8 files per stream, and 3MB per file.
> -_test_streams 9 22 4 8 3 0 0
> -_test_streams 9 22 4 8 3 1 0
> -_test_streams 9 22 4 8 3 0 1
> -_test_streams 9 22 4 8 3 1 1
> +_test_streams 9 44 4 8 3 0 0
> +_test_streams 9 44 4 8 3 1 0
> +_test_streams 9 44 4 8 3 0 1
> +_test_streams 9 44 4 8 3 1 1
>
>  status=0
>  exit
> diff --git a/tests/xfs/174 b/tests/xfs/174
> index 1245a217..c01cb865 100755
> --- a/tests/xfs/174
> +++ b/tests/xfs/174
> @@ -24,8 +24,8 @@ _check_filestreams_support || _notrun "filestreams not available"
>  # test number of streams greater than AGs. Expected to fail.
>  _set_stream_timeout_centisecs 6000
>
> -_test_streams 8 32 65 3 1 1 0 fail
> -_test_streams 8 32 65 3 1 0 1 fail
> +_test_streams 8 64 65 3 1 1 0 fail
> +_test_streams 8 64 65 3 1 0 1 fail
>
>  status=0
>  exit
> diff --git a/tests/xfs/176 b/tests/xfs/176
> index ba4aae59..8d60cd36 100755
> --- a/tests/xfs/176
> +++ b/tests/xfs/176
> @@ -23,7 +23,7 @@ _require_scratch_xfs_shrink
>  _require_xfs_io_command "falloc"
>  _require_xfs_io_command "fpunch"
>
> -_scratch_mkfs "-d size=50m -m crc=1 -i sparse" |
> +_scratch_mkfs "-d size=512m -m crc=1 -i sparse" |
>         _filter_mkfs > /dev/null 2> $tmp.mkfs
>  . $tmp.mkfs    # for isize
>  cat $tmp.mkfs >> $seqres.full
> diff --git a/tests/xfs/205 b/tests/xfs/205
> index 104f1f45..f1a8200a 100755
> --- a/tests/xfs/205
> +++ b/tests/xfs/205
> @@ -23,7 +23,7 @@ _require_scratch_nocheck
>  unset SCRATCH_RTDEV
>
>  fsblksz=1024
> -_scratch_mkfs_xfs -d size=$((32768*fsblksz)) -b size=$fsblksz >> $seqres.full 2>&1
> +_scratch_mkfs_xfs -d size=$((524288*fsblksz)) -b size=$fsblksz >> $seqres.full 2>&1
>  _scratch_mount
>
>  # fix the reserve block pool to a known size so that the enospc calculations
> diff --git a/tests/xfs/206 b/tests/xfs/206
> index cb346b6d..a813ac44 100755
> --- a/tests/xfs/206
> +++ b/tests/xfs/206
> @@ -69,7 +69,7 @@ mkfs_filter()
>
>  # mkfs slightly smaller than that, small log for speed.
>  echo "=== mkfs.xfs ==="
> -mkfs.xfs -f -bsize=4096 -l size=32m -dagsize=76288719b,size=3905982455b \
> +mkfs.xfs -f -bsize=4096 -l size=64m -dagsize=76288719b,size=3905982455b \
>          $tmpfile  | mkfs_filter
>
>  mount -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
> diff --git a/tests/xfs/227 b/tests/xfs/227
> index cd927dc4..5f5f519e 100755
> --- a/tests/xfs/227
> +++ b/tests/xfs/227
> @@ -122,7 +122,7 @@ create_target_attr_last()
>  }
>
>  # use a small filesystem so we can control freespace easily
> -_scratch_mkfs_sized $((50 * 1024 * 1024)) >> $seqres.full 2>&1
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
>  _scratch_mount
>  fragment_freespace
>
> diff --git a/tests/xfs/233 b/tests/xfs/233
> index 2b2b8666..573b7a17 100755
> --- a/tests/xfs/233
> +++ b/tests/xfs/233
> @@ -18,7 +18,7 @@ _require_xfs_scratch_rmapbt
>  _require_no_large_scratch_dev
>
>  echo "Format and mount"
> -_scratch_mkfs_sized $((2 * 4096 * 4096)) > $seqres.full 2>&1
> +_scratch_mkfs_sized $((32 * 4096 * 4096)) > $seqres.full 2>&1
>  _scratch_mount >> $seqres.full 2>&1
>
>  testdir=$SCRATCH_MNT/test-$seq
> diff --git a/tests/xfs/250 b/tests/xfs/250
> index 8af32711..72b65227 100755
> --- a/tests/xfs/250
> +++ b/tests/xfs/250
> @@ -69,7 +69,7 @@ _test_loop()
>          _check_xfs_filesystem $LOOP_DEV none none
>  }
>
> -_test_loop 50g 16m 40G
> +_test_loop 50g 64m 40G
>  echo "*** done"
>  status=0
>  exit
> diff --git a/tests/xfs/259 b/tests/xfs/259
> index 88e2f3ee..8829e76b 100755
> --- a/tests/xfs/259
> +++ b/tests/xfs/259
> @@ -49,7 +49,7 @@ for del in $sizes_to_check; do
>                         >/dev/null 2>&1 || echo "dd failed"
>                 lofile=$(losetup -f)
>                 losetup $lofile "$testfile"
> -               $MKFS_XFS_PROG -l size=32m -b size=$bs $lofile |  _filter_mkfs \
> +               $MKFS_XFS_PROG -l size=64m -b size=$bs $lofile |  _filter_mkfs \
>                         >/dev/null 2> $tmp.mkfs || echo "mkfs failed!"
>                 . $tmp.mkfs
>                 sync
> diff --git a/tests/xfs/279 b/tests/xfs/279
> index 835d187f..262f30b7 100755
> --- a/tests/xfs/279
> +++ b/tests/xfs/279
> @@ -55,7 +55,7 @@ _check_mkfs()
>  (
>  echo "==================="
>  echo "4k physical 512b logical aligned"
> -SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 128`
> +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 512`
>  test -b "$SCSI_DEBUG_DEV" || _notrun "Could not get scsi_debug device"
>  # sector size should default to 4k
>  _check_mkfs $SCSI_DEBUG_DEV
> @@ -68,7 +68,7 @@ _put_scsi_debug_dev
>  (
>  echo "==================="
>  echo "4k physical 512b logical unaligned"
> -SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 1 128`
> +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 1 512`
>  test -b "$SCSI_DEBUG_DEV" || _notrun "Could not get scsi_debug device"
>  # should fail on misalignment
>  _check_mkfs $SCSI_DEBUG_DEV
> @@ -85,7 +85,7 @@ _put_scsi_debug_dev
>  (
>  echo "==================="
>  echo "hard 4k physical / 4k logical"
> -SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 4096 0 128`
> +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 4096 0 512`
>  test -b "$SCSI_DEBUG_DEV" || _notrun "Could not get scsi_debug device"
>  # block size smaller than sector size should fail
>  _check_mkfs -b size=2048 $SCSI_DEBUG_DEV
> diff --git a/tests/xfs/289 b/tests/xfs/289
> index c722deff..dc453b55 100755
> --- a/tests/xfs/289
> +++ b/tests/xfs/289
> @@ -39,10 +39,10 @@ tmpbind=$TEST_DIR/tmpbind.$$
>  mkdir -p $tmpdir || _fail "!!! failed to create temp mount dir"
>
>  echo "=== mkfs.xfs ==="
> -$MKFS_XFS_PROG -d file,name=$tmpfile,size=16m -f >/dev/null 2>&1
> +$MKFS_XFS_PROG -d file,name=$tmpfile,size=512m -f >/dev/null 2>&1
>
>  echo "=== truncate ==="
> -$XFS_IO_PROG -fc "truncate 256m" $tmpfile
> +$XFS_IO_PROG -fc "truncate 5g" $tmpfile
>
>  echo "=== xfs_growfs - unmounted, command should be rejected ==="
>  $XFS_GROWFS_PROG $tmpdir 2>&1 |  _filter_test_dir
> @@ -61,34 +61,34 @@ echo "=== mount ==="
>  $MOUNT_PROG -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
>
>  echo "=== xfs_growfs - mounted - check absolute path ==="
> -$XFS_GROWFS_PROG -D 8192 $tmpdir | _filter_test_dir > /dev/null
> +$XFS_GROWFS_PROG -D 262114 $tmpdir | _filter_test_dir > /dev/null
>
>  echo "=== xfs_growfs - check relative path ==="
> -$XFS_GROWFS_PROG -D 12288 ./tmpdir > /dev/null
> +$XFS_GROWFS_PROG -D 393216 ./tmpdir > /dev/null
>
>  echo "=== xfs_growfs - no path ==="
> -$XFS_GROWFS_PROG -D 16384 tmpdir > /dev/null
> +$XFS_GROWFS_PROG -D 524288 tmpdir > /dev/null
>
>  echo "=== xfs_growfs - symbolic link ==="
>  ln -s $tmpdir $tmpsymlink
> -$XFS_GROWFS_PROG -D 20480 $tmpsymlink | _filter_test_dir > /dev/null
> +$XFS_GROWFS_PROG -D 655360 $tmpsymlink | _filter_test_dir > /dev/null
>
>  echo "=== xfs_growfs - symbolic link using relative path ==="
> -$XFS_GROWFS_PROG -D 24576 ./tmpsymlink.$$ > /dev/null
> +$XFS_GROWFS_PROG -D 786432 ./tmpsymlink.$$ > /dev/null
>
>  echo "=== xfs_growfs - symbolic link using no path ==="
> -$XFS_GROWFS_PROG -D 28672 tmpsymlink.$$ > /dev/null
> +$XFS_GROWFS_PROG -D 917504 tmpsymlink.$$ > /dev/null
>
>  echo "=== xfs_growfs - bind mount ==="
>  mkdir $tmpbind
>  $MOUNT_PROG -o bind $tmpdir $tmpbind
> -$XFS_GROWFS_PROG -D 32768 $tmpbind | _filter_test_dir > /dev/null
> +$XFS_GROWFS_PROG -D 1048576 $tmpbind | _filter_test_dir > /dev/null
>
>  echo "=== xfs_growfs - bind mount - relative path ==="
> -$XFS_GROWFS_PROG -D 36864 ./tmpbind.$$ > /dev/null
> +$XFS_GROWFS_PROG -D 1179648 ./tmpbind.$$ > /dev/null
>
>  echo "=== xfs_growfs - bind mount - no path ==="
> -$XFS_GROWFS_PROG -D 40960 tmpbind.$$ > /dev/null
> +$XFS_GROWFS_PROG -D 1310720 tmpbind.$$ > /dev/null
>
>  echo "=== xfs_growfs - plain file - should be rejected ==="
>  $XFS_GROWFS_PROG $tmpfile 2>&1 | _filter_test_dir
> diff --git a/tests/xfs/291 b/tests/xfs/291
> index a2425e47..560e8891 100755
> --- a/tests/xfs/291
> +++ b/tests/xfs/291
> @@ -16,8 +16,8 @@ _supported_fs xfs
>
>  # real QA test starts here
>  _require_scratch
> -logblks=$(_scratch_find_xfs_min_logblocks -n size=16k -d size=133m)
> -_scratch_mkfs_xfs -n size=16k -l size=${logblks}b -d size=133m >> $seqres.full 2>&1
> +logblks=$(_scratch_find_xfs_min_logblocks -n size=16k -d size=512m)
> +_scratch_mkfs_xfs -n size=16k -l size=${logblks}b -d size=512m >> $seqres.full 2>&1
>  _scratch_mount
>
>  # First we cause very badly fragmented freespace, then
> diff --git a/tests/xfs/306 b/tests/xfs/306
> index b57bf4c0..b52285da 100755
> --- a/tests/xfs/306
> +++ b/tests/xfs/306
> @@ -30,7 +30,7 @@ unset SCRATCH_RTDEV
>
>  # Create a small fs with a large directory block size. We want to fill up the fs
>  # quickly and then create multi-fsb dirblocks over fragmented free space.
> -_scratch_mkfs_xfs -d size=20m -n size=64k >> $seqres.full 2>&1
> +_scratch_mkfs_xfs -d size=512m -n size=64k >> $seqres.full 2>&1
>  _scratch_mount
>
>  # Fill a source directory with many largish-named files. 1k uuid-named entries
> diff --git a/tests/xfs/445 b/tests/xfs/445
> index 9c55cac7..d97a57bb 100755
> --- a/tests/xfs/445
> +++ b/tests/xfs/445
> @@ -47,7 +47,7 @@ _check_filestreams_support || _notrun "filestreams not available"
>  unset SCRATCH_RTDEV
>
>  # use small AGs for frequent stream switching
> -_scratch_mkfs_xfs -d agsize=20m,size=2g >> $seqres.full 2>&1 ||
> +_scratch_mkfs_xfs -d agsize=64m,size=2g >> $seqres.full 2>&1 ||
>         _fail "mkfs failed"
>  _scratch_mount "-o filestreams"
>
> diff --git a/tests/xfs/514 b/tests/xfs/514
> index cf5588f2..1243d293 100755
> --- a/tests/xfs/514
> +++ b/tests/xfs/514
> @@ -37,7 +37,7 @@ esac
>  _require_command "$(type -P $CAT)" $CAT
>
>  file=$TEST_DIR/xx.$seq
> -truncate -s 128m $file
> +truncate -s 512m $file
>  $MKFS_XFS_PROG $file >> /dev/null
>
>  for COMMAND in `$XFS_DB_PROG -x -c help $file | awk '{print $1}' | grep -v "^Use"`; do
> diff --git a/tests/xfs/520 b/tests/xfs/520
> index 2fceb07c..d9e252bd 100755
> --- a/tests/xfs/520
> +++ b/tests/xfs/520
> @@ -60,7 +60,7 @@ force_crafted_metadata() {
>  }
>
>  bigval=100000000
> -fsdsopt="-d agcount=1,size=64m"
> +fsdsopt="-d agcount=1,size=512m"
>
>  force_crafted_metadata freeblks 0 "agf 0"
>  force_crafted_metadata longest $bigval "agf 0"
> --
> 2.31.1
>
