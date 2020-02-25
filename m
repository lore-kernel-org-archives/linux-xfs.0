Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B88C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7287D2084E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:42:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BD86t7Mg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbgBYSmm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:42:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34440 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731596AbgBYSml (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 13:42:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Bg7gMxpsBp76rjwUBR2oQD3SGUIULXByxvfSiSaBjz8=; b=BD86t7MgxdsLxgwPoV7BvA79Wp
        w6/X8ipnY3mcP0Xt6zQTabU79I3fRPO3yn4/PztuhQiucD+po2HvE2SS6KWbzqRPh6QSQ7dAc30go
        wBfMLlR8vSaegEdWeLcSOzRs+1578Ri174g/p8pu0TPPCetzmxtsvCMSsLLmPBKhO6hTMFkiiXCIo
        jNWsTjFco6E6tA7Z9pBPdxMC7CdL8+awwmHOVPnB2EuafqDsnvzx2LpDQUgJgi+PSCAfZZmWwVddh
        XqUeck81nCf8BeP/p+jwVsfZOXcJgazvQ5pfHH+0mnQ7rkzrKjB/2G1BD22L3jzaBrKCWf3Fad/qR
        heNQFg/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6fAG-00052M-NS; Tue, 25 Feb 2020 18:42:40 +0000
Date:   Tue, 25 Feb 2020 10:42:40 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/25] libxfs: open-code "exit on buffer read failure" in
 upper level callers
Message-ID: <20200225184240.GA18626@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258949476.451378.9569854305232356529.stgit@magnolia>
 <20200225174252.GG20570@infradead.org>
 <20200225184023.GJ6740@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225184023.GJ6740@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 10:40:23AM -0800, Darrick J. Wong wrote:
> Prior to this patch, the "!(flags & DEBUGGER)" expressions in the call
> sites evaluate to 0 or 1, and this effectively results in libxfs_mount
> passing EXIT_ON_FAILURE to the buffer read functions as the flag value.
> The flag value is passed all the way down to __read_buf, and when it
> sees an IO failure, it exits.
> 
> After this patch, libxfs_mount passes flags==0, which means that we get
> a buffer back, possibly with b_error set.  If b_error is set, we log a
> warning about the screwed up filesystem and return a null mount if the
> libxfs_mount caller didn't indicate that it is a debugger.  Presumably
> the libxfs_mount caller will exit with error if we return a null mount.
> 
> IOWs, I'm doing exactly what the commit message says, but in a rather
> subtle way.  I'll clarify that, if you'd like.

Ok, with a proper commit message this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
