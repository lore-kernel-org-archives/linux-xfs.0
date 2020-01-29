Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E782C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 18:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0F88206D4
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 18:05:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ijP1e+m1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgA2SFu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 13:05:50 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57968 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgA2SFu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 13:05:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FtXN+ihjLcTWyR5RDJVDJm8f88d5m5LcR/gfJ6tAjGU=; b=ijP1e+m1SXZlmvcThnpB4AmI2
        KF8atCpEXM18UPwHkj2dlMQO8Z9iMj0g7MMIR3y/kRnf0YlaHIVuHzfkqKXrr3RFYbwZ2DmQqnIUh
        nzHmY8KVoax3EzhWihOeRnINu/aDi7epkDiSmiPu0HPjHmfuy+u4b6v+1m/FEfxnOnjCHHwXwCG6P
        jGnfFQxHanDDjjCxW5s/ww3sDofNBGPPJ4G6oFU8r8Ps3z+RUTydpbmENSCrudA72rorRANtq8V/6
        4hSDgCli4ci4EAwIYZ8qFAASUzIjRy7Gyq20N72ACy4fBcQbGHpofwsl/sN8PRgJkmHycxD8ropo8
        +FpnRcXNQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwrin-00059N-Ox; Wed, 29 Jan 2020 18:05:49 +0000
Date:   Wed, 29 Jan 2020 10:05:49 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: do not redeclare globals provided by libraries
Message-ID: <20200129180549.GA14855@infradead.org>
References: <0892b951-ac99-9f84-9c65-421798daa547@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0892b951-ac99-9f84-9c65-421798daa547@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 27, 2020 at 04:56:02PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> In each of these cases, db, logprint, and mdrestore are redeclaring
> as a global variable something which was already provided by a
> library they link with.

Independent of any better way to handle the library interaction this
looks like an improvement on its own:

Reviewed-by: Christoph Hellwig <hch@lst.de>
