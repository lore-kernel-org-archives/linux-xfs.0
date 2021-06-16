Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FAB3C48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 05:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F32B1613BF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 05:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhFPFnx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 01:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhFPFnx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 01:43:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3024C061574;
        Tue, 15 Jun 2021 22:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9VGm5xaLvjbFDtoros7tGjv8KsB0cEAWZOcOjV8QoDE=; b=qU/flGsc+XimPohXeJB7kypdkX
        Gg7q6E4xhO6o7WVwsBT7mygdtcg7oHu+erPHyjUv4/RN1t7ESssYa4T1AUNbhdE3piWRm8BzlkQ58
        hpJpEcmbTACgVcbCi40dKnzU4PArS8kqmPKMBG7xqkmuzsYvY2+QlR9T3sDvx6zXVcdHHRIMOCHYG
        8Ffu4MkSYcLKeS4DTCqakWl68bIIxJL/55dvJx7rESVWx9qlQmfPPIEyu8XaN4KmSE8ivNbCzGwTG
        zFp9oIJgY9iNhXRc/84yLAyFa3QWMrnY08XGeTdJaxugqGjJuwV/UwZBeIGB5sQh1VowvTIJPrl9z
        yrPt7bxQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltOIn-007eL0-03; Wed, 16 Jun 2021 05:41:29 +0000
Date:   Wed, 16 Jun 2021 06:41:24 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Subject: Re: [PATCH 02/13] misc: move exit status into trap handler
Message-ID: <YMmPBFyHuSuG5WGM@infradead.org>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370435035.3800603.9525365377170213035.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162370435035.3800603.9525365377170213035.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 01:59:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the "exit $status" clause of the _cleanup function into the
> argument to the "trap" command so that we can standardize the
> registration of the atexit cleanup code in the next few patches.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
