Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8111C433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Dec 2020 21:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8364C22509
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Dec 2020 21:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgLLVPe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 12 Dec 2020 16:15:34 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60413 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbgLLVPZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 12 Dec 2020 16:15:25 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BA5983C3CE6;
        Sun, 13 Dec 2020 08:14:40 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1koCDv-003J2X-9P; Sun, 13 Dec 2020 08:14:39 +1100
Date:   Sun, 13 Dec 2020 08:14:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20201212211439.GC632069@dread.disaster.area>
References: <20201208181027.GB1943235@magnolia>
 <20201208191913.GB1685621@bfoster>
 <20201209032624.GH1943235@magnolia>
 <20201209041950.GY3913616@dread.disaster.area>
 <20201209155211.GB1860561@bfoster>
 <20201209170428.GC1860561@bfoster>
 <20201209205132.GA3913616@dread.disaster.area>
 <20201210142358.GB1912831@bfoster>
 <20201210215004.GC3913616@dread.disaster.area>
 <20201211133901.GA2032335@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211133901.GA2032335@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=7-415B0cAAAA:8
        a=-dL5HOfXmfJsX-LxWmsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 11, 2020 at 08:39:01AM -0500, Brian Foster wrote:
> On Fri, Dec 11, 2020 at 08:50:04AM +1100, Dave Chinner wrote:
> > As for a mechanism for dynamically adding log incompat flags?
> > Perhaps we just do that in xfs_trans_alloc() - add an log incompat
> > flags field into the transaction reservation structure, and if
> > xfs_trans_alloc() sees an incompat field set and the superblock
> > doesn't have it set, the first thing it does is run a "set log
> > incompat flag" transaction before then doing it's normal work...
> > 
> > This should be rare enough it doesn't have any measurable
> > performance overhead, and it's flexible enough to support any log
> > incompat feature we might need to implement...
> > 
> 
> But I don't think that is sufficient. As Darrick pointed out up-thread,
> the updated superblock has to be written back before we're allowed to
> commit transactions with incompatible items. Otherwise, an older kernel
> can attempt log recovery with incompatible items present if the
> filesystem crashes before the superblock is written back.

Sure, that's what the hook in xfs_trans_alloc() would do. It can do
the work in the context that is going to need it, and set a wait
flag for all incoming transactions that need a log incompat flag to
wait for it do it's work.  Once it's done and the flag is set, it
can continue and wake all the waiters now that the log incompat flag
has been set. Anything that doesn't need a log incompat flag can
just keep going and doesn't ever get blocked....

> We could do some sync transaction and/or sync write dance at runtime,
> but I think the performance/overhead aspect becomes slightly less
> deterministic. It's not clear to me how many bits we'd support over
> time, and whether users would notice hiccups when running some sustained
> workload and happen to trigger sync transaction/write or AIL push
> sequences to set internal bits.

I don't think the number of bits is ever going to be a worry.  If we
do it on a transaction granularlity, it will only block transactions
taht need the log incomapt bit, and only until the bit is set.

I suspect this is one of the rare occasions where an unlogged
modification makes an awful lot of sense: we don't even log that we
are adding a log incompat flag, we just do an atomic synchronous
write straight to the superblock to set the incompat flag(s). The
entire modification can be done under the superblock buffer lock to
serialise multiple transactions all trying to set incompat bits, and
we don't set the in-memory superblock incompat bit until after it
has been set and written to disk. Hence multiple waits can check the
flag after they've got the sb buffer lock, and they'll see that it's
already been set and just continue...

This gets rid of the whole "what about a log containing an item that
sets the incompat bit" problem, and it provides a simple means of
serialising and co-ordinating setting of a log incompat flag....

> My question is how flexible do we really need to make incompatible log
> recovery support? Why not just commit the superblock once at mount time
> with however many bits the current kernel supports and clear them on
> unmount? (Or perhaps consider a lazy setting variant where we set all
> supported bits on the first modification..?)

We don't want to set the incompat bits if we don't need to. That
just guarantees user horror stories that start with "boot system
with new kernel, crash, go back to old kernel, can't mount root
filesystem anymore".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
