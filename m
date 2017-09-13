Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:31009
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752087AbdIMVkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2017 17:40:32 -0400
Date: Thu, 14 Sep 2017 07:40:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: Uninitialized memory read at xlog_write
Message-ID: <20170913214028.GX17782@dastard>
References: <201709042119.CDE26519.MtQJHFOSOFOLVF@I-love.SAKURA.ne.jp>
 <20170911150157.GA13400@bfoster.bfoster>
 <201709131614.FAG69217.MSHFFVOFLJtQOO@I-love.SAKURA.ne.jp>
 <20170913094335.GV17782@dastard>
 <201709131859.AHB43227.SOFFOHJVMLFtOQ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201709131859.AHB43227.SOFFOHJVMLFtOQ@I-love.SAKURA.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: bfoster@redhat.com, sandeen@redhat.com, dchinner@redhat.com, linux-xfs@vger.kernel.org

On Wed, Sep 13, 2017 at 06:59:38PM +0900, Tetsuo Handa wrote:
> Dave Chinner wrote:
> > On Wed, Sep 13, 2017 at 04:14:37PM +0900, Tetsuo Handa wrote:
> > > [  OK  ] Stopped target Switch Root.
> > > 
> > > [  OK  ] Stopped target Initrd File Systems.[ 1054.691505] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff880135396660)
> > > [ 1054.691506] 000000000000000093050a200000000000000000000000000000000000000000
> > > [ 1054.691511]  u u u u u u u u i i i i i i i i u u u u u u u u u u u u u u u u
> > > [ 1054.691515]  ^
> > > [ 1054.691519] RIP: 0010:xlog_write+0x344/0x6b0
> > 
> > What line of code does this correspond to?
> > 
> 
>                         /*
>                          * Copy region.
>                          *
>                          * Unmount records just log an opheader, so can have
>                          * empty payloads with no data region to copy. Hence we
>                          * only copy the payload if the vector says it has data
>                          * to copy.
>                          */
>                         ASSERT(copy_len >= 0);
>                         if (copy_len > 0) {
>                                 memcpy(ptr, reg->i_addr + copy_off, copy_len); // <= xlog_write+0x344/0x6b0
>                                 xlog_write_adv_cnt(&ptr, &len, &log_offset,
>                                                    copy_len);
>                         }
> 

Ok, that's what I suspected. The region being copied is set up
in xlog_cil_insert_format_items(), so problem is in one of the
->iop_format methods it calls to format the dirty metadata into the
region.

And given that the address is ...6660, it's likely the offset into
the structure being copied is 96 bytes.

$ pahole...
.....
struct xfs_log_dinode {
.....
       xfs_agino_t                di_next_unlinked;     /*    96     4 */
.....

Try the patch below.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: log a dummy next_unlinked value

From: Dave Chinner <dchinner@redhat.com>

Prevent kmemcheck from throwing warnings about reading 32 bits of
uninitialised memory when formatting an inode region into the incore
log buffer by writing a dummy value of zero into the
di_next_unlinked field.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_item.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6d0f74ec31e8..67c59a6c8b7c 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -364,6 +364,9 @@ xfs_inode_to_log_dinode(
 	to->di_dmstate = from->di_dmstate;
 	to->di_flags = from->di_flags;
 
+	/* log a dummy value to ensure logged structure is fully initialised */
+	to->di_next_unlinked = NULLAGINO;
+
 	if (from->di_version == 3) {
 		to->di_changecount = inode->i_version;
 		to->di_crtime.t_sec = from->di_crtime.t_sec;
