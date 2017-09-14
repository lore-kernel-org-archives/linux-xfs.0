Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750740AbdINEJo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Sep 2017 00:09:44 -0400
Date: Thu, 14 Sep 2017 12:09:42 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: xfs/310: relax extent count check
Message-ID: <20170914040942.GE8034@eguan.usersys.redhat.com>
References: <20170903155101.GA30258@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903155101.GA30258@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

[adding linux-xfs list]

On Sun, Sep 03, 2017 at 05:51:01PM +0200, Christoph Hellwig wrote:
> If we got over the bmbt length we'll always allocate two extents,
> its just that so far getbmap merged them.
> 
> Also fix/update some comments.
> 
> diff --git a/tests/xfs/310 b/tests/xfs/310
> index c78f6f1..f33a15a 100755
> --- a/tests/xfs/310
> +++ b/tests/xfs/310
> @@ -1,7 +1,7 @@
>  #! /bin/bash
>  # FS QA Test No. 310
>  #
> -# Create a file with more than 2^21 extents (the max length of a bmbt record).
> +# Create a file with more than 2^21 blocks (the max length of a bmbt record).
>  #
>  #-----------------------------------------------------------------------
>  # Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
> @@ -75,8 +75,9 @@ mkdir $testdir
>  blksz="$(_get_block_size $testdir)"
>  $XFS_IO_PROG -f -c "falloc 0 $((nr_blks * blksz))" $testdir/file1 >> $seqres.full
>  
> +# make sure the allocator didn't allocate more than the needed two extents
>  echo "Check extent count"
> -xfs_bmap -l -p -v $testdir/file1 | grep '^[[:space:]]*1:' -q && xfs_bmap -l -p -v $testdir/file1
> +xfs_bmap -l -p -v $testdir/file1 | grep '^[[:space:]]*2:' -q && xfs_bmap -l -p -v $testdir/file1

It'd be great if someone could help to review this change. Thanks a lot!

Eryu

>  inum=$(stat -c '%i' $testdir/file1)
>  umount $SCRATCH_MNT
>  
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
