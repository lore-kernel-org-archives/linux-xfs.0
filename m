Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 938537F88
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 16:30:56 -0600 (CST)
Date: Mon, 9 Dec 2013 16:30:52 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 04/11] xfs: add xfs_ilock_attr_map_shared
Message-ID: <20131209223052.GZ1935@sgi.com>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203128.663030833@bombadil.infradead.org>
	<20131208223610.GE31386@dastard>
	<20131209181612.GA22183@infradead.org>
	<20131209222433.GY10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131209222433.GY10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Dave,

On Tue, Dec 10, 2013 at 09:24:33AM +1100, Dave Chinner wrote:
> On Mon, Dec 09, 2013 at 10:16:12AM -0800, Christoph Hellwig wrote:
> > On Mon, Dec 09, 2013 at 09:36:10AM +1100, Dave Chinner wrote:
> > > > +			/*
> > > > +			 * Even after flushing the inode, there can still be
> > > > +			 * delalloc blocks on the inode beyond EOF due to
> > > > +			 * speculative reallocation.  These are not removed
> > > 
> > > "speculative preallocation"
> > 
> > I just re-indented the comment, the wording is the original one.  Maybe
> > we'll get a commit that cares enought to fix it on the fly..
> 
> Actually, I checked that before commenting on it - the original
> comment is correct:
> 
>  626                 /*
>  627                  * even after flushing the inode, there can still be delalloc
>  628                  * blocks on the inode beyond EOF due to speculative
>  629                  * preallocation. These are not removed until the release
>  630                  * function is called or the inode is inactivated. Hence we
>  631                  * cannot assert here that ip->i_delayed_blks == 0.
>  632                  */
> 
> I wouldn't have pointed at it if the original code had that
> problem... :/

If you want to extend your Reviewed-by: on this patch I will clean up the
spelling mistake and pull in this series.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
