Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:17067 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754726AbdGUXBi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 19:01:38 -0400
Date: Sat, 22 Jul 2017 09:00:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: consolidate local format inode fork verifiers
Message-ID: <20170721230058.GY17762@dastard>
References: <20170719160318.GP4224@magnolia>
 <20170720022602.GR17762@dastard>
 <20170720055057.GQ4224@magnolia>
 <20170720224934.GW17762@dastard>
 <20170721135405.GB44069@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170721135405.GB44069@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Jul 21, 2017 at 09:54:05AM -0400, Brian Foster wrote:
> On Fri, Jul 21, 2017 at 08:49:34AM +1000, Dave Chinner wrote:
> > On Wed, Jul 19, 2017 at 10:50:57PM -0700, Darrick J. Wong wrote:
> > > On Thu, Jul 20, 2017 at 12:26:02PM +1000, Dave Chinner wrote:
> > > > On Wed, Jul 19, 2017 at 09:03:18AM -0700, Darrick J. Wong wrote:
> ...
> > > <rambling off topic now>
> > > 
> > > While we're on the subject of verifiers, Eric Sandeen has been wishing
> > > that we could make it easier to figure out which buffer verifier test
> > > failed, and it would seem that the XFS_CORRUPTION_ERROR macro is used to
> > > highlight bad inode fork contents.  Perhaps we should create a similar
> > > macro that we could use to log exactly which buffer verifier test
> > > failed?
> > 
> > I don't want to put some shouty macro on every second line of a
> > verifier. Think differently - we currently return a true/false
> > from the internal verifier functions to trigger a call to
> > xfs_verifier_error(). How about they return __line__
> > on error and 0 on success and then pass that returned value into
> > xfs_verifier_error() and add that to the error output?
> > 
> > That tells us which check failed without adding more code to every
> > single verifier check - use the compiler to give us what we need
> > without any additional code, maintenance or runtime overhead.  All
> > we need to know is the kernel version so we can translate the line
> > number to a failed check...
> > 
> 
> I think the ideal situation is the verifier error prints the check that
> failed, similar to an assert failure.

Well, that comes from a macro that feeds the assert failure message
__func__ and __line__.

> I'm not aware of any way to do
> that without a macro,

I just outlined how to do it above.

> but I'm also not against crafting a new, verifier
> specific one to accomplish that. Technically, it doesn't have to be
> shouty :), but IMO, the diagnostic/usability benefit outweighs the
> aesthetic cost.

I disagree - there are so many verifier checks (and we only grow
more as time goes on) so whatever we do needs them to be
easily maintainable and not compromise the readabilty of the verifer
code.

> Beyond that, I'm not against dumping a line number but it would seem
> kind of unusual to dump a line number without at least a filename. FWIW,

We don't really need the filename because we have the name of the
verifier that failed in the ops structure. Hence we can print a
{verfier name, line number} tuple which is effectively the same as
{filename, line number}.

> the generic verifier error reporting function also dumps an instruction
> address for where the report is generated:
> 
>  XFS (...): Metadata corruption detected at xfs_symlink_read_verify+0xcd/0x100 [xfs], xfs_symlink block 0x58
>
> We obviously want to have information about which verifier failed, but
> I'm not sure we need the actual address of the xfs_verifier_error()
> caller. It would be nice if we could replace (the address, not
> necessarily the function name) that with, or add to it, an address that
> refers to the particular check that failed.

Yes, that's exactly what I'm proposing we do.  What we really need to know is

	1. the block that was corrupted (from bp)
	2. the verifier that detected the corruption (from bp)
	3. the IO type (read/write from bp)
	4. the verifier check that failed (returned from verifier)

We already have 1-3, but we don't have 4. We need to replace the
replace __return_address used in the error message with __line__ or
__THIS_IP__ that is returned from the if() branch that failed and
from that we can then easily track the cause of the failure back to
the source.

Returning __line__ or __THIS_IP__ from the verifier doesn't require
new macros, or really any significant code change as most verifiers
arelady return a true/false. All we need to do is plumb it into
xfs_verifier_error().

With that extra info we can output a slightly different message,
say:

XFS (...): Metadata corruption detected during read of block 0xx58 by xfs_symlink verifier, line 132

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
