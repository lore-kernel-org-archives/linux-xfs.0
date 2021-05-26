Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE231C47088
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 18:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE18F613E6
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 18:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbhEZS1s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 14:27:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235484AbhEZS1n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 May 2021 14:27:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4C8F613AC;
        Wed, 26 May 2021 18:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622053571;
        bh=Rjfk/ZPO0Mlr6l38CNkP+6LjMZv1NlJRwnD/ph0vwXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UvXDXmk9e2fuZ4gHySewzh9G6cUUR7+BNcmd5urb9AvMp+tOp7MXz8RC8GPrXhDd4
         ChjjgURfHmHKtz0X6+2HndyupQFQHpypk2jHReTq7u5BhnIYtDqQ+U4ybBQ+Upd3O7
         P8L0QIGF58BM0zv6GethDWWKWzwiKqyArjBSTPWIRbU7evxoZ+0DjGyIqYqkNETT3g
         2r6F6aB40eqUSpZ5f6oDME0DDJO/lELooGna3txM+OSZmuhbdyYy+ij9gLAh32ZwUT
         mNVzu4tSN5Irv8N0x+HTuJpToArNcW3q+42LPwReVy07v7b0OzVoE86IM0Y8WwzDR1
         xHd6NfEra3hLA==
Date:   Wed, 26 May 2021 11:26:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>
Subject: Re: patch review scheduling...
Message-ID: <20210526182611.GI202144@locust>
References: <20210526012704.GH202144@locust>
 <YK42pwKb48UnzOpR@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK42pwKb48UnzOpR@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 26, 2021 at 07:53:11AM -0400, Brian Foster wrote:
> On Tue, May 25, 2021 at 06:27:04PM -0700, Darrick J. Wong wrote:
> > Hello list, frequent-submitters, and usual-reviewer-suspects:
> > 
> > As you've all seen, we have quite a backlog of patch review for 5.14
> > already.  The people cc'd on this message are the ones who either (a)
> > authored the patches caught in the backlog, (b) commented on previous
> > iterations of them, or (c) have participated in a lot of reviews before.
> > 
> > Normally I'd just chug through them all until I get to the end, but even
> > after speed-reading through the shorter series (deferred xattrs,
> > mmaplock, reflink+dax) I still have 73 to go, which is down from 109
> > this morning.
> > 
> > So, time to be a bit more aggressive about planning.  I would love it if
> > people dedicated some time this week to reviewing things, but before we
> > even get there, I have other questions:
> > 
> > Dave: Between the CIL improvements and the perag refactoring, which
> > would you rather get reviewed first?  The CIL improvments patches have
> > been circulating longer, but they're more subtle changes.
> > 
> > Dave and Christoph: Can I rely on you both to sort out whatever
> > conflicts arose around reworking memory page allocation for xfs_bufs?
> > 
> > Brian: Is it worth the time to iterate more on the ioend thresholds in
> > the "iomap: avoid soft lockup warnings" series?  Specifically, I was
> > kind of interested in whether or not we should/could scale the max ioend
> > size limit with the optimal/max io request size that devices report,
> > though I'm getting a feeling that block device limits are all over the
> > place maybe we should start with the static limit and iterate up (or
> > down?) from there...?
> > 
> 
> I was starting to think about the optimal I/O size thing yesterday given
> the latest feedback. I think it makes sense and it's probably easy
> enough to incorporate, but if you're asking me about patch processing
> logistics, IMO none of the changes or outstanding feedback since the v2
> (inline w/ v1) are terribly important to fix the original problem.
> 
> Most of the feedback since v2 has been additive (i.e. "fix this problem
> too") or surmising about inconsequential things like cond_resched()
> usage or whether the threshold should be defined based on pages or not.
> v2 used a large threshold to avoid things like risk of
> unintended/unexpected consequences causing a revert down the line and
> reintroducing the soft lockup problem, which is otherwise easily fixable
> without significant change to functional behavior (given the current
> worst case of unbound aggregation). So since you ask and after having
> thought about it, if you're looking for a targeted fix to merge sooner
> rather than later I think the smart thing to do is stick with v2 and
> rebase the subsequent changes to reduce interrupt context latency and
> general completion latency on top of that. (In fact, I probably should
> have done that for v3.)

Yeah, this basically comes down to: take v2 as a fix for 5.13?  Or v3
as a larger fix for 5.14?  I guess I'm the one ranting about having too
many stall warning escalations, so it's up to me to pick something.
TBH I like the "put v3 in 5.14" option since it gives us a much longer
testing ramp...

--D

> 
> Brian
> 
> > Everyone else: If you'd like to review something, please stake a claim
> > and start reading.
> > 
> > Everyone else not on cc: You're included too!  If you like! :)
> > 
> > --D
> > 
> 
