Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE173C11F68
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8A86613ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhGBI7n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 04:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhGBI7n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 04:59:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7303EC061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 01:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=G9nCv8pXyolqSVniCoomKl43FE
        Le2mU3Q919XHmZgM5+EEMlGnwHzudgogRfHoBfJp1fzEoCPowIVuUlUdvfIBTyrQoLvUf6d/apQP1
        EshkVuYAbEf7pBHXOUt04vHG+RoP5fU4f3vCxSW6K8HMVDKx4COUphJ0VXTx174FTs8GhJDBWyu1O
        4OL8BXrb0lTICJbj8s0np8eNG183pqVbgruIuT93xfUgR45TAxSVy5Hwuvd6vAw698RC61J/bjAkE
        NjDfxkWqo9ORALeM9CIPzeWQNeTGsQxf1JPoGZrhbmh510s5hgnANfuOzPAGeiXcUo74DWq6wzALh
        6VFtw+UQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzEyR-007XQB-3x; Fri, 02 Jul 2021 08:56:44 +0000
Date:   Fri, 2 Jul 2021 09:56:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: pass a CIL context to xlog_write()
Message-ID: <YN7UwzT2GT3iMbrC@infradead.org>
References: <20210630072108.1752073-1-david@fromorbit.com>
 <20210630072108.1752073-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630072108.1752073-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
