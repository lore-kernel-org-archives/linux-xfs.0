Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:63264 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752230AbeC0WcW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 18:32:22 -0400
Date: Wed, 28 Mar 2018 09:32:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: FreeBSD and xfsprogs ?
Message-ID: <20180327223201.GR18129@dastard>
References: <cem@freebsd.org>
 <CAG6CVpU3qe10UUY6B-N4fs9WTwwUerVcJh0CrP22D8hvB4Z14Q@mail.gmail.com>
 <201803261953.w2QJrYQm028227@slippy.cwsent.com>
 <CAG6CVpXi3rb-NfLUXQqzStipmwRviKJPMpgKeQA9DfBmOWJ5oQ@mail.gmail.com>
 <20180327160714.GB4818@magnolia>
 <8396fd92-3a64-a84f-b110-7edc6f0844b0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8396fd92-3a64-a84f-b110-7edc6f0844b0@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Conrad Meyer <cem@freebsd.org>, Cy Schubert <Cy.Schubert@cschubert.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Carlos Maiolino <cmaiolino@redhat.com>, "freebsd-arch@freebsd.org" <freebsd-arch@freebsd.org>, xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 27, 2018 at 11:48:29AM -0500, Eric Sandeen wrote:
> On 3/27/18 11:07 AM, Darrick J. Wong wrote:
> > [cc the xfsprogs maintainer]
> > [cc xfs list]
> 
> Yes, thanks.
> 
> > On Mon, Mar 26, 2018 at 12:57:55PM -0700, Conrad Meyer wrote:
> >> Yeah, someone broke the build recently via a base toolchain change or
> >> a ports framework/compiler change.  I don't think that changes
> >> anything.
> >>
> >> On Mon, Mar 26, 2018 at 12:53 PM, Cy Schubert <Cy.Schubert@cschubert.com> wrote:
> >>> In message <CAG6CVpU3qe10UUY6B-N4fs9WTwwUerVcJh0CrP22D8hvB4Z14Q@mail.gma
> >>> il.com>
> >>> , Conrad Meyer writes:
> >>>> On Fri, Mar 23, 2018 at 12:18 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote
> >>>> :
> >>>>> On the Linux xfs development list there is an RFC to remove IRIX,
> >>>>> Darwin, and FreeBSD support from xfsprogs, the userspace program used
> >>>>> to create/interact with XFS filesystems. Just wanted to poke and check
> >>>>> to ensure that FreeBSD is not interested in XFS, if this is incorrect
> >>>>> now would be the good time to chime into the list and discussion.
> >>>>>
> >>>>> [0] https://lkml.kernel.org/r/20180322202102.wpff347scdmfpv62@odin.usersys.
> >>>> redhat.com
> >>>>
> >>>> Hi Luis,
> >>>>
> >>>> FreeBSD 11+ can mount XFS filesystems read and write via a FUSE port
> >>>> incorporating LKL[0] (sysutils/fusefs-lkl).  I would appreciate
> > Yikes.  I'm curious, how many people use fusefs-lkl?
> > 
> > Eric will have more to say about this, but is your xfsprogs port still
> > on 3.2.4 because ./configure can't find libblkid?
> 
> So: At this point, it seems like if you're still on a 4 year old xfsprogs
> release with custom patches due to build problems we've never heard about,
> there doesn't seem to be a very strong effort to keep XFS on FreeBSD thriving.
> 
> And, given that you're stuck on 3.2.4, removing support from 4.16.0 won't
> change your situation anyway.
> 
> Are people using this?  Is anyone dedicated to maintaining it, or is it
> just kind of floating along at this point?
> 
> I'd rather not keep non-building freebsd code around just in case; I'd like
> to either see someone take ownership to get freebsd properly building upstream,
> or just drop it and let FreeBSD keep patching on the side as you've been doing
> for a few years anyway.
> 
> Thoughts?

We don't support fuse-lkl XFS filesystems on Linux, so I'm not sure
that using it on some other platform compels us to maintain a
current userspace tool port to those platforms...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
