Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBA19ZRG150037 for <xfs@oss.sgi.com>; Sun, 9 Dec 2012 19:09:35 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QmGR4A2OwgOXwNod for <xfs@oss.sgi.com>;
	Sun, 09 Dec 2012 17:12:02 -0800 (PST)
Date: Mon, 10 Dec 2012 12:12:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix re-use of EWOULDBLOCK during read on dm-mirror
Message-ID: <20121210011201.GI15784@dastard>
References: <50C11E95.4050502@suse.com>
 <20121207095326.GI27172@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121207095326.GI27172@dastard>
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
To: Jeff Mahoney <jeffm@suse.com>
Cc: xfs@oss.sgi.com

On Fri, Dec 07, 2012 at 08:53:26PM +1100, Dave Chinner wrote:
> On Thu, Dec 06, 2012 at 05:39:17PM -0500, Jeff Mahoney wrote:
> > When using lvconvert to convert a linear mapping to a dm-raid1 mirror,
> > we encountered issues where the log would be flooded with messages like:
> > 
> > metadata I/O error: block 0xee7060 ("xfs_trans_read_buf") error 11 numblks 8
> > 
> > The cause is that dm-mirror (and striping, and others) will return
> > -EWOULDBLOCK for readahead requests while the mirror is rebuilding.
> 
> That's nasty - since when has DM been doing this? I doubt anything
> handles a EAGAIN error from the storage layer properly - it's not
> an error the filesystem expects from the lower layers at all.

Wow, it's been doing this since at least 2008 - it's taken the
best part of 5 years for someone to trip over this.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
