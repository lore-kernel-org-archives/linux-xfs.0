Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926DAC61D85
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Nov 2023 16:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjKUQIp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Nov 2023 11:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbjKUQIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Nov 2023 11:08:44 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED572126
        for <linux-xfs@vger.kernel.org>; Tue, 21 Nov 2023 08:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Vme0PKTQGmQm9tKRNPr1/XLq5bwvhQ0UELIYmH1q/aI=; b=Q0Y1sW25kL78w0sZqq1h+SZPZy
        3VHBUcAkvp/OhfXhjw05ZpVtOOsDca9KxCjC7HQLq22iEiAQ3CGPzc+tCi0p6NNGnv7YsX/Wo6TmG
        mLO0D3CfKv7jd8HjKj9oYSZxVAPFOHz6zZFhD3oOuxco/D/lwqh52yRUOPTjEvAHtH89Uvk7ysnGc
        uVehK986T7hp+YSYhhwqU9P+h5eUtkfh99DGk4XaD2DFxoNgm+pwnWO9Ub62gWcKkzuSRj91e1VP0
        rJC8aEr706WoM5Cbfd69AAxEEPV55efWtAMaDSDYLsRMnMQPEnJ60ULurwNkQenhe2wCVb+/fTwDn
        j5lVnVXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r5TIl-00HFIl-2u;
        Tue, 21 Nov 2023 16:08:39 +0000
Date:   Tue, 21 Nov 2023 08:08:39 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jianan Wang <wangjianan.zju@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: Question on xfs related kernel panic
Message-ID: <ZVzWB5JFW9vqpJ6F@infradead.org>
References: <911c61d5-08e6-4233-a1dc-5b3df2250031@gmail.com>
 <20231110193440.GL1205143@frogsfrogsfrogs>
 <179cca2a-65ee-45cf-8d5c-ca09fc18212e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179cca2a-65ee-45cf-8d5c-ca09fc18212e@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 10, 2023 at 02:23:53PM -0800, Jianan Wang wrote:
> Hi Darrick,
> 
> Thanks for your response. I will open a case to Ubuntu on this issue. However, can you give me a hint on what could be wrong? Failed to kmalloc seems to be a pretty severe issue, and is that related to any kind of kernel memory corruption by certain kernel modules or so?

The P taint suggest you have a proprietary module loaded.  Nothing
is even remotely supportable for that case.
