Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9E8C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CC1123370
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbhAMPIk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 10:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbhAMPIj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 10:08:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D91DC061575
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 07:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=H46v1jaLxaK1LtkiZ1NgfXMXLWzcBhcWMgX8zWIkkdg=; b=pRYtW461l0T5y7ly+6krtcvW2C
        nJhcQ29P+S8RLzb2PZxWILta9NCwpH+SN3yBNXgIbuK052owoowjK+s5lYEdUjt4nRVGid1EZNJ93
        IJu0v1Bt4tBC665/G6tZkpu/jLXw9ca7Y8Rtk9Vg5cJXljXecW0hINtwc2taP6CAoAoj4GWX+cXU5
        zEfeWi2YNCkq7Dctdkvf9V/UkuOX2MLVuAeM0DNL+KVOPVS0QpGXxCm8ceJJ8OW8Hnvav/OseCfZe
        zOFII70pqpmQjtV88iCQmqoMe0GbKwn9FeQxpCVbUt0Jn4bqPjuUt53jlXPw0ZciQtxlxEVfYcINf
        +LidMo/g==;
Received: from 213-225-33-181.nat.highway.a1.net ([213.225.33.181] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzhkN-006Oa9-5m; Wed, 13 Jan 2021 15:07:50 +0000
Date:   Wed, 13 Jan 2021 16:07:42 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: rename block gc start and stop functions
Message-ID: <X/8MvsoeW6510REz@infradead.org>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040743287.1582286.3961995540471736727.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161040743287.1582286.3961995540471736727.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 03:23:52PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Shorten the names of the two functions that start and stop block
> preallocation garbage collection and move them up to the other blockgc
> functions.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
