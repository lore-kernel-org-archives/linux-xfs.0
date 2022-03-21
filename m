Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8BAC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 22:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiCUWwU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 18:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiCUWwL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 18:52:11 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8615C3D8B3F
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 15:41:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 40013533776;
        Tue, 22 Mar 2022 09:41:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nWQiJ-008HnX-Co; Tue, 22 Mar 2022 09:41:23 +1100
Date:   Tue, 22 Mar 2022 09:41:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: shutdown in intent recovery has non-intent
 items in the AIL
Message-ID: <20220321224123.GK1544202@dread.disaster.area>
References: <20220321012329.376307-1-david@fromorbit.com>
 <20220321012329.376307-3-david@fromorbit.com>
 <20220321215236.GK8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321215236.GK8224@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6238ff15
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=4v67lGCmLuo1e8ycD80A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 02:52:36PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 21, 2022 at 12:23:29PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > generic/388 triggered a failure in RUI recovery due to a corrupted
> > btree record and the system then locked up hard due to a subsequent
> > assert failure while holding a spinlock cancelling intents:
> > 
> >  XFS (pmem1): Corruption of in-memory data (0x8) detected at xfs_do_force_shutdown+0x1a/0x20 (fs/xfs/xfs_trans.c:964).  Shutting down filesystem.
> >  XFS (pmem1): Please unmount the filesystem and rectify the problem(s)
> >  XFS: Assertion failed: !xlog_item_is_intent(lip), file: fs/xfs/xfs_log_recover.c, line: 2632
> >  Call Trace:
> >   <TASK>
> >   xlog_recover_cancel_intents.isra.0+0xd1/0x120
> >   xlog_recover_finish+0xb9/0x110
> >   xfs_log_mount_finish+0x15a/0x1e0
> >   xfs_mountfs+0x540/0x910
> >   xfs_fs_fill_super+0x476/0x830
> >   get_tree_bdev+0x171/0x270
> >   ? xfs_init_fs_context+0x1e0/0x1e0
> >   xfs_fs_get_tree+0x15/0x20
> >   vfs_get_tree+0x24/0xc0
> >   path_mount+0x304/0xba0
> >   ? putname+0x55/0x60
> >   __x64_sys_mount+0x108/0x140
> >   do_syscall_64+0x35/0x80
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> > 
> > Essentially, there's dirty metadata in the AIL from intent recovery
> > transactions, so when we go to cancel the remaining intents we assume
> > that all objects after the first non-intent log item in the AIL are
> > not intents.
> > 
> > This is not true. Intent recovery can log new intents to continue
> > the operations the original intent could not complete in a single
> > transaction. The new intents are committed before they are deferred,
> > which means if the CIL commits in the background they will get
> > inserted into the AIL at the head.
> 
> Like you, I wonder how I never hit this.  Maybe I've never hit a
> corrupted rmap btree record during recovery?
> 
> So I guess what we're tripping over is a sequence of items in the AIL
> that looks something like this?
> 
> 0. <recovered non intent items>
> 1. <recovered intent item>
> 2. <new non-intent item>
> 3. <new intent items>

Mostly correct, but not quite. At the end of the first phase of
recovery (i.e. reading the log and extracting/recovering individual
items), the AIL looks like this:

0. <incomplete recovered intents>

It has nothing else in it, just the intents that need recovery.

In the second phase of recovery, we start processing those intents,
walking the above list and calling ->recover on them. IIUC,
recovering a BUI can create CUI and RUI intents, recovering a CUI
can create both RUI and EFI intents, and recovering a RUI can create
EFI intents.

Now, processing these newly created chained intents is deferred
after committing them to the *CIL*, so only the initial intents in 0
above are replayed because we check the AIL contents again. If there
is enough space in the journal and CIL to aggregate all these new
intents and objects, they will never reach the AIL before the
initial intent recovery has completed, and the check will never
fail.  Hence I think the actual logged contents check is rarely, if
ever, run properly because nothing has reached the AIL in normal
cases.

However, if the CIL -ever- commits during intent processing, then
the AIL check is completely invalid - the AIL can contain buffers,
inodes, new intents, etc in any order:

0. <incomplete recovered intents>
1. <non intent items>
2. <new chained/deferred intents>
3. <non intent items>
4. <new chained/deferred intents>
5. <non intent items>
....

> So we speed along the AIL list, dealing with the <0> items until we get
> to <1>.  We recover <1>, which generates <2> and <3>.  Next, the
> debugging code thinks we've hit the end of the list of recovered items,
> and therefore it can keep walking the AIL and that it will only find
> items like <2>.  Unfortunately, it finds the new intent <3> and trips?

Effectively, yes.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-- 
Dave Chinner
david@fromorbit.com
