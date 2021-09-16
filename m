Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57099C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 07:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3063960FA0
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 07:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbhIPHW2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 03:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234786AbhIPHW1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 03:22:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7ABC0613C1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Sep 2021 00:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HPHfuuc31v0XMQu7KxWcU5oK6eX1cM53fJNrX9FMxvI=; b=eg+PlVBAq+dedOD3I351ncARzC
        OOPDs89DKZZg1K6X/8Vcn5GcUNnN+Da9+o1yCv2+ZdIMh6HqLVORAaKkYa7CzZFpxtST3hWo4Ummq
        3yy9ivsOeM3fIvzflSsYWik0oLJ8aZyxGODPyC73fBA2R/CzBQTri16E6MDoGGduytXs/qDpfj7Ze
        nPb1GIqVrmxZs1/hEEWY0Q6G6/tbeLx1OfEgElXivRCfHk3gXeH6fwYCJ05RFKcWoVn74OoS1VzhA
        qfml1rl7eWPb2PGZHz3yPUr7gAoD7SMiLyck/4hmaKS67dr4q+g8f2IpiKnrtczwkinFIIhQfAuFp
        mkQT8/GA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQlh0-00GPd4-FD; Thu, 16 Sep 2021 07:20:29 +0000
Date:   Thu, 16 Sep 2021 08:20:22 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 60/61] xfs_db: convert the agresv command to use
 for_each_perag
Message-ID: <YULwNqhX/DBhlsDn@infradead.org>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174752232.350433.14940185128838830345.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163174752232.350433.14940185128838830345.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 15, 2021 at 04:12:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Convert the AG iteration loop for this debugger command to use
> for_each_perag, since it's the only place in userspace that obvious
> wants it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
