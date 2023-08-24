Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A1AC7113B
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 22:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243781AbjHXWCC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 18:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243868AbjHXWCA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 18:02:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322D61BD4
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 15:01:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80D8C652E4
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 22:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05E7C433C7;
        Thu, 24 Aug 2023 22:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692914514;
        bh=tdiGdypFcU6x/OQs2YxEoPAVck2Euj6CyOuabEF1/Ig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DrtLqExF0j0bxeyI55O9J2yvAEgcjbyCFJY8c3kJEgnzqAjrl3SFC3Uei2HLGJqEB
         WuPoVxMlV7ehuDHXDX9O6OptS6Fzx0TdswePpWLgJQblCTVFPC5xEIwkSF5FnWn4FI
         VM5j0n4nisUdvptgmorD5URi8Y433Kxnd+i2LUyAyZgikGTeahffJLeceQsTOrQ1B/
         jpsfUOBnSbQi5Gkwz+/KfAPkfOXXVOUk+QrUzOSSs2rlVkpzQUeh5vTItTYAU+DTdB
         004G/Bw+aiSp1s1i90Lv1QQcSc9KADX5foIheGKb3n+6e6epHkujN5+wJBRAjAvFEf
         kwvh+Z/ihP7lA==
Date:   Thu, 24 Aug 2023 15:01:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Message-ID: <20230824220154.GA17912@frogsfrogsfrogs>
References: <20230719014413.GC11352@frogsfrogsfrogs>
 <ZLeBvfTdRbFJ+mj2@dread.disaster.area>
 <2A3BFAC0-1482-412E-A126-7EAFE65282E8@oracle.com>
 <ZL3MlgtPWx5NHnOa@dread.disaster.area>
 <2D5E234E-3EE3-4040-81DA-576B92FF7401@oracle.com>
 <ZMCcJSLiWIi3KBOl@dread.disaster.area>
 <BED64CCE-93D1-4110-B2C8-903A00D0013C@oracle.com>
 <3B6E1DAE-5191-4050-BE97-75B4D22BDE24@oracle.com>
 <20230824045234.GK11263@frogsfrogsfrogs>
 <ZOcGl/tujTv2MjEr@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZOcGl/tujTv2MjEr@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 24, 2023 at 05:28:23PM +1000, Dave Chinner wrote:
> On Wed, Aug 23, 2023 at 09:52:34PM -0700, Darrick J. Wong wrote:
> > On Fri, Aug 18, 2023 at 03:25:46AM +0000, Wengang Wang wrote:
> > 
> > Since xfs_efi_item_recover is only performing one step of what could be
> > a chain of deferred updates, it never rolls the transaction that it
> > creates.  It therefore only requires the amount of grant space that
> > you'd get with tr_logcount == 1.  It is therefore a bit silly that we
> > ask for more than that, and in bad cases like this, hang log recovery
> > needlessly.
> 
> But this doesn't fix the whatever problem lead to the recovery not
> having the same full tr_itruncate reservation available as was held
> by the transaction that logged the EFI and was running the extent
> free at the time the system crashed. There should -always- be enough
> transaction reservation space in the journal to reserve space for an
> intent replay if the intent recovery reservation uses the same
> reservation type as runtime.
> 
> Hence I think this is still just a band-aid over whatever went wrong
> at runtime that lead to the log not having enough space for a
> reservation that was clearly held at runtime and hadn't yet used.

Maybe I'm not remembering accurately how permanent log reservations
work.  Let's continue picking on tr_itruncate from Wengang's example.
IIRC, he said that tr_itruncate on the running system was defined
roughly like so:

tr_itruncate = {
	.tr_logres	= 180K
	.tr_logcount	= 2,
	.tr_logflags	= XFS_TRANS_PERM_LOG_RES,
}

At runtime, when we want to start a truncation update, we do this:

	xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, ...);

Call sequence: xfs_trans_alloc -> xfs_trans_reserve -> xfs_log_reserve
-> xlog_ticket_alloc.  Ticket allocation assigns tic->t_unit_res =
(tr_logres + overhead) and tic->t_cnt = tr_logcount.

