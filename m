Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963CECA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 13:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CFED20679
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 13:54:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eg9xCw0T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502265AbfJYNyI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 09:54:08 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38748 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730937AbfJYNyH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 09:54:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ntOyGQOXb6sd5LnNi0R9xVGKExzx3ImqSUwz91KsqyU=; b=eg9xCw0TgEkaL395U7HxPOUwU
        dkeYlkHVuhP4v3BntzaWja25rQGqHejQFtgwqtA49m8MzqHsXiBvGJRTFWDYqZtRQf2fojb233dyi
        GfWU9BR1xWVwjbPIIRzDKirW8Os4Sp+yLkAcOielI5MVE06uWes5jrT2sFRhulhmNV+6NxYC8Xhx2
        /2sTpFR48dUR4TMx7kFvUrucgyRPQJBPPUZnun7v3Pl4EXvVXZiWFKhREasCoooyUO7KkpyWJ3PqP
        RyNZO0sBY6VV/QsdLiFyzJ2AI4txeerU7wk/y8p8X+dFXPw82P/eNVNIfemZ19GGYAI9/ZnAut4vS
        pZEIcsZqg==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO02X-0000Ro-6K; Fri, 25 Oct 2019 13:54:07 +0000
Date:   Fri, 25 Oct 2019 15:53:20 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 06/17] xfs: use kmem functions for struct xfs_mount
Message-ID: <20191025135320.GB22076@infradead.org>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190346680.27074.12024650426066059590.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157190346680.27074.12024650426066059590.stgit@fedora-28>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 03:51:06PM +0800, Ian Kent wrote:
> The remount function uses the kmem functions for allocating and freeing
> struct xfs_mount, for consistency use the kmem functions everwhere for
> struct xfs_mount.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
