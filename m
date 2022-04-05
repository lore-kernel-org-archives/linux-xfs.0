Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A60C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 02:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbiDFCyn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 22:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452315AbiDEPyp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 11:54:45 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228DB1A810
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 07:52:28 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id p15so23687074lfk.8
        for <linux-xfs@vger.kernel.org>; Tue, 05 Apr 2022 07:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=apN/3SIR1SIXwSVZkY9NizgUyV+9RYTdDNzCwDuc+TE=;
        b=j8Hd7rQD3E+a8ZklQtld3Px/xgx/PeS1MHcA2NGqOBmdV7GwBUQ5mgOADccBIjJB8W
         hoAxZjUTlsvrFYrPCavKbS1ES57LEqd11fq3TxDbGizENqcR94mdJIY8kpE4o159R+ke
         588DG416nnNUD7nTuYTY6hCWyOqqwOsHqln50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=apN/3SIR1SIXwSVZkY9NizgUyV+9RYTdDNzCwDuc+TE=;
        b=kXUjESxU4fAXS5p2wO4cuCcDAY5ZZmjjWZrgkaDDBr05LFXzI1dwVqzORnTVMHsJRc
         1QA2tvhKUQtx1XII2Z3i/7fCyW9o+jE883G1Ywtp1Xm+snCDpdrKT8maDLIMppbsLB7X
         tyoXd2UL8YPyiaqSpAzN2oO/qePOtVRvNy5NBDsLGZChJ/7V7IGjze7PSuEEE8EZHGAt
         GnZqDAwMw7+iVeuYhML0ZL8FFFJBajpHWtcbCqY7oeDKtcIAaNMpei3YQr43kuDwB05z
         Ea0qBM7tEqf3CdOXM1gkMfi8WpEMcqxP6bcQf6HVORJiceZ24NemcFys4u5F7JABUWKZ
         BD8g==
X-Gm-Message-State: AOAM531gnE70ylWdBx1bOUdufHdJmKl8nfVaqyNaBzNqEIGeSdKVq4M0
        mzY5d0kitlVaIZSNLadhtr8nJ/BBvAon0Ff2JmzbuQ==
X-Google-Smtp-Source: ABdhPJzZY9tG+J5WhMP3FrgHr31/LqPF2lHKy+n6qXtNvJskTHgZoZeW877VLmbvAS6XCFh4G3qApSHNO+kCNovHsiE=
X-Received: by 2002:a05:6512:151c:b0:45c:6b70:c892 with SMTP id
 bq28-20020a056512151c00b0045c6b70c892mr2860562lfb.124.1649170346963; Tue, 05
 Apr 2022 07:52:26 -0700 (PDT)
MIME-Version: 1.0
References: <CABEBQikRSCuJumOYmgzNLN6dOZ+YUvOQMFby7WJGSwGoFM3YMg@mail.gmail.com>
 <20220404232204.GT1544202@dread.disaster.area>
In-Reply-To: <20220404232204.GT1544202@dread.disaster.area>
From:   Frank Hofmann <fhofmann@cloudflare.com>
Date:   Tue, 5 Apr 2022 15:52:15 +0100
Message-ID: <CABEBQi=xJMDwCTvQB4mq1Wvpxues9MGbr9M7=k_BW+jpnarPJQ@mail.gmail.com>
Subject: Re: Self-deadlock (?) in xfs_inodegc_worker / xfs_inactive ?
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 5, 2022 at 12:22 AM Dave Chinner <david@fromorbit.com> wrote:
>

Hi Dave,

thank you for the quick reply. See inline/below. Will test the patch
and report back.

> On Mon, Apr 04, 2022 at 02:16:23PM +0100, Frank Hofmann wrote:
> > Hi,
> >
> > we see machines getting stuck with a large number of backed-up
> > processes that invoke statfs() (monitoring stuff), like:
> >
> > [Sat Apr  2 09:54:32 2022] INFO: task node_exporter:244222 blocked for
> > more than 10 seconds.
> > [Sat Apr  2 09:54:32 2022]       Tainted: G           O
> > 5.15.26-cloudflare-2022.3.4 #1
>
> Is this a vanilla kernel, or one that has been patched extensively
> by cloudflare?

Probably best to say "by and large vanilla". We carry a single-digit
number of non-mainlined feature and driver patches that our product
and infrastructure relies on (network code features and drivers). But
we do not usually modify either kernel, mm, fs or arch subtrees at
all. We sometimes backport certain (security) changes before
linux-stable gets them "ordinarily". Our 5.15.26 has no changes in mm,
fs, arch at all, vs. linux-stable.

>
[ ... ]
>
> Waiting for background inode gc to complete.

ack.

