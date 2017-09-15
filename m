Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:43424 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751194AbdIOLTj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2017 07:19:39 -0400
Subject: Re: xfs: Uninitialized memory read at xlog_write
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20170913094335.GV17782@dastard>
        <201709131859.AHB43227.SOFFOHJVMLFtOQ@I-love.SAKURA.ne.jp>
        <20170913214028.GX17782@dastard>
        <201709141915.HAD04123.FQOSHJtVOLFMFO@I-love.SAKURA.ne.jp>
        <20170914224431.GA10621@dastard>
In-Reply-To: <20170914224431.GA10621@dastard>
Message-Id: <201709152019.BHA98861.OHFFQOLVFJOMtS@I-love.SAKURA.ne.jp>
Date: Fri, 15 Sep 2017 20:19:35 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: bfoster@redhat.com, sandeen@redhat.com, dchinner@redhat.com, linux-xfs@vger.kernel.org

Dave Chinner wrote:
> On Thu, Sep 14, 2017 at 07:15:38PM +0900, Tetsuo Handa wrote:
> > 
> > ----------
> >          Starting Load/Save Random Seed...
> > 
> >          Starting Configure read-only root support...
> > 
> > [ 1106.927991] ptr=ffffc90001c08218 reg->i_addr=ffff880134c7fda8 copy_off=0 copy_len=16
> > [ 1106.928022] ptr=ffffc90001c08234 reg->i_addr=ffff88013395f858 copy_off=0 copy_len=56
> > [ 1106.928100] ptr=ffffc90001c08278 reg->i_addr=ffff88013395f890 copy_off=0 copy_len=96
> > [ 1106.932354] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff88013395f860)
> 
> Hold on- that warning has come from the /prior/ region copy, not
> the current region!
> 
> i.e. 2nd last copy region was ffff88013395f858 for 0x38 bytes, and
> this spans address that failed ffff88013395f860. i.e. it's 8 bytes
> into that region. It's 48 bytes before the region that we were
> copying when kmemcheck triggered!
> 
> I'm going to guess that we've got a log op header, followed by
> a inode format header, follow by something like a v2 inode core.
> i.e. log op headers are 16 bytes, xfs_inode_log_format are 56 bytes,
> and a v2 inode core is 96 bytes.
> 
> So, the inode log format header:
> 
> struct xfs_inode_log_format {
>         uint16_t                   ilf_type;             /*     0     2 */
>         uint16_t                   ilf_size;             /*     2     2 */
>         uint32_t                   ilf_fields;           /*     4     4 */
>         uint16_t                   ilf_asize;            /*     8     2 */
>         uint16_t                   ilf_dsize;            /*    10     2 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         uint64_t                   ilf_ino;              /*    16     8 */
>         union {
>                 uint32_t           ilfu_rdev;            /*           4 */
>                 uuid_t             ilfu_uuid;            /*          16 */
>         } ilf_u;                                         /*    24    16 */
>         int64_t                    ilf_blkno;            /*    40     8 */
>         int32_t                    ilf_len;              /*    48     4 */
>         int32_t                    ilf_boffset;          /*    52     4 */
> 
>         /* size: 56, cachelines: 1, members: 10 */
>         /* sum members: 52, holes: 1, sum holes: 4 */
>         /* last cacheline: 56 bytes */
> };
> 
> Oh, that's right. Someone, a long, long time ago, screwed up the on
> disk inode log structure but nobody noticed it due to the Irix MIPS
> compilers padding the structure identically on 32 and 64 bit
> systems. Port to linux, and i386/x86-64 padded it differently. The
> fix at the time was to make it right in recovery and continue to
> use the native structure at runtime. Ok, let's fix that properly
> now.
> 
> Try the patch below.

Bingo! This patch fixes the XFS splat. Thank you.

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: Don't log uninitialised fields in inode structures
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Prevent kmemcheck from throwing warnings about reading uninitialised
> memory when formatting inodes into the incore log buffer. There are
> several issues here - we don't always log all the fields in the
> inode log format item, and we never log the inode the
> di_next_unlinked field.
> 
> In the case of the inode log format item, this is aused b cerbated
> by the old xfs_inode_log_format structure padding issue. Hence make
> the padded, 64 bit aligned version of the structure the one we always
> use for formatting the log and get rid of the 64 bit variant. This
> means we'll always log the 64-bit version and so recovery only needs
> to convert from the unpadded 32 bit version from older 32 bit
> kernels.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_log_format.h | 27 +++++----------
>  fs/xfs/xfs_inode_item.c        | 79 ++++++++++++++++++++++--------------------
>  fs/xfs/xfs_ondisk.h            |  2 +-
>  3 files changed, 50 insertions(+), 58 deletions(-)
