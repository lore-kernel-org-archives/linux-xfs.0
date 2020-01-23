Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D907C33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F607207FF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jkOKMUFC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgAWWnO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:43:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53256 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWWnO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 17:43:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nmAXDFu5Wnt4vEKA7gKMVdQ5bZGYgz0lV4X7HaZZEFo=; b=jkOKMUFCUL2IbrpAywNiIVc0S
        KojEjjJAkgs8kDY8Kn01uim7vYFD8HWj4XzgrlaQ4CNNaXSUcszf5qHYHc7Qo5GyfWXBqjfdm1V86
        Xxh2A5fraiyXKK6ym5opKEGRSlJ3p/bcPipojmHWjd8KDqQxTebDBICqWTNq3eAbK9DCtGT2ENlry
        SeMt0Pim4l1BEQ8p4V+XeEGIX1GiPH/Bi3Uyt/qPILwdxKCQ0dNl7gwCjsrbibrj1kEiyDVHZbRN8
        oNW3zQJXKSetQXtM1Devp0+/n66JtO47A36YzojcoNClxqDfI4VrafaUZVwvicjRe9m7e3T84Rj6l
        q40LcxoOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iulBw-00050m-Kg; Thu, 23 Jan 2020 22:43:12 +0000
Date:   Thu, 23 Jan 2020 14:43:12 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 19/29] xfs: replace ATTR_ENTBASESIZE with offsetoff
Message-ID: <20200123224312.GH2669@infradead.org>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-20-hch@lst.de>
 <20200121183621.GS8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121183621.GS8247@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 21, 2020 at 10:36:21AM -0800, Darrick J. Wong wrote:
> > -	((ATTR_ENTBASESIZE + (namelen) + 1 + sizeof(uint32_t)-1) \
> > +	((offsetof(struct attrlist_ent, a_name) + \
> > +	 (namelen) + 1 + sizeof(uint32_t) - 1) \
> >  	 & ~(sizeof(uint32_t)-1))
> 
> This looks like an open-coded round_up(), doesn't it?  Or roundup(), I
> can't remember which is which. :?

It looks ok this way, but I'll see if there is something more fancy to
use here..
