Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE4B8ECAAD8
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 07:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiH3Hgt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 03:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiH3Hgs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 03:36:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515E8BB02D
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 00:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661845004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B/NuMk94jfuQHWLyRbLs5uxJsV+9Y4MlAC5cefV6x6k=;
        b=XgwL9/WG9Y0AmGgf8okgtOrbko7BKgMJGX+WKuH4XoU7f0EH40U4q+R2nkEGE1F5ZVxM6U
        tdZ86a4MAyRdrH0udUHuziYmJSn0EMZRb3LY5NaZlMCT+8qkQBs8M3V345xCrsKH4gXtSg
        +Xd/rb/jkS7LK0iKPluF4STDdmk4C90=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-262-H2HTbMTqP5yHwkSsdUgEvw-1; Tue, 30 Aug 2022 03:36:41 -0400
X-MC-Unique: H2HTbMTqP5yHwkSsdUgEvw-1
Received: by mail-qt1-f198.google.com with SMTP id h13-20020ac87d4d000000b00342f6c363afso8115908qtb.9
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 00:36:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=B/NuMk94jfuQHWLyRbLs5uxJsV+9Y4MlAC5cefV6x6k=;
        b=1Ii7BeJbvrhK3+hW/BtsdynoL8HW3SzvnIkSfugB0vxIjLORSEEreZgTLomH1uVkJo
         2UZqOJ14xgsaiImLYlh9uztFZTA7S3ERV2wdZio3f9CyDQBhWyu7ZhzKhvu77F+aDpvK
         NYvHV0Hk927h8s+8lhx6ZVgfPmRcl1pJSC/iDf8+eLy5cJJxGdpmbqLVCqo/BC7x+/6Z
         AoNpnwsHsyfZ7FKpVPk0nMAi/RBQKpipw1MwAwgXS7PD6JJo6zJCM0z/xrHqVkiLZjPL
         ocjrCVWsMST4OQYDGRhzRICGArrQmDi0c3urMNez6Ev27cxfj5z/J74DO749aZNw5ni0
         tzEQ==
X-Gm-Message-State: ACgBeo1yDg8M6oLOm2Lr0t92hGrxfXVXxC+j2jyFapC3PKEmSkB6rRwg
        a9SQqMWLxv92XSQsCvrNaZKp/8S626h+xSZgouO4sjL4To/JUDac8Dy346jmg5MQoAY03L1NrXo
        1d1qpFRX0e+oTaR+gCLz0
X-Received: by 2002:ad4:5def:0:b0:476:c97f:e28d with SMTP id jn15-20020ad45def000000b00476c97fe28dmr14266922qvb.42.1661845000844;
        Tue, 30 Aug 2022 00:36:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR49eXlS9swzWESkFRsqlV350CCKxCUMi7f6QcJgVfJqJbwBY+3LkVcuBOjBDygn7ltu5THzHg==
X-Received: by 2002:ad4:5def:0:b0:476:c97f:e28d with SMTP id jn15-20020ad45def000000b00476c97fe28dmr14266909qvb.42.1661845000289;
        Tue, 30 Aug 2022 00:36:40 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s6-20020a05620a29c600b006bb82221013sm7510993qkp.0.2022.08.30.00.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 00:36:39 -0700 (PDT)
Date:   Tue, 30 Aug 2022 15:36:34 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/4] tests: increase fs size for mkfs
Message-ID: <20220830073634.7qklqvl2la53kbv4@zlang-mailbox>
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
 <20220830044433.1719246-2-jencce.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830044433.1719246-2-jencce.kernel@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 30, 2022 at 12:44:30PM +0800, Murphy Zhou wrote:
> Since this xfsprogs commit:
> 	6e0ed3d19c54 mkfs: stop allowing tiny filesystems
> XFS requires filesystem size bigger then 300m.

I'm wondering if we can just use 300M, or 512M is better. CC linux-xfs to
get more discussion about how to deal with this change on mkfs.xfs.

> 
> Increase thoese numbers to 512M at least. There is no special
> reason for the magic number 512, just double it from original
> 256M and being reasonable small.

Hmm... do we need a global parameter to define the minimal XFS size,
or even minimal local fs size? e.g. MIN_XFS_SIZE, or MIN_FS_SIZE ...

