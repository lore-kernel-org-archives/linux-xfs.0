Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39053 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbeKSAJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Nov 2018 19:09:46 -0500
Date: Sun, 18 Nov 2018 21:49:16 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 5/5] xfs/420: only check the extent layout after syncing
Message-ID: <20181118134916.GD3889@desktop>
References: <20181110115145.30356-1-hch@lst.de>
 <20181110115145.30356-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181110115145.30356-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sat, Nov 10, 2018 at 12:51:45PM +0100, Christoph Hellwig wrote:
> This tests validates the correct extent layout for some hairy reflink
> related issues.  But until we called sync or fsync we have no gurantee
> of any data fork layout, as only writeback moves the extents from the
> COW for to the data fork.
> 
> Without this we'll see an error if we use COW fork speculative
> preallocations for non-overwrites, which is useful to reduce
> fragmentation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/420 | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tests/xfs/420 b/tests/xfs/420
> index a083a12b..aea95c7b 100755
> --- a/tests/xfs/420
> +++ b/tests/xfs/420
> @@ -93,6 +93,8 @@ $XFS_IO_PROG -c "pwrite -S 0x63 $((blksz * 3)) $blksz" $testdir/file2 >> $seqres
>  $XFS_IO_PROG -c "pwrite -S 0x63 0 $blksz" $testdir/file3 >> $seqres.full
>  $XFS_IO_PROG -c "pwrite -S 0x63 $((blksz * 3)) $blksz" $testdir/file3 >> $seqres.full
>  
> +sync
> +

There's another round of the same checks after

  echo "sync filesystem" | tee -a $seqres.full

I think we could just remove the checks before this sync, otherwise we
end up doing the same checks twice.

Thanks,
Eryu

P.S.

Patch 2/3/4 in this patchset look good to me, I've applied them, so
there's no need to resend them when resending patch 1 and 5.

>  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
>  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
>  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
> -- 
> 2.19.1
> 
