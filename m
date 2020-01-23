Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C02CC33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC5C221835
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:39:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jhUCo/m6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgAWWjK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:39:10 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53120 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbgAWWjK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 17:39:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HCJKwF5B2+gpffy0VULqvEpeK4QXEyJEUzRJ+TjBgfw=; b=jhUCo/m6OM+N7mjTYmRxWUmnn
        tfV5N/o/MX3riJbYoCLn9sEGZLAhDmwxSENVVjduV8rQiX+wL1laWOmKTtqxkOn6Xs7SWCXECdBI3
        bei/plVUX8/ANIkSmWboVkvMARDKKLKQAZoR4MYzKQoJV2Ju88eQNPzOKGbQpi03d/u9JLCuiL1y2
        8wKbKG18dwlQIWHxW7nhjUjeZTNPE2NTIKQtT2Qq+tFo1QH2Yl3sH7ls9J/CgCHUGM8Daniy7K38f
        WXqgeI4S9rT+84LlRga+sB+F/ZGIwved1X7dw9Sf5+t4IOLNxZc+Gqex3qAVugdknihUb80CuMVl8
        B4BT43agA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iul80-0003TI-Fy; Thu, 23 Jan 2020 22:39:08 +0000
Date:   Thu, 23 Jan 2020 14:39:08 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 11/29] xfs: pass an initialized xfs_da_args to
 xfs_attr_get
Message-ID: <20200123223908.GE2669@infradead.org>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-12-hch@lst.de>
 <20200121181247.GK8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121181247.GK8247@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 21, 2020 at 10:12:47AM -0800, Darrick J. Wong wrote:
> > - * If ATTR_KERNOVAL is set in @flags, then the caller does not want the value,
> > - * just an indication whether the attribute exists and the size of the value if
> > - * it exists. The size is returned in @valuelenp,
> > + * If ATTR_KERNOVAL is set in args->flags, then the caller does not want the
> 
> "...is set in @args->flags..." ?
> 
> (I mean... it's pretty obvious to a human that "args" refers to the
> parameter, but I dunno if the automated scanning tools are going to get
> all cranky if we don't @ it.)

This isn't a kerneldoc style comment, so no tool will parse it.  I'd
like to avoid strange annotations where not needed.
