Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9B8677F6C
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 08:03:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8AA8E8F8050
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 06:03:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NBsQSiE5gXsEUWJy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 06:03:32 -0700 (PDT)
Date: Thu, 25 Jun 2015 09:03:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/20] xfs: add owner field to extent allocation and
	freeing
Message-ID: <20150625130330.GB36162@bfoster.bfoster>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
	<1433311497-10245-9-git-send-email-david@fromorbit.com>
	<20150624190918.GA3604@bfoster.bfoster>
	<20150624211306.GI22807@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150624211306.GI22807@dastard>
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
Cc: xfs@oss.sgi.com

On Thu, Jun 25, 2015 at 07:13:06AM +1000, Dave Chinner wrote:
> On Wed, Jun 24, 2015 at 03:09:19PM -0400, Brian Foster wrote:
> > On Wed, Jun 03, 2015 at 04:04:45PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > For the rmap btree to work, we have to fed the extent owner
> > > information to the the allocation and freeing functions. This
> > > information is what will end up in the rmap btree that tracks
> > > allocated extents. While we technically don't need the owner
> > > information when freeing extents, passing it allows us to validate
> > > that the extent we are removing from the rmap btree actually
> > > belonged to the owner we expected it to belong to.
> > > 
> > > We also define a special set of owner values for internal metadata
> > > that would otherwise have no owner. This allows us to tell the
> > > difference between metadata owned by different per-ag btrees, as
> > > well as static fs metadata (e.g. AG headers) and internal journal
> > > blocks.
> > > 
> > > There are also a couple of special cases we need to take care of -
> > > during EFI recovery, we don't actually know who the original owner
> > > was, so we need to pass a wildcard to indicate that we aren't
> > > checking the owner for validity. We also need special handling in
> > > growfs, as we "free" the space in the last AG when extending it, but
> > > because it's new space it has no actual owner...
> > > 
> > 
> > Any reason not to support passing the owner through the efi/efd log
> > structures? You've already plumbed it through the bmap_free struct. I
> > suppose that could make this a backwards incompatible feature rather
> > than read-only incompatible, though.
> 
> That's an interesting idea that I didn't really consider.
> 
> I'll have a think about it, along with a couple of other suggestions
> from Darrick (e.g. increasing the rmap record size and keeping
> owner-related location information (file offset) in it) as that will
> also impact on any changes to EFI/EFD structure.
> 

Ok.. it's not really a problem, it just seems like a gap given that this
work presumably pushes the owner through the rest of the extent free
path for verification purposes. I think it would be a bit of a shame to
do that work and not have the same verification in the event of a crash,
assuming it can be done relatively cleanly.

> As for ro compat vs incompat, an EFI/EFD change would be a log
> incompat flag, so only be relevant if the log is dirty at mount
> time. Hence if the log was clean then the ro-compat flag would be
> used, and so a change of EFI/EFD format isn't a huge deal...
> 

That makes sense. Hmm, I have yet to get through the rest of this series
so I'm not sure whether extent free results in any rmapbt modifications,
but if so, wouldn't we need that log incompat. flag anyways? Even if the
EFI/EFD doesn't change, how can we allow an older kernel to recover
extent free transactions if they don't know how to update the rmapbt
appropriately?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
