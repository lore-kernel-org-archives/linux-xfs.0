Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:41217 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756720AbeDXLpH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Apr 2018 07:45:07 -0400
Date: Tue, 24 Apr 2018 19:45:01 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] xfs/191: remove logarithm-based test
Message-ID: <20180424114501.GC11384@desktop>
References: <1524281782-18208-1-git-send-email-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1524281782-18208-1-git-send-email-yangx.jy@cn.fujitsu.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

[cc linux-xfs for xfs specific test for review]

On Sat, Apr 21, 2018 at 11:36:22AM +0800, Xiao Yang wrote:
> Since commit 2cf637c in xfsprogs-dev, logarithm-based options
> were removed, so it's unnecessary to test them.
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>

This reminded me that Dave mentioned xfs/191 was broken[1], just remove
it from auto group?

Thanks,
Eryu

[1] https://www.spinics.net/lists/fstests/msg08915.html

> ---
>  tests/xfs/191-input-validation | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/tests/xfs/191-input-validation b/tests/xfs/191-input-validation
> index cff3efa..f3498a0 100755
> --- a/tests/xfs/191-input-validation
> +++ b/tests/xfs/191-input-validation
> @@ -262,7 +262,6 @@ do_mkfs_fail -l version=0  $SCRATCH_DEV
>  
>  # naming section, should pass
>  do_mkfs_pass -n size=65536 $SCRATCH_DEV
> -do_mkfs_pass -n log=15 $SCRATCH_DEV
>  do_mkfs_pass -n version=2 $SCRATCH_DEV
>  do_mkfs_pass -n version=ci $SCRATCH_DEV
>  do_mkfs_pass -n ftype=0 -m crc=0 $SCRATCH_DEV
> @@ -309,7 +308,6 @@ do_mkfs_fail -r size=65536 $SCRATCH_DEV
>  do_mkfs_pass -i size=256 -m crc=0 $SCRATCH_DEV
>  do_mkfs_pass -i size=512 $SCRATCH_DEV
>  do_mkfs_pass -i size=2048 $SCRATCH_DEV
> -do_mkfs_pass -i log=10 $SCRATCH_DEV
>  do_mkfs_pass -i perblock=2 $SCRATCH_DEV
>  do_mkfs_pass -i maxpct=10 $SCRATCH_DEV
>  do_mkfs_pass -i maxpct=100 $SCRATCH_DEV
> -- 
> 1.8.3.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
