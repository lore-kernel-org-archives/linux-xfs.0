Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19CFC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 03:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3FC265092
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 03:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhCPD3K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:29:10 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39902 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231424AbhCPD2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 23:28:38 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6BBA91041AD2;
        Tue, 16 Mar 2021 14:28:36 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lM0Nl-0032Bx-Sx; Tue, 16 Mar 2021 14:28:33 +1100
Date:   Tue, 16 Mar 2021 14:28:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 45/45] xfs: expanding delayed logging design with
 background material
Message-ID: <20210316032833.GM63242@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-46-david@fromorbit.com>
 <20210311023020.GS3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311023020.GS3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=jkXT8voDenjgNZkUpgIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 06:30:20PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:43PM +1100, Dave Chinner wrote:
> > +The method used to log an item or chain modifications together isn't
> > +particularly important in the scope of this document. It suffices to know that
> > +the method used for logging a particular object or chaining modifications
> > +together are different and are dependent on the object and/or modification being
> > +performed. The logging subsystem only cares that certain specific rules are
> > +followed to guarantee forwards progress and prevent deadlocks.
> 
> (Aww, maybe we /should/ document how we choose between intents, logical
> updates, and physical updates.  But that can come in a later patch.)

*nod*

> > +Transactions in XFS
> > +===================
> > +
> > +XFS has two types of high level transactions, defined by the type of log space
> > +reservation they take. These are known as "one shot" and "permanent"
> 
> (Ugh, I wish we could call them 'compound' or 'rolling'
> transactions....)

I guess that's a set of followup patches at some point. Calling them
'rolling transactions' everywhere would certainly be an improvement.

> > +Log Space Accounting
> > +====================
> > +
> > +The position in the log is typically referred to as a Log Sequence Number (LSN).
> > +The log is circular, so the positions in the log are defined by the combination
> > +of a cycle number - the number of times the log has been overwritten - and the
> > +offset into the log.  A LSN carries the cycle in the upper 32 bits and the
> > +offset in the lower 32 bits. The offset is in units of "basic blocks" (512
> > +bytes). Hence we can do realtively simple LSN based math to keep track of
> > +available space in the log.
> > +
> > +Log space accounting is done via a pair of constructs called "grant heads".  The
> > +position of the grant heads is an absolute value, so the amount of space
> > +available in the log is defined by the distance between the position of the
> > +grant head and the current log tail. That is, how much space can be
> > +reserved/consumed before the grant heads would fully wrap the log and overtake
> > +the tail position.
> > +
> > +The first grant head is the "reserve" head. This tracks the byte count of the
> > +reservations currently held by active transactions. It is a purely in-memory
> > +accounting of the space reservation and, as such, actually tracks byte offsets
> > +into the log rather than basic blocks. Hence it technically isn't using LSNs to
> > +represent the log position, but it is still treated like a split {cycle,offset}
> > +tuple for the purposes of tracking reservation space.
> 
> Lol, the grant head is delalloc for transactions.

Yes, in effect that's exactly what it does. The log is at ENOSPC
when we run out of reservation space, and the AIL is the garbage
collector that reclaims used space....

> > @@ -67,12 +350,13 @@ the log over and over again. Worse is the fact that objects tend to get
> >  dirtier as they get relogged, so each subsequent transaction is writing more
> >  metadata into the log.
> >  
> > -Another feature of the XFS transaction subsystem is that most transactions are
> > -asynchronous. That is, they don't commit to disk until either a log buffer is
> > -filled (a log buffer can hold multiple transactions) or a synchronous operation
> > -forces the log buffers holding the transactions to disk. This means that XFS is
> > -doing aggregation of transactions in memory - batching them, if you like - to
> > -minimise the impact of the log IO on transaction throughput.
> > +It should now also be obvious how relogging and asynchronous transactions go
> > +hand in hand. That is, transactions don't get written to the physical journal
> > +until either a log buffer is filled (a log buffer can hold multiple
> > +transactions) or a synchronous operation forces the log buffers holding the
> > +transactions to disk. This means that XFS is doing aggregation of transactions
> > +in memory - batching them, if you like - to minimise the impact of the log IO on
> > +transaction throughput.
> 
> ...microtransaction fusion, yippee!

I'll have to remember that next time I play algorithm buzzword
bingo... :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
