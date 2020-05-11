Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D62C47255
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 15:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0468206DB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 15:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mAJe8CtF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgEKPfd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 11:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726173AbgEKPfd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 11:35:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13950C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 08:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mdXUqDkHLMbfYTTJOGy/y5Li8HJCTvdIf6xVfr17wFQ=; b=mAJe8CtFxD67PP26KAZVRVn5F9
        nJlU4vC2KCglzEiWcWcjfnc0jFFQmFH5OMGk6EXpLGnXHFvMU/DJwp4jM9iTTA2VF66dK/YmPHiGf
        urfko5VSvlcBXynYGvs/VKY8ckahsA3Vg8vqvsyHhBbDxTrv0AUqXkD021YxR8/VhCCjbWvv6prlz
        lpFLV6NWoMnVQTDGvDI6gUgerZlwfUlQle11I5Z2HWp8x+5XR97iMaac4h/l7fDEGaNoy6x/pKLjI
        /5FNIPHT52Yc2/9K4ydWdN16XwkVU34TYtHVyZqsZPraTD8tCdYSTe8XgrJGvUMxTv8dNIhgA7Q94
        TDc9+40Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYASq-0001NP-AF; Mon, 11 May 2020 15:35:32 +0000
Date:   Mon, 11 May 2020 08:35:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] xfs: allow adjusting individual quota grace times
Message-ID: <20200511153532.GB11320@infradead.org>
References: <ca1d2bb6-6f37-255c-1015-a20c6060d81c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca1d2bb6-6f37-255c-1015-a20c6060d81c@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 02:47:02PM -0500, Eric Sandeen wrote:
> So there's no real way to know that the grace period adjustment failed
> on an older kernel.  We could consider that a bug and fix it, or
> consider it a change in behavior that we can't just make without
> at least some form of versioning.  Thoughts?

I'd consider a bug, as applications are very unlikely to rely on
these ignored calls (famous last words..).
