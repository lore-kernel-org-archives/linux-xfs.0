Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26FEC2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7051F613DB
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhFQIOd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 04:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhFQIOc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 04:14:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B37C061574
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 01:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=TPM1Brib/ohN08NsJ5VdPeF+ol
        7yCoQibJzJ4KmVO7XtD75lqFjE459J7Qrlf9lpNVu4pY9vf2xF/o8Bcn9sRUyXf43ZzRtCQDcZpCi
        NtSgC9aU+Bu+eYMYIVa97+giOxXomBlL71Dq3bvDbuwQsl8lqEsmxtB87O6DMTeN+oMc01kZzCM8d
        D4lyqNsRab9EH/H36PVdMMwv46hbalEPFayJf1zVY3qTeHRfDj+iXDKRarQl4vgVhoCOfHiel5Xiv
        Gxfrm3NEw+hwFKDjvPnc4STBAfKebSgzFThz5A/b4IOtbjzrlAwPKIdlWKHg0+2k0wJCzhvyw1UIA
        hpL0b3VA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltn8K-008uPB-H5; Thu, 17 Jun 2021 08:12:18 +0000
Date:   Thu, 17 Jun 2021 09:12:16 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix log intent recovery ENOSPC shutdowns when
 inactivating inodes
Message-ID: <YMsD4EqGR5QdyR8s@infradead.org>
References: <162388773802.3427167.4556309820960423454.stgit@locust>
 <162388774359.3427167.14326615553028119265.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162388774359.3427167.14326615553028119265.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
