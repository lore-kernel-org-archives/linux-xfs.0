Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF14C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 07:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58F4022573
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 07:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgLDHyr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 02:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgLDHyr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 02:54:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2890FC061A52;
        Thu,  3 Dec 2020 23:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YwMmp9Po9KaoD0NNYk3HwEV3ejsrXIggwtX+cmpAFd8=; b=vd1ekFAS1Iuc4aTT78JnV3zy58
        g4wpw/IAVO93BSBjUdXMCKIf19dLiuJM6DH/2NvcbOSis0lNlnY5EN9g6tqpTk3S4GCAjjOtwvDeh
        UCXX6UhU1yGNBZlZH7AqqtJ5X8MeH6EPb6FYfk9Xemz+mlcaaTzL1eJIuJEjpuEAiZBs3F2Xk0Axg
        16CUEvcBIC4eKvcDAEeJFR+lOKxhgqh2lBPETOUCX9wKfQjhfsb8KlfDuc12Ej8O5ctWdbF/lGaBA
        qBrypqtfGvpwV0+c1QG6AFY7thVJnv5W6Qu1zdkW5H149iDeBObkPSG9EvQdD5/c/YR6pTT3MeH2C
        XDVAAYTA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kl5un-0007uq-Fk; Fri, 04 Dec 2020 07:54:05 +0000
Date:   Fri, 4 Dec 2020 07:54:05 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: initialise attr fork on inode create
Message-ID: <20201204075405.GA30060@infradead.org>
References: <20201202232724.1730114-1-david@fromorbit.com>
 <20201203084012.GA32480@infradead.org>
 <20201203214426.GE3913616@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203214426.GE3913616@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 08:44:26AM +1100, Dave Chinner wrote:
> > > +		if ((IS_ENABLED(CONFIG_SECURITY) && dir->i_sb->s_security) ||
> > > +		    default_acl || acl)
> > > +			need_xattr = true;
> > > +
> > > +		error = xfs_create(XFS_I(dir), &name, mode, rdev,
> > > +					need_xattr, &ip);
> > 
> > It might be wort to factor the condition into a little helper.  Also
> > I think we also have security labels for O_TMPFILE inodes, so it might
> > be worth plugging into that path as well.
> 
> Yeah, a helper is a good idea - I just wanted to get some feedback
> first on whether it's a good idea to peek directly at
> i_sb->s_security or whether there is some other way of knowing ahead
> of time that a security xattr is going to be created. I couldn't
> find one, but that doesn't mean such an interface doesn't exist in
> all the twisty passages of the LSM layers...

I've added the relevant list, maybe someone there has an opinion.
