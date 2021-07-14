Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2AFBC07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 07:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88FEA613B2
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 07:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbhGNHWO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238139AbhGNHWN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 03:22:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F00C061574
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 00:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GfSgLypsO752Xsgqzu79Qyl1nGX3P2HYG56yatbwQg4=; b=VwrQ5FYf6FU/ayLvl3ee85YV2W
        zWgSFiWipqJKZwUmTwMGmVR8UODYR8H6xqY3TDqeiIxxu1fAormvPSEqmLD9P9+awUZD5Ksc6TfID
        +w05fnyYWsabP3lx6AwHRJH8lamPMiNBr/gq6+thViQAHILbEqqODfeunDTLrTKLbSR1Bnu7jm7kA
        PqzqpCTMobgNrUWE2MG43xP4qxH5Pc//J+j2+lespN8VBeqY6t5Da1MnJ7r6AjU1hoqsJ+zXC4WHb
        7N7zX/h04ADo07ESoeeYZp+oqgwEwGU4w/oncKZcgVAwJ+4DHSThWfNFbJvcAVJ6fx8iYcOjsrMHq
        ejYhCDtw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3ZAd-001xTw-T5; Wed, 14 Jul 2021 07:19:09 +0000
Date:   Wed, 14 Jul 2021 08:19:03 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/16] xfs: open code sb verifier feature checks
Message-ID: <YO6P55WO21ou8BwK@infradead.org>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-12-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:19:07PM +1000, Dave Chinner wrote:
> Also, move the good version number check into xfs_sb.c instead of it
> being an inline function in xfs_format.h

I think we kept it in the header so that repair can use it trivially
without needing a non-static function without out of file users in the
kernel.
