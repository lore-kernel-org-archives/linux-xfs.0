Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF51C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 118EF23383
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbhAMPZa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 10:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbhAMPZa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 10:25:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50B6C061795
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 07:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vDBqRzPjSiwj+Bh7zJjs9wvmqU3kFPqcd8has4r+t3s=; b=XDoAjqyRXgl0uEfP/vboqUPa7C
        /gZgxe5HgiFV9Yj+merjpqXAMZqgjPchDqpDC8TuMfBdFMMXJAIn1aDBweXkxzg45lTZDbQ6a4Iei
        1T8LjZIove8HCHPvacK1YoT/GwRa201CHpZuyNXWypjaKVWsPHvVI0LOaIGJB2Xu0IFp250A/uUot
        mn8E1szdHT2m6SDvO3vtTRidwjlBPKm7nWP+9471h8eaQ3z7DSLaZKfkoOUaAuK3dip2+kCfX31pO
        4ybUM2is0Ne44yy5Y+KbRlu8l1l3OOG2b7QoJewqsBmx/ssyDUyB8e+wScDaZGNXF77kEHxpaXEXU
        9ttqcUXQ==;
Received: from 213-225-33-181.nat.highway.a1.net ([213.225.33.181] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzi0T-006PNe-MW; Wed, 13 Jan 2021 15:24:27 +0000
Date:   Wed, 13 Jan 2021 16:24:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: lift writable fs check up into log worker task
Message-ID: <X/8QpEDaRN2djf6i@infradead.org>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106174127.805660-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 06, 2021 at 12:41:20PM -0500, Brian Foster wrote:
> The log covering helper checks whether the filesystem is writable to
> determine whether to cover the log. The helper is currently only
> called from the background log worker. In preparation to reuse the
> helper from freezing contexts, lift the check into xfs_log_worker().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
