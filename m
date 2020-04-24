Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5986C55191
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 10:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8837120736
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 10:33:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FXcsfU99"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgDXKdZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 06:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgDXKdY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 06:33:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298FEC09B045
        for <linux-xfs@vger.kernel.org>; Fri, 24 Apr 2020 03:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FwKbLpfa/CJYSzX+ueYAuQa8iqpv6MGFU+rxrQXpZ2I=; b=FXcsfU99tF88XUsBHbKiPQ//wm
        ZuulsJ5OCypOFiS/bbdx95u/hZ9RB3PNCBeqRVkgWzsyEqfS9RwAZNi4H9F5pOJvvoeEpCiGrXnni
        OPnxpYrsP+ve2N/AsNpiiNXefw5szDBIU5Y0tlcCd8E2MlNLeV/TIKar58vPLYGQ71Cv6TJmh2iZX
        U704IAwI2FSoKWbLy6uYiBvXHqcGI3XYYXhMrvVE4PP9Ft2+IYeUNxdlq4N0qqhvF0vGjPdzYOd4q
        Wg/joJZyPpUPIO4VCJJeFs6sqQ/XVxRvG15yMwcw/jZ8Fm+zkQeQKZ6Or2awJWX2qggbrkVaN1uQs
        NBMyujSw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRve7-000334-7f; Fri, 24 Apr 2020 10:33:23 +0000
Date:   Fri, 24 Apr 2020 03:33:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: don't warn about packed members
Message-ID: <20200424103323.GA10781@infradead.org>
References: <20191216215245.13666-1-david@fromorbit.com>
 <20200126110212.GA23829@infradead.org>
 <029fa407-6bf5-c8c0-450a-25bded280fec@sandeen.net>
 <20200312140910.GA11758@infradead.org>
 <b6c1fed7-9e98-7d35-c489-bcdd2a6f9a23@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6c1fed7-9e98-7d35-c489-bcdd2a6f9a23@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 13, 2020 at 09:06:38AM -0500, Eric Sandeen wrote:
> On 3/12/20 9:09 AM, Christoph Hellwig wrote:
> > On Mon, Jan 27, 2020 at 11:43:02AM -0600, Eric Sandeen wrote:
> >> On 1/26/20 5:02 AM, Christoph Hellwig wrote:
> >>> Eric, can you pick this one up?  The warnings are fairly annoying..
> >>>
> >>
> >> Sorry, I had missed this one and/or the feedback on the original patch
> >> wasn't resolved.  I tend to agree that turning off the warning globally
> >> because we know /this/ one is OK seems somewhat suboptimal.
> >>
> >> Let me take a look again.
> > 
> > Can we get this queued up in xfsprogs?  These warnings are pretty
> > annoying..
> 
> 
> Ok.  I don't really like disabling it globally but if it's good enough
> for the kernel... I'll add this to 5.5.0 and push out the release.

Seems like this still isn't in xfsprogs for-next.
