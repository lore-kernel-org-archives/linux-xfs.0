Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43250 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755127AbdGVM3q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 22 Jul 2017 08:29:46 -0400
Date: Sat, 22 Jul 2017 08:29:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: consolidate local format inode fork verifiers
Message-ID: <20170722122944.GA4783@bfoster.bfoster>
References: <20170719160318.GP4224@magnolia>
 <20170720022602.GR17762@dastard>
 <20170720055057.GQ4224@magnolia>
 <20170720224934.GW17762@dastard>
 <20170721135405.GB44069@bfoster.bfoster>
 <20170721230058.GY17762@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170721230058.GY17762@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Sat, Jul 22, 2017 at 09:00:58AM +1000, Dave Chinner wrote:
> On Fri, Jul 21, 2017 at 09:54:05AM -0400, Brian Foster wrote:
> > On Fri, Jul 21, 2017 at 08:49:34AM +1000, Dave Chinner wrote:
> > > On Wed, Jul 19, 2017 at 10:50:57PM -0700, Darrick J. Wong wrote:
> > > > On Thu, Jul 20, 2017 at 12:26:02PM +1000, Dave Chinner wrote:
> > > > > On Wed, Jul 19, 2017 at 09:03:18AM -0700, Darrick J. Wong wrote:
> > ...
> > > > <rambling off topic now>
> > > > 
> > > > While we're on the subject of verifiers, Eric Sandeen has been wishing
> > > > that we could make it easier to figure out which buffer verifier test
> > > > failed, and it would seem that the XFS_CORRUPTION_ERROR macro is used to
> > > > highlight bad inode fork contents.  Perhaps we should create a similar
> > > > macro that we could use to log exactly which buffer verifier test
> > > > failed?
> > > 
> > > I don't want to put some shouty macro on every second line of a
> > > verifier. Think differently - we currently return a true/false
> > > from the internal verifier functions to trigger a call to
> > > xfs_verifier_error(). How about they return __line__
> > > on error and 0 on success and then pass that returned value into
> > > xfs_verifier_error() and add that to the error output?
> > > 
> > > That tells us which check failed without adding more code to every
> > > single verifier check - use the compiler to give us what we need
> > > without any additional code, maintenance or runtime overhead.  All
> > > we need to know is the kernel version so we can translate the line
> > > number to a failed check...
> > > 
> > 
> > I think the ideal situation is the verifier error prints the check that
> > failed, similar to an assert failure.
> 
> Well, that comes from a macro that feeds the assert failure message
> __func__ and __line__.
> 
> > I'm not aware of any way to do
> > that without a macro,
> 
> I just outlined how to do it above.
> 

What I mean is that assert failures (warnings, etc.) print the actual
expression that caused the report along with the file/line information.
What you've described here doesn't accomplish that.

> > but I'm also not against crafting a new, verifier
> > specific one to accomplish that. Technically, it doesn't have to be
> > shouty :), but IMO, the diagnostic/usability benefit outweighs the
> > aesthetic cost.
> 
> I disagree - there are so many verifier checks (and we only grow
> more as time goes on) so whatever we do needs them to be
> easily maintainable and not compromise the readabilty of the verifer
> code.
> 

I agree. ;) But I disagree that using a macro somehow automatically
negatively affects the readability of verifers. Anybody who can make
sense of this:

        if (!xfs_sb_version_hascrc(&mp->m_sb))
                return __line__;
        if (dsl->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
                return __line__;
        if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))
                return __line__;

... could just as easily make sense of something like this:

	xfs_verify_assert(xfs_sb_version_hascrc(&mp->m_sb));
	xfs_verify_assert(dsl->sl_magic == cpu_to_be32(XFS_SYMLINK_MAGIC));
	xfs_verify_assert(uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid));

... where xfs_verify_assert() is some macro that magically packages up
the error information for the report to userspace and affects code
execution appropriately (i.e., function exit).

The macros themselves may be ugly, but nobody concerned with the error
report needs to know anything about how the error reporting mechanism
works. Even then, there is no real complexity here IMO. This is a simple
abstraction to package up error state information. The verifiers
themselves remain just as straightforward (and may very well end up more
compact). Further, we already use these kinds of macros all over the
place today as they seem to be suited for this purpose. 

> > Beyond that, I'm not against dumping a line number but it would seem
> > kind of unusual to dump a line number without at least a filename. FWIW,
> 
> We don't really need the filename because we have the name of the
> verifier that failed in the ops structure. Hence we can print a
> {verfier name, line number} tuple which is effectively the same as
> {filename, line number}.
> 

Technically, better than nothing...

> > the generic verifier error reporting function also dumps an instruction
> > address for where the report is generated:
> > 
> >  XFS (...): Metadata corruption detected at xfs_symlink_read_verify+0xcd/0x100 [xfs], xfs_symlink block 0x58
> >
> > We obviously want to have information about which verifier failed, but
> > I'm not sure we need the actual address of the xfs_verifier_error()
> > caller. It would be nice if we could replace (the address, not
> > necessarily the function name) that with, or add to it, an address that
> > refers to the particular check that failed.
> 
> Yes, that's exactly what I'm proposing we do.  What we really need to know is
> 
> 	1. the block that was corrupted (from bp)
> 	2. the verifier that detected the corruption (from bp)
> 	3. the IO type (read/write from bp)
> 	4. the verifier check that failed (returned from verifier)
> 
> We already have 1-3, but we don't have 4. We need to replace the
> replace __return_address used in the error message with __line__ or
> __THIS_IP__ that is returned from the if() branch that failed and
> from that we can then easily track the cause of the failure back to
> the source.
> 
> Returning __line__ or __THIS_IP__ from the verifier doesn't require
> new macros, or really any significant code change as most verifiers
> arelady return a true/false. All we need to do is plumb it into
> xfs_verifier_error().
> 
> With that extra info we can output a slightly different message,
> say:
> 
> XFS (...): Metadata corruption detected during read of block 0xx58 by xfs_symlink verifier, line 132
> 

It sounds to me you're more preoccupied with making a particular code
change here than focusing on what the ideal error report should look
like, and then figuring out the best way to implement it. The above is
incrementally more useful than the original, but still not sufficiently
usable IMO.

Consider the case where a bug report includes a logfile with tens of
(unique) such corruption errors. Nobody wants to go fishing through
verifier callchains to validate that the file of the specific failure
matches the top-level verifier function and then subsequently that the
reported line is sane with respect to the failure ("Oh, did that
verifier call any other functions in separate files with line numbers
that I have to rule out? Let me double check.." "Oh you're on for-next?
I hope my for-next line numbers match up.." "If they don't, hopefully
it's a severe enough mismatch not to point to another test in the same
function." :/). Compound that further with cases where reports may
involve sosreports across 5 or 6 different physical nodes, all with
similar corruption reports (and maybe even running slightly different
kernels, perhaps some with test patches that render all previous line
numbers invalid, etc.) and this all becomes rather painful.

There is a simple solution to this problem: just include all of the
readily accessible state information in the error report. If the
messages above looked something like the following:

  XFS (...): Metadata corruption detected at xfs_symlink_read_verify [xfs], xfs_symlink block 0x58
  XFS (...): Read verifier failed: xfs_log_check_lsn(mp, be64_to_cpu(dsl->sl_lsn)), xfs_symlink_remote.c:114

... we wouldn't have to decode what the error means for every possible
kernel. The error report is self contained like most of the other
errors/assert reports in XFS and throughout the kernel.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
