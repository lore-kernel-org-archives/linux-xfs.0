Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58840 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752829AbeBSNy6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Feb 2018 08:54:58 -0500
Date: Mon, 19 Feb 2018 08:54:57 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 0/4] xfs: fix v5 AGFL wrapping
Message-ID: <20180219135456.GB65426@bfoster.bfoster>
References: <151863191996.12012.10898223924122487735.stgit@magnolia>
 <20180214195651.GB43414@bfoster.bfoster>
 <20180215020548.GN5217@magnolia>
 <20180215131630.GA48590@bfoster.bfoster>
 <20180216175701.GA27629@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180216175701.GA27629@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 16, 2018 at 09:57:01AM -0800, Darrick J. Wong wrote:
> On Thu, Feb 15, 2018 at 08:16:30AM -0500, Brian Foster wrote:
> > On Wed, Feb 14, 2018 at 06:05:48PM -0800, Darrick J. Wong wrote:
> > > On Wed, Feb 14, 2018 at 02:56:51PM -0500, Brian Foster wrote:
> > > > On Wed, Feb 14, 2018 at 10:12:00AM -0800, Darrick J. Wong wrote:
> > > > > Hi all,
> > > > > 
> > > > > Here's a bunch of patches fixing the AGFL padding problem once and for
> > > > > all.  When the v5 disk format was rolled out, the AGFL header definition
> > > > > had a different padding size on 32-bit vs 64-bit systems, with the
> > > > > result that XFS_AGFL_SIZE reports different maximum lengths depending on
> > > > > the compiler.  In Linux 4.5 we fixed the structure definition, but this
> > > > > has lead to sporadic corruption reports on filesystems that were
> > > > > unmounted with a pre-4.5 kernel and a wrapped AGFL and then remounted on
> > > > > a 4.5+ kernel.
> > > > > 
> > > > > To deal with these corruption problems, we introduce a new ROCOMPAT
> > > > > feature bit to indicate that the AGFL has been scanned and guaranteed
> > > > > not to wrap.  We then amend the mounting code to find broken wrapping,
> > > > > fix the wrapping, and if we had to fix anything, set the new ROCOMPAT
> > > > > flag.  The ROCOMPAT flag prevents re-mounting on unpatched kernels, so
> > > > > this series will likely have to be backported.
> > > > > 
> > > > 
> > > > I haven't taken a close enough look at the code yet, but I'm more
> > > > curious about the high level approach before getting into that.. IIUC,
> > > > we'll set the rocompat bit iff we mount on a fixed kernel, found the
> > > > agfl wrapped and detected the agfl size mismatch problem. So we
> > > > essentially only restrict mounts on older kernels if we happen to detect
> > > > the size mismatch conditions on the newer kernel.
> > > 
> > > Correct.
> > > 
> > > > IOW, a user can mount back and forth between good/bad kernels so long as
> > > > the agfl isn't wrapped during a mount on the good kernel, and then at
> > > > some seemingly random point in the future said user might be permanently
> > > > restricted from rw mounts on the older kernel based on the issue being
> > > > detected/cleared in the new kernel. That seems a bit.. heavy-handed for
> > > > such an unpredictable condition. Why is a warning that the user has a
> > > > busted/old/in-need-of-upgrade kernel in the mix not sufficient?
> > > 
> > > I like the rocompat approach because we can prevent admins from mounting
> > > filesystems on old kernels, rather than letting the mount proceed and
> > > then blowing up in the middle of a transaction some time later when
> > > something actually hits the badly wrapped AGFL.  If we backport this
> > > series to the relevant distro kernels (ha!) then they will work without
> > > incident.
> > > 
> > 
> > Ok, so the intent is to "protect" those old kernels from a filesystem
> > that has seen a "fixed" kernel so the _old_ kernel doesn't explode on a
> > filesystem that has a wrapped agfl from a fixed kernel. That sounds
> > reasonable.. I guess what concerns me is that the bit doesn't seem to be
> > used in that manner. A user can always run a fixed kernel, wrap the
> > agfl, then go back to the bad one and cry when it explodes.
> > 
> > IOW, if the goal is this kind of retroactive protection, I'd expect the
> > bit to be enabled any time the filesystem is in a state that would cause
> > problems on the old kernel. Technically, that could mean doing something
> > like setting the bit any time an AGFL is in a wrapped state and clearing
> > it when that state clears. Or perhaps setting it unconditionally on
> > mount and leaving it permanently would be another way to satisfy the
> > requirement, though certainly more heavy handed.
> 
> The previous version of this series did that, though Dave suggested I
> change it to set the bit only if we actually touched an agfl.  I
> probably should have pushed back harder, but it was only rfc at the
> time.
> 

