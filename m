Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C24AC433B4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 15:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D42361394
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 15:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353920AbhDGPu7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 11:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353890AbhDGPul (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Apr 2021 11:50:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E20B61262;
        Wed,  7 Apr 2021 15:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617810631;
        bh=hX9ufdyEnNR2FCIXaxXolxO7oulHRPo+WUj0bVhB1Ao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CjEfXmm6f3UFa7u3Ch1FgsN3/S9WFAgLe9fsmZsQRwNjJJ7+e0R+aM2qxFWU4pcXK
         VdZPDpaXWUTU2Z2cVDs3GS6ldXmA3zLw5TVPIUF5rXIzjAJ/T9G5yqiuXj7EL+Q0lj
         rWvvhVHfjSXnJmgfeFD60DchS7BKIaWUbKC7ExOH20CBipT0OHR7ZKawTCy7WmNYc+
         asCErNV6VPLVxz8fr/+LJQWT74j/+GmpMPwtXxQBisH2RCk67d48d7c6mVr7AVrD85
         ZjvRgXJuHiIjT0QM0UA+0HInxXndo5C6uyymO1UDvb9wpX5IJffXG3+5xAhk8ILpCr
         WJp9qLRlQ/qAQ==
Date:   Wed, 7 Apr 2021 08:50:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] xfs: transaction subsystem quiesce mechanism
Message-ID: <20210407155030.GN3957620@magnolia>
References: <20210406144238.814558-1-bfoster@redhat.com>
 <20210406144238.814558-3-bfoster@redhat.com>
 <20210407080041.GB3363884@infradead.org>
 <YG2ZRXp/vPXlvpcB@bfoster>
 <20210407132455.GA3459356@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407132455.GA3459356@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 07, 2021 at 02:24:55PM +0100, Christoph Hellwig wrote:
> On Wed, Apr 07, 2021 at 07:36:37AM -0400, Brian Foster wrote:
> > Personally, I'd probably have to think about it some more, but initially
> > I don't have any strong objection to removing quotaoff support. More
> > practically, I suspect we'd have to deprecate it for some period of time
> > given that it's a generic interface, has userspace tools, regression
> > tests, etc., and may or may not have real users who might want the
> > opportunity to object (or adjust).
> > 
> > Though perhaps potentially avoiding that mess is what you mean by "...
> > disables accounting vs.  enforcement." I.e., retain the interface and
> > general ability to turn off enforcement, but require a mount cycle in
> > the future to disable accounting..? Hmm... that seems like a potentially
> > nicer/easier path forward and a less disruptive change. I wonder even if
> > we could just (eventually) ignore the accounting disablement flags from
> > userspace and if any users would have reason to care about that change
> > in behavior.
> 
> I'm currently testing a series that just ignores disabling of accounting
> and logs a message and that seems to do ok so far.  I'll check if
> clearing the on-disk flags as well could work out even better.

While I was rejiggering the inode walk parts of quotaoff I did wonder
why it even mattered to dqpurge the affected dquots **now**.  With patch
1 applied, we could just turn off the _ACTIVE flag and let reclaim
erase them slowly.

--D
