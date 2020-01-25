Return-Path: <SRS0=/U9k=3O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A88C35242
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32A1220704
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:14:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lcQMikeg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgAYXOp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 18:14:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47132 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbgAYXOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 18:14:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zuo7VJuz9L3Y/NO8xCLnE8TvDTEpUXw2ayO1DpUExiw=; b=lcQMikegG4Z50egpA8m8nLsRT
        kjMEQgF48H7lKtjYsgzy0RMrFGW+FRiLJaygylHRBLccdSpZhWzQRQG/X7nwlQ/nTacY7Frb20veG
        i8Gs6oQ92MuuLIeWO8wkD5+UyPCg3slk1Rx4hyZr8G9IB4Z78QJjOqfUxhf0bS2bF/Kr1F9y8sqrP
        IbiyKkZRPYXDgZhBd1NMnKRcuVRzu1kvb7ktbNwndPVr/tR6WVV/iXwlxtp9+FockDA32zReNZep3
        P/fxmNq1dsFipANGBudwIVqCpgW2l7aG/UGYlM9l/+9japtahyxq+0Ts9+/sM1J+127B7muiaIHAm
        /MpB2OjGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivUdX-0005QE-Km; Sat, 25 Jan 2020 23:14:43 +0000
Date:   Sat, 25 Jan 2020 15:14:43 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfsprogs: alphabetize libxfs_api_defs.h
Message-ID: <20200125231443.GC15222@infradead.org>
References: <e0f6e0e5-d5e0-1829-f08c-0ec6e6095fb0@redhat.com>
 <5660a718-54b8-2139-8bcf-ae362d09ee5e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5660a718-54b8-2139-8bcf-ae362d09ee5e@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 22, 2020 at 10:41:05AM -0600, Eric Sandeen wrote:
> Rather than randomly choosing locations for new #defines in the
> future, alphabetize the file now for consistency.

This looks ok, but can we just kill off the stupid libxfs_ aliases
instead?  They add absolutely no value.  I volunteer to do the work.