>
> > A linear-over-time increasing number of 'D' state processes is usually
> > what alerts us to this.
> >
> > The oldest thread found waiting appears always to be the inode gc
> > worker doing deferred inactivation:
>
> OK.
>
> > This is a histogram (first column: number of proceses 'D'-ed on that
> > call trace) of `/proc/<PID>/stack`:
>
> It helps greatly if you reformat the stacks back to a readable stack
> (s/=>/\r/g, s/^\n//, s/^ //) so the output is easily readable.

Apologies; my awk script to grab these turns them around for the
counting, will change the output when I post such again.

>
> > 1 stuck on AGF, holding AGI, inode and inode buffer locks
> >
> > down+0x43/0x60
> > xfs_buf_lock+0x29/0xa0
> > xfs_buf_find+0x2c4/0x590
[ ... ]
> > xfs_ifree+0xca/0x4a0
> > xfs_inactive_ifree.isra.0+0x9e/0x1a0
> > xfs_inactive+0xf8/0x170
> > xfs_inodegc_worker+0x73/0xf0
> > process_one_work+0x1e6/0x380
> > worker_thread+0x50/0x3a0
> > kthread+0x127/0x150
> > ret_from_fork+0x22/0x30
> >
> > 1     stuck on inode buffer, holding inode lock, holding AGF
> >
> > down+0x43/0x60
> > xfs_buf_lock+0x29/0xa0
[ ... ]
> > xfs_map_blocks+0x1b5/0x400
> > iomap_do_writepage+0x11d/0x820
> > write_cache_pages+0x189/0x3e0
> > iomap_writepages+0x1c/0x40
> > xfs_vm_writepages+0x71/0xa0
> > do_writepages+0xc3/0x1e0
[ ... ]


I've actually dug through our archives, and found one of these that
occurred in 5.10.53, with:

down+0x3b/0x50
xfs_buf_lock+0x2c/0xb0
xfs_buf_find+0x2c4/0x590
xfs_buf_get_map+0x44/0x270
xfs_buf_read_map+0x52/0x270
xfs_trans_read_buf_map+0x126/0x290
xfs_read_agf+0x87/0x110
xfs_alloc_read_agf+0x33/0x180
xfs_alloc_fix_freelist+0x32d/0x450
xfs_alloc_vextent+0x231/0x440
__xfs_inobt_alloc_block.isra.0+0xc1/0x1a0
__xfs_btree_split+0xef/0x660
xfs_btree_split+0x4b/0x100
xfs_btree_make_block_unfull+0x193/0x1c0
xfs_btree_insrec+0x49d/0x590
xfs_btree_insert+0xa8/0x1f0
xfs_difree_finobt+0xae/0x250
xfs_difree+0x121/0x190
xfs_ifree+0x79/0x150
xfs_inactive_ifree+0xa8/0x1c0
xfs_inactive+0x9e/0x140
xfs_fs_destroy_inode+0xa8/0x1a0
destroy_inode+0x3b/0x70
do_unlinkat+0x1db/0x2f0
do_syscall_64+0x33/0x40
entry_SYSCALL_64_after_hwframe+0x44/0xa9

for the caller of xfs_ifree(), and

down+0x3b/0x50
xfs_buf_lock+0x2c/0xb0
xfs_buf_find+0x2c4/0x590
xfs_buf_get_map+0x44/0x270
xfs_buf_read_map+0x52/0x270
xfs_trans_read_buf_map+0x126/0x290
xfs_imap_to_bp+0x61/0xb0
xfs_trans_log_inode+0x19f/0x250
xfs_bmap_btalloc+0x75c/0x830
xfs_bmapi_allocate+0xe4/0x310
xfs_bmapi_convert_delalloc+0x240/0x470
xfs_map_blocks+0x1b3/0x400
iomap_do_writepage+0x15e/0x870
write_cache_pages+0x186/0x3d0
iomap_writepages+0x1c/0x40
xfs_vm_writepages+0x59/0x80
do_writepages+0x34/0xc0
__writeback_single_inode+0x37/0x290
writeback_sb_inodes+0x1ed/0x430
__writeback_inodes_wb+0x4c/0xd0
wb_writeback+0x1d6/0x290
wb_workfn+0x292/0x4d0
process_one_work+0x1ab/0x340
worker_thread+0x50/0x3a0
kthread+0x11b/0x140
ret_from_fork+0x22/0x30

for the writeback worker.


> That's the deadlock right there.

And yes, you're right the async inode gc doesn't appear to be
necessary; the above looks like the same deadlock you describe -
without the inode gc changes.

>
[ ... ]
> So this has nothing to do with background inode inactivation. It may
> have made it easier to hit, but it's definitely not *caused* by
> background inodegc as these two operations have always been able to
> run concurrently.
>
> The likely cause is going to be the async memory reclaim work from
> late June 2020. Commit 298f7bec503f ("xfs: pin inode backing buffer
> to the inode log item") added the xfs_imap_to_bp() call to
> xfs_trans_log_inode() to pin the inode cluster buffer in memory when
> the inode was first dirtied.

We've been seeing these "for a while" but the rate of occurrence
didn't use to be high (0.01% of systems encountering it once a week).
At the moment, we see it around ten times as frequently as that.
Will work on a reproducer and see how that goes.


>
> Essentially, the problem is that inode unlink list manipulations are
> not consistently ordered with inode allocation/freeing, hence not
> consistently ordered against AGI and AGF locking. I didn't realise
> that there was an AGF component to this problem, otherwise I would
> have sent this patch upstream much sooner:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git/commit/?h=xfs-iunlink-item-2&id=17b71a2fba3549ea55e8bef764532fd42be1213a
>
> That commit is dated August 2020 - about the same time that the
> async memory reclaim stuff was merged. What this will do is:
[ ... ]
> And so the deadlock should go away.
>
> I've attached the current patch from my local dev tree below. Can
> you try it and see if the problem goes away?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
[ ... ]

We'll give it a spin for sure !
As said, unless I can write a testcase/reproducer, it'll have to soak
a few weeks to give us the confidence it's "done it".

Thank you for the fast response,
Frank Hofmann
