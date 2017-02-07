Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754007AbdBGNha (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Feb 2017 08:37:30 -0500
Date: Tue, 7 Feb 2017 08:37:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: split indlen reservations fairly when under
 reserved
Message-ID: <20170207133729.GB7512@bfoster.bfoster>
References: <1486146865-47286-1-git-send-email-bfoster@redhat.com>
 <1486146865-47286-3-git-send-email-bfoster@redhat.com>
 <20170203220208.GB3580@birch.djwong.org>
 <20170206153432.GD57865@bfoster.bfoster>
 <20170207014130.GD12378@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170207014130.GD12378@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Patrick Dung <mpatdung@gmail.com>

On Mon, Feb 06, 2017 at 05:41:30PM -0800, Darrick J. Wong wrote:
> On Mon, Feb 06, 2017 at 10:34:32AM -0500, Brian Foster wrote:
> > On Fri, Feb 03, 2017 at 02:02:08PM -0800, Darrick J. Wong wrote:
> > > On Fri, Feb 03, 2017 at 01:34:25PM -0500, Brian Foster wrote:
> > > > Certain workoads that punch holes into speculative preallocation can
> > > > cause delalloc indirect reservation splits when the delalloc extent is
> > > > split in two. If further splits occur, an already short-handed extent
> > > > can be split into two in a manner that leaves zero indirect blocks for
> > > > one of the two new extents. This occurs because the shortage is large
> > > > enough that the xfs_bmap_split_indlen() algorithm completely drains the
> > > > requested indlen of one of the extents before it honors the existing
> > > > reservation.
> > > 
> > > This looks ok from a "try to avoid the superbadness of ending up with
> > > zero indlen blocks" point of view, but I've been wondering -- how does
> > > punching holes in da reservations result in the reservations being
> > > shorthanded?
> > > 
> > > Is the situation here something like: we create a reservation with
> > > indlen=14 blocks, punch a one-block hole, and now we have two
> > > reservations each wanting indlen=8 so now we're under-reserved?
> > > 
> > 
> > Yeah, basically. xfstests test generic/033 historically was intended to
> > stress this mechanism. Since then, most of the situations that induce
> > this behavior from normal userspace activity have been mitigated by
> > pagecache flush. Doing so before hole punch, for example, converts the
> > extent and consumes/releases the indlen as necessary before the hole
> > punch actually takes place.
> > 
> > > If so, is there a way to fix that?
> > > 
> > 
> > There are probably varying approaches here. Off the top of my head, we
> > could allocate more blocks up front, perhaps try to replenish under
> > reservations dynamically (which the code currently does, albeit
> > accidentally and with risk of not handling allocation failure).
> > 
> > My reasoning for taking this approach is as follows:
> > 
> > - While we've seen the assert/warning issues calling out the situation
> >   of not having indlen blocks, I've yet to see (that I recall :P) a
> >   report of this actually becoming a problem at extent conversion time.
> > - The current ability to reproduce this kind of problem has already been
> >   reduced from hole punches and whatnot to strange interactions with
> >   preallocation.
> > 
> > I'm open to other options, but given the above, I'm hesitant to add more
> > code/complexity for something that as of yet hasn't manifested as a
> > critical problem. The intent was to tweak the existing mechanism to be a
> > bit more fair, though I had to change the code more than I originally
> > wanted to to accomplish that.
> 
> Heh, this does seem like a hard call to make.  If the under-reservation
> ever becomes a problem for extent conversion, will it at least fail
> loudly so we'll know to come back to this?
> 

Good question. :P I think it's not so good if we start inserting extents
without block reservation to allocate bmbt blocks, but tbh I've not dug
down into that failure scenario to say for sure. Since it is an indirect
allocation, it wouldn't surprise me a ton if it did turn out to be a
similar kind of subtle allocation counter inconsistency since in most
cases we will have reservation _somewhere_ to ensure a block can be
allocated. Not great, but not the end of the world either...

> /me suspects it'd be easiest to allocate more up front (I've been
> wondering if this is some sort of rounding mistake?) since adjusting
> after the fact seems problematic.
> 

Yeah. The thought crossed my mind, I just ultimately didn't think it was
worth it to alter normal functional behavior for something that right
now is a corner case.

The reservation is already a "worst case." As it is, "under reservation"
means less than worst case as opposed to imminent catastrophic
destruction. :P

> > > > This ultimately results in a warning from xfs_bmap_del_extent(). This
> > > > has been observed during file copies of large, sparse files using 'cp
> > > > --sparse=always.'
> > > 
> > > Is there a test case to reproduce this?  I ran this patch through the
> > > auto group with no ill effects but I've never seen that assert trigger
> > > while running xfstests so it's harder to tell that the fix is actually
> > > working.
> > > 
> > 
> > I've only been able to reproduce with Patrick's image file. generic/033
> > tests the hole punch workload, but as noted above, that has been
> > mitigated through other means and won't create this situation. Perhaps
> > generic/033 with a hacked up kernel to bypass the cache flush might
> > reproduce this condition..
> > 
> > Actually, looking back.. I see we added a write failure mechanism to XFS
> > in commit 801cc4e1 ("xfs: debug mode forced buffered write failure")
> > that was designed to maintain the ability to test this. I also have an
> > xfstests patch in my tree that updates generic/033 to use said
> > mechanism. It was originally posted for reference along with the kernel
> > patch, but appears to have been dropped on the floor since then.
> > 
> > It looks like the write failure mechanism has since been lobotomized,
> > probably by the iomap rework. I'll try to resurrect that and the test
> > update and see if it helps reproduce this particular problem.
> 
> Ok, thanks.
> 
> > > > To avoid this problem, update xfs_bmap_split_indlen() to explicitly
> > > > apply the reservation shortage fairly between both extents. This smooths
> > > > out the overall indlen shortage and defers the situation where we end up
> > > > with a delalloc extent with zero indlen reservation to extreme
> > > > circumstances.
> > > 
> > > Could you elaborate on what are 'extreme circumstances' here?
> > > 
> > 
> > "Rare circumstances" might be better phrasing here. I _think_ that with
> > a moderately improved algorithm, it can be made notably more difficult
> > to reproduce this condition via interactions with preallocation or
> > anything else that qualifies as a "common" workload. As noted above, it
> > looks like we had to resort to error injection in the past to
> > sufficiently test this..
> 
> Yes.  Right now I'm struggling between (a) are we today close enough to
> solving that problem completely that I ought to hold out for a better
> solution for 4.11? or (b) it's a rare condition, we'll fail noisily if
> it ever does totally fall apart, so let's just throw it on the fire, try
> to fix it for reals in 4.12, and hope that anyone who manages to hit it
> will complain?  Though, you're most familiar with this, so I think your
> opinion carries more weight. :)
> 
> For now I'll pull in the two patches for 4.11 testing.
> 

