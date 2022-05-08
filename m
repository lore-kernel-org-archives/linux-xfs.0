Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2FAC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  8 May 2022 21:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiEHVzk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 May 2022 17:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbiEHVyT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 May 2022 17:54:19 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3D76120AC
        for <linux-xfs@vger.kernel.org>; Sun,  8 May 2022 14:50:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4539A5346F1;
        Mon,  9 May 2022 07:50:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nnonH-009edO-Q2; Mon, 09 May 2022 07:50:23 +1000
Date:   Mon, 9 May 2022 07:50:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/17] xfs: ATTR_REPLACE algorithm with LARP enabled
 needs rework
Message-ID: <20220508215023.GL1098723@dread.disaster.area>
References: <20220506094553.512973-1-david@fromorbit.com>
 <20220506094553.512973-18-david@fromorbit.com>
 <c2159284a8b1c575140b7bbd3190fd38428b0a4d.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2159284a8b1c575140b7bbd3190fd38428b0a4d.camel@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62783b21
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=idSffjYRomP6fWbKisAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 06, 2022 at 11:01:23PM -0700, Alli wrote:
> On Fri, 2022-05-06 at 19:45 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We can't use the same algorithm for replacing an existing attribute
> > when logging attributes. The existing algorithm is essentially:
> > 
> > 1. create new attr w/ INCOMPLETE
> > 2. atomically flip INCOMPLETE flags between old + new attribute
> > 3. remove old attr which is marked w/ INCOMPLETE
> > 
> > This algorithm guarantees that we see either the old or new
> > attribute, and if we fail after the atomic flag flip, we don't have
> > to recover the removal of the old attr because we never see
> > INCOMPLETE attributes in lookups.
> > 
> > For logged attributes, however, this does not work. The logged
> > attribute intents do not track the work that has been done as the
> > transaction rolls, and hence the only recovery mechanism we have is
> > "run the replace operation from scratch".
> > 
> > This is further exacerbated by the attempt to avoid needing the
> > INCOMPLETE flag to create an atomic swap. This means we can create
> > a second active attribute of the same name before we remove the
> > original. If we fail at any point after the create but before the
> > removal has completed, we end up with duplicate attributes in
> > the attr btree and recovery only tries to replace one of them.
> > 
> > There are several other failure modes where we can leave partially
> > allocated remote attributes that expose stale data, partially free
> > remote attributes that enable UAF based stale data exposure, etc.
> > 
> > TO fix this, we need a different algorithm for replace operations
> > when LARP is enabled. Luckily, it's not that complex if we take the
> > right first step. That is, the first thing we log is the attri
> > intent with the new name/value pair and mark the old attr as
> > INCOMPLETE in the same transaction.
> > 
> > From there, we then remove the old attr and keep relogging the
> > new name/value in the intent, such that we always know that we have
> > to create the new attr in recovery. Once the old attr is removed,
> > we then run a normal ATTR_CREATE operation relogging the intent as
> > we go. If the new attr is local, then it gets created in a single
> > atomic transaction that also logs the final intent done. If the new
> > attr is remote, the we set INCOMPLETE on the new attr while we
> > allocate and set the remote value, and then we clear the INCOMPLETE
> > flag at in the last transaction taht logs the final intent done.
> > 
> > If we fail at any point in this algorithm, log recovery will always
> > see the same state on disk: the new name/value in the intent, and
> > either an INCOMPLETE attr or no attr in the attr btree. If we find
> > an INCOMPLETE attr, we run the full replace starting with removing
> > the INCOMPLETE attr. If we don't find it, then we simply create the
> > new attr.
> > 
> > Notably, recovery of a failed create that has an INCOMPLETE flag set
> > is now the same - we start with the lookup of the INCOMPLETE attr,
> > and if that exists then we do the full replace recovery process,
> > otherwise we just create the new attr.
> > 
> > Hence changing the way we do the replace operation when LARP is
> > enabled allows us to use the same log recovery algorithm for both
> > the ATTR_CREATE and ATTR_REPLACE operations. This is also the same
> > algorithm we use for runtime ATTR_REPLACE operations (except for the
> > step setting up the initial conditions).
> > 
> > The result is that:
> > 
> > - ATTR_CREATE uses the same algorithm regardless of whether LARP is
> >   enabled or not
> > - ATTR_REPLACE with larp=0 is identical to the old algorithm
> > - ATTR_REPLACE with larp=1 runs an unmodified attr removal algorithm
> >   from the larp=0 code and then runs the unmodified ATTR_CREATE
> >   code.
> > - log recovery when larp=1 runs the same ATTR_REPLACE algorithm as
> >   it uses at runtime.
> > 
> > Because the state machine is now quite clean, changing the algorithm
> > is really just a case of changing the initial state and how the
> > states link together for the ATTR_REPLACE case. Hence it's not a
> > huge amoutn of code for what is a fairly substantial rework
> > of the attr logging and recovery algorithm....
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> This looks mostly good, though when I run it with the new tests, I seem
> to run into a failed filesystem check at the end.  "bad attribute count
> 0 in attr block 0".  I suspect we still dont have the removal of the
> fork quite right.  It sounds like you're still working with things
> though, I'll keep looking too.

Yeah, that's a strange one. I didn't get it with the based branch
testing (based on 5.18-rc+for-next) but over the weekend where it
got merged with 5.18-rc5 it appears that the error has manifested
in several test runs. I'll dig into it this morning.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
