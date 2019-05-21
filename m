Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:32847 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfEUFEf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 01:04:35 -0400
MIME-Version: 1.0
References: <155839145160.62682.10916303376882370723.stgit@magnolia> <155839147057.62682.15559355049172171217.stgit@magnolia>
In-Reply-To: <155839147057.62682.15559355049172171217.stgit@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 21 May 2019 08:04:23 +0300
Message-ID: <CAOQ4uxhsiM-tCB+RV9P7z6kK_kEwxKpoeAFfc8Y5YwC8F6C40g@mail.gmail.com>
Subject: Re: [PATCH 3/3] generic, xfs: use _scratch_shutdown instead of
 calling src/godown
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <guaneryu@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jeffle Xu <jefflexu@linux.alibaba.com>, fstests <fstests@vger.kernel.org>

On Tue, May 21, 2019 at 1:31 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Overlayfs introduces some complexity with regards to what path we have
> to use to shut down the scratch filesystem: it's SCRATCH_MNT for regular
> filesystems, but it's OVL_BASE_SCRATCH_MNT (i.e. the lower mount of the
> overlay) if overlayfs is enabled.  The helper works through all that, so
> we might as well use it.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks for cleaning that up

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  tests/generic/050 |    2 +-
>  tests/xfs/051     |    2 +-
>  tests/xfs/079     |    2 +-
>  tests/xfs/121     |    4 ++--
>  tests/xfs/181     |    4 ++--
>  5 files changed, 7 insertions(+), 7 deletions(-)
>
>
> diff --git a/tests/generic/050 b/tests/generic/050
> index 9a327165..91632d2d 100755
> --- a/tests/generic/050
> +++ b/tests/generic/050
> @@ -92,7 +92,7 @@ echo "touch files"
>  touch $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
>
>  echo "going down:"
> -src/godown -f $SCRATCH_MNT
> +_scratch_shutdown -f
>
>  echo "unmounting shutdown filesystem:"
>  _scratch_unmount 2>&1 | _filter_scratch
> diff --git a/tests/xfs/051 b/tests/xfs/051
> index bcc824f8..105fa9ff 100755
> --- a/tests/xfs/051
> +++ b/tests/xfs/051
> @@ -47,7 +47,7 @@ _scratch_mount
>  # recovery.
>  $FSSTRESS_PROG -n 9999 -p 2 -w -d $SCRATCH_MNT > /dev/null 2>&1 &
>  sleep 5
> -src/godown -f $SCRATCH_MNT
> +_scratch_shutdown -f
>  $KILLALL_PROG -q $FSSTRESS_PROG
>  wait
>  _scratch_unmount
> diff --git a/tests/xfs/079 b/tests/xfs/079
> index bf965a7f..67250495 100755
> --- a/tests/xfs/079
> +++ b/tests/xfs/079
> @@ -56,7 +56,7 @@ _scratch_mount "-o logbsize=32k"
>  # Run a workload to dirty the log, wait a bit and shutdown the fs.
>  $FSSTRESS_PROG -d $SCRATCH_MNT -p 4 -n 99999999 >> $seqres.full 2>&1 &
>  sleep 10
> -./src/godown -f $SCRATCH_MNT
> +_scratch_shutdown -f
>  wait
>
>  # Remount with a different log buffer size. Going from 32k to 64k increases the
> diff --git a/tests/xfs/121 b/tests/xfs/121
> index d82a367f..2e3914b7 100755
> --- a/tests/xfs/121
> +++ b/tests/xfs/121
> @@ -52,7 +52,7 @@ src/multi_open_unlink -f $SCRATCH_MNT/test_file -n $num_files -s $delay &
>  sleep 3
>
>  echo "godown"
> -src/godown -v -f $SCRATCH_MNT >> $seqres.full
> +_scratch_shutdown -v -f >> $seqres.full
>
>  # time for multi_open_unlink to exit out after its delay
>  # so we have no references and can unmount
> @@ -69,7 +69,7 @@ _try_scratch_mount $mnt >>$seqres.full 2>&1 \
>      || _fail "mount failed: $mnt $MOUNT_OPTIONS"
>
>  echo "godown"
> -src/godown -v -f $SCRATCH_MNT >> $seqres.full
> +_scratch_shutdown -v -f >> $seqres.full
>
>  echo "unmount"
>  _scratch_unmount
> diff --git a/tests/xfs/181 b/tests/xfs/181
> index 882a974b..dba69a70 100755
> --- a/tests/xfs/181
> +++ b/tests/xfs/181
> @@ -65,7 +65,7 @@ pid=$!
>  sleep 10
>
>  echo "godown"
> -src/godown -v -f $SCRATCH_MNT >> $seqres.full
> +_scratch_shutdown -v -f >> $seqres.full
>
>  # kill the multi_open_unlink
>  kill $pid 2>/dev/null
> @@ -83,7 +83,7 @@ _scratch_mount $mnt >>$seqres.full 2>&1 \
>      || _fail "mount failed: $mnt $MOUNT_OPTIONS"
>
>  echo "godown"
> -src/godown -v -f $SCRATCH_MNT >> $seqres.full
> +_scratch_shutdown -v -f >> $seqres.full
>
>  echo "unmount"
>  _scratch_unmount
>
