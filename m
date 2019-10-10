Return-Path: <SRS0=apCn=YD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60752C4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 06:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27F262067B
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 06:39:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ED6I+GPQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfJJGjR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Oct 2019 02:39:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44322 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfJJGjR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Oct 2019 02:39:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tCK5aM7XoMDDJx+NpnU8q9wUnbPgyzZePb+1b7OXzfo=; b=ED6I+GPQed+xNI2nDFeadBdw2
        lmx1JC9AaNDHdgvVbI0OP2joAf2ggMXRiJxuG38BHzPP80H5BXNlCNWMC96TYjpAPPeDeMP9PyjHv
        H3IqHNyZZaS2u5ZXPPIfa/hxVOFbob98kngVcUX93EJop1b3NoPiO/ipljhxzj8URPTlVSt8008jN
        msUxQFGX1oBLCd8ucfZR+Tkt2xJ5S1E7AUQuP2iz6ijtvFT3kscq+ukughYUF5/djd1/KZYFGMeMt
        xjkAAPg0Rqp8ElXwq27GWOcWtEpWHqWMExrBlaGzXtHGvwBLHtNefiziX2jK3l6bMmiKZgMRP8NtS
        9xoZNQxWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIS6X-0004Q1-Dl; Thu, 10 Oct 2019 06:39:17 +0000
Date:   Wed, 9 Oct 2019 23:39:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 04/17] xfs: mount-api - add fs parameter description
Message-ID: <20191010063917.GB15004@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062063161.32346.15357252773768069084.stgit@fedora-28>
 <20191009144817.GA10349@infradead.org>
 <1a612dc55f81e2dbde1b72994399bdcbaee5b2d2.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a612dc55f81e2dbde1b72994399bdcbaee5b2d2.camel@themaw.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 10, 2019 at 08:56:31AM +0800, Ian Kent wrote:
> You suggestion is to add these comments to the case handling in
> xfs_parse_param(), correct?

If there is a strong case for keeping them at all.  Some of them
might be so obvious that we can just drop them I think.
