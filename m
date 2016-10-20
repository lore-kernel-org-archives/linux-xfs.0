Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:53529 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753122AbcJTUWg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Oct 2016 16:22:36 -0400
Date: Fri, 21 Oct 2016 07:22:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Lock ordering in iomap code
Message-ID: <20161020202201.GN14023@dastard>
References: <20161007111314.GA24081@quack2.suse.cz>
 <20161017093148.GA6375@quack2.suse.cz>
 <20161017102657.GA12164@lst.de>
 <20161020115500.GB25779@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161020115500.GB25779@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Oct 20, 2016 at 01:55:00PM +0200, Jan Kara wrote:
> Hi Christoph,
> 
> On Mon 17-10-16 12:26:57, Christoph Hellwig wrote:
> > > Ping? I have ext4 DAX read & write path working with the iomap code but to
> > > convert the fault path, I need this resolved. Are you OK with moving
> > > iomap_begin() / iomap_end() calls outside of page lock / entry lock in the
> > > fault path?
> > 
> > Yes, that sounds fine.
> 
> I've been looking into this some more and realized it's not as easy as I've
> originally though. ->page_mkwrite callback is expected to return with the
> page locked so locking it inside the iomap actor is really awkward (think
> of situation when blocksize < pagesize). Since nobody currently has issues
> with ->iomap_begin being sometimes called with page lock and sometimes
> without, I don't think changing that would be worth the hassle. Just one
> more question: Doesn't XFS have some lock ordering issues when
> xfs_file_iomap_begin() gets called with page lock held from
> iomap_page_mkwrite() for a file with extent size hints and thus we end up
> in xfs_iomap_write_direct() with page lock held? We do a lot of stuff there
> including transaction setup and such...

Lock order in xfs is iolock->page lock->transaction->ilock, so what
is being done in xfs_file_iomap_begin (transactions, ilock) is fine
regardless of whether we hold the page locked or noti when called.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
