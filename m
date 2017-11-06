Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752371AbdKFNBC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Nov 2017 08:01:02 -0500
Date: Mon, 6 Nov 2017 08:01:00 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Message-ID: <20171106130100.GA30884@bfoster.bfoster>
References: <20171030210941.GA5858@dastard>
 <20171031112432.GA7093@bfoster.bfoster>
 <20171101004513.GK5858@dastard>
 <20171101141720.GB11709@bfoster.bfoster>
 <20171101235300.GT5858@dastard>
 <20171102112533.GA15748@bfoster.bfoster>
 <20171102233017.GX5858@dastard>
 <20171103024740.GE4911@magnolia>
 <20171103113622.GB19974@bfoster.bfoster>
 <20171105225028.GB5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171105225028.GB5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Nov 06, 2017 at 09:50:28AM +1100, Dave Chinner wrote:
> On Fri, Nov 03, 2017 at 07:36:23AM -0400, Brian Foster wrote:
> > On Thu, Nov 02, 2017 at 07:47:40PM -0700, Darrick J. Wong wrote:
> > > FWIW the way I've been modelling this patch series in my head is that we
> > > format an arbitrarily large filesystem (m_LBA_size) address space on a
> > > thinp, feed statfs an "adjusted" size (m_usable_size)i which restricts
> > > how much space we can allocate, and now growfs increases or decreases
> > > the adjusted size without having to relocate anything or mess with the
> > > address space.  If the adjusted size ever exceeds the address space
> > > size, then we tack on more AGs like we've always done.  From that POV,
> > > there's no need to physically shrink (i.e. relocate) anything (and we
> > > can leave that for later/never).
> 
> [...]
> 
> > For example, suppose we had an absolute crude, barebones implementation
> > of physical shrink right now that basically trimmmed the amount of space
> > from the end of the fs iff those AGs were completely empty and otherwise
> > returned -EBUSY. There is no other userspace support, etc. As such, this
> > hypothetical feature is extremely limited to being usable immediately
> > after a growfs and thus probably has no use case other than "undo my
> > accidental growfs."
> > 
> > If we had that right now, _then_ what would the logical shrink interface
> > look like?
> 
> Absolutely no different to what I'm proposing we do right now. That
> is, the behaviour of the "shrink to size X" ioctl is determined by
> the feature bit in the superblock.  Hence if the thinspace feature
> is set we do a thin shrink, and if it is not set we do a physical
> shrink. i.e. grow/shrink behaviour is defined by the kernel
> implementation, not the user or the interface.
> 

I don't buy that argument at all. ;) What you describe above may be
reasonable for the current situation where shrink doesn't actually exist
(or thin comes first), but the above example assumes that there is at
least one simple and working physical shrink use case wired up to the
existing interface already. What you suggest means we would change the
behavior of a _working_ interface to do something completely different
based on a feature bit in the filesystem.

> As it is, I still can't see a use case or compelling reason for
> physically shrinking a thin filesystem. What's the use case that
> leads you to think that we need to physically shrink a thin
> filesystem, Brian? Let's get that on the table first, rather than
> waste time discussing hypothetical what-if's....
> 

I think you're missing the point. I'm really not that concerned about
whether we ultimately allow physical shrink or not on thin filesystems.
We can make that decision down the road. As mentioned previously, the
decision to support physical shrink on a thin enabled filesystem is
distinct from preserving the ability to do so via the current interface.

My concern is that the decision to override this interface has the
potential to create a mess later, both with the kernel interface and
from the perspective of xfsprogs usability. I don't want to try and
repeat the weird corner cases where I think that could materialize
because I can't seem to get that across well enough for you to consider
the requisite conditions. Instead, perhaps I'll just try to describe
what I think this interface should look like at a high level...

- Define a new version of struct xfs_growfs_data that includes a
  new_blocks field, new_usable_blocks field and imaxpct. Also include
  whatever mechanical changes are necessary to rev. the interface (i.e.,
  version number, padding, etc.).

  This means that the updated growfs interface supports the ability to
  physically and logically grow/shrink independent from whatever feature
  decisions we make in the future. This also means the logical
  grow/shrink interface is a bit more flexible because we don't have to
  enforce logical grow on physical grow. Finally, if we ever do support
  physical and logical shrink together, the potential for having to
  consider whether a growfs_data->newblocks shrink command means logical
  shrink because it comes from an older (but post-thin) xfsprogs or
  physical shrink because it comes from some 3rd party application goes
  away completely. The kernel interface is clear and well-defined.

For userspace, we have at least a couple options:

- Implement the same behavior as you've already proposed: physically and
  logically grow together, logical shrink only when hasthin == true,
  otherwise return an error. The point here is that using a more
  flexible kernel interface doesn't preclude/enforce how we decide to
  expose this feature in xfsprogs, and afaict doesn't introduce any new
  backwards compatibility issues since we have to update xfsprogs
  anyways. Older xfsprogs would retain the same behavior it has today.

Or...

- Create a separate logical grow/shrink parameter in xfs_growfs (i.e., a
  -T param analogous to -D for physical blocks). This ensures that
  logical shrink/grow can execute independent from physical shrink/grow,
  that there is no potential for confusion over logical vs. physical
  shrink on thin filesystems and in particular, that if we do ever
  support physical shrink but do _not_ support it on thin fs', that
  there is a distinct physical shrink command that _will return an error
  from the kernel_ even after userspace grows support for physical
  shrink, rather than succeed doing something other than what the user
  might have anticipated.

  Note that even with a separate thin parameter, I think we could still
  consider support of logical+physical grow via the xfs_growfs -d
  parameter.

I find the first option unwise because it similarly confuses userspace
syntax of future physical shrink. For example, that causes me to start
to think about things like whether some user could come along after we
support physical shrink (particularly if we don't support it on thin
fs), run the "shrink the data section" command mistakenly thinking it
freed up block address space and then run the corresponding lvresize
command to shrink the volume since the fs shrink succeeded (which leaves
the user in a data loss scenario).

That is primarily due to user error of course, but maybe the user in
that example simply picked the wrong volume out of tens or hundreds of
others and didn't realize it was thin in the first place. I'm sure we'll
have documentation and whatnot to absolve us from blame, but IMO this is
all much more usable with distinct interfaces for physical vs. logical
adjustments.

In summary, my arguments here consist mostly of a collection of red
flags that I see rather than hard incompatibilities or specific use
cases I want to support. The problematic situations change depending on
whether we decide to support physical shrink on thin fs or not and so
it's not really possible or important to try and pin them all down.
OTOH, it's also quite possible that none of them ever materialize at
all.

If they do, I'm pretty sure we could find ways to address each one
individually as we progress, or document potentially confusing behavior
appropriately, etc. The larger point is that I think much of this simply
goes away with a cleaner interface. IMO, this boils down to what I think
is just a matter of practicing good software engineering and system/user
interface design.

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
