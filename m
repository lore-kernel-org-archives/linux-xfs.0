Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:55204 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753186AbdKNLog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2017 06:44:36 -0500
MIME-Version: 1.0
In-Reply-To: <20171114105401.10542-2-eguan@redhat.com>
References: <20171114105401.10542-1-eguan@redhat.com> <20171114105401.10542-2-eguan@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 14 Nov 2017 13:44:35 +0200
Message-ID: <CAOQ4uxg=508aezscTjSx1_WEZqLDOfuOcRfWMTNfB--u31FcJQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] fstests: filter mount error message for EUCLEAN and ESTALE
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Nov 14, 2017 at 12:53 PM, Eryu Guan <eguan@redhat.com> wrote:
> util-linux commit ea848180dd34 ("libmount: add
> mnt_context_get_excode()") since v2.30 changed the error message on
> EUCLEAN and ESTALE again (and maybe other errno too):
>
>  - mount: <device> on <mountpoint> failed: Structure needs cleaning
>  + mount: <mountpoint>: mount(2) system call failed: Structure needs cleaning.
>
> and it causes xfs/005, overlay/037 to fail (and probably xfs/333 too,
> but it's always _notrun for now).
>
> So let's filter out the changing parts and keep the error message
> simple.
>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  common/filter         | 23 +++++++++++++++++++++++
>  tests/overlay/037     |  4 ++--
>  tests/overlay/037.out |  4 ++--
>  tests/xfs/005         |  7 +------
>  tests/xfs/333         |  2 +-
>  tests/xfs/333.out     |  2 +-
>  6 files changed, 30 insertions(+), 12 deletions(-)
>
> diff --git a/common/filter b/common/filter
> index 0cb458b0051f..d1bb94818e3d 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -390,6 +390,13 @@ _filter_fstrim()
>         egrep -o "[0-9]+ bytes" | $AWK_PROG '{print $1}'
>  }
>
> +# Remove the ending dot appended to mount error message, util-linux 2.30
> +# starts to do so.
> +_filter_ending_dot()
> +{
> +       sed -e "s/\.$//"
> +}
> +
>  # Older mount output referred to "block device" when mounting RO devices
>  # It's gone in newer versions
>  _filter_ro_mount() {
> @@ -397,6 +404,22 @@ _filter_ro_mount() {
>             -e "s/mount: cannot mount block device/mount: cannot mount/g"
>  }
>
> +# Filter a failed mount output, util-linux changed the message several times.
> +#
> +# prior to v2.21:
> +# mount: Structure needs cleaning
> +# v2.21 to v2.29:
> +# mount: mount <device> on <mountpoint> failed: Structure needs cleaning
> +# v2.30 and later:
> +# mount: <mountpoint>: mount(2) system call failed: Structure needs cleaning.
> +#
> +# This is also true for ESTALE error. So let's remove all the changing parts
> +# and keep the 'prior to v2.21' format.
> +_filter_error_mount()
> +{
> +       sed -e "s/mount:\(.*failed:\)/mount:/" | _filter_ending_dot
> +}
> +
>  _filter_od()
>  {
>         BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
> diff --git a/tests/overlay/037 b/tests/overlay/037
> index 728732903358..b897ec9263ee 100755
> --- a/tests/overlay/037
> +++ b/tests/overlay/037
> @@ -76,12 +76,12 @@ $UMOUNT_PROG $SCRATCH_MNT
>
>  # Try to mount an overlay with the same upperdir and different lowerdir - expect ESTALE
>  _overlay_scratch_mount_dirs $lowerdir2 $upperdir $workdir -oindex=on \
> -       2>&1 | _filter_scratch
> +       2>&1 | _filter_scratch | _filter_error_mount
>  $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
>
>  # Try to mount an overlay with the same workdir and different upperdir - expect ESTALE
>  _overlay_scratch_mount_dirs $lowerdir $upperdir2 $workdir -oindex=on \
> -       2>&1 | _filter_scratch
> +       2>&1 | _filter_scratch | _filter_error_mount
>  $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
>
>  # Mount overlay with original lowerdir, upperdir, workdir and index=on - expect success
> diff --git a/tests/overlay/037.out b/tests/overlay/037.out
> index 786ef85c29e3..d6ad7cfad687 100644
> --- a/tests/overlay/037.out
> +++ b/tests/overlay/037.out
> @@ -1,3 +1,3 @@
>  QA output created by 037
> -mount: mount SCRATCH_DEV on SCRATCH_MNT failed: Stale file handle
> -mount: mount SCRATCH_DEV on SCRATCH_MNT failed: Stale file handle
> +mount: Stale file handle
> +mount: Stale file handle


037.out doesn't contain SCRATCH_ at all now, so can drop
_filter_scratch in front of _filter_error_mount

> diff --git a/tests/xfs/005 b/tests/xfs/005
> index fade4bbf282b..ebf4b15ec9b5 100755
> --- a/tests/xfs/005
> +++ b/tests/xfs/005
> @@ -40,11 +40,6 @@ _cleanup()
>      rm -f $tmp.*
>  }
>
> -filter_mount()
> -{
> -       sed -e "s/mount .* failed: //"
> -}
> -
>  # get standard environment, filters and checks
>  . ./common/rc
>  . ./common/filter
> @@ -64,7 +59,7 @@ _scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1 || _fail "mkfs failed"
>  $XFS_IO_PROG -c "pwrite 224 4" -c fsync $SCRATCH_DEV | _filter_xfs_io
>
>  # should FAIL, the crc is bad; golden output contains mount failure
> -_scratch_mount 2>&1 | filter_mount
> +_scratch_mount 2>&1 | _filter_error_mount
>
>  # success, all done
>  status=0
> diff --git a/tests/xfs/333 b/tests/xfs/333
> index bf0c811d2435..0a66f08a1062 100755
> --- a/tests/xfs/333
> +++ b/tests/xfs/333
> @@ -64,7 +64,7 @@ _scratch_unmount
>
>  echo "Corrupt fs"
>  _scratch_xfs_db -x -c 'sb 0' -c "write rrmapino $ino" >> $seqres.full
> -_scratch_mount 2>&1 | _filter_scratch
> +_scratch_mount 2>&1 | _filter_scratch | _filter_error_mount
>
>  echo "Test done, mount should have failed"
>
> diff --git a/tests/xfs/333.out b/tests/xfs/333.out
> index f7518f46d900..b3c698750f8f 100644
> --- a/tests/xfs/333.out
> +++ b/tests/xfs/333.out
> @@ -2,5 +2,5 @@ QA output created by 333
>  Format and mount
>  Create some files
>  Corrupt fs
> -mount: mount SCRATCH_DEV on SCRATCH_MNT failed: Structure needs cleaning
> +mount: Structure needs cleaning
>  Test done, mount should have failed

Same as above.

Amir.
