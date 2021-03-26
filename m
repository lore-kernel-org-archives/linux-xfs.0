Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C9C0C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 06:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6218461A36
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 06:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhCZGAu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 02:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCZGAR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Mar 2021 02:00:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75942C0613AA
        for <linux-xfs@vger.kernel.org>; Thu, 25 Mar 2021 23:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OqfjBihpkRfZtStl7uNN14y8yLSY8LUUrMG51bsrzUQ=; b=daZs8z5nfokX2UMKdzW2zW1Qwm
        gBH7o/FbTECIye3OHLtFSX05Gwvxsx7MaqARhd9zY+fIi1l1L0mkz11Hiub39W8IJ3D153zBj6dW1
        apPJO5FvMCsEVFvxghN/LWXRqSeS3pdzUrigjPjxL//d27zhKxHixJPkRUEcRX6QNyt4+pPaLCSm2
        WWCnceJXfIehCZZ6OYyp4wh8vYgZo/XEzqn7vICBwna832HpYn7JXysNuZ2cm7DMe7UJREHxowcEr
        FYaKzW3WY1XU/iPKM0NddFPy0CVQDDpsVN5qRNNh5oHtFFEecyjEDZPKDLMyuPJzRxkDlBe/l6sTs
        2CAKZcjQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lPfVi-00EMLV-IN; Fri, 26 Mar 2021 05:59:56 +0000
Date:   Fri, 26 Mar 2021 05:59:54 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/2] xfs: move the xfs_can_free_eofblocks call under the
 IOLOCK
Message-ID: <20210326055954.GA3421955@infradead.org>
References: <161671805938.621829.266575450099624132.stgit@magnolia>
 <161671806513.621829.6973192250605604420.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161671806513.621829.6973192250605604420.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 05:21:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In xfs_inode_free_eofblocks, move the xfs_can_free_eofblocks call
> further down in the function to the point where we have taken the
> IOLOCK.  This is preparation for the next patch, where we will need that
> lock (or equivalent) so that we can check if there are any post-eof
> blocks to clean out.

I kinda prefer the old style that did the exception path inside the
branch.  But that is just sugacoating, the actual change looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
