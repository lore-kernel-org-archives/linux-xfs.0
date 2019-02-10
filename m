Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38516 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfBJLOf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Feb 2019 06:14:35 -0500
Date: Sun, 10 Feb 2019 19:14:28 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] xfs/420: only check the extent layout after syncing
Message-ID: <20190210111428.GV2713@desktop>
References: <20190204153026.1673-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204153026.1673-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

On Mon, Feb 04, 2019 at 04:30:26PM +0100, Christoph Hellwig wrote:
> This tests validates the correct extent layout for some hairy reflink
> related issues.  But until we called sync or fsync we have no gurantee
> of any data fork layout, as only writeback moves the extents from the
> COW for to the data fork.
> 
> The comparism pass before the sync might see an "error" if we use COW
> fork speculative preallocations for non-overwrites, which is useful to
> reduce fragmentation.
> 
> Just remove the pass of comparisms before the sync, as the one after
> the sync will catch all persistent issues.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I think this is fine. But I'd like the test author to take a look too.

/me looks at Darrick :)

Thanks,
Eryu

> ---
>  tests/xfs/420     | 14 --------------
>  tests/xfs/420.out | 14 --------------
>  2 files changed, 28 deletions(-)
> 
> diff --git a/tests/xfs/420 b/tests/xfs/420
> index a083a12b..0d611fd6 100755
> --- a/tests/xfs/420
> +++ b/tests/xfs/420
> @@ -93,20 +93,6 @@ $XFS_IO_PROG -c "pwrite -S 0x63 $((blksz * 3)) $blksz" $testdir/file2 >> $seqres
>  $XFS_IO_PROG -c "pwrite -S 0x63 0 $blksz" $testdir/file3 >> $seqres.full
>  $XFS_IO_PROG -c "pwrite -S 0x63 $((blksz * 3)) $blksz" $testdir/file3 >> $seqres.full
>  
> -$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
> -$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
> -$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
> -
> -echo "Seek holes and data in file1"
> -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
> -echo "Seek holes and data in file2"
> -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
> -
> -echo "Compare files"
> -md5sum $testdir/file1 | _filter_scratch
> -md5sum $testdir/file2 | _filter_scratch
> -md5sum $testdir/file3 | _filter_scratch
> -
>  echo "sync filesystem" | tee -a $seqres.full
>  sync
>  
> diff --git a/tests/xfs/420.out b/tests/xfs/420.out
> index d1b5483a..39360741 100644
> --- a/tests/xfs/420.out
> +++ b/tests/xfs/420.out
> @@ -6,20 +6,6 @@ c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-420/file1
>  c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-420/file2
>  c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-420/file3
>  CoW the shared part then write into the empty part
> -Seek holes and data in file1
> -Whence	Result
> -DATA	0
> -HOLE	131072
> -Seek holes and data in file2
> -Whence	Result
> -DATA	0
> -HOLE	131072
> -DATA	196608
> -HOLE	262144
> -Compare files
> -c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-420/file1
> -017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-420/file2
> -017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-420/file3
>  sync filesystem
>  Seek holes and data in file1
>  Whence	Result
> -- 
> 2.20.1
> 
