Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60CBC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 00:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239731AbiEKAhO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 20:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiEKAhN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 20:37:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF7A5996E
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 17:37:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8075B82023
        for <linux-xfs@vger.kernel.org>; Wed, 11 May 2022 00:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A651C385D3;
        Wed, 11 May 2022 00:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652229429;
        bh=7aGRwnyqAlqg04tC3dmT/0OTzGzJTswCWazULQtFn4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RQiGiHFM2gJYQ/Y/5CZgpa5sDvzlPNf/t0efmJt082Y45zIBMfx0CHVGJzf/NAp8x
         lM2muZeeQzr6kwAa/U/VYyjp/E3br78nKcm0yTqotbZpPwiVJWFDCzKjkJSLk7go3f
         l3Q93pOOrw2CvSocl3H4jYAblt7zS9yhiMX/kIcVbsB5csMsniALxHet4lgctP1keS
         tSs2fnY9HMrn2n+EcrrVoJPE02bZiKS38AJj+lbdnlBGfz9Ixrydbg44RmQjaHZPzO
         Z3cT9Y19g6rGxBTTuTiMZX7WvR90w1M3hVTmIqnrQEQ/7XBq/LLR60qzW20UiZARSK
         VrlKwBVgM5Keg==
Date:   Tue, 10 May 2022 17:37:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chris Dunlop <chris@onthe.net.au>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: Highly reflinked and fragmented considered harmful?
Message-ID: <20220511003708.GA27195@magnolia>
References: <20220509024659.GA62606@onthe.net.au>
 <20220509230918.GP1098723@dread.disaster.area>
 <CAOQ4uxgf6AHzLM-mGte_L-A+piSZTRsbdLMBT3hZFNhk-yfxZQ@mail.gmail.com>
 <20220510051057.GY27195@magnolia>
 <20220510063051.GA215522@onthe.net.au>
 <20220510081632.GS1098723@dread.disaster.area>
 <20220510191918.GD27195@magnolia>
 <20220510215411.GT1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510215411.GT1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 11, 2022 at 07:54:11AM +1000, Dave Chinner wrote:
