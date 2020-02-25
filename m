Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7056FC35E0C
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 410012082F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:42:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iEx4hOpE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgBYRmx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:42:53 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53402 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728499AbgBYRmx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:42:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qGy+8cF+CFDTI16DfiS38SlYVllpj1bPO6NQQ4l+NkE=; b=iEx4hOpEMGVkiy4Ol/CDAyZG7t
        AJvm76sHuzxiEu9ahPrcIqzciXx9BSe3EXDWX9XvM5hKNmJiZpdf6t4Sw3u/VMmqbbZ7bD+6JzsSh
        Sr4i2paMcxxz8OQ3xKLQBG0tMnfwcsOUIVF+krrXX1UsQ21+oSY39CA93Rova8oD4/+SMO0BXgtl9
        Koyciig2Y2Vd3vhEBRVzFeNjqxdUaeh4NggIz67c0C045xgwj3/S1/S41PLZNIy/W6d2MrHcCIAu6
        3+r4uGLZsR0gdI+r0iq6LdaNDFGgKGQaXoVWaoiiheGaeQDeqFDhUeQCkuZND0eCmEuqeiS4cuRZ7
        BE7tObGw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eEO-0005KJ-OD; Tue, 25 Feb 2020 17:42:52 +0000
Date:   Tue, 25 Feb 2020 09:42:52 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/25] libxfs: open-code "exit on buffer read failure" in
 upper level callers
Message-ID: <20200225174252.GG20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258949476.451378.9569854305232356529.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258949476.451378.9569854305232356529.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:11:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make all functions that use LIBXFS_EXIT_ON_FAILURE to abort on buffer
> read errors implement that logic themselves.  This also removes places
> where libxfs can abort the program with no warning.

How are the libxfs_mount changes related to this commit message?

All the other bits looks fine, but those changes seem to have slipt in
without a good reason.