> 
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  common/config         |  2 +-
>  common/xfs            |  2 +-
>  tests/generic/015     |  2 +-
>  tests/generic/027     |  2 +-
>  tests/generic/042     |  3 +++
>  tests/generic/077     |  2 +-
>  tests/generic/081     |  6 +++---
>  tests/generic/083     |  2 +-
>  tests/generic/085     |  2 +-
>  tests/generic/108     |  4 ++--
>  tests/generic/204     |  2 +-
>  tests/generic/226     |  2 +-
>  tests/generic/250     |  2 +-
>  tests/generic/252     |  2 +-
>  tests/generic/371     |  2 +-
>  tests/generic/387     |  2 +-
>  tests/generic/416     |  2 +-
>  tests/generic/416.out |  2 +-
>  tests/generic/427     |  2 +-
>  tests/generic/449     |  2 +-
>  tests/generic/455     |  2 +-
>  tests/generic/457     |  2 +-
>  tests/generic/482     |  2 +-
>  tests/generic/511     |  2 +-
>  tests/generic/520     |  4 ++--
>  tests/generic/536     |  2 +-
>  tests/generic/619     |  2 +-
>  tests/generic/626     |  2 +-
>  tests/xfs/002         |  2 +-
>  tests/xfs/015         |  2 +-
>  tests/xfs/041         |  8 ++++----
>  tests/xfs/041.out     | 10 +++++-----
>  tests/xfs/042         |  2 +-
>  tests/xfs/049         |  2 +-
>  tests/xfs/073         |  2 +-
>  tests/xfs/076         |  2 +-
>  tests/xfs/078         |  6 +++---
>  tests/xfs/078.out     | 23 +++++++++++------------
>  tests/xfs/104         |  6 +++---
>  tests/xfs/104.out     | 30 ------------------------------
>  tests/xfs/107         |  4 ++--
>  tests/xfs/118         |  4 ++--
>  tests/xfs/148         |  2 +-
>  tests/xfs/149         | 12 ++++++------
>  tests/xfs/168         |  2 +-
>  tests/xfs/170         | 10 +++++-----
>  tests/xfs/170.out     |  8 ++++----
>  tests/xfs/174         |  4 ++--
>  tests/xfs/174.out     |  4 ++--
>  tests/xfs/176         |  2 +-
>  tests/xfs/205         |  2 +-
>  tests/xfs/227         |  2 +-
>  tests/xfs/233         |  2 +-
>  tests/xfs/279         |  6 +++---
>  tests/xfs/289         | 22 +++++++++++-----------
>  tests/xfs/291         |  4 ++--
>  tests/xfs/306         |  2 +-
>  tests/xfs/514         |  2 +-
>  tests/xfs/520         |  2 +-
>  59 files changed, 114 insertions(+), 142 deletions(-)
> 
> diff --git a/common/config b/common/config
> index c30eec6d..45b7650b 100644
> --- a/common/config
> +++ b/common/config
> @@ -325,7 +325,7 @@ fi
>  if [ "$FSTYP" == "xfs" ]; then
>  	XFS_MKFS_HAS_NO_META_SUPPORT=""
>  	touch /tmp/crc_check.img
> -	$MKFS_XFS_PROG -N -d file,name=/tmp/crc_check.img,size=32m -m crc=0 \
> +	$MKFS_XFS_PROG -N -d file,name=/tmp/crc_check.img,size=512m -m crc=0 \
>  		>/dev/null 2>&1;
>  	if [ $? -ne 0 ]; then
>  		XFS_MKFS_HAS_NO_META_SUPPORT=true
> diff --git a/common/xfs b/common/xfs
> index 9f84dffb..efabb0ad 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1176,7 +1176,7 @@ _require_xfs_copy()
>  	# xfs_copy on v5 filesystems do not require the "-d" option if xfs_db
>  	# can change the UUID on v5 filesystems
>  	touch /tmp/$$.img
> -	$MKFS_XFS_PROG -d file,name=/tmp/$$.img,size=64m >/dev/null 2>&1
> +	$MKFS_XFS_PROG -d file,name=/tmp/$$.img,size=512m >/dev/null 2>&1
>  
>  	# xfs_db will return 0 even if it can't generate a new uuid, so
>  	# check the output to make sure if it can change UUID of V5 xfs
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

