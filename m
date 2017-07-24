Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35803 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932070AbdGXSpG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2017 14:45:06 -0400
Date: Mon, 24 Jul 2017 11:44:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: consolidate local format inode fork verifiers
Message-ID: <20170724184456.GD4352@magnolia>
References: <20170719160318.GP4224@magnolia>
 <20170720022602.GR17762@dastard>
 <20170720055057.GQ4224@magnolia>
 <20170720224934.GW17762@dastard>
 <20170721135405.GB44069@bfoster.bfoster>
 <20170721230058.GY17762@dastard>
 <20170722122944.GA4783@bfoster.bfoster>
 <20170724052638.GD17762@dastard>
 <20170724130752.GA11537@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170724130752.GA11537@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 24, 2017 at 09:07:52AM -0400, Brian Foster wrote:
> On Mon, Jul 24, 2017 at 03:26:38PM +1000, Dave Chinner wrote:
> > On Sat, Jul 22, 2017 at 08:29:44AM -0400, Brian Foster wrote:
> > > On Sat, Jul 22, 2017 at 09:00:58AM +1000, Dave Chinner wrote:
> > > > On Fri, Jul 21, 2017 at 09:54:05AM -0400, Brian Foster wrote:
> > > > > On Fri, Jul 21, 2017 at 08:49:34AM +1000, Dave Chinner wrote:
> > > > > but I'm also not against crafting a new, verifier
> > > > > specific one to accomplish that. Technically, it doesn't have to be
> > > > > shouty :), but IMO, the diagnostic/usability benefit outweighs the
> > > > > aesthetic cost.
> > > > 
> > > > I disagree - there are so many verifier checks (and we only grow
> > > > more as time goes on) so whatever we do needs them to be
> > > > easily maintainable and not compromise the readabilty of the verifer
> > > > code.
> > > > 
> > > 
> > > I agree. ;) But I disagree that using a macro somehow automatically
> > > negatively affects the readability of verifers. Anybody who can make
> > > sense of this:
> > > 
> > >         if (!xfs_sb_version_hascrc(&mp->m_sb))
> > >                 return __line__;
> > >         if (dsl->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
> > >                 return __line__;
> > >         if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))
> > >                 return __line__;
> > > 
> > > ... could just as easily make sense of something like this:
> > > 
> > > 	xfs_verify_assert(xfs_sb_version_hascrc(&mp->m_sb));
> > > 	xfs_verify_assert(dsl->sl_magic == cpu_to_be32(XFS_SYMLINK_MAGIC));
> > > 	xfs_verify_assert(uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid));
> > 
> > Still needs branches to return on error so the verifier code
> > functions correctly. So it simply isn't as clean as your example
> > suggests. And, no hiding goto/return/errno variables inside a macro
> > is not an option - that makes for horrible code and we should not
> > repeat those past mistakes we inherited from the old Irix
> > codebase.
> > 
> 
> Clearly the example implies (and the supporting text explains) that the
> macro would lead to function exit.

It does?  Every time I see an *assert() I assume that execution either
continues past it or stops dead in its tracks.  The _GOTO macros make
that clear by pairing the word goto with a label, though I concede that
it feels odd to pass a label as an argument.

> I don't really see the problem with doing that. Again, we already do
> that all over the place. If we don't want to alter function execution
> via the macro, then have it return an expression that resolves to
> false (or an error code or some such) and leave the function execution
> logic in function context. It doesn't really matter to me either way.

I get that hiding branches inside macros makes it too easy for later
readers to be mislead, but if there's one aspect of them that I /do/
like, its that (provided the naming makes it clear that we're branching
somewhere) we /can/ use them to ensure that the return values are
consistent and avoid screwing up repetitive if tests.

Anyway, I was picturing something like this:

#define XFS_VERIFY_FAIL_UNLESS(expr) do { if (expr) return _THIS_IP_; } while(0)

static unsigned long
xfs_blah_verify(...)
{
	XFS_VERIFY_FAIL_UNLESS(blah1 == GOOD1);
	XFS_VERIFY_FAIL_UNLESS(blah2 == GOOD2);
	XFS_VERIFY_FAIL_UNLESS(blah3 == GOOD3);
	...
	return 0;
}

