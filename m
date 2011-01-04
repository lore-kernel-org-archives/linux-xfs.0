Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p045qaB2184555 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 23:52:36 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5F03230E45
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 21:54:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id z8eHAXo5LFOUhG59 for
	<xfs@oss.sgi.com>; Mon, 03 Jan 2011 21:54:43 -0800 (PST)
Date: Tue, 4 Jan 2011 00:54:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: My current xfs-for-2.6.38 tree....
Message-ID: <20110104055441.GA9870@infradead.org>
References: <20110104050259.GH15179@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110104050259.GH15179@dastard>
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
Cc: xfs@oss.sgi.com

On Tue, Jan 04, 2011 at 04:02:59PM +1100, Dave Chinner wrote:
> Folks,
> 
> FYI, my current xfs-for-2.6.38 tree has just been updated. Changes
> since last update:
> 
> 	- dropped the per-cpu superblock counter cleanup patches
> 	  from it so we can get it right before merging.
> 	- added unaligned aio/dio write fix series (needs review)
> 	- added log covering idle fix (needs review)
> 	- added superblock write error hang fix (needs review)
> 
> The tree can be found here (when the rsync updates git.kernel.org):

I'll try to get to review the new patches, but can we please get the
metadata scalability patches into the xfs tree and thus linux-next ASAP?
The merge window is about to open, and we really need to get that stuff
in now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
