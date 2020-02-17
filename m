Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46920C34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 14:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B93B20725
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 14:00:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hrko9lI+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgBQOAY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 09:00:24 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59468 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbgBQOAY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 09:00:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wlr4StxrjH1bGxVzzB/9+bPD9+whgypKwW6IrtqeDw4=; b=hrko9lI+5lit4h1eJwS2IfAz2J
        WP61rCfbN60Krnoh+h/ng7NqfnNlQ1dsWAv4sqHb0wiIZKdUrtOUfH7IiJkl43FsJqYPbiIZAn2yn
        5EJwkhmBgeaEy6YiN2djy06ce2okQBydmfJU2XrP0cPuWM3DHDOpl/MHnwws5//nA/5BpXl//dTzd
        3b8KzYLDYQq4KfhZ/Dx28swWUlvWIbS2Vqit1Z48fIRNk8zMY/9O6FHEG3yp79I0YtOQ7cFfepaap
        NcNTSrbLELoOKFJmeMA3w3fNREkNGSS84LKoj/cQv+vUd+dGm6zdjuniDD7sJelKO9jrjoLSnrj3E
        hwYUp5cQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gwh-0005Fa-Io; Mon, 17 Feb 2020 14:00:23 +0000
Date:   Mon, 17 Feb 2020 06:00:23 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] libxfs: return flush failures
Message-ID: <20200217140023.GN18371@infradead.org>
References: <158086364511.2079905.3531505051831183875.stgit@magnolia>
 <158086366333.2079905.16346740147118345650.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086366333.2079905.16346740147118345650.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:47:43PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Modify platform_flush_device so that we can return error status when
> device flushes fail.

The change itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But the existing logic in platform_flush_device looks suspicious.
Even on a block device fsync is usually the right thing, so we
should unconditionally do that first.  The BLKFLSBUF ioctl does some
rather weird things which I'm not sure we really want here, but if we
do I'd rather see if after we've flushed out the actual data..
