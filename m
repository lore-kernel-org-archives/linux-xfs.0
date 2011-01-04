Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p046i8HW195185 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 00:44:08 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF1C31D08471
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 22:46:14 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	JZAIw8uJCBUPguyW for <xfs@oss.sgi.com>;
	Mon, 03 Jan 2011 22:46:14 -0800 (PST)
Date: Tue, 4 Jan 2011 17:46:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: My current xfs-for-2.6.38 tree....
Message-ID: <20110104064612.GK15179@dastard>
References: <20110104050259.GH15179@dastard>
	<20110104055441.GA9870@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110104055441.GA9870@infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, Jan 04, 2011 at 12:54:41AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 04, 2011 at 04:02:59PM +1100, Dave Chinner wrote:
> > Folks,
> > 
> > FYI, my current xfs-for-2.6.38 tree has just been updated. Changes
> > since last update:
> > 
> > 	- dropped the per-cpu superblock counter cleanup patches
> > 	  from it so we can get it right before merging.
> > 	- added unaligned aio/dio write fix series (needs review)
> > 	- added log covering idle fix (needs review)
> > 	- added superblock write error hang fix (needs review)
> > 
> > The tree can be found here (when the rsync updates git.kernel.org):
> 
> I'll try to get to review the new patches, but can we please get the
> metadata scalability patches into the xfs tree and thus linux-next ASAP?
> The merge window is about to open, and we really need to get that stuff
> in now.

That's all first in the branch and reviewed, so Alex should be able
to simply merge up to the last commit in that part of the series from
the branch I posted.

Alex, if you want I can set up a separate branch for the metadata
scalability series....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
