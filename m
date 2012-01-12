Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CGfnCH006338 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 10:41:49 -0600
Date: Thu, 12 Jan 2012 11:41:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Introduce SEEK_DATA/SEEK_HOLE to XFS V5
Message-ID: <20120112164148.GB22223@infradead.org>
References: <4F06F71A.2010301@oracle.com> <20120110171855.GX6390@sgi.com>
	<4F0D21E5.7010908@oracle.com> <4F0DFB20.7030704@sgi.com>
	<4F0EE5B6.2040408@oracle.com> <4F0EF5DC.1070207@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F0EF5DC.1070207@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, jeff.liu@oracle.com, Ben Myers <bpm@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

On Thu, Jan 12, 2012 at 09:01:48AM -0600, Mark Tinguely wrote:
> >Sorry, am was well understood your opinions in this point for now.
> >IMHO, we can only find and return the data buffer offset at a dirty or
> >unwritten page once the first page was probed.
> >
> 
> From my tests, xfs_bmapi_read() can only find holes if they cross or
> start on a 64KB boundary. It would be nice if unwritten extents were
> at least that good at finding holes.

Are you testing on ia64 with 64k blocks? :)  xfs_bmapi_read will
find holes down to block granularity, that's how it's implemented.
However recent XFS does fairly aggressive preallocation, so you probably
won't find small holes unless you explicitly punch them out using
XFS_IOC_UNRESVSP or fallocate with the hole punch flag.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
