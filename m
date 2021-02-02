Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A4D9C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD17664DD6
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239216AbhBBTTv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234354AbhBBTRl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 14:17:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537FEC0613ED
        for <linux-xfs@vger.kernel.org>; Tue,  2 Feb 2021 11:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=E18ts8mx6uclSndh+14UYCXqmo6eG0t24yqjvFX1Pr8=; b=aRh39iGnbFXdlJajF5Li6hUsxv
        i2RHNAyWiUww5HyDsyozFgIikVBHgHqCxZCJoXO94QROGLQHz1LORtNTxvY44j8GL7jhEwrX3Y9fA
        WsAo5eF6VkoPq0vx6MwAikf6qT1bToy2rwkW4Mq+7vR2ddExvFNSB442oxgfOB5sFX51oqtP7h3W3
        8sq03kOeAEExbQ7Q16ZVPnHm7pubqKviHcA0X52XG/M4YGpNDu90J/5uZqIXp8uKrlJhCP46n6j6+
        K2FPMusK2pH19pBV2VulV5EcVdgoi10K2ZP3k5DkJswTqLupLYyJmHjpQH0jycxZhZE25Y486QCsP
        Z1qMjgow==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l71AV-00FeOx-Eg; Tue, 02 Feb 2021 19:16:56 +0000
Date:   Tue, 2 Feb 2021 19:16:55 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_quota: drop pointless qsort cmp casting
Message-ID: <20210202191655.GA3729393@infradead.org>
References: <85f43472-5341-b979-3c7b-7e49a6ba0ce4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85f43472-5341-b979-3c7b-7e49a6ba0ce4@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 02, 2021 at 01:08:31PM -0600, Eric Sandeen wrote:
> -	du_t		*p2)
> +	const void	*p1,
> +	const void	*p2)
>  {
> -	if (p1->blocks > p2->blocks)
> +	du_t		*d1 = (struct du *)p1;
> +	du_t		*d2 = (struct du *)p2;

Do we even need the casts here?  Shouldn't this be something like:

	const struct du		*d1 = p1;
	const struct du		*d2 = p2;

