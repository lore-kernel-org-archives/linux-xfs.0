Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDBAC433B4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 13:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24FC261394
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 13:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhDGNZ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 09:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhDGNZ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Apr 2021 09:25:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569CDC061756
        for <linux-xfs@vger.kernel.org>; Wed,  7 Apr 2021 06:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cd82FU2EtUAKR7++Zm6dmX0GXI2MEQpILpQFX5Wtm4M=; b=I4zbCIXwkPnE7aZX7KwVBvjuWj
        AztdpyavZWdU2iNQkjwlzeNEfWk8+aTArRVleQhxNlNepQdAoCDmT4+rs4fjmzNpWERNwkEq6DzD2
        gG5noqv3FXB3t4ZaWYU5k+lNTwF0t3hrujCwzbjNLdv3EMTF46Q0Rz1886nBGcZHCWU79Xxk7UAvn
        8NErafJLop8A9uwQgRrJuNHYdC91h05jG04BFE1noiegIuFnxXjb/xyH+Bc+VWUCZB4i9k0ZOJV10
        rL/60aFgXS91FMpQ4GkcgI9trzHKGf1jnyll3jgnsc3kLznPMHTfstqisp5jlVKg3Y/0R3jejQ8u0
        AWrsul6w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lU8Ax-00EWDW-51; Wed, 07 Apr 2021 13:25:00 +0000
Date:   Wed, 7 Apr 2021 14:24:55 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] xfs: transaction subsystem quiesce mechanism
Message-ID: <20210407132455.GA3459356@infradead.org>
References: <20210406144238.814558-1-bfoster@redhat.com>
 <20210406144238.814558-3-bfoster@redhat.com>
 <20210407080041.GB3363884@infradead.org>
 <YG2ZRXp/vPXlvpcB@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YG2ZRXp/vPXlvpcB@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 07, 2021 at 07:36:37AM -0400, Brian Foster wrote:
> Personally, I'd probably have to think about it some more, but initially
> I don't have any strong objection to removing quotaoff support. More
> practically, I suspect we'd have to deprecate it for some period of time
> given that it's a generic interface, has userspace tools, regression
> tests, etc., and may or may not have real users who might want the
> opportunity to object (or adjust).
> 
> Though perhaps potentially avoiding that mess is what you mean by "...
> disables accounting vs.  enforcement." I.e., retain the interface and
> general ability to turn off enforcement, but require a mount cycle in
> the future to disable accounting..? Hmm... that seems like a potentially
> nicer/easier path forward and a less disruptive change. I wonder even if
> we could just (eventually) ignore the accounting disablement flags from
> userspace and if any users would have reason to care about that change
> in behavior.

I'm currently testing a series that just ignores disabling of accounting
and logs a message and that seems to do ok so far.  I'll check if
clearing the on-disk flags as well could work out even better.
