Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 007DFC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD3252177B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:12:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FJbj/BDJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgH0IMl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgH0IMl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 04:12:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754D0C061264
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 01:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oDvytrgzYwuLB+lopO1vq3JZpj4K1FDO8c/KEezltFE=; b=FJbj/BDJdoXOfDVPRIupjw67PH
        zkitWKIlun6fJiak/e52w2WkLPlYMb+Gg7gwl1SEqrg7SfWHA26p2xqf0/Goh8t26EQxJUayrZ0Ft
        nU9Lj0s4rKyocXe67fZXugPG4CUsDi80vqioIgLJDZLuUA4zu6yXzH6UOJnX0/hdO9zWwucqpITyf
        eGaDYhwVzSGAELds7+JK5tjb0ipIw7IAb3/cAQM4j5SoV2OHXIBHBIr5SsvK2szIWnnLqkdLjc0a8
        /lSREeWHeuEsofTv1rzhdnkdtE+L5kmrIZlhqQdj/4g1IC82zFAtc7m3dQlsah5NZNzFgDphdkMpp
        Q3tkxk+g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBD1T-0002JI-5F; Thu, 27 Aug 2020 08:12:39 +0000
Date:   Thu, 27 Aug 2020 09:12:39 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: fix boundary test in xfs_attr_shortform_verify
Message-ID: <20200827081239.GC7605@infradead.org>
References: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
 <689c4eda-dd80-c1bd-843f-1b485bfddc5a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <689c4eda-dd80-c1bd-843f-1b485bfddc5a@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Can you follow up with the struct definition fix ASAP?
