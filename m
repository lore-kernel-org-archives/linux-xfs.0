Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43276 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932902AbeFGQQi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 12:16:38 -0400
Date: Thu, 7 Jun 2018 09:16:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] xfs: verify extent size hint is valid in inode
 verifier
Message-ID: <20180607161631.GM25007@magnolia>
References: <20180605062423.4877-1-david@fromorbit.com>
 <20180605062423.4877-3-david@fromorbit.com>
 <20180605171015.GJ9437@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605171015.GJ9437@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 05, 2018 at 10:10:15AM -0700, Darrick J. Wong wrote:
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
> 
> Looks ok modulo my comments in the next patch,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

FWIW when I applied this to xfsprogs I saw an xfs/033 regression:

Phase 6 - check inode connectivity...
reinitializing root directory
Metadata corruption detected at 0x5555555c60e0, inode 0x80 dinode

fatal error -- could not iget root inode -- error - 117
[Inferior 1 (process 1178) exited with code 01]
(gdb) l *(0x5555555c60e0)
0x5555555c60e0 is in libxfs_inode_validate_extsize (xfs_inode_buf.c:729).

We fail the inode verifier while trying to _iget the root inode so that
we can reinitialize it; I suspect phase 3 is going to need to check the
extent size hints and clear them.

--D

> --D
> 
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
> >  	uint16_t		mode;
> >  	uint16_t		flags;
> >  	uint64_t		flags2;
> > @@ -501,6 +502,12 @@ xfs_dinode_verify(
> >  			return __this_address;
> >  	}
> >  
> > +	/* extent size hint validation */
> > +	fa = xfs_inode_validate_extsize(mp, be32_to_cpu(dip->di_extsize),
> > +					mode, be32_to_cpu(dip->di_flags));
> > +	if (fa)
> > +		return fa;
> > +
> >  	/* only version 3 or greater inodes are extensively verified here */
> >  	if (dip->di_version < 3)
> >  		return NULL;
> > -- 
> > 2.17.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
