Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:38083 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750896AbdGXF0m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2017 01:26:42 -0400
Date: Mon, 24 Jul 2017 15:26:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: consolidate local format inode fork verifiers
Message-ID: <20170724052638.GD17762@dastard>
References: <20170719160318.GP4224@magnolia>
 <20170720022602.GR17762@dastard>
 <20170720055057.GQ4224@magnolia>
 <20170720224934.GW17762@dastard>
 <20170721135405.GB44069@bfoster.bfoster>
 <20170721230058.GY17762@dastard>
 <20170722122944.GA4783@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170722122944.GA4783@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Sat, Jul 22, 2017 at 08:29:44AM -0400, Brian Foster wrote:
> On Sat, Jul 22, 2017 at 09:00:58AM +1000, Dave Chinner wrote:
> > On Fri, Jul 21, 2017 at 09:54:05AM -0400, Brian Foster wrote:
> > > On Fri, Jul 21, 2017 at 08:49:34AM +1000, Dave Chinner wrote:
> > > but I'm also not against crafting a new, verifier
> > > specific one to accomplish that. Technically, it doesn't have to be
> > > shouty :), but IMO, the diagnostic/usability benefit outweighs the
> > > aesthetic cost.
> > 
> > I disagree - there are so many verifier checks (and we only grow
> > more as time goes on) so whatever we do needs them to be
> > easily maintainable and not compromise the readabilty of the verifer
> > code.
> > 
> 
> I agree. ;) But I disagree that using a macro somehow automatically
> negatively affects the readability of verifers. Anybody who can make
> sense of this:
> 
>         if (!xfs_sb_version_hascrc(&mp->m_sb))
>                 return __line__;
>         if (dsl->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
>                 return __line__;
>         if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))
>                 return __line__;
> 
> ... could just as easily make sense of something like this:
> 
> 	xfs_verify_assert(xfs_sb_version_hascrc(&mp->m_sb));
> 	xfs_verify_assert(dsl->sl_magic == cpu_to_be32(XFS_SYMLINK_MAGIC));
> 	xfs_verify_assert(uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid));

Still needs branches to return on error so the verifier code
functions correctly. So it simply isn't as clean as your example
suggests. And, no hiding goto/return/errno variables inside a macro
is not an option - that makes for horrible code and we should not
repeat those past mistakes we inherited from the old Irix
codebase.

And we need to be really careful here - making the code more complex
for pretty errors blows out the size of the code. That means it runs
slower, even though we never execute most of the pretty error print
stuff.  This is an important consideration as verifiers are a
performance critical fast path, both in the kernel and in userspace.

> There is a simple solution to this problem: just include all of the
> readily accessible state information in the error report. If the
> messages above looked something like the following:
> 
>   XFS (...): Metadata corruption detected at xfs_symlink_read_verify [xfs], xfs_symlink block 0x58
>   XFS (...): Read verifier failed: xfs_log_check_lsn(mp, be64_to_cpu(dsl->sl_lsn)), xfs_symlink_remote.c:114
>
> ... we wouldn't have to decode what the error means for every possible
> kernel. The error report is self contained like most of the other
> errors/assert reports in XFS and throughout the kernel.

Just like an assert/warning, we've still got to go match it to the
exact kernel source tree to determine the context in which the
message was emitted and what it actually means.  Making it pretty
doesn't change the amount of work a developer needs to do to
classify or analyse errors in log files, all it does is change the
amount of overhead needed to generate the error message,

Really, verifiers are performance critical fast paths, so the code
that runs inside them needs to be implemented with this in mind. I'm
not against making messages pretty, but let's not do it based on the
on the premise that pretty error messages are more important than
runtime performance when there are no errors...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
