Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65112C35656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E6F124650
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:45:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D3JeThSM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgBUOps (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:45:48 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46710 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728668AbgBUOps (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:45:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ii0S++R9mCn0hy7B/t/mpGZ+GvmrhXwdPJNZpWQXoHk=; b=D3JeThSMEKfpJ8M/7bGfIK2Juw
        Z0yDViDjmBKCfjdQzj0eZGeSrFftbRAvv/9FkosnEvuVZslKBBY0v6gPD+Xu1ftqlTwBanY0hgSZ8
        8yVyYABdlTOW+rC3W7azgmFza+4MynEUISa7ij1Hbq46D+naiZR9C8XN6fbZGD8OlRuO97o3d5YQ4
        JOsbc/i6F5CSWAWE98SCVlie1Yz1JqMHR9oAmFcRe/Id3h13eh2SXDGDmtd7K22suZFzC0OQrhiiW
        zcW8MEyDbA5F7S8hvI33q3/kuENHFOgroL7VTXEHnvEZ192e2EXgEZCHtjKD9wbyA4G6eW9VxaY4I
        Y//04aSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59Yp-000873-M9; Fri, 21 Feb 2020 14:45:47 +0000
Date:   Fri, 21 Feb 2020 06:45:47 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/18] libxfs: make libxfs_bwrite do what
 libxfs_writebufr does
Message-ID: <20200221144547.GE15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216299927.602314.10659390054898124986.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216299927.602314.10659390054898124986.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:43:19PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make libxfs_bwrite equivalent to libxfs_writebufr.  This makes it so
> that libxfs bwrite calls write the buffer to disk immediately and
> without double-freeing the buffer.  However, we choose to consolidate
> around the libxfs_bwrite name to match the kernel.

The commit message looks a little odd.  Also why is the subject a
different style than the previous messages?

Also if there was a double free shouldn't we fix that in a small
backportable patch first (not that I see such a fix anywhere)?
