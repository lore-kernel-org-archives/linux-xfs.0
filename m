Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FDFC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA6D920746
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O2d1CDMO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgEIQoO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726214AbgEIQoO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:44:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BF0C061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 09:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tMFRVkluUNpqUfYDWdFabXufb/WD+B2E+PtCyWv3Qzs=; b=O2d1CDMOczNAJ5eK9AgV/xnPKw
        VKeTpU4FQa/JYJwDMxWpijSP4Z6R3cEJPjcs/wEL3ks3jrb3tcT0xi0lhkOl0m0pia8imdHEnwsQj
        Zvv44P2UleXsh8YRQ7uT5BQZrGrHeR8NDrBV6mip03XmxMjMLSWp9AyIr21B0UPBa3iNH1pVXg/aI
        U/5vzdDTD5MkTzbKOqZyAlD28REHwixCOtbXB2dym2+5kLCRnQTGIwIHOjEiYgEzVWiKvenlrvw0b
        X0ga0v/ac6RZ8ipuVl1ORLKKhf9wz67IXOussV4Eb5ptRN1pwlZTn2y9IL3M9pHOBkHOsqoqqum6s
        I9BObqFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSaD-00035F-2e; Sat, 09 May 2020 16:44:13 +0000
Date:   Sat, 9 May 2020 09:44:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] find_api_violations: fix sed expression
Message-ID: <20200509164413.GE23078@infradead.org>
References: <158904177147.982835.3876574696663645345.stgit@magnolia>
 <158904178381.982835.124483584305094681.stgit@magnolia>
 <20200509163644.GC23078@infradead.org>
 <20200509163821.GN6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509163821.GN6714@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:38:21AM -0700, Darrick J. Wong wrote:
> On Sat, May 09, 2020 at 09:36:44AM -0700, Christoph Hellwig wrote:
> > On Sat, May 09, 2020 at 09:29:43AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Apparently, the grep program in Ubuntu 20.04 is pickier about requiring
> > > '(' to be escaped inside range expressions.  This causes a regression in
> > > xfs/437, so fix it.
> > 
> > Mentioning the actual sed version would be a lot more helpful..
> 
> GNU grep 3.4.

That should go into the changelog for commit instead of the distro
version.
