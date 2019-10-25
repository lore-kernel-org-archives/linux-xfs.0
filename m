Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D70CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 14:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69E3A206DD
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 14:31:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jtuc4bJF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389801AbfJYOb6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 10:31:58 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33424 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfJYOb6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 10:31:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qNAG1H3P/xswQXPqxOQmhl6MDR0rjTCT6ZMlLMMkil8=; b=jtuc4bJF8xklLunaFK6I3QsQP
        NzRPEpEXhr+VrsP0nY284hJeKsfQax2B5OAhhdqiur8Ac3ihL4cXMBRekg8nkNvCwOKifTuXjwBmT
        1ErDRPw3pyq/C6LagnUBzmUUYeScpwXK/cQqjetXag67UYimMqdGxvgtX64CtPI8Bv6hDmN51nXXQ
        A5fXEGUSBAGOYFUcUXPk59sHCx6qP3PEclwkmbi+hKWSJKpe5dvVWc7RpxENx6LQs2GtQiKPRlGA1
        qk/pcYFyG4J51EUCQVAeEUEhgrVpwCycBewIaYRjiVLye2jm0Az1Yx1CHOHoFddnW6kCO4OBlB9J0
        NLwi1+2LQ==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO0dA-0002Hf-Lc; Fri, 25 Oct 2019 14:31:58 +0000
Date:   Fri, 25 Oct 2019 16:31:48 +0200
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
Subject: Re: [PATCH v7 07/17] xfs: move xfs_mount_alloc to be with parsing
 code
Message-ID: <20191025143148.GC22076@infradead.org>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190347206.27074.7719123415772242317.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157190347206.27074.7719123415772242317.stgit@fedora-28>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 03:51:12PM +0800, Ian Kent wrote:
> The struct xfs_mount allocation (and freeing) is only used by the mount
> code, so move xfs_mount_alloc() to the same area as the option handling
> code (as part of the work to locate the mount code together).
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
