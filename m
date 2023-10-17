Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9F6CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 05:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjJQF5w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 01:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbjJQF5w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 01:57:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AFEB6;
        Mon, 16 Oct 2023 22:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0hqF3FraEYnMxfUj7zieQAPfPsyUthCr8j2icFG69Sw=; b=jZ6IBs+M3rhjBo/0CdifPyIvYZ
        /w3tQj91UkMeV2ROPIYtSs/N38BlCH9fKOOSnffUUqMvt+vl5+XkDpXQ/c56dXbcSDzhXXaFEx/aA
        +QN0bV8EkXFHdk2+suE38nCixOOUNDeQYMUBQrxaANcaHbMxHzTGpfXf2zG8x6jYWtoT9wgLsr9yg
        +fCmpgKw/U+CnjPDprT0+e7RyGYDu+8nWXD/1I1w0rFYwwWOKKnaCJU1AW/QmvO3Co8OwvnidHQpq
        v68AtPlCb4cp/0JLwW9eFv20k0KKfF4kDI54s0Wv9f50YI91tTwjFJL0Y7xeNaj1JhbT0WXx57i5+
        Vp2D/mRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qsd5N-00BL5C-35;
        Tue, 17 Oct 2023 05:57:45 +0000
Date:   Mon, 16 Oct 2023 22:57:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, willy@infradead.org
Subject: Re: [PATCH v3 07/28] fsverity: always use bitmap to track verified
 status
Message-ID: <ZS4iWdsXQT7CaxS6@infradead.org>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-8-aalbersh@redhat.com>
 <20231011031543.GB1185@sol.localdomain>
 <q75t2etmyq2zjskkquikatp4yg7k2yoyt4oab4grhlg7yu4wyi@6eax4ysvavyk>
 <20231012072746.GA2100@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012072746.GA2100@sol.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 12:27:46AM -0700, Eric Biggers wrote:
> Currently there are two options: PG_checked and the separate bitmap.  I'm not
> yet convinced that removing the support for the PG_checked method is a good
> change.  PG_checked is a nice solution for the cases where it can be used; it
> requires no extra memory, no locking, and has no max file size.  Also, this
> change seems mostly orthogonal to what you're actually trying to accomplish.

Given that willy has been on a (IMHO reasonable) quest to kill off
as many as possible page flags I'd really like to seize the opportunity
and kill PageCheck in fsverity.  How big are the downsides of the bitmap
vs using the page flags, and do they matter in practice?

