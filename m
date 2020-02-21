Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0EDEC35656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C74E6206DB
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:53:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nqNcDhmw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgBUOxG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:53:06 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55584 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbgBUOxG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:53:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Muxb5wSF7zjlLf891lVBPGas0TNk+KfOhQn1rnmk09g=; b=nqNcDhmwJ4Rev8bxvEDlnrhxje
        IZQKryESvQLWP4LrSTWiXmZW87mn1XclvnzZYyipMAjN/bK/k7f+uGsHulTY4Xhbl1CPTwPQtx3XE
        NvXttho5s2PS9BqCCiKc0iFeu99l895esWqy1L/ff/StEGn4eBg7s0GhX5sDC0LV2RcW0Dhrl5VY2
        T9Pt3cdz9HMU7V2HQycPZrauInKbDL3l6LPd/ft9wJ1GRLyk/q7AAj3eYWkcKwLuVNMVP5oXyzSRr
        HwYX6HqfrDLebvTwZOeli+OihH7Xn6+mxQTuPDx9heFr0UO88HcGoxTWlsB2JEnfb2IdRYtPrVcy/
        /RCm/csQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59ft-0003Rt-IV; Fri, 21 Feb 2020 14:53:05 +0000
Date:   Fri, 21 Feb 2020 06:53:05 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/18] libxfs: straighten out libxfs_writebuf confusion
Message-ID: <20200221145305.GK15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216303592.602314.4622638173533560298.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216303592.602314.4622638173533560298.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:43:55PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> libxfs_writebuf is not a well named function -- it marks the buffer
> dirty and then releases the caller's reference.  The actual write comes
> when the cache is flushed, either because someone explicitly told the
> cache to flush or because we started buffer reclaim.
> 
> Make the buffer release explicit in the callers and rename the function
> to say what it actually does -- it marks the buffer dirty outside of
> transaction context.

FYI, before we made all buffer writes delwri or sync in the kernel the
equivalent function was called xfs_buf_bawrite.  But I'm not sure that
was a better name.  But maybe libxfs_buf_mark_dirty is a tad better?

Otherwise looks good.

