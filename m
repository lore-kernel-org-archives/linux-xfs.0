Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF87C35249
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 06:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D114217F4
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 06:07:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eJQg+apr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgBEGHW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 01:07:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43784 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgBEGHW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 01:07:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=s9gOu92DPXu1I9H0Y8k09s8f1t+mdmZ/JljpUYSre3s=; b=eJQg+aprtIYGln8LLpnrfdnwa2
        fECn23+EO58bWjEc+7TXHR7fm87N9YrFMhGefcj2oOlnY1/f9IYL8PLIKrNAYshs2T/YoHkd0vt1G
        kt2OAAIY2to/tP626ziNddAErASTwXCLxDJ9JrNdlASoJm3itpmgdD51VYkW1pbNzoWi1yVswO+XY
        Dh633THU+mGm4e3bP3HnOWlYE81eYsJJnePSh+PWEjmj/U6yAD1r9GxfZoEKVBU6DfhwFO4Gd1O15
        bkmohz/EOSLiKYPkuI05CDtLVXhHo7Lz4wYIniZXoAhIDSK7Di4hdTL/KgsHs75zJOq4/EQEXQyop
        prXNLlrw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1izDqJ-0005LZ-Ju; Wed, 05 Feb 2020 06:07:19 +0000
Date:   Tue, 4 Feb 2020 22:07:19 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 11/8] xfs_repair: don't corrupt a attr fork da3 node
 when clearing forw/back
Message-ID: <20200205060719.GA20448@infradead.org>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <20200130181512.GZ3447196@magnolia>
 <20200130184606.GC3447196@magnolia>
 <20200131060315.GA26786@infradead.org>
 <20200204231442.GE6874@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204231442.GE6874@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 03:14:42PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 30, 2020 at 10:03:15PM -0800, Christoph Hellwig wrote:
> > Looks sensible, but I think we want the helpers for both the node and
> > leaf case, something like this untested patch:
> 
> Ok, I was about to repost with more or less the same code.

Just send your version as the official patch, especially if you actually
tested it..
