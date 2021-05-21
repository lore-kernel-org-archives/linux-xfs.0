Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2456C43460
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 07:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83D93613B6
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 07:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbhEUH7f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 May 2021 03:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhEUH7f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 May 2021 03:59:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3882C061574;
        Fri, 21 May 2021 00:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PlTD64atGptX252DwWmvXy/Vb8v9vtRUDNU3mTx23jQ=; b=OxqKp7WckjK0fHpfGRO+W8xZez
        tqhc0uxibnun5R1IfC3Ivau1J+ThD4fWe6ki4DpsKi+9SCUg7NE9tHsyoYHpM1JdcPAuGNimlPc3D
        SgmwmRIQb7bY129RRkuBr3OF2GTXTr/Qk/cOjgjm54VvBU68mC0LtOI3ufdxvnO5vgcPJbqxE9TFa
        E6VN74LIOeTEg5Xt6TbLuZ0kUhUB6XHSmg9ng1hZAMrh30+vgxlQcWgQtWAQIgDxVwEZiJLza0uqM
        3GEz5gMqDy3yptbTl/skFLwrYNszKrBwwDEwdEQydIpVH0MLDQSZ8kLM0hNLv5XP+142l/I+0H2Vo
        mZSsfzvQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lk00y-00GlUt-6V; Fri, 21 May 2021 07:57:04 +0000
Date:   Fri, 21 May 2021 08:56:12 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/6] xfs: force file creation to the data device for
 certain layout tests
Message-ID: <YKdnnJRQhRrGHpab@infradead.org>
References: <162146860057.2500122.8732083536936062491.stgit@magnolia>
 <162146861270.2500122.8499973348974838405.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162146861270.2500122.8499973348974838405.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 04:56:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I found a bunch more tests in the xfs/ directory that try to create
> specific metadata layouts on the data device, either because they're
> fuzz tests or because they're testing specific edge cases of the code
> base.  Either way, these test need to override '-d rtinherit' in the
> MKFS_OPTIONS, so do that with _xfs_force_bdev.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
