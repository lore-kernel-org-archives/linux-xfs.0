Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46580 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbeC0QRe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 12:17:34 -0400
Date: Tue, 27 Mar 2018 09:07:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: FreeBSD and xfsprogs ?
Message-ID: <20180327160714.GB4818@magnolia>
References: <cem@freebsd.org>
 <CAG6CVpU3qe10UUY6B-N4fs9WTwwUerVcJh0CrP22D8hvB4Z14Q@mail.gmail.com>
 <201803261953.w2QJrYQm028227@slippy.cwsent.com>
 <CAG6CVpXi3rb-NfLUXQqzStipmwRviKJPMpgKeQA9DfBmOWJ5oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG6CVpXi3rb-NfLUXQqzStipmwRviKJPMpgKeQA9DfBmOWJ5oQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Conrad Meyer <cem@freebsd.org>
Cc: Cy Schubert <Cy.Schubert@cschubert.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Carlos Maiolino <cmaiolino@redhat.com>, "freebsd-arch@freebsd.org" <freebsd-arch@freebsd.org>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

[cc the xfsprogs maintainer]
[cc xfs list]

On Mon, Mar 26, 2018 at 12:57:55PM -0700, Conrad Meyer wrote:
> Yeah, someone broke the build recently via a base toolchain change or
> a ports framework/compiler change.  I don't think that changes
> anything.
> 
> On Mon, Mar 26, 2018 at 12:53 PM, Cy Schubert <Cy.Schubert@cschubert.com> wrote:
> > In message <CAG6CVpU3qe10UUY6B-N4fs9WTwwUerVcJh0CrP22D8hvB4Z14Q@mail.gma
> > il.com>
> > , Conrad Meyer writes:
> >> On Fri, Mar 23, 2018 at 12:18 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote
> >> :
> >> > On the Linux xfs development list there is an RFC to remove IRIX,
> >> > Darwin, and FreeBSD support from xfsprogs, the userspace program used
> >> > to create/interact with XFS filesystems. Just wanted to poke and check
> >> > to ensure that FreeBSD is not interested in XFS, if this is incorrect
> >> > now would be the good time to chime into the list and discussion.
> >> >
> >> > [0] https://lkml.kernel.org/r/20180322202102.wpff347scdmfpv62@odin.usersys.
> >> redhat.com
> >>
> >> Hi Luis,
> >>
> >> FreeBSD 11+ can mount XFS filesystems read and write via a FUSE port
> >> incorporating LKL[0] (sysutils/fusefs-lkl).  I would appreciate

Yikes.  I'm curious, how many people use fusefs-lkl?

Eric will have more to say about this, but is your xfsprogs port still
on 3.2.4 because ./configure can't find libblkid?

--D

> >> xfsprogs retaining FreeBSD support at least for creating or modifying
> >> offline XFS filesystems, if it isn't too painful for you.
> > fusefs-lkl is flagged broken as of r465272.
> >
> >
> > --
> > Cheers,
> > Cy Schubert <Cy.Schubert@cschubert.com>
> > FreeBSD UNIX:  <cy@FreeBSD.org>   Web:  http://www.FreeBSD.org
> >
> >         The need of the many outweighs the greed of the few.
> >
> >
