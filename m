Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAMOTTn137063
	for <linux-xfs@oss.sgi.com>; Thu, 10 Nov 2011 16:24:29 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22975236EA5
	for <linux-xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:24:27 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	PinO4PWpZqFNcGfH for <linux-xfs@oss.sgi.com>;
	Thu, 10 Nov 2011 14:24:27 -0800 (PST)
Date: Fri, 11 Nov 2011 09:24:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS realtime O_DIRECT failures
Message-ID: <20111110222424.GB2386@dastard>
References: <loom.20111108T180925-222@post.gmane.org>
	<20111109080133.GB20604@infradead.org>
	<CAGedfzmcmfLXhBEzm9yhpRQTf-7dnMenXqe0FABAzJgP0rxSUA@mail.gmail.com>
	<20111109223314.GQ5534@dastard>
	<CAGedfznrW4c9Bf3D-7+CEUUa-_u5iVzh+KskwFS9bom0s=C=gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGedfznrW4c9Bf3D-7+CEUUa-_u5iVzh+KskwFS9bom0s=C=gQ@mail.gmail.com>
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
To: Alan Cook <acook@visionpointsystems.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com

On Wed, Nov 09, 2011 at 05:52:15PM -0500, Alan Cook wrote:
> On Wed, Nov 9, 2011 at 5:33 PM, Dave Chinner <david@fromorbit.com> wrote:
> > I'm not sure from that description just why the realtime volume adds
> > any benefit to your workflow. Separation of data and metadata is
> > does not provide you with data compression, so you must be doing
> > something different with the real time device to acheive
> > compression. Any details on that aspect of your setup?
> 
> The compression is done via hardware that sits between the block layer
> and the actual storage device (in this case it is a solid state
> drive).  Having both the data and meta data reside on the same device
> creates a problem, as the block layer has no idea whether it has data
> or meta data, and so will compress the meta data along with the
> regular data, which is very bad.  Splitting the meta data to a
> separate device eliminated that problem.

XFS metadata IO is tagged with REQ_META, so the block layer can
easily distinguish it from data IO.  Even if the version if XFS you
are using is not doing this, it's rather simple to add it to
_xfs_buf_ioapply().

With that, your problem at the block layer goes away, and hence the
need to separate data from metadata at the filesystem layer goes
away, too.

> > As to your current problem, it's got a NULL pointer dereference
> > trying to lock the per-ag structure. That means the per-ag lookup
> > failed, which implies that the RT freespace bitmap may be corrupt
> > and it's tried to read a bitmap block that is apparently beyond the
> > end of the filesystem.  What does xfs_check/xfs_repair -n tell you
> > about the filesystem state?
> 
> Unfortunately they do not tell a lot.  Running xfs_check/xfs_repair -n
> prior to running the test reports no errors.  However, attempting to
> run it after the test fails results in an indefinite I/O block (state
> of D+ for the process).  In fact, if I run the test utility twice, it
> results in a hung system.

That sounds like you have a problem with your block device or
underlying storage, not a filesystem problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
