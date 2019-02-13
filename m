Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59122 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfBMFGy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 00:06:54 -0500
Date: Tue, 12 Feb 2019 21:06:46 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs/420: only check the extent layout after syncing
Message-ID: <20190213050646.GA6503@magnolia>
References: <20190204153026.1673-1-hch@lst.de>
 <20190211235144.GA6477@magnolia>
 <20190212190022.GA28460@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190212190022.GA28460@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Feb 12, 2019 at 08:00:22PM +0100, Christoph Hellwig wrote:
> On Mon, Feb 11, 2019 at 03:51:44PM -0800, Darrick J. Wong wrote:
> > > The comparism pass before the sync might see an "error" if we use COW
> > > fork speculative preallocations for non-overwrites, which is useful to
> > > reduce fragmentation.
> > 
> > What error do you see?
> 
> -- /root/xfstests/tests/xfs/420.out	2019-02-12 15:41:12.202606228 +0000
> +++ /root/xfstests/results//xfs/420.out.bad	2019-02-12 18:58:06.158426573
> +0000
> @@ -14,8 +14,6 @@
>  Whence	Result
>  DATA	0
>  HOLE	131072
> -DATA	196608
> -HOLE	262144
>  Compare files
>  c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-420/file1
>  017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-420/file2
> 
> 
> > > -echo "Seek holes and data in file1"
> > > -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
> > > -echo "Seek holes and data in file2"
> > > -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
> > 
> > This removed code tests that the earlier write of 64k of data into file2
> > between 192k and 256k can be found by SEEK_DATA before file2 gets
> > sync'd to disk.
> 
> Well, and it might not be able to be found if it is in the COW fork..

But why would data only be able to be found in the COW fork?

Does this test failure happen for you on a regular xfs filesystem, or
does it only happen with the alwayscow patchset?

If yes, are unfsync'd O_ATOMIC writes to holes invisible to seek_data
until fsync finishes?

> > And this removed code checks that the page cache contents remain stable
> > and correct even for a write that goes through the COW mechanism.
> > 
> > I don't see why it's advantageous to remove this part of the test?
> 
> Last time I send a patch to just add a sync and got the recommendation
> to just remove the double tests before and after the sync..

Yes, and I think Eryu is wrong.  We wrote data into a hole between 192k
and 256k, and SEEK_DATA should be able to find that data (it's readable
from the page cache, after all) even if we haven't yet fsync'd the file.

--D
