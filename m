Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EEFCC4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45EE32389B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgLGR03 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbgLGR03 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 12:26:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E09C061749;
        Mon,  7 Dec 2020 09:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AGQIg+oueMi6A55NMaIsDwwntSDRLAaqgJpE2Y2vFI8=; b=N+fvHN7hp3O2EWlUAG05xivFKk
        IrO/k0u2ORK1/oZ0VXXMDLAVrpm0eClgkyJCHSSea5bTxD0jJQRBLLuNNeP9gPoPtgY0O5lkpRWrx
        4O6vRNLH9+JtgH5dtzb0GB4Lgq8Fwt57F5rIDRxYDsNFwxvVF5G7O33GydF8EGzInj0vlrQ36zs6f
        ZGauVtg8tQZGT+gZ63TXaPOjTeoHh5lHUOblulx07qqeYbWVSqJgvqw2EIFqhm2iJ8lQ5JlmL7HoE
        JKQunTOuX91ltrUw0nZ0CdAb1ekmgxC7YmVMhPQj/hi9Sqx8aQs6511t6NvuFET6DBKMk+7yYTGYt
        dxCi2jMw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmKGf-0005cI-IG; Mon, 07 Dec 2020 17:25:45 +0000
Date:   Mon, 7 Dec 2020 17:25:45 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: initialise attr fork on inode create
Message-ID: <20201207172545.GA20743@infradead.org>
References: <20201202232724.1730114-1-david@fromorbit.com>
 <20201203084012.GA32480@infradead.org>
 <20201203214426.GE3913616@dread.disaster.area>
 <20201204075405.GA30060@infradead.org>
 <f39eb0d7-e437-5dae-303a-bae399e4bada@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f39eb0d7-e437-5dae-303a-bae399e4bada@schaufler-ca.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 09:22:13AM -0800, Casey Schaufler wrote:
> Only security modules should ever look at what's in the security blob.
> In fact, you can't assume that the presence of a security blob
> (i.e. ...->s_security != NULL) implies "need_xattr", or any other
> state for the superblock.

Maybe "strongly suggests that an xattr will be added" is the better
wording.

> 
> >>  or whether there is some other way of knowing ahead
> >> of time that a security xattr is going to be created. I couldn't
> >> find one, but that doesn't mean such an interface doesn't exist in
> >> all the twisty passages of the LSM layers...
> > I've added the relevant list, maybe someone there has an opinion.
> 
> How is what you're looking for different from security_ismaclabel() ?

Not at all.  What this needs is a guestimate (which doesn't have
to be 100% reliable) that a new inode created by ->create, ->mknod,
or ->mkdir will have an xattr set on it during the creation syscall.
