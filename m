Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1250 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750762AbdGUNyH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Jul 2017 09:54:07 -0400
Date: Fri, 21 Jul 2017 09:54:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: consolidate local format inode fork verifiers
Message-ID: <20170721135405.GB44069@bfoster.bfoster>
References: <20170719160318.GP4224@magnolia>
 <20170720022602.GR17762@dastard>
 <20170720055057.GQ4224@magnolia>
 <20170720224934.GW17762@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170720224934.GW17762@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Jul 21, 2017 at 08:49:34AM +1000, Dave Chinner wrote:
> On Wed, Jul 19, 2017 at 10:50:57PM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 20, 2017 at 12:26:02PM +1000, Dave Chinner wrote:
> > > On Wed, Jul 19, 2017 at 09:03:18AM -0700, Darrick J. Wong wrote:
...
> > <rambling off topic now>
> > 
> > While we're on the subject of verifiers, Eric Sandeen has been wishing
> > that we could make it easier to figure out which buffer verifier test
> > failed, and it would seem that the XFS_CORRUPTION_ERROR macro is used to
> > highlight bad inode fork contents.  Perhaps we should create a similar
> > macro that we could use to log exactly which buffer verifier test
> > failed?
> 
> I don't want to put some shouty macro on every second line of a
> verifier. Think differently - we currently return a true/false
> from the internal verifier functions to trigger a call to
> xfs_verifier_error(). How about they return __line__
> on error and 0 on success and then pass that returned value into
> xfs_verifier_error() and add that to the error output?
> 
> That tells us which check failed without adding more code to every
> single verifier check - use the compiler to give us what we need
> without any additional code, maintenance or runtime overhead.  All
> we need to know is the kernel version so we can translate the line
> number to a failed check...
> 

I think the ideal situation is the verifier error prints the check that
failed, similar to an assert failure. I'm not aware of any way to do
that without a macro, but I'm also not against crafting a new, verifier
specific one to accomplish that. Technically, it doesn't have to be
shouty :), but IMO, the diagnostic/usability benefit outweighs the
aesthetic cost.

Beyond that, I'm not against dumping a line number but it would seem
kind of unusual to dump a line number without at least a filename. FWIW,
the generic verifier error reporting function also dumps an instruction
address for where the report is generated:

 XFS (...): Metadata corruption detected at xfs_symlink_read_verify+0xcd/0x100 [xfs], xfs_symlink block 0x58

We obviously want to have information about which verifier failed, but
I'm not sure we need the actual address of the xfs_verifier_error()
caller. It would be nice if we could replace (the address, not
necessarily the function name) that with, or add to it, an address that
refers to the particular check that failed. Granted, that may require
some kind of noinline context setting helper function if
__return_address is the only option to get that information or if we
wanted to include multiple bits of data. Just a thought.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
