Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 59C447F63
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 16:13:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CEA81AC001
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 14:13:11 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	JEQ3w9hf3QPPyGhi for <xfs@oss.sgi.com>;
	Wed, 24 Jun 2015 14:13:09 -0700 (PDT)
Date: Thu, 25 Jun 2015 07:13:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/20] xfs: add owner field to extent allocation and
	freeing
Message-ID: <20150624211306.GI22807@dastard>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
	<1433311497-10245-9-git-send-email-david@fromorbit.com>
	<20150624190918.GA3604@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150624190918.GA3604@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 24, 2015 at 03:09:19PM -0400, Brian Foster wrote:
> On Wed, Jun 03, 2015 at 04:04:45PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > For the rmap btree to work, we have to fed the extent owner
> > information to the the allocation and freeing functions. This
> > information is what will end up in the rmap btree that tracks
> > allocated extents. While we technically don't need the owner
> > information when freeing extents, passing it allows us to validate
> > that the extent we are removing from the rmap btree actually
> > belonged to the owner we expected it to belong to.
> > 
> > We also define a special set of owner values for internal metadata
> > that would otherwise have no owner. This allows us to tell the
> > difference between metadata owned by different per-ag btrees, as
> > well as static fs metadata (e.g. AG headers) and internal journal
> > blocks.
> > 
> > There are also a couple of special cases we need to take care of -
> > during EFI recovery, we don't actually know who the original owner
> > was, so we need to pass a wildcard to indicate that we aren't
> > checking the owner for validity. We also need special handling in
> > growfs, as we "free" the space in the last AG when extending it, but
> > because it's new space it has no actual owner...
> > 
> 
> Any reason not to support passing the owner through the efi/efd log
> structures? You've already plumbed it through the bmap_free struct. I
> suppose that could make this a backwards incompatible feature rather
> than read-only incompatible, though.

That's an interesting idea that I didn't really consider.

I'll have a think about it, along with a couple of other suggestions
from Darrick (e.g. increasing the rmap record size and keeping
owner-related location information (file offset) in it) as that will
also impact on any changes to EFI/EFD structure.

As for ro compat vs incompat, an EFI/EFD change would be a log
incompat flag, so only be relevant if the log is dirty at mount
time. Hence if the log was clean then the ro-compat flag would be
used, and so a change of EFI/EFD format isn't a huge deal...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
