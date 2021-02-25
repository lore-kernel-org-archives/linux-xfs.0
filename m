Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF64C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 07:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B019464E21
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 07:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbhBYHmY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 02:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbhBYHlw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 02:41:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E964DC061786
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 23:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=waO0gUURus4WiWoQeq/WsAUMQ9xF7X3Zd6Yj3yfiB+Y=; b=k/Mxih16G47DcwJJhWkkN8jKPS
        Ak0iSPf/DhKKVzTUYm5AZmVYg8DjOMjUfgUKbeq/d+hXwbY0RfPBhB0xO0YE0wcsjf+9X+QrduFHv
        dhQRX6+eGRicsH09WuVKOnZB0gC+4twnOfzuTh1Yrds3C+MGFULuVNf9cZKZ+HZm8vjH2L4fHm0h0
        sWJLSrXBD3MpI7HMfniiO6rpz3UDyG7DtYWqTEYONpAd9twdzN7JLcw9J0B7uDvAneX8MB7Q8gtES
        zmZ2+05ewJ8d5884imhhxFW7Rlgf0ZwYZ44pcQjhxLXPD4HLhVHnujEeSIS8tmlrmkhCfFshcZ1v/
        nsW4KMRQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBGS-00AQHS-M7; Thu, 25 Feb 2021 07:40:59 +0000
Date:   Thu, 25 Feb 2021 07:40:48 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, hch@lst.de,
        bfoster@redhat.com
Subject: Re: [PATCH 2/5] xfs_repair: allow upgrades to v5 filesystems
Message-ID: <20210225074048.GE2483198@infradead.org>
References: <161319522350.423010.5768275226481994478.stgit@magnolia>
 <161319523460.423010.11387475504369174814.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161319523460.423010.11387475504369174814.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 12, 2021 at 09:47:14PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add some helper functions so that we can allow users to upgrade V5
> filesystems in a sane manner.  This just lands the boilerplate; the
> actual feature validation and whatnot will land in the next patches.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
