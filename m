Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:1832 "EHLO
        ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750920AbdKEWub (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Nov 2017 17:50:31 -0500
Date: Mon, 6 Nov 2017 09:50:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Message-ID: <20171105225028.GB5858@dastard>
References: <20171030133117.GA3535@bfoster.bfoster>
 <20171030210941.GA5858@dastard>
 <20171031112432.GA7093@bfoster.bfoster>
 <20171101004513.GK5858@dastard>
 <20171101141720.GB11709@bfoster.bfoster>
 <20171101235300.GT5858@dastard>
 <20171102112533.GA15748@bfoster.bfoster>
 <20171102233017.GX5858@dastard>
 <20171103024740.GE4911@magnolia>
 <20171103113622.GB19974@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103113622.GB19974@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Nov 03, 2017 at 07:36:23AM -0400, Brian Foster wrote:
> On Thu, Nov 02, 2017 at 07:47:40PM -0700, Darrick J. Wong wrote:
> > FWIW the way I've been modelling this patch series in my head is that we
> > format an arbitrarily large filesystem (m_LBA_size) address space on a
> > thinp, feed statfs an "adjusted" size (m_usable_size)i which restricts
> > how much space we can allocate, and now growfs increases or decreases
> > the adjusted size without having to relocate anything or mess with the
> > address space.  If the adjusted size ever exceeds the address space
> > size, then we tack on more AGs like we've always done.  From that POV,
> > there's no need to physically shrink (i.e. relocate) anything (and we
> > can leave that for later/never).

[...]

> For example, suppose we had an absolute crude, barebones implementation
> of physical shrink right now that basically trimmmed the amount of space
> from the end of the fs iff those AGs were completely empty and otherwise
> returned -EBUSY. There is no other userspace support, etc. As such, this
> hypothetical feature is extremely limited to being usable immediately
> after a growfs and thus probably has no use case other than "undo my
> accidental growfs."
> 
> If we had that right now, _then_ what would the logical shrink interface
> look like?

Absolutely no different to what I'm proposing we do right now. That
is, the behaviour of the "shrink to size X" ioctl is determined by
the feature bit in the superblock.  Hence if the thinspace feature
is set we do a thin shrink, and if it is not set we do a physical
shrink. i.e. grow/shrink behaviour is defined by the kernel
implementation, not the user or the interface.

As it is, I still can't see a use case or compelling reason for
physically shrinking a thin filesystem. What's the use case that
leads you to think that we need to physically shrink a thin
filesystem, Brian? Let's get that on the table first, rather than
waste time discussing hypothetical what-if's....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
