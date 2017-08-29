Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44855 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754471AbdH2Ol0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Aug 2017 10:41:26 -0400
Date: Tue, 29 Aug 2017 16:41:24 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: rewrite getbmap using the xfs_iext_* helpers
Message-ID: <20170829144124.GB32169@lst.de>
References: <20170828150612.16437-1-hch@lst.de> <20170828183142.GG4757@magnolia> <20170828193507.GA31009@lst.de> <20170828210125.GH4757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170828210125.GH4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Aug 28, 2017 at 02:01:25PM -0700, Darrick J. Wong wrote:
> Aha, I see, it's only if you pass in -e to xfs_bmap then you get a hole record:

Good luck passing -e to xfs_bmap:

root@brick:/home/hch/work/xfsprogs# xfs_bmap -e foo
Illegal option -e
Usage: xfs_bmap [-adlpvV] [-n nx] file...

:)


> 
> $ truncate -s 50m /storage/tmp/a
> $ xfs_io -c 'bmap -elpv' /storage/tmp/a
> /storage/tmp/a:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET         TOTAL FLAGS
>    0: [0..102399]:     hole                                 102400
> $ xfs_bmap /storage/tmp/a
> /storage/tmp/a: no extents
> $ xfs_io -c 'bmap -lpv' /storage/tmp/a
> /storage/tmp/a: no extents
> 
> (eesh.)

But only if there are no other extents:

root@brick:/home/hch/work/xfsprogs# truncate -s 50m foo
root@brick:/home/hch/work/xfsprogs# xfs_io -c 'bmap -elpv' foo
foo:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET         TOTAL FLAGS
   0: [0..102399]:     hole                                 102400
root@brick:/home/hch/work/xfsprogs# echo bar > foo
root@brick:/home/hch/work/xfsprogs# xfs_io -c 'bmap -elpv' foo
foo:
 EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          730691408..730691415  3 (390992..390999)     8 000000

I think we need to actually define getbmap semantics, as it seems
to be a collection of accidental corner cases..
