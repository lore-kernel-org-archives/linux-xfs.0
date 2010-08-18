Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IFoP7m120585 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 10:50:25 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D94986478
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 08:50:53 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	4gSPvIDh6eHDWxzR for <xfs@oss.sgi.com>;
	Wed, 18 Aug 2010 08:50:53 -0700 (PDT)
Date: Thu, 19 Aug 2010 01:50:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: page discard on page error
Message-ID: <20100818155043.GL7362@dastard>
References: <AANLkTimHBE_9pD1wWOkryOnqBgL2bJQTKoe52wYjfNw3@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTimHBE_9pD1wWOkryOnqBgL2bJQTKoe52wYjfNw3@mail.gmail.com>
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
To: Mike Gao <ygao.linux@gmail.com>
Cc: hch@lst.de, xfs@oss.sgi.com

On Wed, Aug 18, 2010 at 09:27:55AM -0500, Mike Gao wrote:
> Hi, all,
> 
> I sync latest XFS last month and build into our embedded system. When I
> test, I found below issue.
> It seems that the xfs_iomap failed when it did allocat with
> xfs_ilock_nowait().
> I debug this and found that ip->i_lock is locked and there are sometime no
> unlock coming between two lock trying.
> This issue will give wrong data in file on disk exactly on that offset.

Ah, it looks like we dropped the EAGAIN error from xfs_map_blocks()
on the floor.

Christoph, the 2.6.34 code did this:

error:
......
        /*
         * If it's delalloc and we have nowhere to put it,
         * throw it away, unless the lower layers told
         * us to try again.
         */
        if (err != -EAGAIN) {
                if (!unmapped)
                        xfs_aops_discard_page(page);
                ClearPageUptodate(page);
        }

and the caller redirtied the page on EAGAIN. The EAGAIN comes from
the BMAPI_TRYLOCK case, so it is a valid return indicating that we
would have blocked on a non-blocking IO.

The current code does not handle EAGAIN at all, just discards the
page. This looks incorrect - I think that EAGAIN should still cause
the page to be redirtied, not discarded. I'm not sure if I missed
something else, though - can you remember why you removed the EAGAIN
case?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
