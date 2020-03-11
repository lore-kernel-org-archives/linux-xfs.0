Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93798C10F25
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 06:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61B47208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 06:35:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X/xm8bhX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgCKGf6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 02:35:58 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52170 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgCKGf5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 02:35:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cI1BCrKum0g3Ar4zdSArnpKc3sTSQ/IxofBYMfB9tmA=; b=X/xm8bhXUI90W+kFI9AQz1QNGy
        NtBAYA3mAe5Z+BXyIld3YRiDEo1BtiKZqQeonRZM9ceBnR5IIUz8KcrLFcs29PZMG410RTybJr6cc
        A8Lwd0aHaz5g65KU+E36WZ8bsHE8BSsODoVT8FaQ1qlkWjKXytSzEYzjFbflk1E9MVNVzys6wf9ML
        /KeXFRGW8ydwKIikdBbDsAfyqtrlFB1maCKjRWAX6xM1wSg6xeLBVwAsIQoIjGmLqeNQgbnqxU5Xl
        eExU9HhAd1g6OCJMJLwEWqKzxXvw+YmtPg8/vf6K3XVErf/k+PFDsb2q1+3luiRy3HGGK9SQAGgz0
        8fEOC+jw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBuyD-0006Y3-Mp; Wed, 11 Mar 2020 06:35:57 +0000
Date:   Tue, 10 Mar 2020 23:35:57 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix use-after-free when aborting corrupt attr
 inactivation
Message-ID: <20200311063557.GB13368@infradead.org>
References: <158388761806.939081.5340701470247161779.stgit@magnolia>
 <158388762432.939081.11036027889087941270.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158388762432.939081.11036027889087941270.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 10, 2020 at 05:47:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Log the corrupt buffer before we release the buffer.

Oops,

looks correct:

Reviewed-by: Christoph Hellwig <hch@lst.de>
