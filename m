Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B6EC28D13
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Aug 2022 02:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiHWCSv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 22:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiHWCSv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 22:18:51 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C1874E86F
        for <linux-xfs@vger.kernel.org>; Mon, 22 Aug 2022 19:18:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-4-169.pa.nsw.optusnet.com.au [49.195.4.169])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6FB5D10E8B10;
        Tue, 23 Aug 2022 12:18:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oQJV9-00GOPz-CZ; Tue, 23 Aug 2022 12:18:47 +1000
Date:   Tue, 23 Aug 2022 12:18:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: ensure log tail is always up to date
Message-ID: <20220823021847.GO3600936@dread.disaster.area>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-5-david@fromorbit.com>
 <YwQgT1i0x2i+wGF8@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwQgT1i0x2i+wGF8@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=63043909
        a=FOdsZBbW/tHyAhIVFJ0pRA==:117 a=FOdsZBbW/tHyAhIVFJ0pRA==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=EeSMy61KkEL7v2Yay4UA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 22, 2022 at 05:33:19PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 10, 2022 at 09:03:48AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Whenever we write an iclog, we call xlog_assign_tail_lsn() to update
> > the current tail before we write it into the iclog header. This
> > means we have to take the AIL lock on every iclog write just to
> > check if the tail of the log has moved.
> > 
> > This doesn't avoid races with log tail updates - the log tail could
> > move immediately after we assign the tail to the iclog header and
> > hence by the time the iclog reaches stable storage the tail LSN has
> > moved forward in memory. Hence the log tail LSN in the iclog header
> > is really just a point in time snapshot of the current state of the
> > AIL.
> > 
> > With this in mind, if we simply update the in memory log->l_tail_lsn
> > every time it changes in the AIL, there is no need to update the in
> > memory value when we are writing it into an iclog - it will already
> > be up-to-date in memory and checking the AIL again will not change
> > this.
> 
> This is too subtle for me to understand -- does the codebase
> already update l_tail_lsn?  Does this patch make it do that?

tl;dr: if the AIL is empty, log->l_tail_lsn is not updated on the
first insert of a new item into the AILi and hence is stale.
xlog_state_release_iclog() currently works around that by calling
xlog_assign_tail_lsn() to get the tail lsn from the AIL. This change
makes sure log->l_tail_lsn is always up to date.

In more detail:

The tail update occurs in xfs_ail_update_finish(), but only if we
pass in a non-zero tail_lsn. xfs_trans_ail_update_bulk() will only
set a non-zero tail_lsn if it moves the log item at the tail of the
log (i.e. we relog the tail item and move it forwards in the AIL).

Hence if we pass a non-zero tail_lsn to xfs_ail_update_finish(), it
indicates it needs to check it against the LSN of the item currently
at the tail of the AIL. If the tail LSN has not changed, we do
nothing, if it has changed, then we call
xlog_assign_tail_lsn_locked() to update the log tail.

The problem with the current code is that if the AIL is empty when
we insert the first item, we've actually moved the log tail but we
do not update the log tail (i.e. tail_lsn is zero in this case). If
we then release an iclog for writing at this point in time, the tail
lsn it writes into the iclog header would be wrong - it does not
reflect the log tail as defined by the AIL and the checkpoint that
has just been committed.

Hence xlog_state_release_iclog() called xlog_assign_tail_lsn() to
ensure that it checked that the tail LSN it applies to the iclog
reflects the current state of the AIL. i.e. it checks if there is an
item in the AIL, and if so, grabs the tail_lsn from the AIL. This
works around the fact the AIL doesn't update the log tail on the
first insert.

Hence what this patch does is have xfs_trans_ail_update_bulk set
the tail_lsn passed to xfs_ail_update_finish() to NULLCOMMITLSN when
it does the first insert into the AIL. NULLCOMMITLSN is a
non-zero value that won't match with the LSN of items we just
inserted into the AIL, and hence xfs_ail_update_finish() will go an
update the log tail in this case.

Hence we close the hole when the log->l_tail_lsn is incorrect after
the first insert into the AIL, and hence we no longer need to update
the log->l_tail_lsn when reading it into the iclog header -
log->l_tail_lsn is always up to date, and so we can now just read it
in xlog_state_release_iclog() rather than having to grab the AIL
lock and checking the AIL to update log->l_tail_lsn with the correct
tail value from iclog IO submission....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
