Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B8B907CA0
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2016 18:01:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6FF32304032
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2016 16:00:58 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id vGIafkUKVLC9vsPL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 Mar 2016 16:00:53 -0700 (PDT)
Date: Fri, 25 Mar 2016 16:00:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/16] xfs: first part of rmapbt functionality
Message-ID: <20160325230014.GA5822@birch.djwong.org>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
	<20160310141434.GA29058@infradead.org>
	<20160310214432.GX30721@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160310214432.GX30721@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Mar 11, 2016 at 08:44:32AM +1100, Dave Chinner wrote:
> On Thu, Mar 10, 2016 at 06:14:34AM -0800, Christoph Hellwig wrote:
> > On Tue, Mar 08, 2016 at 03:16:02PM +1100, Dave Chinner wrote:
> > > This isn't all of the rmap functionality. It's patches up to the
> > > point where I've come across the first piece that needs to be
> > > reworked (the rmap intent execution code), so there's no point
> > > holding these back until I've sorted that out. This builds on top of
> > > for-next and the patch set I posted yesterday.
> > > 
> > > Darrick, I've changed the authorship of the patches to reflect
> > > the original series this has come from - can you check to see if
> > > there's anything I got wrong when I did that?

Looks ok to me.

> > I'll come some minor bits on the actual patches, but I'd like to
> > understand a few fundamental things first:
> > 
> > For one Darrick has introduced a new rmapxbt btree recently, which
> > allows using a rmap on reflink enabled file systems.  In his tree
> > we thus have two different implementation of a reverse mapping
> > btree.  Is there any good reason to keep it this way?  For one
> > reflinks are a compelling feature that I doubt people want to
> > disable in the long run, so most filesystem will be using rmapxbt.
> > I also don't think having these two implementations is good for the
> > testing matrix in the long run.
> 
> I haven't got as far as the rmapxbt code yet - it's currently at the
> end of the entire series, and I'm trying to sort out problems in
> infrastructure right now (i.e. rmapbt modifications are atomic and
> crash safe w.r.t. bmapbt changes and EFI processing).
> 
> I'm planning on re-ordering the rmapxbt and interval query tree
> stuff to before the reflink code is included, but I haven't got
> hatfar yet so I haven't looked at the code yet. It's slow going, and
> right now I don't think I'm going to have even a complete rmapbt
> series done in time for the merge 4.6 merge window, let alone all
> the extra stuff Darrick has done.
> 
> So with only a couple of days left before the merge window opens, I
> think this all needs to slip to the next merge window while we sort
> out what disk format we are going to use and rework the series to
> introduce only that format.

Now that rmap has slipped to 4.7, there's no point in holding back on
the disk format changes that I wanted to make.

The interval query code makes it much easier to look for left neighbor
rmap records on a reflink filesystem.  With that piece, we can drop
the requirement that every bmbt record corresponds exactly with an
rmapbt record; we can also make use of bits 20-30 of the rm_blockcount
field, which will make the rmapbt smaller.

Doing this also enables me to rip out a large chunk of the deferred
rmap processing code (mostly patches 15-16) because everything can
turn into calling the interval query aware versions of
xfs_rmap_{alloc,free}.  At the same time I'll add rmapbt update intent
log items--Dave, I know you were working on that; please send along
whatever you have.

I've been wrangling with the problem of how to deal with refcount
btree updates that update so many records that we overflow the
transaction reservation.  Right now we simply reserve so much space
that we can (usually) pass xfstests without blowing up, but this won't
work for all cases.  One solution is to roll the transaction if we
detect that we're about to run out of reservation, but that requires
us to be able to log refcount update intents.  However, that isn't so
bad, because...

...I think there's a potential for deadlock when unmapping extents
from a file.  Let's say we want to unmap an extent in AG X whose bmbt
block is in AG (X+1).  Let's say that the bmbt unmap causes the block
to split, and the new bmbt block is in AG (X+1).  Next, we go to
remove the rmapbt record from AG X, but let's say that record removal
also causes a btree split.  In that case, the transaction will
deadlock because it has AGF (X+1) and is trying to grab AGF X, which
is a violation of the locking order rules.

In summary, I think we need to have intent log items for both rmapbt
and refcountbt changes in order to keep things atomic w.r.t. crash
recovery.  I think this solves both the deadlock problem and the
reservation overflow problems with the refcount btree.

MCI/MCD = rMap change intent/done
CCI/CCD = refCount change intent/done

So now unmapping looks like this:
unmap extent -> log MCI -> log CCI -> roll -> remove rmapbt entries ->
  -> log MCD -> roll ->
  -> update refcountbt -> log CCD -> log EFI (for btree merges) -+-> 
     ^-- log CCI for remaining <--------------- if trans full ---|
  -> roll -> free extents -> log EFD -> done unmapping

Regular mapping looks like this:
map extent -> log MCI -> roll -> add rmapbt entries -> log MCD -> roll ->
  -> log EFI (for btree merges) -> free -> log EFD -> done mapping

Reflinking looks like this:
regular unmap -> log CCI -> roll ->
  -> update refcountbt -> log CCD -> log EFI (for btree merges) -+-->
     ^-- log CCI for remaining <--------------- if trans full ---|
  -> regular map -> done reflinking

This is my rough roadmap heading towards LSF:

0) jump forward to 4.6-rc1 after merge window closes
1) drop the skinny rmapbt format
2) use interval queries for xfs_rmap_{alloc,free}
3) use MCI/MCD on freeing extents
4) shove the interval query code and all the rmap stuff before reflink
5) rework rmap to drop the "every bmbt record must have an rmap rec"
6) rework refcount to avoid exhausting transaction reservations
7) prototype btree scrubbing code (done)
8) come up with some toy xfs-scrub utility

How's that sound?  Sorry in advance for the code churn and the
inevitable gigantic patchbomb. :)

--D

> 
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
