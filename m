Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3505EC35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01D5A2084E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hl9O/ohO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbgBYRrN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:47:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57388 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730236AbgBYRrN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:47:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=C3l2zkEpyR/8Q2MWQ9OsLnOXxdoP5C77/X8IFdltOs0=; b=hl9O/ohOCoSbrjkW2IEnPGy00v
        JYu6UZzfSFf0QqK1WwOo+nmfHmmT14JDhQrmkvEr6r0rLyNpvqslCuPBzRjtCFOmdMPcWrIt7AAXz
        afkGPvaXML5p6vP0MN0BJHG7BkZA4l2j8aWeB7SFjYzVGprzcgKtKe/eJlDPel5jHYJqtVS2H1drh
        fPkevMQ8+F5WdTQBP844LT/yG/5i5Jl9eqXerKIHzDYv3YvuaKlcXTZUnOV/FOVwddCnQy5UY05TR
        qs33fotwu/Vqh3oWCgpqU16Bn11dMscLKf85bPZ5dVx4QTK0jTMZ15COvgGsK1WWHHH/S7a1Dby7L
        xmYceqlw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eIa-0007ck-Ne; Tue, 25 Feb 2020 17:47:12 +0000
Date:   Tue, 25 Feb 2020 09:47:12 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/25] libxfs: move log functions for convenience
Message-ID: <20200225174712.GN20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258957007.451378.6015938096424691137.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258957007.451378.6015938096424691137.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:12:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move libxfs_log_clear and libxfs_log_header to the bottom of the file so
> that we avoid having to create advance declarations of static functions
> in the next patch.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I'd be tempted to in fact just move them into a separate file, unless
that would mean marking too many functions non-static as none of this
is related to the normal read/write code.
