Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p06I3uQx098648 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 12:03:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 667BA23ADD0
	for <xfs@oss.sgi.com>; Thu,  6 Jan 2011 10:06:06 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ZBmQblmHLJw5FwTN for
	<xfs@oss.sgi.com>; Thu, 06 Jan 2011 10:06:06 -0800 (PST)
Date: Thu, 6 Jan 2011 13:06:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: add FITRIM support
Message-ID: <20110106180603.GB32670@infradead.org>
References: <20101125112304.GA4195@infradead.org>
	<20110103232514.GF15179@dastard>
	<alpine.LFD.2.00.1101051105120.3095@dhcp-lab-213.englab.brq.redhat.com>
	<201101052307.38379@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201101052307.38379@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Christoph Hellwig <hch@infradead.org>, Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Wed, Jan 05, 2011 at 11:07:35PM +0100, Michael Monnerie wrote:
> On Mittwoch, 5. Januar 2011 Lukas Czerner wrote:
> > If we
> > notice that we are running out of space in advance (how much in
> > advance?), we can start trimming smaller chunks, until we reach
> > reasonable a reasonable pool of reclaimed space, or until we trim
> > the whole device.
> 
> Would it be possible that all blocks that have been in use since the 
> last FITRIM run can be logged?

It's a lot of overhead for the big hammer approach the FITRIM is.  If
you're interested look for some of my earlier discard support patches
as they implemented it using an rbtree.  But getting this fully right
just was a lot of overhead.  My strategy is to instead have the simple
big hammer FITRIM for e.g. people that want to reclaim storage from a
VM or thing provisioned array once in a while, while implementing an
optimized discard on commit for SSDs.  I'm planning to have the latter
ready for 2.6.39.  The biggest part to get it is to avoid allocating
extents from busy ranges, and I've finally got an older patch from Dave
to fully work for that.  The next step is to have proper asynchronous
discard requests to avoid the waiting overhead the other filesystems
have right now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
