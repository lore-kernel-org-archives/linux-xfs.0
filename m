Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E81C2B9F4
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 22:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77F6861107
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 22:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFVW6g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 18:58:36 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:54971 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229800AbhFVW6f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jun 2021 18:58:35 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id B13804087;
        Wed, 23 Jun 2021 08:56:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lvpJY-00Frsa-VE; Wed, 23 Jun 2021 08:56:16 +1000
Date:   Wed, 23 Jun 2021 08:56:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: remove callback dequeue loop from
 xlog_state_do_iclog_callbacks
Message-ID: <20210622225616.GZ664593@dread.disaster.area>
References: <20210622040604.1290539-1-david@fromorbit.com>
 <20210622040604.1290539-3-david@fromorbit.com>
 <YNHZ67ucUUEPJNbh@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNHZ67ucUUEPJNbh@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=eJfxgxciAAAA:8
        a=7-415B0cAAAA:8 a=ymhcTqCDLHW_7MBHh20A:9 a=CjuIK1q_8ugA:10
        a=xM9caqqi1sUkTy8OJ5Uh:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 22, 2021 at 08:39:07AM -0400, Brian Foster wrote:
> On Tue, Jun 22, 2021 at 02:06:02PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If we are processing callbacks on an iclog, nothing can be
> > concurrently adding callbacks to the loop. We only add callbacks to
> > the iclog when they are in ACTIVE or WANT_SYNC state, and we
> > explicitly do not add callbacks if the iclog is already in IOERROR
> > state.
> > 
> > The only way to have a dequeue racing with an enqueue is to be
> > processing a shutdown without a direct reference to an iclog in
> > ACTIVE or WANT_SYNC state. As the enqueue avoids this race
> > condition, we only ever need a single dequeue operation in
> > xlog_state_do_iclog_callbacks(). Hence we can remove the loop.
> > 
> 
> This sort of relates to my question on the previous patch..

Been that way since 1995:

commit fdae46676ab5d359d02d955c989b20b18e2a97f8
Author: Adam Sweeney <ajs@sgi.com>
Date:   Thu May 4 20:54:43 1995 +0000

    275579 - - Fix timing bug in the log callback code.  Callbacks
    must be queued until the incore log buffer goes to the dirty
    state.

......
               /*
+                * Keep processing entries in the callback list
+                * until we come around and it is empty.  We need
+                * to atomically see that the list is empty and change
+                * the state to DIRTY so that we don't miss any more
+                * callbacks being added.
+                */
                spl = LOG_LOCK(log);
+               cb = iclog->ic_callback;
+               while (cb != 0) {
+                       iclog->ic_callback_tail = &(iclog->ic_callback);
+                       iclog->ic_callback = 0;
+                       LOG_UNLOCK(log, spl);
+
+                       /* perform callbacks in the order given */
+                       for (; cb != 0; cb = cb_next) {
+                               cb_next = cb->cb_next;
+                               cb->cb_func(cb->cb_arg);
+                       }
+                       spl = LOG_LOCK(log);
+                       cb = iclog->ic_callback;
+               }
+
+               ASSERT(iclog->ic_callback == 0);

THat's likely also what the locking I removed in the previous patch
was attempting to retain - atomic transition to DIRTY state -
without really understanding if it is necessary or not.

The only way I can see this happening now is racing with shutdown
state being set and callbacks being run at the same time a commit
record is being processed. But now we check for shutdown before we
add callbacks to the iclog, and hence we can't be adding callbacks
while shutdown state callbacks are being run. And that's made even
more impossible by this patch set that is serialising all the
shutdown state changes and callback add/remove under the same
lock....

So, yeah, this is largely behaviour that is historic and the
situation that it avoided is unknown and almost certainly doesn't
exist anymore...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
