Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9D7C433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Jan 2022 05:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiAHFkS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Jan 2022 00:40:18 -0500
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:6277 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229708AbiAHFkR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Jan 2022 00:40:17 -0500
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 933E9800C56
        for <linux-xfs@vger.kernel.org>; Sat,  8 Jan 2022 05:40:16 +0000 (UTC)
Received: from pdx1-sub0-mail-a305.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 0EC19800D20
        for <linux-xfs@vger.kernel.org>; Sat,  8 Jan 2022 05:40:16 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from pdx1-sub0-mail-a305.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.96.96.18 (trex/6.4.3);
        Sat, 08 Jan 2022 05:40:16 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Belong-Inform: 614131f55ede43da_1641620416283_3453432421
X-MC-Loop-Signature: 1641620416283:895123263
X-MC-Ingress-Time: 1641620416282
Received: from kmjvbox (c-98-207-114-56.hsd1.ca.comcast.net [98.207.114.56])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kjlx@templeofstupid.com)
        by pdx1-sub0-mail-a305.dreamhost.com (Postfix) with ESMTPSA id 4JW87M3xQmz1PW
        for <linux-xfs@vger.kernel.org>; Fri,  7 Jan 2022 21:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=templeofstupid.com;
        s=templeofstupid.com; t=1641620415; bh=4q8Y0nifPBqZcMIaY9IBh9VAerk=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=qRooRgIZkp0dASgLBhPHAXM8zJagHp8yYlMB8ewQqZq3ehC/tNwmtljV4w1BYUsHL
         EQ4HxYq9rQlp57s0KIdFdsX6uvEoXUFSaSiXf+gTqWSU6XXPgbtSxi5zVNyDwEvXXw
         H9mOsUAc3f/WntGJ+rfH38AnYV2CxVPLlbiO6/Dw=
Received: from johansen (uid 1000)
        (envelope-from kjlx@templeofstupid.com)
        id e0061
        by kmjvbox (DragonFly Mail Agent v0.9);
        Fri, 07 Jan 2022 21:40:14 -0800
Date:   Fri, 7 Jan 2022 21:40:14 -0800
From:   Krister Johansen <kjlx@templeofstupid.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_bmap_extents_to_btree allocation warnings
Message-ID: <20220108054014.GA3611@templeofstupid.com>
References: <20220105071052.GD20464@templeofstupid.com>
 <20220106010123.GP945095@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106010123.GP945095@dread.disaster.area>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Thu, Jan 06, 2022 at 12:01:23PM +1100, Dave Chinner wrote:
> On Tue, Jan 04, 2022 at 11:10:52PM -0800, Krister Johansen wrote:
> > Hi,
> > I've been running into occasional WARNs related to allocating a block to
> > hold the new btree that XFS is attempting to create when calling this
> > function.  The problem is sporadic -- once every 10-40 days and a
> > different system each time.
> 
> The warning is:
> 
> > WARNING: CPU: 4 PID: 115756 at fs/xfs/libxfs/xfs_bmap.c:716 xfs_bmap_extents_to_btree+0x3dc/0x610 [xfs]
> > RIP: 0010:xfs_bmap_extents_to_btree+0x3dc/0x610 [xfs]
> > Call Trace:
> >  xfs_bmap_add_extent_hole_real+0x7d9/0x8f0 [xfs]
> >  xfs_bmapi_allocate+0x2a8/0x2d0 [xfs]
> >  xfs_bmapi_write+0x3a9/0x5f0 [xfs]
> >  xfs_iomap_write_direct+0x293/0x3c0 [xfs]
> >  xfs_file_iomap_begin+0x4d2/0x5c0 [xfs]
> >  iomap_apply+0x68/0x160
> >  iomap_dio_rw+0x2c1/0x450
> >  xfs_file_dio_aio_write+0x103/0x2e0 [xfs]
> >  xfs_file_write_iter+0x99/0xe0 [xfs]
> >  new_sync_write+0x125/0x1c0
> >  __vfs_write+0x29/0x40
> >  vfs_write+0xb9/0x1a0
> >  ksys_write+0x67/0xe0
> >  __x64_sys_write+0x1a/0x20
> >  do_syscall_64+0x57/0x190
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 

