Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F350C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 01:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF20C23730
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 01:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbhAUAzl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 19:55:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:56010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729581AbhAUAND (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jan 2021 19:13:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5606023441;
        Thu, 21 Jan 2021 00:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611187941;
        bh=XlWxO0NXO3BXrgArLq7ZgVApXQLlrH6RnWCaTEEmRlc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QyRznmcuWlKh2IOs1PYtW6dFjSc95t00FKWpcP1mHu2fV+oJFU1tPgEYQMN9yuB4j
         7IE/0iYKcGsh3kp3Ig6M6SPKrIojunscBRMZSB8wiepZq6Uk6LjpM1puTBg1grGD7L
         DGPU2XjYctxzbC+9rKaJZHvJVJEm8wqnBN4Gx92SQ6QMcsV4HYoSAp8u+bebymjbka
         8PUJ6Ch/ySudXmXjfgF4BIzrwWPErg8Wxn/l7TUIHbk6i7q2kGiWVmu89akd9zb6W4
         r7zu/tBc331PQaWIkopSik4noE1ZCdX4hWim5E4CEuXe1kZopBNH8MALrb8vW36QU4
         Y2fLNxWcd7iZA==
Date:   Wed, 20 Jan 2021 16:12:22 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20210121001222.GU3134581@magnolia>
References: <20201210215004.GC3913616@dread.disaster.area>
 <20201211133901.GA2032335@bfoster>
 <20201212211439.GC632069@dread.disaster.area>
 <20201214155831.GB2244296@bfoster>
 <20201214205456.GD632069@dread.disaster.area>
 <20201215135003.GA2346012@bfoster>
 <20210107232821.GN6918@magnolia>
 <20210113213105.GG331610@dread.disaster.area>
 <20210114022547.GX1164246@magnolia>
 <20210114103047.GE1333929@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114103047.GE1333929@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 14, 2021 at 05:30:47AM -0500, Brian Foster wrote:
> On Wed, Jan 13, 2021 at 06:25:47PM -0800, Darrick J. Wong wrote:
> > On Thu, Jan 14, 2021 at 08:31:05AM +1100, Dave Chinner wrote:
> > > On Thu, Jan 07, 2021 at 03:28:21PM -0800, Darrick J. Wong wrote:
> > > > On Tue, Dec 15, 2020 at 08:50:03AM -0500, Brian Foster wrote:
> > > > > On Tue, Dec 15, 2020 at 07:54:56AM +1100, Dave Chinner wrote:
> > > > > > On Mon, Dec 14, 2020 at 10:58:31AM -0500, Brian Foster wrote:
> > > > > > > On Sun, Dec 13, 2020 at 08:14:39AM +1100, Dave Chinner wrote:
> > > > > > > > On Fri, Dec 11, 2020 at 08:39:01AM -0500, Brian Foster wrote:
> > > > > > > > > On Fri, Dec 11, 2020 at 08:50:04AM +1100, Dave Chinner wrote:
> > > > > > > > > > As for a mechanism for dynamically adding log incompat flags?
> > > > > > > > > > Perhaps we just do that in xfs_trans_alloc() - add an log incompat
> > > > > > > > > > flags field into the transaction reservation structure, and if
> > > > > > > > > > xfs_trans_alloc() sees an incompat field set and the superblock
> > > > > > > > > > doesn't have it set, the first thing it does is run a "set log
> > > > > > > > > > incompat flag" transaction before then doing it's normal work...
> > > > > > > > > > 
> > > > > > > > > > This should be rare enough it doesn't have any measurable
> > > > > > > > > > performance overhead, and it's flexible enough to support any log
> > > > > > > > > > incompat feature we might need to implement...
> > > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > But I don't think that is sufficient. As Darrick pointed out up-thread,
> > > > > > > > > the updated superblock has to be written back before we're allowed to
> > > > > > > > > commit transactions with incompatible items. Otherwise, an older kernel
> > > > > > > > > can attempt log recovery with incompatible items present if the
> > > > > > > > > filesystem crashes before the superblock is written back.
> > > > > > > > 
> > > > > > > > Sure, that's what the hook in xfs_trans_alloc() would do. It can do
> > > > > > > > the work in the context that is going to need it, and set a wait
> > > > > > > > flag for all incoming transactions that need a log incompat flag to
> > > > > > > > wait for it do it's work.  Once it's done and the flag is set, it
> > > > > > > > can continue and wake all the waiters now that the log incompat flag
> > > > > > > > has been set. Anything that doesn't need a log incompat flag can
> > > > > > > > just keep going and doesn't ever get blocked....
> > > > > > > > 
> > > > > > > 
> > > > > > > It would have to be a sync transaction plus sync AIL force in
> > > > > > > transaction allocation context if we were to log the superblock change,
> > > > > > > which sounds a bit hairy...
> > > > > > 
> > > > > > Well, we already do sync AIL forces in transaction reservation when
> > > > > > we run out of log space, so there's no technical reason for this
> > > > > > being a problem at all. xfs_trans_alloc() is expected to block
> > > > > > waiting on AIL tail pushing....
> > > > > > 
> > > > > > > > I suspect this is one of the rare occasions where an unlogged
> > > > > > > > modification makes an awful lot of sense: we don't even log that we
> > > > > > > > are adding a log incompat flag, we just do an atomic synchronous
> > > > > > > > write straight to the superblock to set the incompat flag(s). The
> > > > > > > > entire modification can be done under the superblock buffer lock to
> > > > > > > > serialise multiple transactions all trying to set incompat bits, and
> > > > > > > > we don't set the in-memory superblock incompat bit until after it
> > > > > > > > has been set and written to disk. Hence multiple waits can check the
> > > > > > > > flag after they've got the sb buffer lock, and they'll see that it's
> > > > > > > > already been set and just continue...
> > > > > > > > 
> > > > > > > 
> > > > > > > Agreed. That is a notable simplification and I think much more
> > > > > > > preferable than the above for the dynamic approach.
> > > > > > > 
> > > > > > > That said, note that dynamic feature bits might introduce complexity in
> > > > > > > more subtle ways. For example, nothing that I can see currently
> > > > > > > serializes idle log covering with an active transaction (that may have
> > > > > > > just set an incompat bit via some hook yet not committed anything to the
> > > > > > > log subsystem), so it might not be as simple as just adding a hook
> > > > > > > somewhere.
> > > > > > 
> > > > > > Right, we had to make log covering away of the CIL to prevent it
> > > > > > from idling while there were multiple active committed transactions
> > > > > > in memory. So the state machine only progresses if both the CIL and
> > > > > > AIL are empty. If we had some way of knowing that a transaction is
> > > > > > in progress, we could check that in xfs_log_need_covered() and we'd
> > > > > > stop the state machine progress at that point. But we got rid of the
> > > > > > active transaction counter that we could use for that....
> > > > > > 
> > > > > > [Hmmm, didn't I recently have a patch that re-introduced that
> > > > > > counter to fix some other "we need to know if there's an active
> > > > > > transaction running" issue? Can't remember what that was now...]
> > > > > > 
> > > > > 
> > > > > I think you removed it, actually, via commit b41b46c20c0bd ("xfs: remove
> > > > > the m_active_trans counter"). We subsequently discussed reintroducing
> > > > > the same concept for the quotaoff rework [1], which might be what you're
> > > > > thinking of. That uses a percpu rwsem since we don't really need a
> > > > > counter, but I suspect could be reused for serialization in this use
> > > > > case as well (assuming I can get some reviews on it.. ;).
> > > > > 
> > > > > FWIW, I was considering putting those quotaoff patches ahead of the log
> > > > > covering work so we could reuse that code again in attr quiesce, but I
> > > > > think I'm pretty close to being able to remove that particular usage
> > > > > entirely.
> > > > 
> > > > I was thinking about using a rwsem to protect the log incompat flags --
> > > > code that thinks it might use a protected feature takes the lock in
> > > > read mode until commit; and the log covering code only clears the
> > > > flags if down_write_trylock succeeds.  That constrains the overhead to
> > > > threads that are trying to use the feature, instead of making all
> > > > threads pay the cost of bumping the counter.
> > > 
> > > If you are going to do that, make it a per-cpu rwsem, because we
> > > really only care about the global shared read overhead in the hot
> > > paths and not the overhead of taking it in write mode if
> > > it is only the log covering code that does that...
> > > 
> > > > > I'm more approaching this from a "what are the requirements and how/why
> > > > > do they justify the associated complexity?" angle. That's why I'm asking
> > > > > things like how much difference does a dynamic bit really make for
> > > > > something like xattrs. But I agree that's less of a concern when
> > > > > associated with more obscure or rarely used operations, so on balance I
> > > > > think that's a fair approach to this mechanism provided we consider
> > > > > suitability on a per feature basis.
> > > > 
> > > > Hm.  If I had to peer into my crystal ball I'd guess that the current
> > > > xattr logging scheme works fine for most xattr users, so I wouldn't
> > > > worry much about the dynamic bit.
> > > > 
> > > > However, I could see things like atomic range exchange being more
> > > > popular, in which case people might notice the overhead of tracking when
> > > > we can turn off the feature bit...
> > > 
> > > Hence a per-cpu rwsem... :)
> > 
> > Yup, it seems to work fine, though now I'm distracted over the posteof
> > cleanup serieses... :)

Well ok, it works with the /huge/ exception that there is no
percpu_rwsem_down_write_trylock, which means that we can't have the log
opportunistically try to grab it while covering.  That's kind of a
bummer, since I don't think that's at all desirable.

> FWIW, I have a patch on the list from a few months ago that introduces a
> transaction percpu rwsem for the quotaoff rework:
> 
> https://lore.kernel.org/linux-xfs/20201001150310.141467-3-bfoster@redhat.com/
> 
> Perhaps I should repost?

Ok?  Though /me is busy collecting things for 5.12 ATM... :)

--D

> 
> Brian
> 
> > --D
> > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > 
> 
