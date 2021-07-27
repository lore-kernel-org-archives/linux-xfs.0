Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6AB9C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 21:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD87A60F91
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 21:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhG0Vqt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:46:49 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44996 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231445AbhG0Vqt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 17:46:49 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AA5DF1045876;
        Wed, 28 Jul 2021 07:46:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8UuT-00BWS6-8e; Wed, 28 Jul 2021 07:46:45 +1000
Date:   Wed, 28 Jul 2021 07:46:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: prevent spoofing of rtbitmap blocks when
 recovering buffers
Message-ID: <20210727214645.GU664593@dread.disaster.area>
References: <20210727191502.GH559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727191502.GH559212@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=MfXNflaBLaviXcaL3n8A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 12:15:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While reviewing the buffer item recovery code, the thought occurred to
> me: in V5 filesystems we use log sequence number (LSN) tracking to avoid
> replaying older metadata updates against newer log items.  However, we
> use the magic number of the ondisk buffer to find the LSN of the ondisk
> metadata, which means that if an attacker can control the layout of the
> realtime device precisely enough that the start of an rt bitmap block
> matches the magic and UUID of some other kind of block, they can control
> the purported LSN of that spoofed block and thereby break log replay.

That'd take some effort, especially to crash the system at the point
where it is active in the log...

> Since realtime bitmap and summary blocks don't have headers at all, we
> have no way to tell if a block really should be replayed.  The best we
> can do is replay unconditionally and hope for the best.
> 
> XXX: Won't this leave us with a corrupt rtbitmap if recovery also fails?
> In other words, the usual problems that happen when you /don't/ track
> buffer age with LSNs?  I've noticed that the recoveryloop tests get hung
> up on incorrect frextents after a few iterations, but have not had time
> to figure out if the rtbitmap recovery is wrong, or if there's something
> broken with the old-style summary updates for rt counters.

If we don't track the age of the buffers then replay will always
replay over the top of newer metadata. In general, this isn't a huge
problem for buffer replay as long as recovery always completes
fully.  If recovery always completes fully, the result should be the
same or newer metadata on disk than was previously on disk, even if
we started from older metadata in the journal. Speaking generally,
the LSN ordering really only makes recovery a bit more efficient by
allowing it to elide writeback of modifications that are already on
disk.

That said there some complex interactions between different types of
objects and the recovery of them that LSN ordering addresses. Such
as inodes being logged by buffer at allocation and unlink, but by
log_dinodes for all other modifications. replacing the flush
iteration in inodes because they can be logged and written back at
the same time. And there were some rare, subtle recovery corruptions
around these interactions that were solved by ensuring LSN ordering
was enforced.

The LSN ordering allows us to do fault analysis across log
recovery when we have inconsistencies between related objects such
as inodes, BMBT blocks and free space. I've been using this latter
relationship between log recovery and metadata writeback a *lot*
over the past couple of weeks.

So, really, the LSN order tracking largely doesn't matter when
everything is working as it should, and so always recovering a
RT bitmap buffer should not actually introduce any corruptions
except when log recoveyr fails. In which case, we already have an
inconsistent filesystem and need to reapir it...

> XXXX: Maybe someone should fix the ondisk format to track the (magic,
> blkno, lsn, uuid) like we do everything else in V5?  That's gonna suck
> for 64-bit divisions...

I largely avoided changing the rt bitmap format to add headers and
CRCs largely because it requires expensive rework of the extent to
bitmap indexing mechanism. I'm still not sure if we gain anything
from adding it now.

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_buf_item_recover.c |   32 +++++++++++++++++++++++++-------
>  1 file changed, 25 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 05fd816edf59..a776bcfdf0c1 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -698,19 +698,29 @@ xlog_recover_do_inode_buffer(
>  static xfs_lsn_t
>  xlog_recover_get_buf_lsn(
>  	struct xfs_mount	*mp,
> -	struct xfs_buf		*bp)
> +	struct xfs_buf		*bp,
> +	struct xfs_buf_log_format *buf_f)
>  {
>  	uint32_t		magic32;
>  	uint16_t		magic16;
>  	uint16_t		magicda;
>  	void			*blk = bp->b_addr;
>  	uuid_t			*uuid;
> -	xfs_lsn_t		lsn = -1;
> +	uint16_t		blft;
> +	xfs_lsn_t		lsn = NULLCOMMITLSN;

I'd drop the -1 to NULLCOMMITLSN from the patch - it's not really
part of the bug fix...

Otherwise I think the change looks OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
