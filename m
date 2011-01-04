Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p04JkdWe033643 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 13:46:39 -0600
Subject: Re: My current xfs-for-2.6.38 tree....
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110104064612.GK15179@dastard>
References: <20110104050259.GH15179@dastard>
	<20110104055441.GA9870@infradead.org> <20110104064612.GK15179@dastard>
Date: Tue, 04 Jan 2011 13:48:44 -0600
Message-ID: <1294170524.2485.6.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, 2011-01-04 at 17:46 +1100, Dave Chinner wrote:
> On Tue, Jan 04, 2011 at 12:54:41AM -0500, Christoph Hellwig wrote:
> > On Tue, Jan 04, 2011 at 04:02:59PM +1100, Dave Chinner wrote:
> > > Folks,
> > > 
> > > FYI, my current xfs-for-2.6.38 tree has just been updated. Changes
> > > since last update:
> > > 
> > > 	- dropped the per-cpu superblock counter cleanup patches
> > > 	  from it so we can get it right before merging.
> > > 	- added unaligned aio/dio write fix series (needs review)
> > > 	- added log covering idle fix (needs review)
> > > 	- added superblock write error hang fix (needs review)
> > > 
> > > The tree can be found here (when the rsync updates git.kernel.org):
> > 
> > I'll try to get to review the new patches, but can we please get the
> > metadata scalability patches into the xfs tree and thus linux-next ASAP?
> > The merge window is about to open, and we really need to get that stuff
> > in now.
> 
> That's all first in the branch and reviewed, so Alex should be able
> to simply merge up to the last commit in that part of the series from
> the branch I posted.
> 
> Alex, if you want I can set up a separate branch for the metadata
> scalability series....

No that's OK, I'll take in everything that's reviewed
and ready to go and leave the rest for later.  I've been
waiting for a pull request but this is fine with me.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
