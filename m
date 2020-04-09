Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11B1C2D0EA
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 07:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B243A206F7
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 07:43:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UnaJBBRq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgDIHnF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 03:43:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51644 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgDIHnF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 03:43:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XDskJFJbkbimBj03zVdHwGWOTGskUFVM9N+N95q2vAE=; b=UnaJBBRqtk70Uz0BNtccMe887F
        7cm3AcRqA9qMAukLk9mJkF93uPYjqEZ1N+EaXBezaUWg80TXB1+032P2LoPLBvHnseUke2htZj4+t
        DJy/hKEEZd2atq6mR2P+gEMhroNiJPLJUX64E5GniW2uh/opeLDH8F6ON8EQHjY7ZpmxAfyz0TJkT
        KQpAzw4C2DjjB2R3OOif3rpOt9woDkQ82Cp5+qQ2pZlTnam4dJvMWVaaYaGsiCxmJOK4eznF6I23P
        hxDCPGaGgnjWr7hXkM1wK6l2Dss26fqUgybP9vRYl/8di/oO+AZ+iTqknBzu6wOR5Ra7kwCEZFK+d
        Jp6HQxjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMRq4-0008Ji-Mi; Thu, 09 Apr 2020 07:43:04 +0000
Date:   Thu, 9 Apr 2020 00:43:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] libxfs: don't barf in libxfs_bwrite on a null buffer
 ops name
Message-ID: <20200409074304.GE21033@infradead.org>
References: <158619914362.469742.7048317858423621957.stgit@magnolia>
 <158619915000.469742.14620929774691026014.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158619915000.469742.14620929774691026014.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 06, 2020 at 11:52:30AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't crash if we failed to write a buffer that had no buffer verifier.
> This should be rare in practice, but coverity found a valid bug.
> 
> Coverity-id: 1460462
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
