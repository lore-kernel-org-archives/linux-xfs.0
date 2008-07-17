Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jul 2008 15:39:15 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6HMdAHk001328
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 15:39:10 -0700
Date: Fri, 18 Jul 2008 08:40:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: latest -git: kernel BUG at fs/xfs/support/debug.c:54!
Message-ID: <20080717224012.GH29319@disturbed>
References: <19f34abd0807171046j425bebc6m8d8eb80a641e0e5b@mail.gmail.com> <487F980F.7070708@redhat.com> <19f34abd0807171218u3de86ddbt506b0b4fa0548406@mail.gmail.com> <19f34abd0807171229p724cc44ese3cb064a65fbd2c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807171229p724cc44ese3cb064a65fbd2c0@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Tim Shimmin <xfs-masters@oss.sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@saeurebad.de>

On Thu, Jul 17, 2008 at 09:29:39PM +0200, Vegard Nossum wrote:
> On Thu, Jul 17, 2008 at 9:18 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > Thanks, you are right. I have adjusted my configuration, but I am
> > still able to produce this:
> >
> > BUG: unable to handle kernel paging request at b62a66e0
> > IP: [<c030ef88>] xfs_alloc_fix_freelist+0x28/0x490
> 
> FWIW, this is fs/xfs/xfs_alloc.c:1817:
> 
>         if (!pag->pagf_init) {

Which kind of implies that we've got a bogus fsbno
that we're using as the basis of allocation.....

What is the corruption you are inducing? Can you produce
a xfs_metadump image of the filesystem and put it up somewhere
that we can access it?

I suspect that we are not validating the block numbers coming
out of the various btrees as landing inside the filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
