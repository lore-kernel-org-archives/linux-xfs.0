Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60360 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937064AbeBUNjR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Feb 2018 08:39:17 -0500
Date: Wed, 21 Feb 2018 08:39:16 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 0/4] xfs: fix v5 AGFL wrapping
Message-ID: <20180221133915.GA29048@bfoster.bfoster>
References: <151863191996.12012.10898223924122487735.stgit@magnolia>
 <20180214195651.GB43414@bfoster.bfoster>
 <20180215020548.GN5217@magnolia>
 <20180215131630.GA48590@bfoster.bfoster>
 <20180216175701.GA27629@magnolia>
 <20180219135456.GB65426@bfoster.bfoster>
 <20180220170830.GF27629@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180220170830.GF27629@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 20, 2018 at 09:08:30AM -0800, Darrick J. Wong wrote:
> On Mon, Feb 19, 2018 at 08:54:57AM -0500, Brian Foster wrote:
> > On Fri, Feb 16, 2018 at 09:57:01AM -0800, Darrick J. Wong wrote:
> > > On Thu, Feb 15, 2018 at 08:16:30AM -0500, Brian Foster wrote:
> > > > On Wed, Feb 14, 2018 at 06:05:48PM -0800, Darrick J. Wong wrote:
> > > > > On Wed, Feb 14, 2018 at 02:56:51PM -0500, Brian Foster wrote:
...
> > > > 
> > > > Ok, so the intent is to "protect" those old kernels from a filesystem
> > > > that has seen a "fixed" kernel so the _old_ kernel doesn't explode on a
> > > > filesystem that has a wrapped agfl from a fixed kernel. That sounds
> > > > reasonable.. I guess what concerns me is that the bit doesn't seem to be
> > > > used in that manner. A user can always run a fixed kernel, wrap the
> > > > agfl, then go back to the bad one and cry when it explodes.
> > > > 
> > > > IOW, if the goal is this kind of retroactive protection, I'd expect the
> > > > bit to be enabled any time the filesystem is in a state that would cause
> > > > problems on the old kernel. Technically, that could mean doing something
> > > > like setting the bit any time an AGFL is in a wrapped state and clearing
> > > > it when that state clears. Or perhaps setting it unconditionally on
> > > > mount and leaving it permanently would be another way to satisfy the
> > > > requirement, though certainly more heavy handed.
> > > 
> > > The previous version of this series did that, though Dave suggested I
> > > change it to set the bit only if we actually touched an agfl.  I
> > > probably should have pushed back harder, but it was only rfc at the
> > > time.
> > > 
> > 
> > It's not clear which of the above options you're referring to. FWIW, the
> > former seems notably more usable to me than the latter.
> 
> Sorry about that.  The previous iteration would do:
> 
> if (!has_fixedagfl) {
> 	fix_agfls();
> 	set_fixedagfl();
> }
> 
> Which probably doesn't satisfy your usability test. :)
> 
> Hmm... another possible strategy would be to fix the agfls and set the
> fixedagfl bit at mount time, then at unmount/freeze/remount-ro we fix
> the agfls again and clear the fixedagfl bit.  Then the only way an
> unpatched kernel hits this is if we crash with a patched kernel and the
> recovery mount is an unpatched kernel.
> 

What's the purpose of "fixing the agfls again" at unmount time? Hasn't
the patched kernel already addressed the size mismatch at mount time?

> What does everyone think of this strategy?  I think I like it the most
> of all the things we've put forth because the only time anyone will trip
> over this rocompat bit is this one specific scenario.
> 
> (Apologies if we've already talked about this, I've gotten lost in this
> thread.)
> 
...
> > > > 
> > > > Hmm, I still think my preferred approach is to mount time detect,
> > > > enforce read-only and tell the user to xfs_repair[1]. It's the most
> > > 
> > > I think this is difficult to do for the root fs -- in general I don't
> > > think initrds ship with xfs_repair and the logic to detect the "refuses
> > > to mount rw" condition and react to that with xfs_repair and a second
> > > mount attempt.
> > > 
> > 
> > Good point. I guess what concerns me is leaving around such highly
> > specialized code. I figured an error check is less risk than a function
> > that modifies the fs. Do we have a test case that would exercise this
> > codepath going forward, at least?
> 
> I did write xfstests for the general case, though apparently I've been
> lagging xfstests and haven't sent it.  :/
> 
> Oh, right, we're still discussing semantics & existence of an rocompat
> bit, which affects the golden output.
> 

Ok..

