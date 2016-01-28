Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 214527CA2
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 15:59:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D9E308F8039
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 13:59:00 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id VIqIt3Huwhu2EGfl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2016 13:58:59 -0800 (PST)
Date: Thu, 28 Jan 2016 13:58:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: stop using ioends for direct write completions
Message-ID: <20160128215853.GC6431@birch.djwong.org>
References: <1452766237-2314-1-git-send-email-hch@lst.de>
	<20160128131656.GB14876@infradead.org>
	<20160128205333.GF20038@birch.djwong.org>
	<20160128211056.GA27287@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160128211056.GA27287@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Jan 28, 2016 at 10:10:56PM +0100, Christoph Hellwig wrote:
> On Thu, Jan 28, 2016 at 12:53:33PM -0800, Darrick J. Wong wrote:
> > On Thu, Jan 28, 2016 at 05:16:56AM -0800, Christoph Hellwig wrote:
> > > Any chance to get a review for this?  It should really help
> > > with sorting out the buffered I/O COW code.
> > 
> > It looks reasonable to me.  I separated the dio and buffered CoW remap paths a
> > couple of weeks ago, because it seems that IO errors only get passed back as a
> > return value from __blockdev_direct_IO, therefore the remapping has to be done
> > from xfs_vm_do_dio anyway because we don't want to remap if the write fails.
> > Just yesterday I removed the "is_cow" flag from the ioend, so now we're back to
> > having a separate XFS_IO_COW ioend type.
> 
> For direct I/O we will need something like this to properly support AIO
> writes.

Aw, snap, I knew I'd forgotten something.  Yep, we'll need that... I think
xfs_end_io_direct_write will have to sniff out the error status from "size"
and either remap or discard the CoW allocations as appropriate.

Heh, guess I'd better go write some aio tests. :)

> > So... reflink doesn't need the patch but OTOH directio doesn't really need 
> > the overhead of allocating an ioend anyway. :)
> 
> Yep.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
