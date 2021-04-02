Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CCEFC433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 06:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DE9261107
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 06:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhDBGrA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 02:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhDBGq6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 02:46:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079D3C0613E6
        for <linux-xfs@vger.kernel.org>; Thu,  1 Apr 2021 23:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KZb5C7Dr/oa5zAnCxyOLJlJ9SPCMRQiBkBLIlFuN4cA=; b=H+oA5OBwJG4ib1KGj3HTWIOZps
        g6OKzLlkbFO2eAHPfn1OjXRqsJV3AFwTguft/HMY7MS5UAQEWztJ7O3xrlrSSdKTCA/cXUybCN7aj
        K6Wny0VNvWyn3AGOjXOx8Y4abHfojRqEHrriQzD9AuZ3BiUnWApOEJOpgsRx9NOCMfpU6jYm3b3DJ
        qnYPRaLYOPH6EA2PpFW3Bq4Mg136YquvuuhdOheGUAcB+rGoS4NZ7UJw3/wci4Y31CfUFxKN/aWtH
        0YaUcTRyFz4Shwzb6W1hDMSLwjQyoj0+Z4d6OUWNSm8c3XPWz0lp11yuPaqRIGZa1J4OnbZkIrIYz
        4vjaFOPw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSDZu-007Inb-16; Fri, 02 Apr 2021 06:46:47 +0000
Date:   Fri, 2 Apr 2021 07:46:46 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] design: document the new inode btree counter feature
Message-ID: <20210402064646.GC1739516@infradead.org>
References: <161672690975.721010.3851165011742824524.stgit@magnolia>
 <161672691610.721010.7862802842151633155.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161672691610.721010.7862802842151633155.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 07:48:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Update the ondisk format documentation to discuss the inode btree
> counter feature.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
