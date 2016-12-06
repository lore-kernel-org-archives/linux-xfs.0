Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35529 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbcLFCJP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 21:09:15 -0500
Date: Mon, 5 Dec 2016 18:09:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: reflink COW improvements
Message-ID: <20161206020908.GC8436@birch.djwong.org>
References: <1480971924-4864-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1480971924-4864-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 05, 2016 at 10:05:21PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds a few improvements to the direct I/O COW path.
> 
> Note that patch 2 at this point causes a regression in xfs/214:
> 
> @ -11,7 +11,7 @@
>  CoW one of the files
>  root      --       0       0       0              4     0     0       
>  nobody    --       0       0       0              1     0     0       
> -fsgqa     --    3520       0       0              4     0     0       
> +fsgqa     --    3072       0       0              4     0     0       
>  Remount the FS to see if accounting changes
>  root      --       0       0       0              4     0     0       
>  nobody    --       0       0       0              1     0     0 
> 
> But I think the test golden output actually is wrong - the test
> claims it tests that we don't get blocks charged during the COW,
> but the 3520 here means 512 bytes were charged, and later in the
> golden output we actually see that going away after a remount.

I think it's correct for how the directio path used to work...

So xfs/214 writes a 1MB file and reflinks it twice, with the intent of
playing with file2.  So, file2 looks like this:

dddddddddddddddd (d = existing data, data fork fork)
                 (cow fork)

A 512K cowextsize hint is set and we write to the last 64K of one of
the files.  The old dio write code would make the usual delalloc
reservation, which rounds both up and down to the nearest cowextsize
boundary:

dddddddddddddddd (data fork)
        cccccccc (cow fork)

At this point, we should be charged for 3584K -- 1MB for each of the
three files, and 512K for the CoW delalloc.

Then we call fsync, which CoWs the last 64k out to disk.  Now we have:

dddddddddddddddD (D = replacement data, data fork)
        ccccccc  (cow fork)

The quota charge is now 3520K -- 1MB for each of the three files plus
the 448K that remains in the CoW fork anticipating a future write.
Remounting flushes out the cow fork:

dddddddddddddddD (data fork)
                 (cow fork)

So now the quota charge is back to an even 3072MB -- three 1MB files.

My suspicion is that since the new patchset bypasses the delalloc +
conversion dance and replaces it with allocating exactly as many blocks
as the dio write asked for + rounding up to the nearest cowextsize.  In
this case, we never make the delalloc reservation between 512K and 896K,
so the repquota output says 3072K instead of 3520K.

(That said, I've been tied up in meetings all day so I haven't had a
chance to apply the patches and find out for real.)


--D