It's not clear which of the above options you're referring to. FWIW, the
former seems notably more usable to me than the latter.

> > Note that what I dislike about other possible combinations of the above,
> > such as setting the bit internally/conditionally and never clearing it
> > (which is what I think this series currently does), is that can
> > potentially fool a user who actually does due diligence to test a
> > filesystem against two kernels (for whatever, probably odd, reason). For
> > example:
> > 
> > - mount fs on good kernel, scribble on it
> > - test my (bad) back up kernel, mount, scribble some more
> > - back to my primary kernels, everything still works, deploy!
> > 
> > So the whole "set the bit unconditionally" thing might be heavy-handed,
> > but at least that is predictable. The set/clear approach is less
> > predictable, but the advantage of that approach is that it is
> > recoverable without putting a user in a bind with no other option but to
> > upgrade.
> > 
> > > The thing I dislike about this approach is that now we have this
> > > rocompat bit that has to be backported everywhere, and it only triggers
> > > in the specific case that (a) you have a v5 filesystem that (b) you run
> > > a mixed environment with 4.5+ and pre-4.5 kernels and (c) happened to
> > > land on a badly wrapped AGFL.  It's a lot of work for us (and the distro
> > > partners) but it's the least amount of work for admins -- so long as
> > > they keep their environments up to date.
> > > 
> > 
> > We should have already backported fixes to stable kernels for the AGFL
> > size problem itself, right? IOW, it really should be a minimal set of
> > users affected by this who haven't updated their old, broken kernels
> > that should have stable updates available by now.
> 
> Eric tells me RHEL xfsprogs/kernels ship with the agfl fix reverted /
> not applied, so there are potentially a lot of people who haven't
> updated... :/
> 

Eh, I suppose that could be another problem. I guess that is "our
problem" though, and not something we should allow to factor into
upstream decisions.

> (I also find it weird that RHEL7 changed the mkfs defaults post-GA to
> enable v5 by default, doesn't that create compatibility problems?)
> 

I don't recall the reasoning behind that decision. It may have just been
early enough for the benefit to outweigh the risk.

> > If so, then I agree.. Technicalities aside, I'm not a huge fan of
> > propagating a feature bit all over just to try and isolate those users.
> > Plus with some of the other ideas I'm throwing out above, we'd have to
> > start also thinking about users who might end up using two old kernels
> > that cross the boundary where the feature bit was introduced. Ugh. :P
> > 
> > Yet another way to look at it.. if we have enough users out there using
> > two kernels where one of them happens to be a stale/broken kernel
> > because they haven't upgraded to the agfl fix, what evidence do we have
> > that those users would actually update their variant of the "good agfl"
> > kernel to one that handles the agfl good/bad transition and sets a
> > feature bit? IOW, it seems to me that on some level the ship has sailed.
> 
> That's difficult to know.  Some customers have certified configurations
> and never update (and never run mixed environments), others are fairly
> good at pulling down the quarterly updates, and others do risky things
> like run mixed $distrokernel series, because mixing 2.6.39 and 4.1 is
> fun.
> 

Heh, indeed. I guess this is part of the reason why I wonder whether a
feature bit could create as many user issues as it resolves. In a sense,
we're floating another compatibility obstacle downstream (by that I mean
upstream -stable) that users have to navigate around.

