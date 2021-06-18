Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5CFC48BE8
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 22:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BEA461279
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 22:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhFRWRp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 18:17:45 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:53442 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234797AbhFRWRo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 18:17:44 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 77B823E7E;
        Sat, 19 Jun 2021 08:15:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1luMlR-00ELEE-TZ; Sat, 19 Jun 2021 08:15:01 +1000
Date:   Sat, 19 Jun 2021 08:15:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/8 V2] xfs: log fixes for for-next
Message-ID: <20210618221501.GJ664593@dread.disaster.area>
References: <20210617082617.971602-1-david@fromorbit.com>
 <YMuVPgmEjwaGTaFA@bfoster>
 <20210617190519.GV158209@locust>
 <20210617234308.GH664593@dread.disaster.area>
 <YMyav1+JiSlQbDFH@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMyav1+JiSlQbDFH@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=20KFwNOVAAAA:8 a=QWIvB97FxFm2QMqQn68A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 09:08:15AM -0400, Brian Foster wrote:
> On Fri, Jun 18, 2021 at 09:43:08AM +1000, Dave Chinner wrote:
> > On Thu, Jun 17, 2021 at 12:05:19PM -0700, Darrick J. Wong wrote:
> > > On Thu, Jun 17, 2021 at 02:32:30PM -0400, Brian Foster wrote:
> > > > On Thu, Jun 17, 2021 at 06:26:09PM +1000, Dave Chinner wrote:
> > > > > Hi folks,
> > > > > 
> > > > > This is followup from the first set of log fixes for for-next that
> > > > > were posted here:
> > > > > 
> > > > > https://lore.kernel.org/linux-xfs/20210615175719.GD158209@locust/T/#mde2cf0bb7d2ac369815a7e9371f0303efc89f51b
> > > > > 
> > > > > The first two patches of this series are updates for those patches,
> > > > > change log below. The rest is the fix for the bigger issue we
> > > > > uncovered in investigating the generic/019 failures, being that
> > > > > we're triggering a zero-day bug in the way log recovery assigns LSNs
> > > > > to checkpoints.
> > > > > 
> > > > > The "simple" fix of using the same ordering code as the commit
> > > > > record for the start records in the CIL push turned into a lot of
> > > > > patches once I started cleaning it up, separating out all the
> > > > > different bits and finally realising all the things I needed to
> > > > > change to avoid unintentional logic/behavioural changes. Hence
> > > > > there's some code movement, some factoring, API changes to
> > > > > xlog_write(), changing where we attach callbacks to commit iclogs so
> > > > > they remain correctly ordered if there are multiple commit records
> > > > > in the one iclog and then, finally, strictly ordering the start
> > > > > records....
> > > > > 
> > > > > The original "simple fix" I tested last night ran almost a thousand
> > > > > cycles of generic/019 without a log hang or recovery failure of any
> > > > > kind. The refactored patchset has run a couple hundred cycles of
> > > > > g/019 and g/475 over the last few hours without a failure, so I'm
> > > > > posting this so we can get a review iteration done while I sleep so
> > > > > we can - hopefully - get this sorted out before the end of the week.
> > > > > 
> > > > 
> > > > My first spin of this included generic/019 and generic/475, ran for 18
> > > > or so iterations and 475 exploded with a stream of asserts followed by a
> > > > NULL pointer crash:
> > > > 
> > > > # grep -e Assertion -e BUG dmesg.out
> > > > ...
> > > > [ 7951.878058] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > > > [ 7952.261251] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > > > [ 7952.644444] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > > > [ 7953.027626] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > > > [ 7953.410804] BUG: kernel NULL pointer dereference, address: 000000000000031f
> > > > [ 7954.118973] BUG: unable to handle page fault for address: ffffa57ccf99fa98
> > > > 
> > > > I don't know if this is a regression, but I've not seen it before. I've
> > > > attempted to spin generic/475 since then to see if it reproduces again,
> > > > but so far I'm only running into some of the preexisting issues
> > > > associated with that test.
> > 
> > I've not seen anything like that. I can't see how the changes in the
> > patchset would affect BUI reference counting in any way. That seems
> > more like an underlying intent item shutdown reference count issue
> > to me (and we've had a *lot* of them in the past)....
> > 
> 
> I've not made sense of it either, but at the same time, I've not seen it
> in all my testing thus far up until targeting this series, and now I've
> seen it twice in as many test runs as my overnight run fell into some
> kind of similar haywire state. Unfortunately it seemed to be
> spinning/streaming assert output so I lost any record of the initial
> crash signature. It wouldn't surprise me if the fundamental problem is
> some older bug in another area of code, but it's hard to believe it's
> not at least related to this series somehow.
> 
> Also FYI, earlier iterations of generic/475 triggered a couple instances
> of the following assert failure before things broke down more severely:
> 
>  XFS: Assertion failed: *log_offset + *len <= iclog->ic_size || iclog->ic_state == XLOG_STATE_WANT_SYNC, file: fs/xfs/xfs_log.c, line: 2115

Yup, that's a bogus state check in the asssert. I already have a
patch to fix that - the async shutdown can change the iclog state
to XLOG_STATE_IOERROR at any time, so any iclog state assert outside of
the log->l_icloglock needs also to allow for XLOG_STATE_IOERROR as
a valid state.

This is one of the problems I was alluding to on #xfs when I said:

[18/6/21 14:42] <dchinner> I'm really not liking getting repeatedly
caught out by racing, unreferenced iclog state changes during
shutdown and having to handle them everywhere.

Patch, FYI, below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: fix incorrect assert in xlog_write_single

From: Dave Chinner <dchinner@redhat.com>

generic/475 failed with this assert after a log shutdown:

[ 3953.166235] XFS: Assertion failed: *log_offset + *len <= iclog->ic_size || iclog->ic_state == XLOG_STATE_WANT_SYNC, file: fs/xfs/xfs_log.c, line: 2115

The problem is that after the log has shut down, the iclog state is
XLOG_STATE_IOERROR. The shutdown can change the iclog state at any
time while we are writing to it, so we need to add IOERROR to the
valid states here.

Note that we already have similar IOERROR state checks in asserts
in the xlog_write() code for this reason (e.g. in
xlog_write_get_more_iclog_space()) so this is just a case where the
IOERROR state check was missed. The IOERROR state will be processed
when we release the iclog, so just add the state into the assert and
let the iclog release code handle the error.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 94b6bccb9de9..221c080df305 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2113,7 +2113,8 @@ xlog_write_single(
 	int			index;
 
 	ASSERT(*log_offset + *len <= iclog->ic_size ||
-		iclog->ic_state == XLOG_STATE_WANT_SYNC);
+		iclog->ic_state == XLOG_STATE_WANT_SYNC ||
+		iclog->ic_state == XLOG_STATE_IOERROR);
 
 	ptr = iclog->ic_datap + *log_offset;
 	for (lv = log_vector;
