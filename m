Return-Path: <SRS0=E0aF=CS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB8BC433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 15:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3491A20672
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 15:39:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TN1u2vRk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgIIPis (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 11:38:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59805 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730416AbgIIPil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Sep 2020 11:38:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599665913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z4WLvIzZwpwTPzaRrJ1G9lhOx77srGve6/iwA8zYmiw=;
        b=TN1u2vRk85FT3Ytkm0IRELzSOyFby0zQqa1VQpo3nxbr+5BYe0ATCxRlHBflAHdAQHwizZ
        LgAbjB9WwGibTND9o8ccvm45hlE2HvWrg5lN3TMkxwhYUBd4TFYRVPjbhFp9DYjAONCKkB
        B3glBxitgnpUkrACmx8hyT+IfmBlVMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-CYmqQF9BOradQTjVzq4GIA-1; Wed, 09 Sep 2020 11:00:39 -0400
X-MC-Unique: CYmqQF9BOradQTjVzq4GIA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42C978027E2;
        Wed,  9 Sep 2020 15:00:38 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CDC8D60CC0;
        Wed,  9 Sep 2020 15:00:37 +0000 (UTC)
Date:   Wed, 9 Sep 2020 11:00:35 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: quotaoff, transaction quiesce, and dquot logging
Message-ID: <20200909150035.GC765129@bfoster>
References: <20200904155949.GF529978@bfoster>
 <20200904222936.GH12131@dread.disaster.area>
 <20200908155602.GB721341@bfoster>
 <20200908210720.GP12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908210720.GP12131@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 09, 2020 at 07:07:20AM +1000, Dave Chinner wrote:
> On Tue, Sep 08, 2020 at 11:56:02AM -0400, Brian Foster wrote:
> > On Sat, Sep 05, 2020 at 08:29:36AM +1000, Dave Chinner wrote:
> > > IOWs, the barrier mechanism I added was designed to provide the
> > > exact "no dquots are logged after the quotaoff item is committed to
> > > the log" invariant you describe. It's basically the same mechanism
> > > we use for draining direct IO via taking IOLOCKs to prevent new
> > > submissions and calling inode_dio_wait() to drain everything in
> > > flight....
> > > 
> > 
> > Right, I follow all of the above. I've been experimenting with an
> > approach that just freezes all transactions as opposed to only quota
> > transactions just to reduce the amount of code involved. What I'm trying
> > to point out is that I don't think this quotaoff logic alone is
> > sufficient to prevent dquot log ordering problems.
> > 
> > Consider the following example scenario:
> > 
> > - fs mounted w/ user+group quotas enabled
> > - inode 0x123 is in-core w/ user+group dquots already attached
> > - user executes 'xfs_quota -xc "off -g" <mnt>' to turn off group quotas
> > - quotaoff drains all outstanding transactions, clears (group) quota
> >   flag, logs quotaoff start/end ...
> > 
> > Meanwhile..
> > 
> > - user executes an fallocate request on inode 0x123, which blocks down
> >   in xfs_alloc_file_space() -> xfs_trans_alloc() due to the quotaoff in
> >   progress.
> > - quotaoff releases the trans barrier and begins doing its dquot
> >   flush/purge thing..
> > - falloc grabs the 0x123 ilock and xfs_trans_reserve_quota_bydquots() ->
> >   xfs_trans_dqresv() -> xfs_trans_mod_dquot() joins the user/group
> >   dquots to the transaction quota ctx because they are still attached to
> >   the inode at this point (and user quota is still enabled), hence quota
> >   blocks are reserved in both
> 
> There's the bug. The patch I wrote needs to ensure that the quotas
> are enabled when attaching the dquot to the dqinfo. The code
> currently checks for global "quota on" state, but it doesn't check
> individual quota state...
> 

Ok. I was surmising about something similar down in the commit path, but
it seems more appropriate to avoid attaching the dquot to the
transaction (and not doing any accounting, reservation or otherwise) in
the first place.

> > - xfs_trans_mod_dquot_byino() (via xfs_bmapi_write() -> ... -> xfs_bmap_btalloc() ->
> >   xfs_bmap_btalloc_accounting()) skips accounting the allocated blocks
> >   to the group dquot because it is not enabled
> 
> Right, the reservation functions need to do the same thing as
> xfs_trans_mod_dquot_byino(). I simply missed that for the
> reservation functions. i.e. Adding the same style of check like:
> 
> 	if (XFS_IS_UQUOTA_ON(mp) && udq)
> 
> before doing anything with user quota will avoid this problem as
> we are already in transaction context and the UQUOTA on or off state
> will not change until the transaction ends.
> 
> > concept itself. It seems like we should be able to head this issue off
> > somewhere in this sequence (i.e., checking the appropriate flag before
> > the dquot is attached), but it also seems like the quotaoff start/end
> > plus various quota flags all fit together a certain way and I feel like
> > some pieces of the puzzle are still missing from a design standpoint...
> 
> I can't think of anything that is missing - the quota off barrier
> gives us an atomic quota state change w.r.t. running transactions,
> so we just need to make sure we check the quota state before joining
> anything quota related to a transaction rather than assume that the
> presence of a dquot attached to an inode means that quotas are on.
> 

This gets back to my earlier questions around the various quota flags.
If I trace through the code of some operations, it seems like this
approach should work (once this logging issue is addressed, and more
testing required of course). However if I refer back to the runtime
macro comment:

/*
 * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
 * quota will be not be switched off as long as that inode lock is held.
 */

This will technically no longer be the case because the updated quotaoff
will clear all of the flags before cycling any ilocks and detaching
dquots. I'm aware it will drain the transaction subsystem, but does
anything else depend on not seeing such a state change with an inode
lock held? I haven't seen anything so far that would conflict, but the
comment here is rather vague on details.

Conversely, if not, I'm wondering whether there's a need for an ACTIVE
flag at all if we'd clear it at the same time as the ACCT|ENFD flags
during quotaoff anyways. It sounds like the answer to both those
questions is no based on your previous responses, perhaps reason being
that the transaction drain on the quotaoff side effectively replaces the
need for this rule on the general transaction side. Hm? Note that I
wouldn't remove the ACTIVE flag immediately anyways, but I want to make
sure the concern is clear..

Thanks for the feedback.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

