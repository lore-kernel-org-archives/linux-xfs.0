Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38360 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388333AbeGXRvM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 13:51:12 -0400
Date: Tue, 24 Jul 2018 09:43:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] xfs: verify extent size hint is valid in inode
 verifier
Message-ID: <20180724164346.GU4813@magnolia>
References: <20180605062423.4877-1-david@fromorbit.com>
 <20180605062423.4877-3-david@fromorbit.com>
 <6196d8ce-03b9-eaae-4a07-d307e35540ca@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6196d8ce-03b9-eaae-4a07-d307e35540ca@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 11:39:53PM -0700, Eric Sandeen wrote:
> On 6/4/18 11:24 PM, Dave Chinner wrote:
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
> 
> So, I think that if I do:
> 
> # mkfs.xfs -f -m crc=0 $TEST_DEV
> # ./check xfs/229
> # ./check xfs/229
> 
> I trip the verifier, because I end up with freed inodes on disk with an
> extent size hints but zeroed flags.  
> 
> xfs_ifree sets di_flags = 0 but doesn't clear di_extsize; xfs_inode_validate_extsize
> says if extsize !=0 and the hint flag is set, it fails
> 
> Anyone else see this?

Yeah, I think I just hit this on the TEST_DEV in xfs/242.

git blame says I lifted the code from the scrub code, and I probably
wrote the code having read the ioctl code (which clears the extsize
field if the iflag isn't set).

> (crc=0 needed because that causes us to actually reread the inode chunks
> in xfs_iread vs. /* shortcut IO on inode allocation if possible */

Hmmm, so a v5 fs mounted with ikeep will also read an inode chunk when
creating an inode.  It looks like we do that (instead of zeroing the
incore inode and setting a random i_generation) to preserve the existing
generation number?

In any case, it's pretty clear that kernels have been writing out freed
inode cores with di_mode == 0, di_flags == 0, and di_extsize == (some
number) so we clearly can't have that in the verifier.  It looks like we
only examine di_extsize if either EXTSZ flag are set, so it's not
causing incorrect behavior.  Maybe it can be a preening fix in
scrub/repair.

--D

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