(Let's pretend for the sake of argument that the overhead is 5K.)

Now xfs_log_reserve calls xlog_grant_head_check.  That does:

	*need_bytes = xlog_ticket_reservation(log, head, tic);

For the reserve head, the ticket reservation computation is
(tic->t_unit_res * tic->t_cnt), which in this case is (185K * 2) ==
370K, right?  So we make sure there's at least 370K free in the reserve
head, then add that to the reserve and write heads.

Now that we've allocated the transaction, delete the bmap mapping,
log an EFI to free the space, and roll the transaction as part of
finishing the deferops chain.  Rolling creates a new xfs_trans which
shares its ticket with the old transaction.  Next, xfs_trans_roll calls
__xfs_trans_commit with regrant == true, which calls xlog_cil_commit
with the same regrant parameter.

xlog_cil_commit calls xfs_log_ticket_regrant, which decrements t_cnt and
subtracts t_curr_res from the reservation and write heads.

If the filesystem is fresh and the first transaction only used (say)
20K, then t_curr_res will be 165K, and we give that much reservation
back to the reservation head.  Or if the file is really fragmented and
the first transaction actually uses 170K, then t_curr_res will be 15K,
and that's what we give back to the reservation.

Having done that, we're now headed into the second transaction with an
EFI and 185K of reservation, correct?

Now let's say the first transaction gets written to disk and we crash
without ever completing the second transaction.  Now we remount the fs,
log recovery finds the unfinished EFI, and calls xfs_efi_recover to
finish the EFI.  However, xfs_efi_recover starts a new tr_itruncate
tranasction, which asks for (185K * 2) == 370K of log reservation.
This is a lot more than the 185K that we had reserved at the time of the
crash.

Did I get all that right?

If so, what if prior to the crash, the system had many other threads
initiating much smaller transactions, say for mtime updates?  And what
if those threads consumed all the rest of the log reservation and pushed
those transactions out to disk after the first transaction in the
tr_itruncate chain?

Won't log recovery then find the log to contain (in order):

1. The first itruncate transaction and the EFI.
2. A bunch of mtime update transactions.
3. Approximately 185K of free space.

We can't move the log tail forward because we haven't dealt with the
EFI; there's only 185K of log space left to reserve; and xfs_efi_recover
wants 370K.  It's only going to take one step in the intent processing
chain and commit that step, so I don't see why the recovery transaction
needs more than one step's worth of log space.  Any subsequent steps in
the deferops chain get a new transaction later once we've unpinned the
log tail.

> > Which is exactly what you theorized above.  Ok, I'm starting to be
> > convinced... :)
> 
> I'm not. :/
> 
> > I wonder, if you add this to the variable declarations in
> > xfs_efi_item_recover (or xfs_efi_recover if we're actually talking about
> > UEK5 here):
> > 
> > 	struct xfs_trans_resv	resv = M_RES(mp)->tr_itruncate;
> > 
> > and then change the xfs_trans_alloc call to:
> > 
> > 	resv.tr_logcount = 1;
> > 	error = xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);
> > 
> > Does that solve the problem?
> 
> It might fix this specific case given the state of the log at the
> time the system crashed.

Yes.  There are running kernels out there that persist this situation
(bugs and all) in the ondisk log.  I know so, because the issue that
Wengang has been dealing with came from a customer.  IIRC, the customer
report stated that they were truncating some heavily fragmented sparse
files, the node stalled long enough that the node manager rebooted the
node, and when the node came back up, log recovery stalled because
that's what the running kernel had written to the log.

IOWs, I'm operating on an assumption that we have two problems to solve:
the runtime acconting bug that you've been chasing, and Wengang's where
log recovery asks for more log space than what had been in the log
ticket at the time of the crash.

> However, it doesn't help the general
> case where whatever went wrong at runtime results in there being
> less than a single tr_itruncate reservation unit available in the
> log.

I agree that this fix won't address the problem of how runtime got here
in the first place.

> One of the recent RH custom cases I looked at had much less than a
> single tr_itruncate unit reservation when it came to recovering the
> EFI, so I'm not just making this up.

I didn't think you were, I merely am not ready to decide that these
aren't separate problems. :)

> I really don't think this problem is not solvable at recovery time.
> if the runtime hang/crash leaves the EFI pinning the tail of the log
> and something has allowed the log to be overfull (i.e. log space
> used plus granted EFI reservation > physical log space), then we may
> not have any space at all for any sort of reservation during
> recovery.
> 
> I suspect that the cause of this recovery issue is the we require an
> overcommit of the log space accounting before we throttle incoming
> transaction reservations (i.e. the new reservation has to overrun
> before we throttle). I think that the reservation accounting overrun
> detection can race to the first item being placed on the wait list,

Yeah, I was wondering that myself when I was looking at the logic
between list_empty_careful and the second xlog_grant_head_wait and
wondering if that "careful" construction actually worked.

> which might allow transactions that should be throttled to escape
> resulting in a temporary log space overcommit. IF we crash at jsut
> the wrong time and an intent-in-progress pins the tail of the log,
> the overcommit situation can lead to recovery not having enough
> space for intent recovery reservations...
> 
> This subtle overcommit is one of the issues I have been trying to
> correct with the byte-based grant head accounting patches (which I'm
> -finally- getting back to). I know that replaying the log from the
> metadump that repoduces the hang with the byte-based grant head
> accounting patchset allowed log recovery to succeed. It has a
> different concept of where the head and tail are and hence how much
> log space is actually available at any given time, and that
> difference was just enough to allow a tr_itruncate reservation to
> succced. It also has different reservation grant overrun detection
> logic, but I'm not 100% sure if it solves this underlying runtime
> overcommit problem or not yet...

<nod>

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