> > > A second solution I considered was fixing the AGFL at mount/remount-rw
> > > time like we do in this series and adding code to move the AGFL to the
> > > start at freeze/remount-ro/umount time.  For the common case where we
> > > don't crash, we handle the mixed kernel environment seamlessly.  This
> > > would be my primary choice except that it'll still blow up if we wrap
> > > the AGFL, crash, and reboot with an old kernel.  Here too it won't fail
> > > at mount time, it'll fail some time after mount when something tries to
> > > modify an AGFL.
> > > 
> > 
> > Interesting idea, but I also think it would be unfortunate to alter our
> > normal/common runtime behavior to pacify some old, broken kernel that
> > also has stable fixes. To get around the crash thing, we'd probably have
> > to shuffle the AGFL locations on the fly, and that would be even worse
> > IMO.
> 
> Agreed, in the long run everyone will be post-4.5 so we should minimize
> the clutter and pain.
> 
> > > One solution involves a fair amount of backport and sw redeployment but
> > > makes it obvious when things are broken; the other solution handles it
> > > *almost* seamlessly... until it doesn't.
> > > 
> > > > I guess I'm just not really seeing the value in using the feature bit
> > > > for this as opposed to doing something more simple like detect an agfl
> > > > with a size mismatch with respect to the current kernel and forcing the
> > > > read-only mount in that instance. E.g., similar to how we handle log
> > > > recovery byte order mismatches:
> > > > 
> > > >   "dirty log written in incompatible format - can't recover"
> > > > 
> > > > But in this case it would be more something like "agfl in invalid state,
> > > > mounting read-only, please run xfs_repair and ditch that old kernel that
> > > 
> > > Good point, third option: if the agfl wraps badly, printk that the agfl
> > > is in an invalid state and that the user must mount with -o fixagfl
> > > (which will fix the problem and set the rocompat flag) and upgrade the
> > > kernel.  Seems kinda clunky... but all of these solutions have a wart of
> > > some kind.
> > > 
> > 
> > Hmm, I still think my preferred approach is to mount time detect,
> > enforce read-only and tell the user to xfs_repair[1]. It's the most
> 
> I think this is difficult to do for the root fs -- in general I don't
> think initrds ship with xfs_repair and the logic to detect the "refuses
> to mount rw" condition and react to that with xfs_repair and a second
> mount attempt.
> 

Good point. I guess what concerns me is leaving around such highly
specialized code. I figured an error check is less risk than a function
that modifies the fs. Do we have a test case that would exercise this
codepath going forward, at least?

> Also I think this doesn't work if we do an initial ro mount and then try
> to remount-rw...
> 

That one seems like it would just require a bit more code. E.g., we'd
have to cache or re-check state on ro -> rw transitions. That's
secondary to the rootfs use case justification, though..

> > simple implementation as we don't have to carry fixup code in the kernel
> > for such an uncommon situation (which facilitates a broad backport
> > strategy). It protects the users on stable kernels who pull in the
> > latest bug fixes, including the guy who goes from a bad kernel to a good
> > one, and all kernels going forward without having to use a feature bit.
> > We don't do anything for the guy who wraps the agfl on newer kernels and
> > goes back to the bad one, but at some point he just needs to update the
> > broken kernel.
> > 
> > [1] I guess doing a mount time fix up vs. a read-only mount + warning is
> > a separate question from the feature bit. I'd prefer the latter for
> > simplicity, but perhaps there are use cases where the benefit outweighs
> > the risk.
> > 
> > Anyways, that's just my .02. There is no real great option here, I
> > guess. I just think that at some point maybe it's best to fix all the
> > kernels we can to handle the size mismatch, live with the fact that some
> > users might have those old, unfixed kernels and bonk them on the head to
> > upgrade when they (hopefully decreasingly) pop up. Perhaps others can
> > chime in with more thoughts..
> 
> Yeah, we could do that too (make all the next releases of
> rhel/ol/debian/ubuntu/sles/whatever quietly fix the bad-wrap agfls and
> skip the feature bit) and just let the unpatched kernels rot.  It keeps
> coming up, though...
> 

I guess I haven't really noticed it enough to consider it an ongoing
issue (which doesn't mean it isn't :P). Any pattern to the use cache
behind these continued reports..?

>From an upstream perspective, RHEL continuing to operate in this mode
certainly does create an ongoing situation where a "current" distro
has/causes compatibility issues, particularly since some other
downstream distros may have kernels that use the upstream/fixed format.

I'll reiterate that in principle I don't think downstream decisions
should prohibit doing the right thing upstream, but for somebody on a
downstream distro who happens to test an upstream kernel (say as part of
a regression test/investigation), having the upstream kernel decide the
downstream kernel is no longer allowed to mount the fs seems kind of
mean. :P

Brian

> --D
> 
> > 
> > Brian
> > 
> > > > caused this in the first place ..." Then we write a FAQ entry that
> > > > elaborates on how/why a user hit that problem and backport to stable
> > > > kernels as far and wide as possible. Hm?
> > > 
> > > I /do/ like the part about writing FAQ to update the kernel.
> > > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > > --D
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
