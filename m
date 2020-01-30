Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A7DC2D0DB
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 13:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C37A52082E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 13:31:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TrJkPA49"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbgA3Nbg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 08:31:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49854 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbgA3Nbg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 08:31:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rPL4MXdHkMdY8xLQAYnLWuk0ew8Dz+ZyQ5modCjF8tA=; b=TrJkPA49fGXyWRrDLfalaqe7Z
        Ep7DvEo5ajT3wbvQR0zcd3p53Lg/ILDz6vGHgIO/NCvvlYpNqYXzq7ti+wFdZ6B7rMaRwUDfkX8TJ
        41dotcG+YlVdanSCkMFYIvwEZpdFmmJSKl082bmHj27IrKSyCdI94q3iufEcyC+O965UApC96Dxo3
        mP63WTBdVWMcaAF/j17uPr8vuHBgLDEJgXpzyJrzXtjdNssUH7KeWBwFL8DubDKXtCjGqvLWyuqP6
        6zR/i9A0OnZzYMXXCld3w3Gh8vnCkne2DpWlcdavsL7z5xwCazaMao5D0eAVSrJWSzz9LYDlS5Z9H
        U/Aj5KjkQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ix9ux-0001sh-TR; Thu, 30 Jan 2020 13:31:35 +0000
Date:   Thu, 30 Jan 2020 05:31:35 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: replace mr*() functions with native rwsem calls
Message-ID: <20200130133135.GA21809@infradead.org>
References: <20200128145528.2093039-1-preichl@redhat.com>
 <20200128145528.2093039-5-preichl@redhat.com>
 <20200130074503.GB26672@infradead.org>
 <CAJc7PzUmpRP0-MG49kO5XqZKfM-o4SpYtUKpXC3LC_3Yi2htZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJc7PzUmpRP0-MG49kO5XqZKfM-o4SpYtUKpXC3LC_3Yi2htZg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 30, 2020 at 09:57:02AM +0100, Pavel Reichl wrote:
> the changes are divided into three patches so the changes are really
> obvious and each patch does just one thing...it was actually an extra
> effort to separate the changes but if there's an agreement that it
> does not add any value then I can squash them into one - no problem
> ;-)

Well, they make the change a lot less obvious.  After we have some form
of patch 1, mrlocks are just a pointless wrapper.  Removing it in one
go is completely obvious - splitting it in 3 patches with weird
inbetween states is everything but.
