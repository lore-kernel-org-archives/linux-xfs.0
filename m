Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEBF4C2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C87C613DF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhFQIQy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 04:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhFQIQy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 04:16:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BE8C061574
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 01:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3GTIrjeeuyhbnf8mPkFO/VTnEbBlnzjHeSBQ4UfFW80=; b=j2ANK9ePzj89uQW0/t6gPWLaAl
        hwN54fxQ6BKtEGK+1BbIg3XZjpd/U1az1LTju3+goAAsSs6CDyL8pIed5+iAGjrb56OxiqdYsyVlN
        JI5uCQED7r244gG/wrtWxtELmyVNtYXhhnzY9yQNf25atj592iw8wS/QTfNKxSqblmfHgX1PHWXKn
        6ps/ji215q92MlJ0CNk7bVrFgid+h1h3nZLiqOHVf/c1OkaH0drriuxs2mLf6kSaW3baUaccL+XEA
        eFdSxB+7+e9JwWjEc/vTJQx9Dm6ChSYMVi7agkN4IzbEpsCsqkFJ0PHdzX+CjUZVUNHnjzvWVUCzr
        bx6i616Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltnAZ-008uXB-2o; Thu, 17 Jun 2021 08:14:38 +0000
Date:   Thu, 17 Jun 2021 09:14:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: force the log offline when log intent item
 recovery fails
Message-ID: <YMsEa4CSu12V4ifB@infradead.org>
References: <162388773802.3427167.4556309820960423454.stgit@locust>
 <162388774909.3427167.8813765394953438195.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162388774909.3427167.8813765394953438195.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 04:55:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If any part of log intent item recovery fails, we should shut down the
> log immediately to stop the log from writing a clean unmount record to
> disk, because the metadata is not consistent.  The inability to cancel a
> dirty transaction catches most of these cases, but there are a few
> things that have slipped through the cracks, such as ENOSPC from a
> transaction allocation, or runtime errors that result in cancellation of
> a non-dirty transaction.
> 
> This solves some weird behaviors reported by customers where a system
> goes down, the first mount fails, the second succeeds, but then the fs
> goes down later because of inconsistent metadata.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
