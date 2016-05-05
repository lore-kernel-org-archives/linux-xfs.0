Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED6087CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 18:49:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53295AC005
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 16:49:55 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XcUQjDIFJu6i5hdk for <xfs@oss.sgi.com>;
	Thu, 05 May 2016 16:49:51 -0700 (PDT)
Date: Fri, 6 May 2016 09:49:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/7] Configurable error behavior [V3]
Message-ID: <20160505234948.GE26977@dastard>
References: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
	<20160505141107.GG1231@bfoster.bfoster>
	<20160505143718.GB9359@redhat.com>
	<20160505151827.GA1523@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160505151827.GA1523@bfoster.bfoster>
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

On Thu, May 05, 2016 at 11:18:28AM -0400, Brian Foster wrote:
> On Thu, May 05, 2016 at 04:37:18PM +0200, Carlos Maiolino wrote:
> > On Thu, May 05, 2016 at 10:11:07AM -0400, Brian Foster wrote:
> > > I suggest just to pull it out of the error classification stuff entirely
> > > and place it under xfs_mount. E.g., at the same level as "fail_writes"
> > > (but not a DEBUG mode only option).
> > > 
> > > I'm also wondering whether we need more mechanism for the
> > > fail_at_unmount behavior. For example, instead of defining
> > > XFS_MOUNT_UNMOUNTING, could we just call a function that resets
> > > max_retries (of each class) to 0 in the unmount path? Then maybe call
> > > the mount tunable retry_on_unmount or something like that. Thoughts?
> > > 
> > I don't oppose to that, although, having a flag like XFS_MOUNT_UNMOUNTING, might
> > be useful in the future, but still, wouldn't be better this single flag, instead
> > of walk through all classes/errors resetting the max_retries? It sounds as
> > granular as having fail_at_unmount inside each error, despite the fact it's not
> > exposed to user-space, we will need to interact over each max_retries to
> > actually shutdown the filesystem during unmount, which, is also error-prone
> > IMHO.
> 
> I view the granularity problem as a usability problem, not necessarily a
> code problem. E.g., why would somebody know or care to configure certain
> errors to fail on unmount but not others. If we have a knob, I think the
> knob is more clear as a general behavior knob rather than an error
> classification knob. Of course, that assumes there isn't some unknown
> good reason for per-error behavior (and/or a userspace mgmt tool that
> could provide a more usable interface on top of per-error knobs).

FWIW, this is exactly what we need to work out with this patch -
what makes sense in the UAPI ;)

I have to agree with Brian here - it doesn't make a whole lot of
sense to have per-error "fail-at-umount" configuration without an
obvious use-case. Hence a single option at the top level of the
error heirarchy makes sense i.e.
/sys/fs/xfs/<dev>/error/fail_at_unmount.

If, in future, someone needs more fine-grained control we can always
add it back in to the per-error config as an override to the global
setting...

> > It also depends on how granular we will implement fail_at_unmount. If it's a
> > single global option, resetting all max_retries works, otherwise it might not
> > work, for example, if we decide to have fail_at_unmount for each class, we might
> > need to reset max_retries only in specific errors, which will increase the
> > complexity of the code.
> > 
> 
> I'm assuming a per-mount option is sufficient. :) Otherwise, I'm just
> thinking out loud for ways to try and condense and/or reuse the code a
> bit here. I don't see a reason to add new mechanisms or config tunables
> in cases where we can accomplish the same thing by making existing
> knobs/mechanisms sufficiently generic.

Code re-use is good, but I don't think it is good when it conflates
or obfuscates specific behaviours we are checking for.  As such, I'd
prefer that we have a generic flag we can check for an unmount in
progress. There's likely to be code outside the IO error checking
that we might need to check for unmount, so we really should have a
separate flag for it and make all checks explicit.

Think of it this way: we explicitly check for a shutdown situation
to trigger imeediate failure processing in the IO path. Modifying
max retries at unmount to trigger immediate failure is akin to doing
the same thing when a shutdown is triggered rather than checking for
the shutdown flag.

IOWs, the flag is as much documentation as it is implementation - it
makes it explicit that this code path was intended to allow failure
at unmount, just like it is explicit that we intend to fail if a
shutdown is detected...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
