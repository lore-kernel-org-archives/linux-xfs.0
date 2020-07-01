Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1D7C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D19B206A1
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:51:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nvGNq3N9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGAIv7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgGAIv6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:51:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5989DC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SOQzsCwn7NvN76VuqULr4ZgMI0YgbnRr/keOos1P8Co=; b=nvGNq3N9FH26yAdYYq9Iwdr+os
        uTzoabdyDybvytOVtPcGPZm42UlMX9XxO7ctrYp2Er7O7l3bhUvlSpqyaNYuS4uN65agmcI/ZwA9H
        8jAGvdi8kR4owe23ijnz+joBnMWckoUakAfWhoQA4PPl7/3l/bC5bGfVSFS/3XWDTHWVLCg5wQRow
        meMiL/iy0awTGsXE5+57uaiem9t2SSPktSwuIL2mS/tLkq3HlzeGelP6H+aW7GzPcxQE8xwQQdhCM
        qm6dJye/0Lw8BFAn5D5ArL7jdP1pfnYJ3+4NAFCPMDc0jaRqVZUX7JizNLxJvUYeZcdj/X+Wba700
        UWIyRIqQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYTF-0007hC-0j; Wed, 01 Jul 2020 08:51:57 +0000
Date:   Wed, 1 Jul 2020 09:51:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/18] xfs: stop using q_core timers in the quota code
Message-ID: <20200701085156.GJ25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353177481.2864738.2222411495060044495.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353177481.2864738.2222411495060044495.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:42:54AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add timers fields to the incore dquot, and use that instead of the ones
> in qcore.  This eliminates a bunch of endian conversions and will
> eventually allow us to remove qcore entirely.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
