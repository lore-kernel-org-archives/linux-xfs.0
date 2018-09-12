Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46428 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbeILSTo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Sep 2018 14:19:44 -0400
Date: Wed, 12 Sep 2018 21:15:09 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] xfs/119: fix too small log size error
Message-ID: <20180912131509.GA17817@desktop>
References: <20180912110404.32673-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180912110404.32673-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Sep 12, 2018 at 07:04:04PM +0800, Zorro Lang wrote:
> xfs/119 fails on 4k hard sector size device if reflink (with/without
> rmapbt) is enabled:
> 
>   # mkfs.xfs -f -m reflink=1,rmapbt=0 -l version=2,size=2560b,su=64k /dev/sdf
>   log size 2560 blocks too small, minimum size is 2688 blocks
>   # mkfs.xfs -f -m reflink=1,rmapbt=1 -l version=2,size=2560b,su=64k /dev/sdf
>   log size 2560 blocks too small, minimum size is 4368 blocks
> 
> So remove log size parameter and run mkfs.xfs again if it fails.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> I saw Dave changed the log size once in commit:
>   d0a3cc5a xfs/104: log size too small for 4k sector drives
> 
> But it's still not enough after we have reflink feature now. I don't
> know why this case need "-l version=2,size=2560b,su=64k",
> if someone learns about this case, please tell me how to change this
> case properly. If the log size parameter is not necessary, I'd like
> to remove it.

I guess we still need the log size param, as the test is testing
"freeze/thaws on a small log fs", please see commit 3ebdf78c16cb ("Test
out pv#942130 where the unmount rec is not ungranting log space. Merge
of master-melb:xfs-cmds:23759a by kenmcd."), but we don't have much
background information from that ancient commit log..

Thanks,
Eryu

> 
> Thanks,
> Zorro
> 
>  tests/xfs/119 | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/119 b/tests/xfs/119
> index bf7f1ca8..d507aacf 100755
> --- a/tests/xfs/119
> +++ b/tests/xfs/119
> @@ -40,7 +40,14 @@ sync
>  
>  export MKFS_OPTIONS="-l version=2,size=2560b,su=64k" 
>  export MOUNT_OPTIONS="-o logbsize=64k"
> -_scratch_mkfs_xfs >/dev/null
> +_scratch_mkfs_xfs >/dev/null 2>&1
> +# The specified log size maybe too small if new features (e.g: reflink
> +# or/and rmapbt) is enabled. So if mkfs fails, don't specify log size
> +# and try to mkfs again.
> +if [ $? -ne 0 ]; then
> +	export MKFS_OPTIONS="-l version=2,su=64k"
> +	_scratch_mkfs_xfs >/dev/null
> +fi
>  
>  _scratch_mount
>  
> -- 
> 2.14.4
> 
