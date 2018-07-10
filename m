Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39448 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933631AbeGJOnr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jul 2018 10:43:47 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] common/xfs: remove bad xfs_repair -t option
References: <20180710094129.1052-1-zlang@redhat.com>
Message-ID: <57d1a12b-dfaf-834a-a74e-3654624af336@sandeen.net>
Date: Tue, 10 Jul 2018 09:43:46 -0500
MIME-Version: 1.0
In-Reply-To: <20180710094129.1052-1-zlang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org



On 7/10/18 4:41 AM, Zorro Lang wrote:
> The xfs_repair "-t" option shouldn't be used alone. An interval must
> follow the -t option, or xfs_repair will report errors. And only
> modify reporting interval is useless, if we don't enable ag_stride.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---

I agree, -t looks like it should only have been used for xfs_check.
This seems to go back a long way in history [1], but I think it has always
been broken.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


[1] commit 6c6ba523c29d78a009d237e2a019d65beb5fced8
Author: fsgqa <fsgqa>
Date:   Fri Aug 29 06:04:54 2003 +0000

    QA updates to enable simplified large filesystem testing

> Hi,
> 
> I don't know why we must need the -t option for xfs_repair, I can't
> find any description to explain it. But I can find an explanation
> about why we use "-t" for _xfs_check.
> 
>   # xfs_check runs out of memory on large files, so even providing the test
>   # option (-t) to avoid indexing the free space trees doesn't make it pass on
>   # large filesystems. Avoid it.
> 
> The -t option for xfs_repair is totally different with it for
> xfs_check, maybe -m option is more useful if we think about the
> memory size.
> 
> And the -t option need to work with -o ag_stride together. I'd like
> to remove the "-t" option directly, due to I really don't know why
> we need it, or how to give it a proper number.
> 
> If the original author knows why we need it, and can give me some
> suggestions, please help.
> 
> Thanks,
> Zorro
> 
>  common/xfs | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/common/xfs b/common/xfs
> index ecf54bbf..61a3c2d9 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -193,7 +193,6 @@ _scratch_xfs_repair()
>  		SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
>  	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
>  		SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -r$SCRATCH_RTDEV"
> -	[ "$LARGE_SCRATCH_DEV" = yes ] && SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -t"
>  	$XFS_REPAIR_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
>  }
>  
> 