<snip>
 
> So 1,871,665 of 228,849,020 blocks free in the AG. That's 99.2%
> full, so it's extremely likely you are hitting a full AG condition.
> 
> /me goes and looks at xfs_iomap_write_direct()....
> 
> .... and notices that it passes "0" as the total allocation block
> count, which means it isn't reserving space in the AG for both the
> data extent and the BMBT blocks...
> 
> ... and several other xfs_bmapi_write() callers have the same
> issue...
> 
> Ok, let me spend a bit more looking into this in more depth, but it
> looks like the problem is at the xfs_bmapi_write() caller level, not
> deep in the allocator itself.

I noodled on this a bit more and have another hypothesis.  Feel free to
tell me that this one is just as nuts (or more).  However, after
thinking through your comments about the accounting, and reviewing some
other patches and threads for similar problems:

https://lore.kernel.org/linux-xfs/20171127202434.43125-4-bfoster@redhat.com/
https://lore.kernel.org/linux-xfs/20171207185810.48757-1-bfoster@redhat.com/
https://lore.kernel.org/linux-xfs/20190327145000.10756-1-bfoster@redhat.com/

I wondered if perhaps the problem was related to other problems in
xfs_alloc_fix_freelist.  Taking inspiration from some of the fixes that
Brian made here, it looks like there's a possibility of the freelist
refill code grabbing blocks that were assumed to be available by
previous checks in that function.

For example, using some values from a successful trace of a directio
allocation:

              dd-102227  [027] .... 4969662.381037: xfs_alloc_near_first: dev 25
3:1 agno 0 agbno 5924 minlen 4 maxlen 4 mod 0 prod 1 minleft 1 total 8 alignment
 4 minalignslop 0 len 4 type NEAR_BNO otype START_BNO wasdel 0 wasfromfl 0 resv
0 datatype 0x9 firstblock 0xffffffffffffffff

              dd-102227  [027] .... 4969662.381047: xfs_alloc_near_first: dev 25
3:1 agno 0 agbno 5921 minlen 1 maxlen 1 mod 0 prod 1 minleft 0 total 0 alignment
 1 minalignslop 0 len 1 type NEAR_BNO otype NEAR_BNO wasdel 0 wasfromfl 0 resv 0
 datatype 0x0 firstblock 0x1724

[first is the bmap alloc, second is the extents_to_btree alloc]
 
if agflcount = min(pagf_flcount, min_free)
   agflcount = min(3, 8)

and available = pagf_freeblks + agflcount - reservation - min_free - minleft
    available = 14 + 3 - 0 - 8 - 1

    available = 8

which satisfies the total from the first allocation request; however, if
this code path needs to refill the freelists and the ag btree is full
because a lot of space is allocated and not much is free, then inserts
here may trigger rebalances.  Usage might look something like this:

   pagf_freeblks = 14
   allocate 5 blocks to fill freelist
   pags_freeblks = 9
   fill of freelist triggers split that requires 4 nodes
   next iteration allocates 4 blocks to refill freelist
   pages_freeblks = 5
   refill requires rebalance and another node
   next iteration allocates 1 block to refill freelist
   pages_freeblks = 4
   freelist filled; return to caller

   caller consumes remaining 4 blocks for bmap allocation

   pages_freeblks = 0

   no blocks available for xfs_bmap_extents_to_btree

I'm not sure if this is possible, but I thought I'd mention it since
Brian's prior work here got me thinking about it.  If this does sound
plausible, what do you think about re-validating the space_available
conditions after refilling the freelist?  Something like:

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 353e53b..d235744 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2730,6 +2730,16 @@ xfs_alloc_fix_freelist(
 		}
 	}
 	xfs_trans_brelse(tp, agflbp);
+
+	/*
+	 * Freelist refill may have consumed blocks from pagf_freeblks.  Ensure
+	 * that this allocation still meets its requested constraints by
+	 * revalidating the min_freelist and space_available checks.
+	 */
+	need = xfs_alloc_min_freelist(mp, pag);
+	if (!xfs_alloc_space_available(args, need, flags))
+		goto out_agbp_relse;
+
 	args->agbp = agbp;
 	return 0;
 
perhaps?


Thanks again,

-K
