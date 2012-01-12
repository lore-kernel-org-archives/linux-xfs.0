Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CHe2ZH009038 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 11:40:03 -0600
Date: Thu, 12 Jan 2012 11:39:59 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: Introduce SEEK_DATA/SEEK_HOLE to XFS V5
Message-ID: <20120112173959.GU20739@sgi.com>
References: <4F06F71A.2010301@oracle.com> <20120110171855.GX6390@sgi.com>
	<4F0D21E5.7010908@oracle.com> <4F0DFB20.7030704@sgi.com>
	<4F0EE5B6.2040408@oracle.com> <4F0EF5DC.1070207@sgi.com>
	<20120112164148.GB22223@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120112164148.GB22223@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: jeff.liu@oracle.com, Mark Tinguely <tinguely@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

On Thu, Jan 12, 2012 at 11:41:48AM -0500, Christoph Hellwig wrote:
> On Thu, Jan 12, 2012 at 09:01:48AM -0600, Mark Tinguely wrote:
> > >Sorry, am was well understood your opinions in this point for now.
> > >IMHO, we can only find and return the data buffer offset at a dirty or
> > >unwritten page once the first page was probed.
> > >
> > 
> > From my tests, xfs_bmapi_read() can only find holes if they cross or
> > start on a 64KB boundary. It would be nice if unwritten extents were
> > at least that good at finding holes.
> 
> Are you testing on ia64 with 64k blocks? :)  xfs_bmapi_read will
> find holes down to block granularity, that's how it's implemented.
> However recent XFS does fairly aggressive preallocation, so you probably
						^^^^
					       
it is speculative delay in this case, I think.

-Ben

> won't find small holes unless you explicitly punch them out using
> XFS_IOC_UNRESVSP or fallocate with the hole punch flag.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
