Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2ECFC4743C
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 16:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9E3F6102A
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 16:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhFUQ64 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 12:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232097AbhFUQ6V (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 12:58:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B6DF60200;
        Mon, 21 Jun 2021 16:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624294567;
        bh=pPbwE9oQfN8MldV+Loj9AJUiGw+n6qtm3wpmvBkAc+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qo04DW04kHfWvnWCMk/V9VWF4Gu6fw+/+mvVjoly2Ja6evGTxOZZxgn3776rbzpsw
         BwYIxtKryyuJOwX5hQ7wcQTn5AXtc3SSx6OJeQ867ZgM1NqEnBVwT5SMYxX6wLwWxz
         1d+uMQgotrN7pZjw/tsd/DuyAtrwMAx/za4AUQbZMFeqGqqaBrTTTWsPeqCJdUMKY1
         GWK5mX91IEOj+/K33fSev8ItrDmWqRxTYtY4wnrOk9X2fZMtkrW6W+FUkySH5uieIM
         NpWtXmpM5I5qYhKWmpp7KJld9ZtF9i/LgLS0VFj7BPSMA1aje9tA2/9i85oFGfp/l4
         BWw9CCiQZq8SA==
Date:   Mon, 21 Jun 2021 09:56:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        chandanrlinux@gmail.com, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: shorten the shutdown messages to a single line
Message-ID: <20210621165606.GA3619569@locust>
References: <162404243382.2377241.18273624393083430320.stgit@locust>
 <162404245053.2377241.2678360661858649500.stgit@locust>
 <YNAj8xlFB/XnmVIn@infradead.org>
 <20210621060222.GU664593@dread.disaster.area>
 <YNAscPMObALPLYLa@infradead.org>
 <20210621062929.GV664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621062929.GV664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 21, 2021 at 04:29:29PM +1000, Dave Chinner wrote:
> On Mon, Jun 21, 2021 at 07:06:40AM +0100, Christoph Hellwig wrote:
> > On Mon, Jun 21, 2021 at 04:02:22PM +1000, Dave Chinner wrote:
> > > > >  	if (flags & SHUTDOWN_FORCE_UMOUNT) {
> > > > >  		xfs_alert(mp,
> > > > > -"User initiated shutdown received. Shutting down filesystem");
> > > > > +"User initiated shutdown (0x%x) received. Shutting down filesystem",
> > > > > +				flags);
> > > > >  		return;
> > > > >  	}
> > > > 
> > > > So SHUTDOWN_FORCE_UMOUNT can actually be used together with
> > > > SHUTDOWN_LOG_IO_ERROR so printing something more specific could be
> > > > useful, although I'd prefer text over the hex flags.
> > > 
> > > I'm in the process of reworking the shutdown code because shutdown
> > > is so, so very broken. Can we just fix the message and stop moving
> > > the goal posts on me while I try to fix bugs?
> > 
> > I suggest just not adding these not very useful flags.  That is not
> > moving the goal post.  And I'm growing really tried of this pointlessly
> > aggressive attitude.
> 
> Aggressive? Not at all. I'm being realistic.
> 
> We've still got bugs in the for-next tree that need to be fixed and
> this code is part of the problem. It's already -rc7 and we need to
> focus on understanding the bugs in for-next well enough to either
> fix them or revert them.
> 
> Cosmetic concerns about the code are extremely low priority right
> now, so can you please just have a little patience here and wait for
> me to deal with the bugs rather than bikeshedding log messages that
> might not even exist in a couple of days time?

FWIW I /did/ notice that the flags usage could be turned into an enum
and intentionally left that cleanup (and the "int logerror" sprinkled
everywhere) for 5.15.  Maybe Dave will beat me to it, who knows.

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
