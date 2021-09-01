Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6DBC4320A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 08:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CB1F61057
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 08:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241806AbhIAIw2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 04:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241376AbhIAIw2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 04:52:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D62C061575;
        Wed,  1 Sep 2021 01:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=U7PQLg24X47IaBeqGNAf8OVFgR
        wzT8CYP6KcuQMzqlSU8jrf/zcMP+VQzE3NTScTGE/a6FK6M6s84ifxF9eE6vl7s+8kEVllufVYzf2
        Ki3vDr5l/SsJ+pU64TsxgpUTz+D5OOjDSZbFb5+5ywj9gk12lguNuaS8wmqZ1Np4ARz5lnWDlupce
        9EkTic+hMO48EGa3J11gxbj1S+4a8tPx45uHdFJqkWDmEIwPYqVCAezw4w9DleXUcaanlyg5JqGZ8
        L/sPeTzShmaYdYG6t1u6L4RNaYbJJf0RYq/3/RajL7l+IPXhh/Rv3vb3CL+tdSwJ5xzs0mvmU5ED1
        jiPqcEmw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLLx0-0023rk-24; Wed, 01 Sep 2021 08:50:46 +0000
Date:   Wed, 1 Sep 2021 09:50:30 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 4/5] tools: make sure that test groups are described in
 the documentation
Message-ID: <YS8+1m8EQCCsaaPy@infradead.org>
References: <163045514980.771564.6282165259140399788.stgit@magnolia>
 <163045517173.771564.1524162806861567173.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163045517173.771564.1524162806861567173.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