Thanks. As alluded to above, I still don't think it's worth much further
investigation atm unless this does turn into a larger problem that is
not fully/correctly addressed by these non-architectural enhancements.
In my mind, redesigning this mechanism right now in a manner that adds
complexity just introduces more risk for normal filesystem behavior for
little benefit.

If new problems arise that justify the risk or we find some approach
that really simplifies the whole thing (maybe pulling indirect blocks up
into the xfs_inode or something to avoid all the extent split/merge
logic entirely), then I suppose that's another story..

Brian

> --D
> 
> > 
> > Brian
> > 
> > > (FWIW I'm not opposed to the two patches, but my curiosity isn't yet
> > > satisfied.)
> > > 
> > > --D
> > > 
> > > > Reported-by: Patrick Dung <mpatdung@gmail.com>
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_bmap.c | 58 +++++++++++++++++++++++++++++++++---------------
> > > >  1 file changed, 40 insertions(+), 18 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > > index d2e48ed..4ca4606 100644
> > > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > > @@ -4790,34 +4790,56 @@ xfs_bmap_split_indlen(
> > > >  	xfs_filblks_t			len2 = *indlen2;
> > > >  	xfs_filblks_t			nres = len1 + len2; /* new total res. */
> > > >  	xfs_filblks_t			stolen = 0;
> > > > +	xfs_filblks_t			resfactor;
> > > >  
> > > >  	/*
> > > >  	 * Steal as many blocks as we can to try and satisfy the worst case
> > > >  	 * indlen for both new extents.
> > > >  	 */
> > > > -	while (nres > ores && avail) {
> > > > -		nres--;
> > > > -		avail--;
> > > > -		stolen++;
> > > > -	}
> > > > +	if (ores < nres && avail)
> > > > +		stolen = XFS_FILBLKS_MIN(nres - ores, avail);
> > > > +	ores += stolen;
> > > > +
> > > > +	 /* nothing else to do if we've satisfied the new reservation */
> > > > +	if (ores >= nres)
> > > > +		return stolen;
> > > > +
> > > > +	/*
> > > > +	 * We can't meet the total required reservation for the two extents.
> > > > +	 * Calculate the percent of the overall shortage between both extents
> > > > +	 * and apply this percentage to each of the requested indlen values.
> > > > +	 * This distributes the shortage fairly and reduces the chances that one
> > > > +	 * of the two extents is left with nothing when extents are repeatedly
> > > > +	 * split.
> > > > +	 */
> > > > +	resfactor = (ores * 100) / nres;
> > > > +	len1 = resfactor * len1 / 100;
> > > > +	len2 = resfactor * len2 / 100;
> > > > +	ASSERT(len1 + len2 <= ores);
> > > > +	ASSERT(len1 < *indlen1 && len2 < *indlen2);
> > > >  
> > > >  	/*
> > > > -	 * The only blocks available are those reserved for the original
> > > > -	 * extent and what we can steal from the extent being removed.
> > > > -	 * If this still isn't enough to satisfy the combined
> > > > -	 * requirements for the two new extents, skim blocks off of each
> > > > -	 * of the new reservations until they match what is available.
> > > > +	 * Hand out the remainder to each extent. If one of the two reservations
> > > > +	 * is zero, we want to make sure that one gets a block first. The loop
> > > > +	 * below starts with len1, so hand len2 a block right off the bat if it
> > > > +	 * is zero.
> > > >  	 */
> > > > -	while (nres > ores) {
> > > > -		if (len1) {
> > > > -			len1--;
> > > > -			nres--;
> > > > +	ores -= (len1 + len2);
> > > > +	ASSERT((*indlen1 - len1) + (*indlen2 - len2) >= ores);
> > > > +	if (ores && !len2 && *indlen2) {
> > > > +		len2++;
> > > > +		ores--;
> > > > +	}
> > > > +	while (ores) {
> > > > +		if (len1 < *indlen1) {
> > > > +			len1++;
> > > > +			ores--;
> > > >  		}
> > > > -		if (nres == ores)
> > > > +		if (!ores)
> > > >  			break;
> > > > -		if (len2) {
> > > > -			len2--;
> > > > -			nres--;
> > > > +		if (len2 < *indlen2) {
> > > > +			len2++;
> > > > +			ores--;
> > > >  		}
> > > >  	}
> > > >  
> > > > -- 
> > > > 2.7.4
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
