Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF30C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 02:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A73E235FA
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 02:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbhANCOI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 21:14:08 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48980 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729143AbhAMVcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 16:32:11 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EA35882BEC6;
        Thu, 14 Jan 2021 08:31:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kznjN-006A5Q-OU; Thu, 14 Jan 2021 08:31:05 +1100
Date:   Thu, 14 Jan 2021 08:31:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20210113213105.GG331610@dread.disaster.area>
References: <20201209170428.GC1860561@bfoster>
 <20201209205132.GA3913616@dread.disaster.area>
 <20201210142358.GB1912831@bfoster>
 <20201210215004.GC3913616@dread.disaster.area>
 <20201211133901.GA2032335@bfoster>
 <20201212211439.GC632069@dread.disaster.area>
 <20201214155831.GB2244296@bfoster>
 <20201214205456.GD632069@dread.disaster.area>
 <20201215135003.GA2346012@bfoster>
 <20210107232821.GN6918@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107232821.GN6918@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=7-415B0cAAAA:8
        a=kaczqaxK7GXxzBSzrM4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 07, 2021 at 03:28:21PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 15, 2020 at 08:50:03AM -0500, Brian Foster wrote:
> > On Tue, Dec 15, 2020 at 07:54:56AM +1100, Dave Chinner wrote:
> > > On Mon, Dec 14, 2020 at 10:58:31AM -0500, Brian Foster wrote:
> > > > On Sun, Dec 13, 2020 at 08:14:39AM +1100, Dave Chinner wrote:
> > > > > On Fri, Dec 11, 2020 at 08:39:01AM -0500, Brian Foster wrote:
> > > > > > On Fri, Dec 11, 2020 at 08:50:04AM +1100, Dave Chinner wrote:
> > > > > > > As for a mechanism for dynamically adding log incompat flags?
> > > > > > > Perhaps we just do that in xfs_trans_alloc() - add an log incompat
> > > > > > > flags field into the transaction reservation structure, and if
> > > > > > > xfs_trans_alloc() sees an incompat field set and the superblock
> > > > > > > doesn't have it set, the first thing it does is run a "set log
> > > > > > > incompat flag" transaction before then doing it's normal work...
> > > > > > > 
> > > > > > > This should be rare enough it doesn't have any measurable
> > > > > > > performance overhead, and it's flexible enough to support any log
> > > > > > > incompat feature we might need to implement...
> > > > > > > 
> > > > > > 
> > > > > > But I don't think that is sufficient. As Darrick pointed out up-thread,
> > > > > > the updated superblock has to be written back before we're allowed to
> > > > > > commit transactions with incompatible items. Otherwise, an older kernel
> > > > > > can attempt log recovery with incompatible items present if the
> > > > > > filesystem crashes before the superblock is written back.
> > > > > 
> > > > > Sure, that's what the hook in xfs_trans_alloc() would do. It can do
> > > > > the work in the context that is going to need it, and set a wait
> > > > > flag for all incoming transactions that need a log incompat flag to
> > > > > wait for it do it's work.  Once it's done and the flag is set, it
> > > > > can continue and wake all the waiters now that the log incompat flag
> > > > > has been set. Anything that doesn't need a log incompat flag can
> > > > > just keep going and doesn't ever get blocked....
> > > > > 
> > > > 
> > > > It would have to be a sync transaction plus sync AIL force in
> > > > transaction allocation context if we were to log the superblock change,
> > > > which sounds a bit hairy...
> > > 
> > > Well, we already do sync AIL forces in transaction reservation when
> > > we run out of log space, so there's no technical reason for this
> > > being a problem at all. xfs_trans_alloc() is expected to block
> > > waiting on AIL tail pushing....
> > > 
> > > > > I suspect this is one of the rare occasions where an unlogged
> > > > > modification makes an awful lot of sense: we don't even log that we
> > > > > are adding a log incompat flag, we just do an atomic synchronous
> > > > > write straight to the superblock to set the incompat flag(s). The
> > > > > entire modification can be done under the superblock buffer lock to
> > > > > serialise multiple transactions all trying to set incompat bits, and
> > > > > we don't set the in-memory superblock incompat bit until after it
> > > > > has been set and written to disk. Hence multiple waits can check the
> > > > > flag after they've got the sb buffer lock, and they'll see that it's
> > > > > already been set and just continue...
> > > > > 
> > > > 
> > > > Agreed. That is a notable simplification and I think much more
> > > > preferable than the above for the dynamic approach.
> > > > 
> > > > That said, note that dynamic feature bits might introduce complexity in
> > > > more subtle ways. For example, nothing that I can see currently
> > > > serializes idle log covering with an active transaction (that may have
> > > > just set an incompat bit via some hook yet not committed anything to the
> > > > log subsystem), so it might not be as simple as just adding a hook
> > > > somewhere.
> > > 
> > > Right, we had to make log covering away of the CIL to prevent it
> > > from idling while there were multiple active committed transactions
> > > in memory. So the state machine only progresses if both the CIL and
> > > AIL are empty. If we had some way of knowing that a transaction is
> > > in progress, we could check that in xfs_log_need_covered() and we'd
> > > stop the state machine progress at that point. But we got rid of the
> > > active transaction counter that we could use for that....
> > > 
> > > [Hmmm, didn't I recently have a patch that re-introduced that
> > > counter to fix some other "we need to know if there's an active
> > > transaction running" issue? Can't remember what that was now...]
> > > 
> > 
> > I think you removed it, actually, via commit b41b46c20c0bd ("xfs: remove
> > the m_active_trans counter"). We subsequently discussed reintroducing
> > the same concept for the quotaoff rework [1], which might be what you're
> > thinking of. That uses a percpu rwsem since we don't really need a
> > counter, but I suspect could be reused for serialization in this use
> > case as well (assuming I can get some reviews on it.. ;).
> > 
> > FWIW, I was considering putting those quotaoff patches ahead of the log
> > covering work so we could reuse that code again in attr quiesce, but I
> > think I'm pretty close to being able to remove that particular usage
> > entirely.
> 
> I was thinking about using a rwsem to protect the log incompat flags --
> code that thinks it might use a protected feature takes the lock in
> read mode until commit; and the log covering code only clears the
> flags if down_write_trylock succeeds.  That constrains the overhead to
> threads that are trying to use the feature, instead of making all
> threads pay the cost of bumping the counter.

If you are going to do that, make it a per-cpu rwsem, because we
really only care about the global shared read overhead in the hot
paths and not the overhead of taking it in write mode if
it is only the log covering code that does that...

> > I'm more approaching this from a "what are the requirements and how/why
> > do they justify the associated complexity?" angle. That's why I'm asking
> > things like how much difference does a dynamic bit really make for
> > something like xattrs. But I agree that's less of a concern when
> > associated with more obscure or rarely used operations, so on balance I
> > think that's a fair approach to this mechanism provided we consider
> > suitability on a per feature basis.
> 
> Hm.  If I had to peer into my crystal ball I'd guess that the current
> xattr logging scheme works fine for most xattr users, so I wouldn't
> worry much about the dynamic bit.
> 
> However, I could see things like atomic range exchange being more
> popular, in which case people might notice the overhead of tracking when
> we can turn off the feature bit...

Hence a per-cpu rwsem... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
