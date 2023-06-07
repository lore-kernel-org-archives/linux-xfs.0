Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FE0C77B7A
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jun 2023 07:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239379AbjFGHug (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 03:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239488AbjFGHt4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 03:49:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D11E1FF1
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 00:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PxELtJj+1c7AKO9TGoDaV4kw0FPN43rMrqlcRwCs5ZQ=; b=LSbMbwh7TsAn+21yuBLKb5uqkb
        2tjlCP8ztar8yDluJcrrrkMXehNhusxgN1zmVQTYeb41QE9zEl+EVqx7iKopvmVuatyTIs1v7+qbC
        iU3PnQ88Lp4MEmm5mh7NMaqWMIGJvQ3mJuqlEMICdb6dk2GK41FGJi3emMYp5PpZZSmiG6DRcZSsM
        oCigOIOffdj9eKrTYS3/FscJazG1u8ThEiVw/IZJudW5T1YlORqrEshdKfOIlukIlyrl9AgNjkJDt
        CJp6ucHcl9IGl2qLClz9GVTQjbyjRMvIWqXrqT49M9nvgkwTmprn56TnT86Fbik7ZC25ZrBa8loma
        36YP1SKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q6ntk-004npR-19;
        Wed, 07 Jun 2023 07:48:04 +0000
Date:   Wed, 7 Jun 2023 00:48:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: Comment out unreachable code within
 xchk_fscounters()
Message-ID: <ZIA2NLCSw7nVMh6w@infradead.org>
References: <20230606151122.853315-1-cem@kernel.org>
 <i5VjxsfPIrRyvOoqV6BqW6qno66Gxsc-zGbsc1RZ60MawgxcwuoRtOODkv1SKvanvnXaNriVpBuIGtR99YA_Vw==@protonmail.internalid>
 <ZIAmCHghf8Acr26I@infradead.org>
 <20230607073757.zwfhie3qbn7mox5i@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607073757.zwfhie3qbn7mox5i@andromeda>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 07, 2023 at 09:37:57AM +0200, Carlos Maiolino wrote:
> The code isn't dead, it's temporarily broken. I spoke with Darrick about
> removing it, but by doing that, later, 'reverting' the patch that removed the
> broken code, will break the git history (specifically for git blame), and I
> didn't want to give Darrick extra work by needing to re-add back all this code
> later when he come back to work on this.
> Anyway, just an attempt to quiet built test warning alerts :)
> I'm totally fine ^R'ing these emails :)

#if 0 is a realy bad thing.  I'd much prefer to remvoe it and re-added
it when needed.  But even if Darrick insists on just disabling it, you
need to add a comment explaining what is going on, because otherwise
people will just trip over the complete undocumented #if 0 with a
completely meaningless commit message in git-blame.  That's how people
dealt with code in the early 90s and not now.
