Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B76C1975A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 19:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C07720735
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 19:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XSCW0b7z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgCQTB3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 15:01:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57204 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgCQTB3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 15:01:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=W+oLwk4y4fLeD/iCzrzFHQxBHbqN3vWud7wLkhGItMg=; b=XSCW0b7ziC0FTzAGuhUriL/f+y
        NRMkP0cmv8u5FaYLTqXUxNOpe7up0XHfPmF5fagW5IVoqpHXo2YXWxnBqWbaC1FeJV6cZj5VDS/hl
        6c7m1k5Ly2QdPaiwNcGdM31PKuSXg2MGs7V5xuR3BblZ78W1KHx+gpw5qLw61RYMovyf/doHl3rYt
        3OvTQHkXkD0DvvPuXtUUWDc/F0ZeYic991RrBceAjSx90gDijo3aDEvm2nXybTI2msHpq93NZdCnX
        xM07TvNDl5G6szIecaEApttXWyx2/8Ub60I28LGtL4eMQYF0jQ41o2KOe5DiAxT7KN42+iv+rUL7n
        QJIOKNGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEHSs-00033P-Vp; Tue, 17 Mar 2020 19:01:22 +0000
Date:   Tue, 17 Mar 2020 12:01:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     bfoster@redhat.com, dchinner@redhat.com, sandeen@sandeen.net,
        darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        yi.zhang@huawei.com, houtao1@huawei.com
Subject: Re: [PATCH v2 1/2] xfs: always init fdblocks in mount
Message-ID: <20200317190122.GB4168@infradead.org>
References: <1584428702-127436-1-git-send-email-zhengbin13@huawei.com>
 <1584428702-127436-2-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584428702-127436-2-git-send-email-zhengbin13@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

So if we can't trust the sb counters on your fuzzed file system,
how can we trust the AG counters?

Also if we decide that we always want to rebuild and thus always read
in the pagf all the pagf_init checks can go away..
