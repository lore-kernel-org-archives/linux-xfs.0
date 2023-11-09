Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD35C4167B
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 05:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjKIFo5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 00:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjKIFo5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 00:44:57 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598052699;
        Wed,  8 Nov 2023 21:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Y2kRnAxyU7Lk1wqVjZ47TGlVIDqcltxt13uUo8LX3w0=; b=vJRFLsFEVi4+rJGSrI/5ae02Qs
        J50dGs4hVaha0chTDOg8T4bpuS8nz9AUH0CNdPAZrePXzRaMjc4oUWaU6Ofm4pbCRJYO6SvNVId4m
        QkgksqYn4SoCKLUgXbK4D8bfBmhL+rKm7dk8My/31WrEJZAfmAGMJt0SG2OhawaugOvHHQQz5d2ts
        xs8U5Uvog1Lzzsd2jp1s1gUTlFYCngtnHmJUMjuDTrXJu0UPeXrq6io3KSNMr8oZvIagk5e6mizHu
        Fexw6vKvF01RIFYIrImyjge26bG5d/162e6G2u/yeUlBfArkF5RZ0umNGua/0fWbRF0ttDHPDhFgf
        Ly9uLcKw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0xqY-005LAa-0d;
        Thu, 09 Nov 2023 05:44:54 +0000
Date:   Wed, 8 Nov 2023 21:44:54 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-sparse@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: sparse feature request: nocast integer types
Message-ID: <ZUxx1kvWH7dSIazw@infradead.org>
References: <ZUxoJh7NlWw+uBlt@infradead.org>
 <CAMHZB6G_TZJ_uQGm5an0-bhG8wCxpEQrUCShen7O61Q9arAf+Q@mail.gmail.com>
 <ZUxuY13JnQ8IIFd1@infradead.org>
 <CAMHZB6H7Y0m2Y-ZD0PMKiGDeo7_sy=scDrzbBbBuUJfuzLK-Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMHZB6H7Y0m2Y-ZD0PMKiGDeo7_sy=scDrzbBbBuUJfuzLK-Lg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2023 at 06:43:30AM +0100, Luc Van Oostenryck wrote:
> >
> >> Hmm, that's a little suboptimal.  But still a lot better than nothing.
> >> I'll see what I can do with them.
> >>
> >> Thanks a lot!
> >
> > Yes, something in-between is most probably needed and be clearly specified:
> - does it need to define a new type like done for bitwise?
>   Or can it be used like a specifier/attribute
> - when a warning is required: only out-casting?
> - when __force is needed?

For my use case it'd treat it exactly like __bitwise except for also
allowing arithmetics on it.  Bonus for always allowing 0 withou explicit
__force cast just like __bitwise.

