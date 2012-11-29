Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qATKUYW4081428 for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 14:30:34 -0600
Date: Thu, 29 Nov 2012 14:32:50 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/4] xfs: fix sparse reported log CRC endian issue
Message-ID: <20121129203250.GI27055@sgi.com>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
	<1354068063-1692-5-git-send-email-david@fromorbit.com>
	<20121128133059.GC2765@infradead.org>
	<20121128213110.GV6434@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121128213110.GV6434@dastard>
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
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 29, 2012 at 08:31:10AM +1100, Dave Chinner wrote:
> On Wed, Nov 28, 2012 at 08:30:59AM -0500, Christoph Hellwig wrote:
> > On Wed, Nov 28, 2012 at 01:01:03PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Not a bug as such, just warning noise from the xlog_cksum()
> > > returning a __be32 type when it shoul dbe returning a __le32 type.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > The patch look okay.
> > 
> > But why are we storing the crc field little endian while all other on
> > disk formats are big endian? (And yes I realize it might as well have
> > been me who did that back in the idea, but I still have no idea why)
> 
> Because the CRC always returns the calcuation LE format, even on BE
> systems. So rather than always having to byte swap it everywhere and
> have all the force casts and anootations for sparse, it seems
> simpler to just make it a __le32 everywhere....

This seems reasonable to me, and the patch looks fine.  Christoph, do have any
further objection?

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
