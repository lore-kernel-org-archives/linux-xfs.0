Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370D3C64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 10:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD586206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 10:03:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X5Ces4/q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgLAKCu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 05:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgLAKCt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:02:49 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C09FC0613CF
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=S9/iRVWWD3NPEG6GAANZD0CqHIBEasyLbeO/15smGpg=; b=X5Ces4/qKCRxT41DSzLupD5sQY
        +ZOEKl1LWwuKYM0WxDMxdfoJhLtNQ/jfQ8Y20kaJG42p84IzXG4dMExR+dHWXKVxNe/aCSVTcexWr
        SORUyBvVkJRT720UCR5xzQuA4htwR0RmEQudao91X9rEfLkjiYb1fBvvbNgdLxdh4OQ0Jaa1jsUpX
        qkRYhO5QaGJ+znoA0JbdLDSIM9Rnma34KFd8sI2D9UxqVFxuIShsJzYEIhgtwfiIrUm0LaGAx5zNd
        QwGxZMKSezHuCJ1VkKnzEyazMdeOBCIPsqY4AK8CvvCpASX5Mb5h9xXL3Y6F8IUdnIicLMQh2unNl
        mAgsq3Qw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2U2-0002je-UW; Tue, 01 Dec 2020 10:02:06 +0000
Date:   Tue, 1 Dec 2020 10:02:06 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: use reflink to assist unaligned copy_file_range
 calls
Message-ID: <20201201100206.GA10262@infradead.org>
References: <160679383048.447787.12488361211673312070.stgit@magnolia>
 <160679383664.447787.14224539520566294960.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679383664.447787.14224539520566294960.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 07:37:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a copy_file_range handler to XFS so that we can accelerate file
> copies with reflink when the source and destination ranges are not
> block-aligned.  We'll use the generic pagecache copy to handle the
> unaligned edges and attempt to reflink the middle.

Isn't this something we could better handle in the VFS (or a generic
helper) so that all file systems that support reflink could benefit?