As you change the 256 to 512 at here, better to change above comment which says
why 256M is needed.

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
> diff --git a/tests/generic/042 b/tests/generic/042
> index dbc65e33..54f883cd 100755
> --- a/tests/generic/042
> +++ b/tests/generic/042
> @@ -32,8 +32,11 @@ _crashtest()
>  	# f2fs-utils 1.9.0 needs at least 38 MB space for f2fs image. However,
>  	# f2fs-utils 1.14.0 needs at least 52 MB. Not sure if it will change
>  	# again. So just set it 128M.
> +	# xfsprogs 5.19.0 requires xfs size larger then 300m.
>  	if [ $FSTYP == "f2fs" ]; then
>  		size=128M
> +	elif [ $FSTYP == "xfs" ]; then
> +		size=512M
>  	fi
>  
>  	# Create an fs on a small, initialized image. The pattern is written to
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
>  	>>$seqres.full 2>&1
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
> diff --git a/tests/generic/416.out b/tests/generic/416.out
> index 8d2ffacf..8f12447d 100644
> --- a/tests/generic/416.out
> +++ b/tests/generic/416.out
> @@ -1,3 +1,3 @@
>  QA output created by 416
> -wrote 16777216/16777216 bytes at offset 0
> +wrote 67108864/67108864 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
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
> diff --git a/tests/generic/455 b/tests/generic/455
> index 649b5410..128e87d5 100755
> --- a/tests/generic/455
> +++ b/tests/generic/455
> @@ -51,7 +51,7 @@ SANITY_DIR=$TEST_DIR/fsxtests
>  rm -rf $SANITY_DIR
>  mkdir $SANITY_DIR
>  
> -devsize=$((1024*1024*200 / 512))        # 200m phys/virt size
> +devsize=$((1024*1024*512 / 512))        # 512m phys/virt size
>  csize=$((1024*64 / 512))                # 64k cluster size
>  lowspace=$((1024*1024 / 512))           # 1m low space threshold
>  
> diff --git a/tests/generic/457 b/tests/generic/457
> index da75798f..8604d5c5 100755
> --- a/tests/generic/457
> +++ b/tests/generic/457
> @@ -55,7 +55,7 @@ SANITY_DIR=$TEST_DIR/fsxtests
>  rm -rf $SANITY_DIR
>  mkdir $SANITY_DIR
>  
> -devsize=$((1024*1024*200 / 512))        # 200m phys/virt size
> +devsize=$((1024*1024*512 / 512))        # 512m phys/virt size
>  csize=$((1024*64 / 512))                # 64k cluster size
>  lowspace=$((1024*1024 / 512))           # 1m low space threshold
>  
> diff --git a/tests/generic/482 b/tests/generic/482
> index 28c83a23..011e605d 100755
> --- a/tests/generic/482
> +++ b/tests/generic/482
> @@ -64,7 +64,7 @@ if [ $nr_cpus -gt 8 ]; then
>  fi
>  fsstress_args=$(_scale_fsstress_args -w -d $SCRATCH_MNT -n 512 -p $nr_cpus \
>  		$FSSTRESS_AVOID)
> -devsize=$((1024*1024*200 / 512))	# 200m phys/virt size
> +devsize=$((1024*1024*512 / 512))	# 512m phys/virt size
>  csize=$((1024*64 / 512))		# 64k cluster size
>  lowspace=$((1024*1024 / 512))		# 1m low space threshold
>  
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
>  	>> $seqres.full 2>&1
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
> index 05de5578..5173cfe5 100755
> --- a/tests/xfs/041
> +++ b/tests/xfs/041
> @@ -38,10 +38,10 @@ _fill()
>  }
>  
>  _do_die_on_error=message_only
> -agsize=32
> +agsize=512
>  echo -n "Make $agsize megabyte filesystem on SCRATCH_DEV and mount... "
> -_scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2>&1 >/dev/null || _fail "mkfs failed"
> -bsize=`_scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2>&1 | _filter_mkfs 2>&1 \
> +_scratch_mkfs_xfs -dsize=${agsize}m,agcount=2 2>&1 >/dev/null || _fail "mkfs failed"
> +bsize=`_scratch_mkfs_xfs -dsize=${agsize}m,agcount=2 2>&1 | _filter_mkfs 2>&1 \
>  		| perl -ne 'if (/dbsize=(\d+)/) {print $1;}'`
>  onemeginblocks=`expr 1048576 / $bsize`
>  _scratch_mount
> @@ -51,7 +51,7 @@ echo "done"
>  # full allocation group -> partial; partial -> expand partial + new partial;
>  # partial -> expand partial; partial -> full
>  # cycle through 33m -> 67m -> 75m -> 96m
> -for size in 33 67 75 96
> +for size in 513 1027 1059 1536

Above comment need to be changed too.

>  do
>      grow_size=`expr $size \* $onemeginblocks`
>      _fill $SCRATCH_MNT/fill_$size
> diff --git a/tests/xfs/041.out b/tests/xfs/041.out
> index 0e675804..9e2a2c6d 100644
> --- a/tests/xfs/041.out
> +++ b/tests/xfs/041.out
> @@ -1,19 +1,19 @@
>  QA output created by 041
> -Make 32 megabyte filesystem on SCRATCH_DEV and mount... done
> +Make 512 megabyte filesystem on SCRATCH_DEV and mount... done
>  Fill filesystem... done
> -Grow filesystem to 33m... done
> +Grow filesystem to 513m... done
>  Flush filesystem... done
>  Check files... done
>  Fill filesystem... done
> -Grow filesystem to 67m... done
> +Grow filesystem to 1027m... done
>  Flush filesystem... done
>  Check files... done
>  Fill filesystem... done
> -Grow filesystem to 75m... done
> +Grow filesystem to 1059m... done
>  Flush filesystem... done
>  Check files... done
>  Fill filesystem... done
> -Grow filesystem to 96m... done
> +Grow filesystem to 1536m... done
>  Flush filesystem... done
>  Check files... done
>  Growfs tests passed.
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
>  	_filter_mkfs > /dev/null 2> $tmp.mkfs
>  . $tmp.mkfs	# for isize
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
> diff --git a/tests/xfs/078.out b/tests/xfs/078.out
> index cc3c47d1..fe324b07 100644
> --- a/tests/xfs/078.out
> +++ b/tests/xfs/078.out
> @@ -19,9 +19,9 @@ data blocks changed from 168024 to 336048
>  *** unmount
>  *** check
>  
> -=== GROWFS (from 344113152 to 1376452608, 2048 blocksize)
> +=== GROWFS (from 688226304 to 1376452608, 2048 blocksize)
>  
> -*** mkfs loop file (size=344113152)
> +*** mkfs loop file (size=688226304)
>  meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
>  data     = bsize=XXX blocks=XXX, imaxpct=PCT
>           = sunit=XXX swidth=XXX, unwritten=X
> @@ -32,14 +32,14 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
>  wrote 2048/2048 bytes at offset 1376452608
>  *** mount loop filesystem
>  *** grow loop filesystem
> -xfs_growfs --BlockSize=2048 --Blocks=168024
> -data blocks changed from 168024 to 672096
> +xfs_growfs --BlockSize=2048 --Blocks=336048
> +data blocks changed from 336048 to 672096
>  *** unmount
>  *** check
>  
> -=== GROWFS (from 86028288 to 1376452608, 512 blocksize)
> +=== GROWFS (from 688226304 to 1376452608, 512 blocksize)
>  
> -*** mkfs loop file (size=86028288)
> +*** mkfs loop file (size=688226304)
>  meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
>  data     = bsize=XXX blocks=XXX, imaxpct=PCT
>           = sunit=XXX swidth=XXX, unwritten=X
> @@ -50,14 +50,14 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
>  wrote 512/512 bytes at offset 1376452608
>  *** mount loop filesystem
>  *** grow loop filesystem
> -xfs_growfs --BlockSize=512 --Blocks=163840
> -data blocks changed from 163840 to 2688384
> +xfs_growfs --BlockSize=512 --Blocks=1344192
> +data blocks changed from 1344192 to 2688384
>  *** unmount
>  *** check
>  
> -=== GROWFS (from 172056576 to 688230400, 1024 blocksize)
> +=== GROWFS (from 688226304 to 688230400, 1024 blocksize)
>  
> -*** mkfs loop file (size=172056576)
> +*** mkfs loop file (size=688226304)
>  meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
>  data     = bsize=XXX blocks=XXX, imaxpct=PCT
>           = sunit=XXX swidth=XXX, unwritten=X
> @@ -68,8 +68,7 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
>  wrote 1024/1024 bytes at offset 688230400
>  *** mount loop filesystem
>  *** grow loop filesystem
> -xfs_growfs --BlockSize=1024 --Blocks=168024
> -data blocks changed from 168024 to 672096
> +xfs_growfs --BlockSize=1024 --Blocks=672096
>  *** unmount
>  *** check
>  
> diff --git a/tests/xfs/104 b/tests/xfs/104
> index d16f46d8..e4876633 100755
> --- a/tests/xfs/104
> +++ b/tests/xfs/104
> @@ -53,14 +53,14 @@ _require_xfs_io_command "falloc"
>  _scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
>  . $tmp.mkfs	# extract blocksize and data size for scratch device
>  
> -endsize=`expr 550 \* 1048576`	# stop after growing this big
> -incsize=`expr  42 \* 1048576`	# grow in chunks of this size
> +endsize=`expr 1920 \* 1048576`	# stop after growing this big
> +incsize=`expr 179 \* 1048576`	# grow in chunks of this size
>  modsize=`expr   4 \* $incsize`	# pause after this many increments
>  
>  [ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
>  
>  nags=4
> -size=`expr 125 \* 1048576`	# 120 megabytes initially
> +size=`expr 512 \* 1048576`	# 512 megabytes initially
>  sizeb=`expr $size / $dbsize`	# in data blocks
>  echo "*** creating scratch filesystem"
>  logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
> diff --git a/tests/xfs/104.out b/tests/xfs/104.out
> index de6c7f27..c3fc8829 100644
> --- a/tests/xfs/104.out
> +++ b/tests/xfs/104.out
> @@ -95,33 +95,3 @@ log      =LDEV bsize=XXX blocks=XXX
>  realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
>  AGCOUNT=14
>  
> -*** stressing filesystem
> -*** growing filesystem
> -meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> -data     = bsize=XXX blocks=XXX, imaxpct=PCT
> -         = sunit=XXX swidth=XXX, unwritten=X
> -naming   =VERN bsize=XXX
> -log      =LDEV bsize=XXX blocks=XXX
> -realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> -AGCOUNT=15
> -
> -*** stressing filesystem
> -*** growing filesystem
> -meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> -data     = bsize=XXX blocks=XXX, imaxpct=PCT
> -         = sunit=XXX swidth=XXX, unwritten=X
> -naming   =VERN bsize=XXX
> -log      =LDEV bsize=XXX blocks=XXX
> -realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> -AGCOUNT=17
> -
> -*** stressing filesystem
> -*** growing filesystem
> -meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> -data     = bsize=XXX blocks=XXX, imaxpct=PCT
> -         = sunit=XXX swidth=XXX, unwritten=X
> -naming   =VERN bsize=XXX
> -log      =LDEV bsize=XXX blocks=XXX
> -realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> -AGCOUNT=18
> -
> diff --git a/tests/xfs/107 b/tests/xfs/107
> index 1ea9c492..e1f9b537 100755
> --- a/tests/xfs/107
> +++ b/tests/xfs/107
> @@ -23,9 +23,9 @@ _require_scratch
>  _require_xfs_io_command allocsp		# detect presence of ALLOCSP ioctl
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
> index 503eff65..49762556 100755
> --- a/tests/xfs/149
> +++ b/tests/xfs/149
> @@ -42,10 +42,10 @@ _require_loop
>  mkdir -p $mntdir || _fail "!!! failed to create temp mount dir"
>  
>  echo "=== mkfs.xfs ==="
> -$MKFS_XFS_PROG -d file,name=$loopfile,size=16m -f >/dev/null 2>&1
> +$MKFS_XFS_PROG -d file,name=$loopfile,size=512m -f >> $seqres.full 2>&1
>  
>  echo "=== truncate ==="
> -$XFS_IO_PROG -fc "truncate 256m" $loopfile
> +$XFS_IO_PROG -fc "truncate 3072m" $loopfile
>  
>  echo "=== create loop device ==="
>  loop_dev=$(_create_loop_device $loopfile)
> @@ -69,10 +69,10 @@ echo "=== mount ==="
>  $MOUNT_PROG $loop_dev $mntdir || _fail "!!! failed to loopback mount"
>  
>  echo "=== xfs_growfs - check device node ==="
> -$XFS_GROWFS_PROG -D 8192 $loop_dev > /dev/null
> +$XFS_GROWFS_PROG -D 262144 $loop_dev > /dev/null
>  
>  echo "=== xfs_growfs - check device symlink ==="
> -$XFS_GROWFS_PROG -D 12288 $loop_symlink > /dev/null
> +$XFS_GROWFS_PROG -D 393216 $loop_symlink > /dev/null
>  
>  echo "=== unmount ==="
>  $UMOUNT_PROG $mntdir || _fail "!!! failed to unmount"
> @@ -81,10 +81,10 @@ echo "=== mount device symlink ==="
>  $MOUNT_PROG $loop_symlink $mntdir || _fail "!!! failed to loopback mount"
>  
>  echo "=== xfs_growfs - check device symlink ==="
> -$XFS_GROWFS_PROG -D 16384 $loop_symlink > /dev/null
> +$XFS_GROWFS_PROG -D 524288 $loop_symlink > /dev/null
>  
>  echo "=== xfs_growfs - check device node ==="
> -$XFS_GROWFS_PROG -D 20480 $loop_dev > /dev/null
> +$XFS_GROWFS_PROG -D 655360 $loop_dev > /dev/null
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/168 b/tests/xfs/168
> index ffcd0df8..f3d5193b 100755
> --- a/tests/xfs/168
> +++ b/tests/xfs/168
> @@ -51,7 +51,7 @@ _require_xfs_io_command "falloc"
>  _scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs >/dev/null
>  . $tmp.mkfs	# extract blocksize and data size for scratch device
>  
> -endsize=`expr 125 \* 1048576`	# stop after shrinking this big
> +endsize=`expr 300 \* 1048576`	# stop after shrinking this big
>  [ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
>  
>  nags=2
> diff --git a/tests/xfs/170 b/tests/xfs/170
> index b9ead341..f437fff3 100755
> --- a/tests/xfs/170
> +++ b/tests/xfs/170
> @@ -31,11 +31,11 @@ _set_stream_timeout_centisecs 3000
>  # the log for small filesystems, so we make sure there's one more AG than
>  # filestreams to encourage the allocator to skip whichever AG owns the log.
>  #
> -# Exercise 9x 22MB AGs, 4 filestreams, 8 files per stream, and 3MB per file.
> -_test_streams 9 22 4 8 3 0 0
> -_test_streams 9 22 4 8 3 1 0
> -_test_streams 9 22 4 8 3 0 1
> -_test_streams 9 22 4 8 3 1 1
> +# Exercise 9x 68MB AGs, 4 filestreams, 8 files per stream, and 9MB per file.
> +_test_streams 9 68 4 8 9 0 0
> +_test_streams 9 68 4 8 9 1 0
> +_test_streams 9 68 4 8 9 0 1
> +_test_streams 9 68 4 8 9 1 1
>  
>  status=0
>  exit
> diff --git a/tests/xfs/170.out b/tests/xfs/170.out
> index 16dcb795..513c230d 100644
> --- a/tests/xfs/170.out
> +++ b/tests/xfs/170.out
> @@ -1,20 +1,20 @@
>  QA output created by 170
> -# testing 9 22 4 8 3 0 0 ....
> +# testing 9 68 4 8 9 0 0 ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
>  + passed, streams are in seperate AGs
> -# testing 9 22 4 8 3 1 0 ....
> +# testing 9 68 4 8 9 1 0 ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
>  + passed, streams are in seperate AGs
> -# testing 9 22 4 8 3 0 1 ....
> +# testing 9 68 4 8 9 0 1 ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
>  + passed, streams are in seperate AGs
> -# testing 9 22 4 8 3 1 1 ....
> +# testing 9 68 4 8 9 1 1 ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
> diff --git a/tests/xfs/174 b/tests/xfs/174
> index 1245a217..3b04cd35 100755
> --- a/tests/xfs/174
> +++ b/tests/xfs/174
> @@ -24,8 +24,8 @@ _check_filestreams_support || _notrun "filestreams not available"
>  # test number of streams greater than AGs. Expected to fail.
>  _set_stream_timeout_centisecs 6000
>  
> -_test_streams 8 32 65 3 1 1 0 fail
> -_test_streams 8 32 65 3 1 0 1 fail
> +_test_streams 8 68 72 3 1 1 0 fail
> +_test_streams 8 68 72 3 1 0 1 fail
>  
>  status=0
>  exit
> diff --git a/tests/xfs/174.out b/tests/xfs/174.out
> index 5df581fe..d9fea2f7 100644
> --- a/tests/xfs/174.out
> +++ b/tests/xfs/174.out
> @@ -1,10 +1,10 @@
>  QA output created by 174
> -# testing 8 32 65 3 1 1 0 fail ....
> +# testing 8 68 72 3 1 1 0 fail ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
>  + expected failure, matching AGs
> -# testing 8 32 65 3 1 0 1 fail ....
> +# testing 8 68 72 3 1 0 1 fail ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
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
>  	_filter_mkfs > /dev/null 2> $tmp.mkfs
>  . $tmp.mkfs	# for isize
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

