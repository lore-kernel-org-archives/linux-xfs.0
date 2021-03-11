Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA05BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EA9564FAF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhCKDl2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:41:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229971AbhCKDlP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 22:41:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E715564E77;
        Thu, 11 Mar 2021 03:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615434075;
        bh=1ZwUcCM5og/Bfl4Z4KYLvCmLd9bgRv7FJxobr9v0KE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q8IeBcOi0tVY0PhFYo/O3OCKWjl55jL9vwsXt5MTxo20uWr5W1uakF70ZGW3QrvIs
         vVzjkjPHQeFv9uG6UHW8l5KYSP1S0R1mP2sG3kG3NNaSmbUhoOFxcuyHTY3kpzg3Y2
         BlZwWnctf3yEP670dBH9x87L3b6p4SVBWCDjn/8Hyx2VVB1RtoHl+7xMozfZ1xfwdn
         r6DM+AooDrQDO/abxYP8acyDesjMMqs0n5UqcpK99ukv5FpmebtELlcyLbDpm6B3Xb
         wRU2A1Du0+R3TYOOaB2sXKpvN1r6J3Q01KVeyfhilbKy3EzGT3rWSN+BdXDEkMzvGp
         6GbCgyzQvmO7A==
Date:   Wed, 10 Mar 2021 19:41:14 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/45] xfs: reserve space and initialise xlog_op_header
 in item formatting
Message-ID: <20210311034114.GD7269@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-26-david@fromorbit.com>
 <20210309022134.GM3419940@magnolia>
 <20210311032932.GL74031@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311032932.GL74031@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2021 at 02:29:32PM +1100, Dave Chinner wrote:
> On Mon, Mar 08, 2021 at 06:21:34PM -0800, Darrick J. Wong wrote:
> > On Fri, Mar 05, 2021 at 04:11:23PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Current xlog_write() adds op headers to the log manually for every
> > > log item region that is in the vector passed to it. While
> > > xlog_write() needs to stamp the transaction ID into the ophdr, we
> > > already know it's length, flags, clientid, etc at CIL commit time.
> > > 
> > > This means the only time that xlog write really needs to format and
> > > reserve space for a new ophdr is when a region is split across two
> > > iclogs. Adding the opheader and accounting for it as part of the
> > > normal formatted item region means we simplify the accounting
> > > of space used by a transaction and we don't have to special case
> > > reserving of space in for the ophdrs in xlog_write(). It also means
> > > we can largely initialise the ophdr in transaction commit instead
> > > of xlog_write, making the xlog_write formatting inner loop much
> > > tighter.
> > > 
> > > xlog_prepare_iovec() is now too large to stay as an inline function,
> > > so we move it out of line and into xfs_log.c.
> > > 
> > > Object sizes:
> > > text	   data	    bss	    dec	    hex	filename
> > > 1125934	 305951	    484	1432369	 15db31 fs/xfs/built-in.a.before
> > > 1123360	 305951	    484	1429795	 15d123 fs/xfs/built-in.a.after
> > > 
> > > So the code is a roughly 2.5kB smaller with xlog_prepare_iovec() now
> > > out of line, even though it grew in size itself.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > Sooo... if I understand this part of the patchset correctly, the goal
> > here is to simplify and shorten the inner loop of xlog_write.
> 
> That's one of the goals. The other goal is to avoid needing to
> account for log op headers separately in the high level CIL commit
> code.
> 
> > Callers
> > are now required to create their own log op headers at the start of the
> > xfs_log_iovec chain in the xfs_log_vec, which means that the only time
> > xlog_write has to create an ophdr is when we fill up the current iclog
> > and must continue in a new one, because that's not something the callers
> > should ever have to know about.  Correct?
> 
> Yes.
> 
> > If so,
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> Thanks!
> 
> > It /really/ would have been nice to have kept these patches separated by
> > major functional change area (i.e. separate series) instead of one
> > gigantic 45-patch behemoth to intimidate the reviewers...
> 
> How is that any different from sending out 6-7 separate dependent
> patchsets one immediately after another?  A change to one patch in
> one series results in needing to rebase at least one patch in each
> of the smaller patchsets, so I've still got to treat them all as one
> big patchset in my development trees. Then I have to start
> reposting patchsets just because another patchset was changed, and
> that gets even more confusing trying to work out what patchset goes
> with which version and so on. It's much easier for me to manage them
> as a single patchset....

Well, ok, but it would have been nice for the cover letter to give
/some/ hint as to what's changing in various subranges, e.g.

"Patches 32-36 reduce the xc_cil_lock critical sections,
 Patches 37-41 create per-cpu cil structures and move log items and
       vectors to use them,
 Patches 42-44 are more cleanups,
 Patch 45 documents the whole mess."

So I could see the outlines of where the 45 patches were going.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
