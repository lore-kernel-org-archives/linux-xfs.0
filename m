Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B10207F4E
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 22:32:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 85D15304032
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 20:32:49 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HgoUavb7QyRTaUso for <xfs@oss.sgi.com>;
	Mon, 03 Mar 2014 20:32:47 -0800 (PST)
Date: Tue, 4 Mar 2014 15:32:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: don't leak EFSBADCRC to userspace
Message-ID: <20140304043225.GQ13647@dastard>
References: <1393825194-1719-1-git-send-email-david@fromorbit.com>
	<1393825194-1719-2-git-send-email-david@fromorbit.com>
	<20140303174425.GB28196@laptop.bfoster>
	<20140303222946.GJ13647@dastard>
	<20140304012056.GA29755@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140304012056.GA29755@laptop.bfoster>
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

On Mon, Mar 03, 2014 at 08:20:57PM -0500, Brian Foster wrote:
> On Tue, Mar 04, 2014 at 09:29:46AM +1100, Dave Chinner wrote:
> > On Mon, Mar 03, 2014 at 12:44:26PM -0500, Brian Foster wrote:
> > > On Mon, Mar 03, 2014 at 04:39:53PM +1100, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > While the verifier reoutines may return EFSBADCRC when a buffer ahs
> > > > a bad CRC, we need to translate that to EFSCORRUPTED so that the
> > > > higher layers treat the error appropriately and so we return a
> > > > consistent error to userspace. This fixes a xfs/005 regression.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > 
> > > This change looks Ok to me, but when I start looking through the users
> > > of bp->b_error, I see examples like xfs_dir3_data_read() being called in
> > > xfs_dir2_leaf_addname() where it looks like an error could bubble all
> > > the way up to xfs_vn_mknod() and its callers.
> > 
> > Sure, but:
> > 
> > xfs_dir3_data_read
> >   xfs_da_read_buf
> >     xfs_trans_read_buf_map
> > 
> > Which means the patch prevents the EFSBADCRC leaking back out
> > through that path because it converts it in xfs_trans_read_buf_map.
> > 
> 
> Ok, I see. FWIW, I was also trolling through some of the log recovery
> code and it appears that code uses b_ops for write verification purposes
> only (i.e., crc generation I suspect), correct?

Yes.

> > > If the intent is to use EFSBADCRC as an internal-only error to
> > > differentiate corruption from crc failure, why not push this more
> > > closely to the boundaries that we have already defined? For example, we
> > > already convert positive errnos to negative at the internal/external
> > > boundaries. Could we convert those to use some kind of
> > > XFS_USERSPACE_ERROR(error) macro/helper that converts errors
> > > appropriately?
> > 
> > That doesn't solve the problem needing an error conversion layer in
> > the first place. The long term goal is to remove the error
> > conversions in XFS by converting the core code to the same error
> > passing conventions as the rest of the kernel code. We manage to
> > screw the negation up fairly regularly because it is convoluted and
> > we cal into generic code that returns negative errors from the core
> > that returns positive errors in lots of places. The conversion
> > surface is just too large to manage sanely.
> > 
> 
> Well it wasn't clear that the error conversion layer was a problem that
> itself needed solving, but fair enough. ;) If the objective is to move
> away from the positive/negative business to something more "kernel
> native," then building more infrastructure around that is probably not
> the way to go, unless that was actually part of the changeover strategy
> (e.g., if we happened to use something that conditionally negated error
> values to support incremental codepath conversions... as a semi-random
> thought).

I'm not sure there's any real benefit to adding infrastructure when
doing the conversion. It's a lot of little changes involving pushing
the conversion down from the top layers, combined with converting
interfaces (e.g. bmapi) as they get exposed.

Some functions will be able to lose variables as the return becomes
a tri-state value (e.g. the btree functions for looking up records);
others will be able to use IS_ERR() for pointer returns, and so on.
This will have a flow on effect on the code in the callers, and so
it really comes down to spending the time to peel back each layer
carefully.

It's a lot of work, hence the "long term goal" aspect of it. We've
been talking about doing this cleanup for several years now, but it
hasn't yet been done because it's going to take hundreds of patches
to do... ;)

> > > Another thought could be to reconsider whether we still need some of
> > > these extra warnings, as in the xfs_mount.c hunk below, now that we have
> > > the generic xfs_verifier_error() messaging. E.g., if we could remove
> > > those, perhaps we could snub out EFSBADCRC in or around the verifier
> > > after it makes a distinction.
> > 
> > Redundant errors aren't s significant problem. It's the lack of
> > meaningful error messages that are much more of an issue. We get
> > more meaningful error messages as a result of the EFSBADCRC changes
> > that have been made, but for the moment that error simply means
> > EFSCORRUPTED to the higher layers. Hence the translation back to
> > EFSCORRUPTED at the (low) layers where the error no longer has
> > a distinct meaning.
> > 
> 
> Right, the purpose is not to solve the problem of redundant errors.
> Rather, if the only thing preventing the consolidation of the EFSBADCRC
> trap to a single hunk are redundant errors, then it wouldn't be a
> problem to remove those errors and push the EFSBADCRC trap into the
> generic code for the purpose of clarity.

I don't see much point in trying to have a single trap for EFSBADCRC
because the moment we want to handle one of those cases specially we
are going to have to - as a first step - remove the single trap and
push it outwards to all the places that need it like this patch
does....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
