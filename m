Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:10009 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752781AbeEPFqP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 01:46:15 -0400
Date: Wed, 16 May 2018 15:46:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 31/33] iomap: add support for sub-pagesize buffered I/O
 without buffer heads
Message-ID: <20180516054611.GK10363@dastard>
References: <20180509074830.16196-1-hch@lst.de>
 <20180509074830.16196-32-hch@lst.de>
 <eebcc4bf-f646-edc6-264b-124b3880f3cb@suse.de>
 <20180515072625.GA23384@lst.de>
 <8b36b6c2-03b0-ea66-9bea-df2695dd1dba@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b36b6c2-03b0-ea66-9bea-df2695dd1dba@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Tue, May 15, 2018 at 08:47:25AM -0500, Goldwyn Rodrigues wrote:
> On 05/15/2018 02:26 AM, Christoph Hellwig wrote:
> > On Mon, May 14, 2018 at 11:00:08AM -0500, Goldwyn Rodrigues wrote:
> >>> +	if (iop || i_blocksize(inode) == PAGE_SIZE)
> >>> +		return iop;
> >>
> >> Why is this an equal comparison operator? Shouldn't this be >= to
> >> include filesystem blocksize greater than PAGE_SIZE?
> > 
> > Which filesystems would that be that have a tested and working PAGE_SIZE
> > support using iomap?
> 
> Oh, I assumed iomap would work for filesystems with block size greater
> than PAGE_SIZE.

It will eventually, but first we've got to remove the iomap
infrastructure and filesystem dependencies on bufferheads....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
