Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3ELHH8J100466 for <xfs@oss.sgi.com>; Wed, 14 Apr 2010 16:17:17 -0500
Subject: Re: [PATCHv2 9/10] xfs: a few more minor xfs_log_recover.c cleanups
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100412071131.GK2493@dastard>
References: <1270852266.7840.159.camel@doink> <20100412071131.GK2493@dastard>
Date: Wed, 14 Apr 2010 16:19:12 -0500
Message-ID: <1271279952.3559.81.camel@doink>
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
Cc: xfs@oss.sgi.com

On Mon, 2010-04-12 at 17:11 +1000, Dave Chinner wrote:
> On Fri, Apr 09, 2010 at 05:31:06PM -0500, Alex Elder wrote:
> > Minor things that didn't seem to warrant their own individual
> > patches:
> > - In xlog_bread_noalign(), reorder assertions so the buffer pointer
> >   is known to be non-null before attempting to dereference it.
> 
> That's OK, but if you are debugging then it'll be obvious what
> happend by it being a null ptr dereference rather than an assert
> failure. Hence if anything I'd just kill the ASSERT(bp)....

I personally prefer proactively asserting it rather than
just deducing it was a null pointer from the wreckage.  But
whatever, we disagree and I'm OK with dropping the assert.

> > - Add a more descriptive header comment for xlog_find_verify_cycle().
> 
> It just describes what the code does - I don't think it make the
> code any clearer and makes it more likely that if we ever change the
> code the comment will then be wrong...

I still think the existing comments are confusing.  What do you
think of this instead:

/*
 * Check that the range of blocks does not contain stop_on_cycle_no.
 * Fill in *new_blk with the block offset where such block is found,
 * or with -1 (an invalid block number) if there is no such block in
 * the range.  The scan needs to occur from front to back and the
 * pointer into the region must be updated since a later routine will
 * need to perform another test.  
 */

> > - Make a few additions to the comments in xlog_find_head().  Also
> >   rearrange some expressions in a few spots to produce the same
> >   result, but in a way that seems more clear what's being computed.
> 
> I'd say this is probably the only bits of the patch that add value.
> Can you split this one out by itself?

I will re-post a v3 on this and the others I've responded to
today, just so we're all clear on what's being accepted.  I
will break this patch into two pieces, allowing for this last
bit to be considered separate from the rest.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
