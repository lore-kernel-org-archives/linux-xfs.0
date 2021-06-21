Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AEE9C48BE5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 06:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 565FB61026
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 06:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhFUGJe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 02:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhFUGJd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jun 2021 02:09:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91E3C061574
        for <linux-xfs@vger.kernel.org>; Sun, 20 Jun 2021 23:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rI1ApoFRhISRXpYsH88RfYQGXJ4249CFch6yUoBsQSk=; b=qgCFeMe1QSEbQWh/GaqLNlqEYH
        cZdAMEwpwGLhmADmGb5PFMx52bjHZUX2C7z6hAjAMBIEXWM9CjtiN38E72YGbwiugM5l8DKEEqgbI
        xdJqMT8GBMafSeZLSxJTv23G5OFdCX0/eEvyOs7ZQNJW2MggR5aNQWmKtbR624XXTm4D2bbC3YQ1j
        Xen9k3R9HUViSR1qPrTlGkoKA7qkZBW4MXfQcRaNJw6QyTVKwiRzdtAxVqnHyeM6+vyUcvvPLYFI0
        AgrK6u+SbsuxFXxXNP3Z1yw/WsIY6DTLjBGFGu3+xI58QiAzSvyblb92FKAS+zPjuuf3qOBnq8V7N
        yuyfHZvA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvD4y-00Cm1Q-0n; Mon, 21 Jun 2021 06:06:46 +0000
Date:   Mon, 21 Jun 2021 07:06:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        chandanrlinux@gmail.com, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: shorten the shutdown messages to a single line
Message-ID: <YNAscPMObALPLYLa@infradead.org>
References: <162404243382.2377241.18273624393083430320.stgit@locust>
 <162404245053.2377241.2678360661858649500.stgit@locust>
 <YNAj8xlFB/XnmVIn@infradead.org>
 <20210621060222.GU664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621060222.GU664593@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 21, 2021 at 04:02:22PM +1000, Dave Chinner wrote:
> > >  	if (flags & SHUTDOWN_FORCE_UMOUNT) {
> > >  		xfs_alert(mp,
> > > -"User initiated shutdown received. Shutting down filesystem");
> > > +"User initiated shutdown (0x%x) received. Shutting down filesystem",
> > > +				flags);
> > >  		return;
> > >  	}
> > 
> > So SHUTDOWN_FORCE_UMOUNT can actually be used together with
> > SHUTDOWN_LOG_IO_ERROR so printing something more specific could be
> > useful, although I'd prefer text over the hex flags.
> 
> I'm in the process of reworking the shutdown code because shutdown
> is so, so very broken. Can we just fix the message and stop moving
> the goal posts on me while I try to fix bugs?

I suggest just not adding these not very useful flags.  That is not
moving the goal post.  And I'm growing really tried of this pointlessly
aggressive attitude.
