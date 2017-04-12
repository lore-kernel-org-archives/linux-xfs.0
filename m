Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753148AbdDLL0s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Apr 2017 07:26:48 -0400
Date: Wed, 12 Apr 2017 07:26:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] mdrestore: warn about corruption if log is dirty
Message-ID: <20170412112644.GD6834@bfoster.bfoster>
References: <20170411141237.9274-1-jtulak@redhat.com>
 <20170411141237.9274-3-jtulak@redhat.com>
 <20170411223405.GC12369@dastard>
 <20170411234326.GA5109@birch.djwong.org>
 <0baf80cd-08d8-8238-95d1-5895cd1b4c22@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0baf80cd-08d8-8238-95d1-5895cd1b4c22@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Apr 11, 2017 at 08:48:32PM -0500, Eric Sandeen wrote:
> On 4/11/17 6:43 PM, Darrick J. Wong wrote:
> > On Wed, Apr 12, 2017 at 08:34:05AM +1000, Dave Chinner wrote:
> >> On Tue, Apr 11, 2017 at 04:12:37PM +0200, Jan Tulak wrote:
> >>> A dirty log in an obfuscated dump means that a corruption can happen
> >>> when replaying the log (which contains unobfuscated data). Warn the user
> >>> about this possibility.
> >>
> >>> The xlog workaround is copy&paste solution from repair/phase2.c and
> >>> other tools, because the function is not implemented in libxlog.
> >>>
> >>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> >>
> >> I think this is overkill. mdrestore is not the place
> >> to be interpreting the state of the dumped image - it is a basic
> >> "restore the image" program, not a "check the validity of the image"
> >> program.
> >>
> >> Secondly, if people are having problems with running log recovery on
> >> a restored obfuscated image and getting corruption and not knowing
> >> why or what to do, then that is a /documentation and training/
> >> problem, not a code problem.
> >>
> >> i.e. the problem is that people who aren't developers are trying to
> >> use tools that were written for developers to do forensic analysis
> >> of failures. Don't dumb down the tool for clueless users - point the
> >> users at the documentation that the tool requires to use correctly...
> > 
> > Looking at the patch, that's a lot of code to add to mdrestore that has
> > nothing to do with metadump restoration.
> 
> (tl;dr: slightly different approach suggested at the end)
> 
> So, yeah.  I hadn't really thought about the bulk of code when I made
> the suggestion.  The whole "given a device or file, get to a libxfs_mount"
> thing is repeated enough that I wonder if it shouldn't find its way
> into some factored code, which would make it nicer to read, at least.
> That doesn't address the issue of linking with new libs, or the
> overall elegance of the tool, though.
> 

Yeah, it would be nice if this could be done a bit more cleanly without
another duplication of the libxfs init stuff. It's a bit unfortunate to
include all of that just to emit a warning.

> > The key change we're trying to make is to prevent people incorrectly
> > replaying an XFS with a dirty log when the fs image has been restored
> > from an obfuscated metadump.
> 
> Yeah, the way this started was a metadump from the field which ended
> up "showing" corruption which was only a side-effect of this situation.
> 
> I had never considered this outcome; Brian diagnosed it and I don't
> know if it was obvious to him either.  It clearly wasn't obvious to
> support personnel.  I'm not sure I've ever seen it before, and I have
> replayed obfuscated metadumps.  And yes, we could talk about "better
> training" but in reality "you should have read the docs we just updated!"
> only goes so far.
> 

It's not obvious at all, IMO. I don't think it would be a bad idea to
update the xfs_metadump manpage or whatnot too, but I don't think that
eliminates the need for _at least_ a warning.

> We have a lot of warnings to help people not use tools in bad ways
> or that duplicate information from a manpage, if it's highly
> relevant to that point of operation:
> 
> "Filesystem log is dirty; image will contain unobfuscated metadata in log."
> 
> "ERROR: The log head and/or tail cannot be discovered. Attempt to mount the
> filesystem to replay the log or use the -L option to destroy the log and
> attempt a repair."
> 
> "Only one AG detected - cannot validate filesystem geometry.
> Use the -o force_geometry option to proceed."
> 

... or:

"ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair.  If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this."

I don't see the need for a warning here as much different from the
above, tbh.

> Handed a metadump, AFAIK there is obvious way to even /know/ whether
> it's safe to replay the log.  It would involve a mount -ro,norecovery
> and intuiting that the filenames are obfuscated, or digging in with
> xfs_db, coupled with more xfs_db work or logprint to see if the log
> is even dirty, etc.
> 

Yep.

> Anyway, there seem to be two intertwined objections:
> 
> 1) xfs_metadump has no business cracking open the image log, and
> 2) xfs_metadump has no business alerting the user to this situation
> 
> I'm pretty sympathetic to the first argument, a little less so to the second.
> 

Agreed.

> > So in my mind this brings up two questions:  First, how do we prevent
> > log replay in such situations?  Second, how do we teach people not to
> > attempt log replay?
> 
> (honestly, in many cases log replay is fine, right?)
> 
> >  As you point out, it's better that we educate
> > people as what problems each tool tries to solve and where the sharp
> > edges might be on the debugging tools, but the answer to the first
> > question ensures that us fallible developers can't do something stupid
> > even though we theoretically know better.
> > 
> > Frankly, if the goal is to nudge n00b members of support teams away from
> > a behavior that won't help them towards starting their failure analysis,
> > then then I think we ought to patch the log recovery code to detect an
> > obfuscated fs image, complain to dmesg about someone making an illogical
> > move, and then refuse to mount the log.
> 
> (I think I like that less than the current approach; if given a choice
> beetween cruft in userspace or kernelspace I'll take userspace each
> time ;) but I see what you mean about denying at the point of potential
> failure...)
> 

Another way to look at this is obfuscation is out of the control of the
kernel. E.g., in theory (I don't see how in practice..), perhaps
xfs_metadump could someday learn how to obfuscate such images
correctly/selectively so as to avoid corruption. How is the kernel
supposed to interpret such images and know when to allow or not allow
log recovery?

> > I'd rather push back on the incorrect behavior at the time it is done,
> > instead of training people to ignore a priori warning messages.
> 
> I don't think that a:
> 
>  WARNING: Replaying the log on this image may corrupt the filesystem!
> 
> would be ignored, tbh.
> 
> Anyway -
> 
> My hope here was to alert the person handling the metadump that it may
> require special handling.  I don't think we need that warning on the
> xfs_metadump side; it's not that user's concern (the unobfuscated
> data /is/ their privacy concern.)
> 

I think we do need it on the metadump side. It nudges the user to submit
a valid image if at all possible, to verify the result or at least ask
somebody about the warning if they run into it.

> What if we used the mb_reserved field in the first metablock header
> as a short flags field to indicate OBFUSCATED | DIRTY_LOG | XXX???
> and fill it in at metadump time, so that the state of the metadump
> can be trivially indicated and/or observed without all the somewhat
> inappropriate extra libxfs/libxlog code baggage?  
> 
> I see value in that by itself, because the recipient of a metadump
> doesn't /really/ know what they've been handed; what (if any) messages
> we present to the mdrestore user based on that information could be
> debated later.
> 

That sounds interesting/reasonable to me on first thought. Without
digging into the code, I take it that embedding this into a metadump
header means this won't affect the resulting filesystem image in any
way..? If that doesn't conflict with any other use of that field, it
sounds like that would eliminate the need for all of the libxfs bits on
the mdrestore side as well.

Brian

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