Granted, with code review to spot inconsistencies maybe the macro really
is pointless, and we can just open-code everything.  I dunno.  To be
honest I actually do prefer the macro in this particular case.

static unsigned long
xfs_blah_verify(...)
{
	if (!(blah1 == GOOD1))
		return _THIS_IP_;
	if (!(blah2 == GOOD2))
		return _THIS_IP_;
	if (!(blah3 == GOOD3))
		return _THIS_IP_;
	...
	return 0;
}

static void
xfs_blah_read_verify(bp)
{
	struct xfs_mount	*mp = bp->b_target->bt_mount;
	unsigned long		x;

	if (xfs_sb_version_hascrc(&mp->m_sb) &&
	    !xfs_buf_verify_cksum(bp, XFS_BLAH_CRC_OFF))
		xfs_buf_ioerror(bp, -EFSBADCRC);
	x = xfs_blah_verify(mp, bp);
	if (x) {
		xfs_err(mp, "Read verifier failed on daddr %llu at %pF within %s",
				bp->b_bn, x, __func__);
		xfs_buf_ioerror(bp, -EFSCORRUPTED);
	}

	if (bp->b_error)
		xfs_verifier_error(bp);

}

> > And we need to be really careful here - making the code more complex
> > for pretty errors blows out the size of the code. That means it runs
> > slower, even though we never execute most of the pretty error print
> > stuff.  This is an important consideration as verifiers are a
> > performance critical fast path, both in the kernel and in userspace.

Fair enough.  Adding more stuff to facilitate prettyprinting could
indeed bloat the size of the verifiers, but let's convert one of the
verifiers and compare before and after numbers.

> I guess we'd increase the size of the code for strings that represent
> the associated checks and whatever extra the macro code may end up
> duplicating. Once an error is detected, I think much of the latter could
> be packaged into a noinline helper. It's not immediately clear to me
> what we're looking at for a size increase, so I don't think "blows out"
> is a fair characterization without some actual data [1]. I do think this
> is a fair/valid concern however, we'd just need to try and experiment
> and see how much it costs to convert over a verifier or two, for
> example.
> 
> And I'm not sure how you make the leap from there to an automatic
> performance degradation. I also agree that the verifiers are performance
> critical and wouldn't suggest taking an approach if I thought we'd
> measurably affect performance. As it is, I'd expect that additional
> overhead of storing error context (hell, we could always just dump it
> from where the problem was originally detected rather than pass it to
> the generic verifier report function) would essentially be nil up until
> a verification check fails.

I don't think there's much difference in the generated code between
opencoded verifier tests and a macro that more or less does the same
thing but also helps us to avoid copy-pasta mistakes.  TBH I'm more
worried about us making a mistake in the verifiers that screw up what we
accept coming from / allow to be written to disk than I am about the
exact size of each verifier function.

