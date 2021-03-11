Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 460EDC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 12:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB19564FE2
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 12:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhCKMzj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 07:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbhCKMzP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 07:55:15 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C74C061574;
        Thu, 11 Mar 2021 04:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=e3bRAv9IBKAV+2VkpoJMJf+k2s
        k9qiOIyBYOJqzlwLZbZ8DUzPk1kuBa9QoJwyQwY5MOSsG69d3AM9vXsWg5yLbUDHJHmjSy4iizRXX
        pn9d+Pwx5GZeuHjfz0vJfhR74p+/t5UODNvW32p8v8+oV56NDXgtifDWVKqEcIEo+eysK8BQ3bXBg
        GWGlVUvlIa+F9WPaDikZ4Sfgskov7t/C8V/TbSdY4EevwZYgC3YUjbg0fQbW1yXibi8NtIJZd4dWq
        zJIzGqYuEJpuaFogEXq/kSxW3DBDHzRe2BsHpoN2nsOUGLiR/0H8qCWxz7VxrSh9rqsrYh3KpgJuy
        r5L0aN4g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKKqA-007KIB-RH; Thu, 11 Mar 2021 12:55:03 +0000
Date:   Thu, 11 Mar 2021 12:54:58 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] fstests: remove libattr dependencies
Message-ID: <20210311125458.GC1742851@infradead.org>
References: <161526476928.1212985.15718497220408703599.stgit@magnolia>
 <161526478017.1212985.2364574454492357224.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161526478017.1212985.2364574454492357224.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
