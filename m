Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 427D2C63793
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 06:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2118E61279
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 06:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhGVF7v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 01:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhGVF7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 01:59:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3072AC061575;
        Wed, 21 Jul 2021 23:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J0LiYdo9Jf82hkLx0nUWfst8prXX9riEpoRbphSJtI0=; b=DUTNPMYlQelVIJTGoaavXBEbXI
        xtclEKJ0BSMNBbDEg94L8ODPisgVaJC1vDx3Pe3vHwJ7xQlKIfWaAVxQXeY+e0EtXlQHtpLVrGrt6
        Bl1M4Zco1JZ38Jvcab4jgGg0ctaScrOFkofp0wkzWiHQdvi7YpYiUwzkSZgWnM6RC9xVSrO5O93rS
        pAcFtMNRTNjoSitKIgOqCRwpVgPsawwA9vQF6c//ITyuO0lnx3OGhTPscWUe21E/TfX81EXjYvwka
        CGjr/G8qYXVF0yHnUrs+M96BJ1yxCvnhwIMkZubr5T4ry/CeE3aFGs/3ReoSoq+ztKya+y92tCm5/
        mZg9Vatg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6SN9-009xqL-L2; Thu, 22 Jul 2021 06:40:05 +0000
Date:   Thu, 22 Jul 2021 07:39:55 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/1] xfs: test regression in shrink when EOFS splits a
 sparse inode cluster
Message-ID: <YPkSu7fKSQr6GHMR@infradead.org>
References: <162674333583.2650988.770205039530275517.stgit@magnolia>
 <162674334129.2650988.5261253913273700235.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162674334129.2650988.5261253913273700235.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

What do EOFS and EOAG stand for?