> > > Also I think this doesn't work if we do an initial ro mount and then try
> > > to remount-rw...
> > > 
> > 
> > That one seems like it would just require a bit more code. E.g., we'd
> > have to cache or re-check state on ro -> rw transitions. That's
> > secondary to the rootfs use case justification, though..
> 
> <nod>
> 
> > > > simple implementation as we don't have to carry fixup code in the kernel
> > > > for such an uncommon situation (which facilitates a broad backport
> > > > strategy). It protects the users on stable kernels who pull in the
> > > > latest bug fixes, including the guy who goes from a bad kernel to a good
> > > > one, and all kernels going forward without having to use a feature bit.
> > > > We don't do anything for the guy who wraps the agfl on newer kernels and
> > > > goes back to the bad one, but at some point he just needs to update the
> > > > broken kernel.
> > > > 
> > > > [1] I guess doing a mount time fix up vs. a read-only mount + warning is
> > > > a separate question from the feature bit. I'd prefer the latter for
> > > > simplicity, but perhaps there are use cases where the benefit outweighs
> > > > the risk.
> > > > 
> > > > Anyways, that's just my .02. There is no real great option here, I
> > > > guess. I just think that at some point maybe it's best to fix all the
> > > > kernels we can to handle the size mismatch, live with the fact that some
> > > > users might have those old, unfixed kernels and bonk them on the head to
> > > > upgrade when they (hopefully decreasingly) pop up. Perhaps others can
> > > > chime in with more thoughts..
> > > 
> > > Yeah, we could do that too (make all the next releases of
> > > rhel/ol/debian/ubuntu/sles/whatever quietly fix the bad-wrap agfls and
> > > skip the feature bit) and just let the unpatched kernels rot.  It keeps
> > > coming up, though...
> > > 
> > 
> > I guess I haven't really noticed it enough to consider it an ongoing
> > issue (which doesn't mean it isn't :P). Any pattern to the use cache
> > behind these continued reports..?
> 
> No particular pattern, other than using/freeing agfl blocks.
> 

I'm more curious about the use case than the workload. E.g., what's the
purpose for using two kernels? Was it bad luck on an upgrade or
something that implies the problematic state could reoccur (i.e., active
switching between good/bad kernels)?

IOW, if the "it keeps coming up" situation is simply because the
existing userbase hasn't fully upgraded yet, then a simple detect/repair
forward-fix patch is going to be sufficient (perhaps with a warning not
to revert to $previous kernel) to resolve the problem for the remaining
set of users who are susceptible to the problem.

If the problem is instead a set of users that are switching back and
forth for whatever reason, then perhaps a feature bit policy is more
justified.

> > From an upstream perspective, RHEL continuing to operate in this mode
> > certainly does create an ongoing situation where a "current" distro
> > has/causes compatibility issues, particularly since some other
> > downstream distros may have kernels that use the upstream/fixed format.
> > 
> > I'll reiterate that in principle I don't think downstream decisions
> > should prohibit doing the right thing upstream, but for somebody on a
> > downstream distro who happens to test an upstream kernel (say as part of
> > a regression test/investigation), having the upstream kernel decide the
> > downstream kernel is no longer allowed to mount the fs seems kind of
> > mean. :P
> 
> Agreed, though agfl-related crashes are also mean. :/
> 

Yeah, but you can recover from that. In the use case above, the feature
bit has permanently prevented the user from going back to the distro
kernel. So this is one semi-realistic "switching between kernels" use
case where I think this feature bit actually hurts more than it helps.
If it were a big enough problem, I'd much rather have the downstream
kernel implement the feature bit to indicate that the upstream kernel
shouldn't/can't mount this filesystem than retroactively doing the
opposite. Even then, I still think I'd prefer the downstream kernel just
detect, fail to mount and encourage repair so we don't have to support
the strange transition from a clearly unsupported sequence (but this is
all downstream/distro discussion).

FWIW, if you actually want to make progress on this in absense of any
other feedback, I think the best approach is to refactor this series to
separate the detect/repair mechanism from all of this feature bit policy
stuff. The former all seems reasonable/justified to me based on your
explanations, so I'd be happy to review those portions of it without the
feature bit (which could still be tacked on for further review,
reordered appropriately on merge if ultimately necessary, etc.) and
consider the feature bit separately based on justification for added
benefit over the former.

Brian

> --D
> 
> > Brian
> > 
> > > --D
> > > 
> > > > 
> > > > Brian
> > > > 
> > > > > > caused this in the first place ..." Then we write a FAQ entry that
> > > > > > elaborates on how/why a user hit that problem and backport to stable
> > > > > > kernels as far and wide as possible. Hm?
> > > > > 
> > > > > I /do/ like the part about writing FAQ to update the kernel.
> > > > > 
> > > > > --D
> > > > > 
> > > > > > Brian
> > > > > > 
> > > > > > > --D
> > > > > > > --
> > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > --
> > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