> On Tue, May 10, 2022 at 12:19:18PM -0700, Darrick J. Wong wrote:
> > On Tue, May 10, 2022 at 06:16:32PM +1000, Dave Chinner wrote:
> > > On Tue, May 10, 2022 at 04:30:51PM +1000, Chris Dunlop wrote:
> > > > On Mon, May 09, 2022 at 10:10:57PM -0700, Darrick J. Wong wrote:
> > > > > On Tue, May 10, 2022 at 07:07:35AM +0300, Amir Goldstein wrote:
> > > > > > On Mon, May 09, 2022 at 12:46:59PM +1000, Chris Dunlop wrote:
> > > > > > > Is it to be expected that removing 29TB of highly reflinked and fragmented
> > > > > > > data could take days, the entire time blocking other tasks like "rm" and
> > > > > > > "df" on the same filesystem?
> > > > ...
> > > > > > From a product POV, I think what should have happened here is that
> > > > > > freeing up the space would have taken 10 days in the background, but
> > > > > > otherwise, filesystem should not have been blocking other processes
> > > > > > for long periods of time.
> > > 
> > > Sure, that's obvious, and without looking at the code I know what
> > > that is: statfs()
> > > 
> > > > > Indeed.  Chris, do you happen to have the sysrq-w output handy?  I'm
> > > > > curious if the stall warning backtraces all had xfs_inodegc_flush() in
> > > > > them, or were there other parts of the system stalling elsewhere too?
> > > > > 50 billion updates is a lot, but there shouldn't be stall warnings.
> > > > 
> > > > Sure: https://file.io/25za5BNBlnU8  (6.8M)
> > > > 
> > > > Of the 3677 tasks in there, only 38 do NOT show xfs_inodegc_flush().
> > > 
> > > yup, 3677 tasks in statfs(). The majority are rm, df, and check_disk
> > > processes, there's a couple of veeamagent processes stuck and
> > > an (ostnamed) process, whatever that is...
> > > 
> > > No real surprises there, and it's not why the filesystem is taking
> > > so long to remove all the reflink references.
> > > 
> > > There is just one background inodegc worker thread running, so
> > > there's no excessive load being generated by inodegc, either. It's
> > > no different to a single rm running xfs_inactive() directly on a
> > > slightly older kernel and filling the journal:
> > > 
> > > May 06 09:49:01 d5 kernel: task:kworker/6:1     state:D stack:    0 pid:23258 ppid:     2 flags:0x00004000
> > > May 06 09:49:01 d5 kernel: Workqueue: xfs-inodegc/dm-1 xfs_inodegc_worker [xfs]
> > > May 06 09:49:01 d5 kernel: Call Trace:
> > > May 06 09:49:01 d5 kernel:  <TASK>
> > > May 06 09:49:01 d5 kernel:  __schedule+0x241/0x740
> > > May 06 09:49:01 d5 kernel:  schedule+0x3a/0xa0
> > > May 06 09:49:01 d5 kernel:  schedule_timeout+0x271/0x310
> > > May 06 09:49:01 d5 kernel:  __down+0x6c/0xa0
> > > May 06 09:49:01 d5 kernel:  down+0x3b/0x50
> > > May 06 09:49:01 d5 kernel:  xfs_buf_lock+0x40/0xe0 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_buf_find.isra.32+0x3ee/0x730 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_buf_get_map+0x3c/0x430 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_buf_read_map+0x37/0x2c0 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_trans_read_buf_map+0x1cb/0x300 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_btree_read_buf_block.constprop.40+0x75/0xb0 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_btree_lookup_get_block+0x85/0x150 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_btree_overlapped_query_range+0x33c/0x3c0 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_btree_query_range+0xd5/0x100 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_rmap_query_range+0x71/0x80 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_rmap_lookup_le_range+0x88/0x180 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_rmap_unmap_shared+0x89/0x560 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_rmap_finish_one+0x201/0x260 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_rmap_update_finish_item+0x33/0x60 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_defer_finish_noroll+0x215/0x5a0 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_defer_finish+0x13/0x70 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_itruncate_extents_flags+0xc4/0x240 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_inactive_truncate+0x7f/0xc0 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_inactive+0x10c/0x130 [xfs]
> > > May 06 09:49:01 d5 kernel:  xfs_inodegc_worker+0xb5/0x140 [xfs]
> > > May 06 09:49:01 d5 kernel:  process_one_work+0x2a8/0x4c0
> > > May 06 09:49:01 d5 kernel:  worker_thread+0x21b/0x3c0
> > > May 06 09:49:01 d5 kernel:  kthread+0x121/0x140
> > > 
> > > There are 18 tasks in destroy_inode() blocked on a workqueue flush
> > > - these are new unlinks that are getting throttled because that
> > > per-cpu inodegc queue is full and work is ongoing. Not a huge
> > > deal, maybe we should look to hand full queues to another CPU if
> > > the neighbour CPU has an empty queue. That would reduce
> > > unnecessary throttling, though it may mean more long running
> > > inodegc processes in the background....
> > > 
> > > Really, though, I don't see anything deadlocked, just a system
> > > backed up doing a really large amount of metadata modification.
> > > Everything is sitting on throttles or waiting on IO and making
> > > slow forwards progress as metadata writeback allows log space to be
> > > freed.
> > > 
> > > I think we should just accept that statfs() can never really report
> > > exactly accurate space usagei to userspace and get rid of the flush.
> > 
> > What about all the code that flushes gc work when we hit ENOSPC/EDQUOT?
> > Do we let those threads stall too because the fs is out of resources and
> > they can just wait?  Or would that also be better off with a flush
> > timeout and userspace can just eat the ENOSPC/EDQUOT after 30 seconds?
> 
> 1. Not an immediate problem we need to solve.
> 2. flush at enospc/edquot is best effort, so doesn't need to block
>    waiting on inodegc. the enospc/edquot flush will get repeated
>    soon enough, so that will take into account progress made by
>    long running inodegc ops.
> 3. we leave pending work on the per-cpu queues under the
>    flush/throttle thresholds indefinitely.
> 4. to be accurate, statfs() needs to flush #3.

Yes, that's the state of things currently...

> 5. While working on the rework of inode reclaimation, I converted the
>    inodegc queues to use delayed works to ensure work starts on
>    per-cpu queues within 10ms of queueing to avoid #3 causing
>    problems.
> 6. I added a non-blocking async flush mechanism that works by
>    modifying the queue timer to 0 to trigger immedate work
>    scheduling for anything that hasn't been run.

*OH*, you've already built those two things?  Well that makes this
/much/ easier.  I think all we'd need to fix #4 is an xfs_inodegc_push()
function that statfs/enospc/edquot can call to do xfs_inodegc_queue_all
and return immediately.

/me calms down, goes back to proofreading the online fsck design doc.

--D

> #4 is the problem that Chris hit - we're trying to be perfectly
> accurate when perfect accuracy is impossible and we're paying the
> price for that.
> 
> Fix #3, and the need to block statfs() largely goes away. And as per
> #2, we don't really need to block edquot/enospc flushes, either. We
> jsut need to push the queues to make sure they are running and doing
> work...
> 
> > > Work around the specific fstests dependencies on rm always
> > > immediately making unlinked inodes free space in fstests rather than
> > > in the kernel code.
> > 
> > <grumble> I *really* don't want to launch *yet another* full scale audit
> > of XFS + supporting software behavior on tiny and/or full filesystems.
> 
> This doesn't need an audit. Just fix the "single unlinks don't get
> processed until a flush occurs" problem, and most of the issues
> fstests has will go away.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
