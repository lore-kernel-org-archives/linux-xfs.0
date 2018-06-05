Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:31438 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752365AbeFEW4U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 18:56:20 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQKsD-00035Q-Vk
        for linux-xfs@vger.kernel.org; Wed, 06 Jun 2018 08:56:18 +1000
Date: Wed, 6 Jun 2018 08:56:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfs: verify extent size hint is valid in inode
 verifier
Message-ID: <20180605225617.GJ10363@dastard>
References: <20180605062423.4877-1-david@fromorbit.com>
 <20180605062423.4877-3-david@fromorbit.com>
 <20180605095359.jrakxjvodb6q5glx@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605095359.jrakxjvodb6q5glx@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Tue, Jun 05, 2018 at 11:53:59AM +0200, Carlos Maiolino wrote:
> On Tue, Jun 05, 2018 at 04:24:19PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > There are rules for vald extent size hints. We enforce them when
> > applications set them, but fuzzers violate those rules and that
> > screws us over.
> > 
> > This results in alignment assertion failures when setting up
> > allocations such as this in direct IO:
> > 
> > XFS: Assertion failed: ap->length, file: fs/xfs/libxfs/xfs_bmap.c, line: 3432
> > ....
> > Call Trace:
> >  xfs_bmap_btalloc+0x415/0x910
> >  xfs_bmapi_write+0x71c/0x12e0
> >  xfs_iomap_write_direct+0x2a9/0x420
> >  xfs_file_iomap_begin+0x4dc/0xa70
> >  iomap_apply+0x43/0x100
> >  iomap_file_buffered_write+0x62/0x90
> >  xfs_file_buffered_aio_write+0xba/0x300
> >  __vfs_write+0xd5/0x150
> >  vfs_write+0xb6/0x180
> >  ksys_write+0x45/0xa0
> >  do_syscall_64+0x5a/0x180
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > 
> > And from xfs_db:
> > 
> > core.extsize = 10380288
> > 
> > Which is not an integer multiple of the block size, and so violates
> > Rule #7 for setting extent size hints. Validate extent size hint
> > rules in the inode verifier to catch this.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_buf.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index f5fff1ccb61d..be197c91307b 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -385,6 +385,7 @@ xfs_dinode_verify(
> >  	xfs_ino_t		ino,
> >  	struct xfs_dinode	*dip)
> >  {
> > +	xfs_failaddr_t		fa;
> 
> Weren't we getting rid of typedefs?

Unneeded typedefs, yes.  e.g. typedef struct foo { } foo_t; serve no
useful purpose, so we get rid of them where appropriate.

> To be honest the typedef here gives more
> clarity to the code than void* directly, so, I'm ok with it anyway, I'm just
> curious is some typedefs are going to be kept.

Right, xfs_failaddr_t is a useful typedef - it tells us that this
variable will hold an instruction pointer related to the failure
that was detected, which is something a void * can't tell us.

It's all about context :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