That said, I've warmed to Dave's idea of passing back _THIS_IP_ as a
compromise between __line__ (not quite enough info) and throwing
(#fs_ok, __func__, __line__) back to callers.

> Would you consider such an approach if we could demonstrate a reasonable
> code size tradeoff and that runtime performance is not affected? If you
> simply hate macros then I guess there isn't much we can do but agree to
> disagree (and I'm not against a non-macro approach if one exists, I just
> don't know what it would be). But otherwise I wouldn't mind running some
> experiments (unless Darrick wanted to..? he brought this up after all..
> :P) if the results will be fairly considered.

So.... the online scrub code actually /does/ stringify every single
metadata object field check so that it can record exactly which check
failed in the ftrace output.  Given that online scrub has less stringent
performance requirements and does expensive cross referencing with other
metadata, one could argue that for scrub the code/performance tradeoff
is acceptable.

I just built a 4.13-rc2 kernel with the scrub/repair patches, and then
summed up the section sizes of the resulting .o files:

note 0
bss 1
comment 1007
mcount 1568
jump 1584
rodata 23503
data 23815
text 130569
debug 3318092

Most of rodata seems to be the stringified text that we save, and rodata
seems to constitute ~18% of the built module size.  If I modify the code
not to stringify anything, the sizes become:

note 0
bss 1
comment 1007
mcount 1568
jump 1584
rodata 6657
data 6969
text 130347
debug 3318092

Now the rodata section is only ~5% of the module size.  I conclude that
there is a definite cost to stringifying things, though I'm actually
surprised that it's only 17KB.

> > > There is a simple solution to this problem: just include all of
> > > the
> > > readily accessible state information in the error report. If the
> > > messages above looked something like the following:
> > > 
> > >   XFS (...): Metadata corruption detected at xfs_symlink_read_verify [xfs], xfs_symlink block 0x58
> > >   XFS (...): Read verifier failed: xfs_log_check_lsn(mp, be64_to_cpu(dsl->sl_lsn)), xfs_symlink_remote.c:114
> > >
> > > ... we wouldn't have to decode what the error means for every possible
> > > kernel. The error report is self contained like most of the other
> > > errors/assert reports in XFS and throughout the kernel.
> > 
> > Just like an assert/warning, we've still got to go match it to the
> > exact kernel source tree to determine the context in which the
> > message was emitted and what it actually means.  Making it pretty
> > doesn't change the amount of work a developer needs to do to
> > classify or analyse errors in log files, all it does is change the
> > amount of overhead needed to generate the error message,
> > 
> 
> Yes, you're still going to want to ultimately dig down into the code and
> do complex root cause analysis. Unfortunately, we can't fix that with
> error reporting. :) I've laid out several situations above as to why I
> think the "pretty" format makes it significantly easier to make sense of
> corruption reports that may be more involved than a single instance or a
> single physical node. A broad assessment can be made from the actual
> corruption report without the need to decode tens or more cryptic
> messages. It potentially saves significant time spent doing unnecessary
> busy work. It also helps reduce unnecessary confusion with general
> reports that might arise from users on distro kernels, etc., where the
> line numbers might not be sufficient or easily misaligned.

Admittedly, bloating up the scrub module with stringified stuff has made
it way quicker for me to figure out what got flagged as a failure and
then decide if the check I wrote is incorrect or if we really did find
something broken.  One more upside to the macro is that we could easily
make each verifier test spit out more information if CONFIG_XFS_DEBUG is
set.  This won't help us with customers encountering production
problems, obviously, but I think there's still value.

> Of course, once we get into debugging an actual problem, we've kind of
> moved outside the scope of this discussion...
> 
> > Really, verifiers are performance critical fast paths, so the code
> > that runs inside them needs to be implemented with this in mind. I'm
> > not against making messages pretty, but let's not do it based on the
> > on the premise that pretty error messages are more important than
> > runtime performance when there are no errors...
> > 
> 
> I agree. As noted above, I would not expect any more overhead than the
> original suggestion to return a line number in the normal runtime case.
> The difference is primarily what we do in the code between when a
> verifier check fails and we report the failure.
> 
> FWIW, an approach that might be a reasonable compromise is to use the
> original suggestion to pass along the line number, but also wrap each
> verifier check in a thinner macro that simply asserts[2] on the verifier
> expression. The new macro could be ifdef'd out completely in production
> builds to eliminate code size concerns. Then if we have reports with
> significant enough corruption issues to warrant it, we collect a
> metadump and use any local debug kernel to access the fs and decode the
> errors for us (or ask the user to run a debug kernel). We can expand the
> verifier macro in the future with production build support if warranted.
> Thoughts?

<shrug> _THIS_IP_ ?

(Sorry for starting to sound like a broken record...)

> Brian
> 
> [1] A simple test that we can do at the moment is to compare a
> production xfs.ko with one with asserts enabled. My local for-next
> branch builds a module of 40104000 bytes without XFS_WARN and 40540208
> bytes with XFS_WARN enabled. That makes for a difference of ~425k and
> roughly a 1% code size increase (accounting for ~1750 asserts and
> supporting code).
> 
> [2] We may not want to use ASSERT() here, but perhaps define a new
> variant to omit the stack trace and otherwise customize to a verifier
> report.

Speaking of ASSERTs, I was going to propose removing the ASSERT calls
from the XFS_WANT_CORRUPTED_* macros since they're used in some of the
directory verifiers and we shouldn't really BUG_ON corrupted disk
contents.  An XFS_ERROR_REPORT follows soon after the ASSERT, so imho I
think we could get by with only one round of complaining.

--D

> 
> > Cheers,
> > 
> > Dave.
> > 
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
