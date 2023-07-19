Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B87FEB64DC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 01:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjGSBoR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 21:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjGSBoQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 21:44:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED3E1BCD
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 18:44:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 488E761680
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 01:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A46C433C8;
        Wed, 19 Jul 2023 01:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689731054;
        bh=V0zteiBiMI30pen05CQ7TxQtcTDFs7UdwJhM3zmEw/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NMjrkiusH3kqm79tm5R4WsjAMe5asaBjOD+NKW0DSzdGlsOTNdoVASEauvAlrM06z
         k60VSr5ze4SR0t/IJ4MzuNAyLlcnM9juh/QVfcxcjX2BrD5wi/32yulkpX1DAPExTV
         qAhl2rfYUwPTyDOn0bS/2MrkvwfTfIUL47//cqMPCNbhB6JNFh+a516QL8GmbRRPqT
         qsJycW3WVa4qc9tcs6mLC+8s3G4SDO5EkaGQxCpmCJ/w4xLgsdqGZmxDil3hoMy83m
         dIeVuqoNvW/dw0cRZyiaoHLbwM+YVv3M0MkzgruemFJFJZwoFEgmcQLL8ZgjEq8Sma
         y32PwRT07GIhQ==
Date:   Tue, 18 Jul 2023 18:44:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Message-ID: <20230719014413.GC11352@frogsfrogsfrogs>
References: <1DB9F8BB-4A7C-4422-B447-90A08E310E17@oracle.com>
 <ZLcqF2/7ZBI44C65@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZLcqF2/7ZBI44C65@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 19, 2023 at 10:11:03AM +1000, Dave Chinner wrote:
> On Tue, Jul 18, 2023 at 10:57:38PM +0000, Wengang Wang wrote:
> > Hi,
> > 
> > I have a XFS metadump (was running with 4.14.35 plussing some back ported patches),
> > mounting it (log recover) hang at log space reservation. There is 181760 bytes on-disk
> > free journal space, while the transaction needs to reserve 360416 bytes to start the recovery.
> > Thus the mount hangs for ever.
> 
> Most likely something went wrong at runtime on the 4.14.35 kernel
> prior to the crash, leaving the on-disk state in an impossible to
> recover state. Likely an accounting leak in a transaction
> reservation somewhere, likely in passing the space used from the
> transaction to the CIL. We've had bugs in this area before, they
> eventually manifest in log hangs like this either at runtime or
> during recovery...
> 
> > That happens with 4.14.35 kernel and also upstream
> > kernel (6.4.0).
> 
> Upgrading the kernel won't fix recovery - it is likely that the
> journal state on disk is invalid and so the mount cannot complete 

Hmm.  It'd be nice to know what the kernel thought it was doing when it
went down.

/me wonders if this has anything to do with the EFI recovery creating a
transaction with tr_itruncate reservation because the log itself doesn't
record the reservations of the active transactions.

<begin handwaving>

Let's say you have a 1000K log, a tr_write reservation is 100k, and a
tr_itruncate reservations are 300k.  In this case, you could
theoretically have 10x tr_write transactions running concurrently; or
you could have 3x tr_itruncate transactions running concurrently.

Now let's say that someone fires up 10 programs that try to fpunch 10
separate files.  Those ten threads will consume all the log grant space,
unmap a block, and log an EFI.  I think in reality tr_logcount means
that 5 threads each consume (2*100k) grant space, but the point here is
that we've used up all the log grant space.

Then crash the system, having committed the first transaction of the
two-transaction chain.

Upon recovery, we'll find the 10x unfinished EFIs and pass them to EFI
recovery.  However, recovery creates a separate tr_itruncate transaction
to finish each EFI.  Now do we have a problem because the required log
grant space is 300k * 10 = 3000k?

It's late and I don't remember how recovery for non-intent items works
quite well enough to think that scenario adds up.  Maybe it was the case
that before the system went down, the log had used 800K of the grant
space for logged buffers and 100K for a single EFI logged in a tr_write
transaction.  Then we crashed, reloaded the 800K of stuff, and now we're
trying to allocate 300K for a tr_itruncate to restart the EFI, but
there's not enough log grant space?

<muggawuggamuggawugga>

--D

> > The is the related stack dumping (6.4.0 kernel):
> > 
> > [<0>] xlog_grant_head_wait+0xbd/0x200 [xfs]
> > [<0>] xlog_grant_head_check+0xd9/0x100 [xfs]
> > [<0>] xfs_log_reserve+0xbc/0x1e0 [xfs]
> > [<0>] xfs_trans_reserve+0x138/0x170 [xfs]
> > [<0>] xfs_trans_alloc+0xe8/0x220 [xfs]
> > [<0>] xfs_efi_item_recover+0x110/0x250 [xfs]
> > [<0>] xlog_recover_process_intents.isra.28+0xba/0x2d0 [xfs]
> > [<0>] xlog_recover_finish+0x33/0x310 [xfs]
> > [<0>] xfs_log_mount_finish+0xdb/0x160 [xfs]
> > [<0>] xfs_mountfs+0x51c/0x900 [xfs]
> > [<0>] xfs_fs_fill_super+0x4b8/0x940 [xfs]
> > [<0>] get_tree_bdev+0x193/0x280
> > [<0>] vfs_get_tree+0x26/0xd0
> > [<0>] path_mount+0x69d/0x9b0
> > [<0>] do_mount+0x7d/0xa0
> > [<0>] __x64_sys_mount+0xdc/0x100
> > [<0>] do_syscall_64+0x3b/0x90
> > [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> > 
> > Thus we can say 4.14.35 kernel didn’t reserve log space at IO time to make log recover
> > safe. Upstream kernel doesn’t do that either if I read the source code right (I might be wrong).
> 
> Sure they do.
> 
> Log space usage is what the grant heads track; transactions are not
> allowed to start if there isn't both reserve and write grant head
> space available for them, and transaction rolls get held until there
> is write grant space available for them (i.e. they can block in
> xfs_trans_roll() -> xfs_trans_reserve() waiting for write grant head
> space).
> 
> There have been bugs in the grant head accounting mechanisms in the
> past, there may well still be bugs in it. But it is the grant head
> mechanisms that is supposed to guarantee there is always space in
> the journal for a transaction to commit, and by extension, ensure
> that we always have space in the journal for a transaction to be
> fully recovered.
> 
> > So shall we reserve proper amount of log space at IO time, call it Unflush-Reserve, to
> > ensure log recovery safe?  The number of UR is determined by current un flushed log items.
> > It gets increased just after transaction is committed and gets decreased when log items are
> > flushed. With the UR, we are safe to have enough log space for the transactions used by log
> > recovery.
> 
> The grant heads already track log space usage and reservations like
> this. If you want to learn more about the nitty gritty details, look
> at this patch set that is aimed at changing how the grant heads
> track the used/reserved log space to improve performance:
> 
> https://lore.kernel.org/linux-xfs/20221220232308.3482960-1-david@fromorbit.com/
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
