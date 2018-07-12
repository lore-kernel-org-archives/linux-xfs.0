Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33355 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbeGLCyY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jul 2018 22:54:24 -0400
Date: Thu, 12 Jul 2018 10:47:01 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] generic/499: add bfoster's alternate reproducer
Message-ID: <20180712024701.GJ2780@desktop>
References: <20180711164919.GD5703@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180711164919.GD5703@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Wed, Jul 11, 2018 at 09:49:19AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add Brian Foster's alternate reproducer code for this problem so that we
> increase the chances that one of them will reproduce the race problem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/generic/499 |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/tests/generic/499 b/tests/generic/499
> index 99d6d308..e0b95871 100755
> --- a/tests/generic/499
> +++ b/tests/generic/499
> @@ -33,6 +33,7 @@ _require_xfs_io_command "fzero"
>  
>  rm -f $seqres.full
>  
> +# djwong's reproducer
>  _scratch_mkfs >>$seqres.full 2>&1
>  _scratch_mount
>  
> @@ -52,6 +53,24 @@ victim=$SCRATCH_MNT/a
>  touch $victim
>  $here/ltp/fsx --replay-ops $tmp.fsxops $victim > $tmp.output || cat $tmp.output
>  
> +# bfoster/hch reproducer
> +_scratch_unmount
> +_scratch_mkfs_sized $((1024 * 1024 * 100)) >>$seqres.full 2>&1
> +_scratch_mount

This test uses a different fs setup (_scratch_mkfs_sized), and adds new
sub-test to an existing case, I think it really deserves a new test.

Thanks,
Eryu

> +
> +$XFS_IO_PROG -fc "pwrite 0 100m" -c fsync $SCRATCH_MNT/file >>$seqres.full 2>&1
> +rm -f $SCRATCH_MNT/file
> +
> +cat >> $tmp.fsxops << ENDL
> +truncate 0x0 0x1f0d6 0x380e1
> +write 0x1ad87 0x6c99 0x180d6
> +zero_range 0x14426 0xd3aa 0x21a20 keep_size
> +mapread 0x1f69a 0x2386 0x21a20
> +ENDL
> +
> +touch $victim
> +$here/ltp/fsx --replay-ops $tmp.fsxops $victim > $tmp.output || cat $tmp.output
> +
>  echo "Silence is golden"
>  status=0
>  exit
