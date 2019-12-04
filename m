Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5151C43603
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 17:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BAFA2077B
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 17:26:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ruhIkV6O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfLDR04 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:26:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43046 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDR04 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Dec 2019 12:26:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tA827TCIUCnuo2HrrDVk9RPyHRdawKqgkx0I/yRb8og=; b=ruhIkV6OtTnLtJ3FSSF14kPaU
        T5jkUnkD0bb/8l9H9JGEh1S7o3AHJkfUcch2vIgYS8DYHef0iM7R6y+rlX/KOkE9TB80aksqDg/fr
        CWh87C7v7RQx0DmFsPrrETpnCWzv7JcxFZ+IRYnvZx9qg00J3lOT2/pvZDcbP593dXUh0LaynS76J
        iraYQSAstytK/xwkSTCa9AcLaNwZRVA9YYvnkuo7x4TGo2H6doAdvyJ73USkW+iwlwP2ekUTqxMqs
        gohnoDim1ksRK3ngBv3qnAtSvsBaVp1Ftq56k3sFKw2H8PEP3ioza1BK2EHzuWzCpq8euOB3oQB6f
        taFr4HmHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1icYQP-0007Cu-0K; Wed, 04 Dec 2019 17:26:53 +0000
Date:   Wed, 4 Dec 2019 09:26:52 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Pavel Reichl <preichl@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3] mkfs: Break block discard into chunks of 2 GB
Message-ID: <20191204172652.GA27507@infradead.org>
References: <20191128062139.93218-1-preichl@redhat.com>
 <BYAPR04MB5749DD0BFA3B6928A87E54B086410@BYAPR04MB5749.namprd04.prod.outlook.com>
 <1051488a-7f91-5506-9959-ff2812edc9e1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1051488a-7f91-5506-9959-ff2812edc9e1@sandeen.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 04, 2019 at 10:24:32AM -0600, Eric Sandeen wrote:
> It'd be great to fix this universally in the kernel but it seems like
> that patch is in discussion for now, and TBH I don't see any real
> drawbacks to looping in mkfs - it would also solve the problem on any
> old kernel w/o the block layer change.

The problem is that we throw out efficiency for no good reason.

> I'd propose that we go ahead w/ the mkfs change, and if/when the kernel
> handles this better, and it's reasonable to expect that we're running
> on a kernel where it can be interrupted, we could remove the mkfs loop
> at a later date if we wanted to.

I'd rather not touch mkfs if a trivial kernel patch handles the issue.
