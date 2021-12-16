Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC1A3C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 05:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbhLPFQp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Dec 2021 00:16:45 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46453 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233679AbhLPFQp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Dec 2021 00:16:45 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C5DF48A528A;
        Thu, 16 Dec 2021 16:16:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mxj8F-003dmM-7C; Thu, 16 Dec 2021 16:16:43 +1100
Date:   Thu, 16 Dec 2021 16:16:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: check sb_meta_uuid for dabuf buffer recovery
Message-ID: <20211216051643.GD449541@dread.disaster.area>
References: <20211216001709.3451729-1-david@fromorbit.com>
 <20211216011054.GK1218082@magnolia>
 <20211216035858.GA27664@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216035858.GA27664@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61bacbbb
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=JNI9CO5MDp4TLxMcgqoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 15, 2021 at 07:58:58PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 15, 2021 at 05:10:54PM -0800, Darrick J. Wong wrote:
> > On Thu, Dec 16, 2021 at 11:17:09AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Got a report that a repeated crash test of a container host would
> > > eventually fail with a log recovery error preventing the system from
> > > mounting the root filesystem. It manifested as a directory leaf node
> > > corruption on writeback like so:
> > > 
> > >  XFS (loop0): Mounting V5 Filesystem
> > >  XFS (loop0): Starting recovery (logdev: internal)
> > >  XFS (loop0): Metadata corruption detected at xfs_dir3_leaf_check_int+0x99/0xf0, xfs_dir3_leaf1 block 0x12faa158
> > >  XFS (loop0): Unmount and run xfs_repair
> > >  XFS (loop0): First 128 bytes of corrupted metadata buffer:
> > >  00000000: 00 00 00 00 00 00 00 00 3d f1 00 00 e1 9e d5 8b  ........=.......
> > >  00000010: 00 00 00 00 12 fa a1 58 00 00 00 29 00 00 1b cc  .......X...)....
> > >  00000020: 91 06 78 ff f7 7e 4a 7d 8d 53 86 f2 ac 47 a8 23  ..x..~J}.S...G.#
> > >  00000030: 00 00 00 00 17 e0 00 80 00 43 00 00 00 00 00 00  .........C......
> > >  00000040: 00 00 00 2e 00 00 00 08 00 00 17 2e 00 00 00 0a  ................
> > >  00000050: 02 35 79 83 00 00 00 30 04 d3 b4 80 00 00 01 50  .5y....0.......P
> > >  00000060: 08 40 95 7f 00 00 02 98 08 41 fe b7 00 00 02 d4  .@.......A......
> > >  00000070: 0d 62 ef a7 00 00 01 f2 14 50 21 41 00 00 00 0c  .b.......P!A....
> > >  XFS (loop0): Corruption of in-memory data (0x8) detected at xfs_do_force_shutdown+0x1a/0x20 (fs/xfs/xfs_buf.c:1514).  Shutting down.
> > >  XFS (loop0): Please unmount the filesystem and rectify the problem(s)
> > >  XFS (loop0): log mount/recovery failed: error -117
> > >  XFS (loop0): log mount failed
> > > 
> > > Tracing indicated that we were recovering changes from a transaction
> > > at LSN 0x29/0x1c16 into a buffer that had an LSN of 0x29/0x1d57.
> > > That is, log recovery was overwriting a buffer with newer changes on
> > > disk than was in the transaction. Tracing indicated that we were
> > > hitting the "recovery immediately" case in
> > > xfs_buf_log_recovery_lsn(), and hence it was ignoring the LSN in the
> > > buffer.
> > > 
> > > The code was extracting the LSN correctly, then ignoring it because
> > > the UUID in the buffer did not match the superblock UUID. The
> > > problem arises because the UUID check uses the wrong UUID - it
> > > should be checking the sb_meta_uuid, not sb_uuid. This filesystem
> > > has sb_uuid != sb_meta_uuid (which is fine), and the buffer has the
> > > correct matching sb_meta_uuid in it, it's just the code checked it
> > > against the wrong superblock uuid.
> > > 
> > > The is no corruption in the filesystem, and failing to recover the
> > > buffer due to a write verifier failure means the recovery bug did
> > > not propagate the corruption to disk. Hence there is no corruption
> > > before or after this bug has manifested, the impact is limited
> > > simply to an unmountable filesystem....
> > > 
> > > This was missed back in 2015 during an audit of incorrect sb_uuid
> > > usage that resulted in commit fcfbe2c4ef42 ("xfs: log recovery needs
> > > to validate against sb_meta_uuid") that fixed the magic32 buffers to
> > > validate against sb_meta_uuid instead of sb_uuid. It missed the
> > > magicda buffers....
> > > 
> > > Fixes: ce748eaa65f2 ("xfs: create new metadata UUID field and incompat flag")
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > Makes sense.  Please send a slimmed down version of this to fstests@.
> 
> <sigh> "...of a reproducer for this to fstests@."

I don't have one. All I have a pre-recovery metadump that has the
issue already in it, and I traced the mount and looked at log print
output to find the issue.

Eric, it seems like getting generic coverage of sb_meta_uuid !=
sb_uuid for at least the recoveryloop group tests would be a goof
thing for the QE team to add to fstests? Alternatively, randomly
decide whether to set a different UUID during each scratch_mkfs
call?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
