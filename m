Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A96CCA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 14:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12F0521D71
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 14:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EwD19HYB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439945AbfJYOhs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 10:37:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34968 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439944AbfJYOhs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 10:37:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I1wBaJcgT3DwtZqi6N5vtakcSLuxA6TpQk/sYoW6Z+4=; b=EwD19HYBE6DjUOoClcUpTUyPN
        QeLVo1NLkERIo8nSUWQNdAOkhEP0UOxkmZjXfxOEhyHthaY2vebmq0ijkOXQB26MGniAmNMntOwaz
        RQhsnT2rQTvVUmMCVos8sBN2VEn+NjnTGwMRWVxGumLgOpqJhbhE4/gLrdA27m7at/IFa90Xm5duG
        LL7QFW76LwSHUEfZuc6FPGJ/hjfYPtnf5pyaHA0KuvBjaTFS1MDzZnJ+ozrnVYbMz/CtWuj1Yyoc5
        rPfQaWJhdTBRuHAy3TVmEqpYwR7Unuc7n3GD0vNoBeSdk5WU2LXAzDtqM+HZxPbk+F5jk0Mv+2YLn
        vn6nB5DeQ==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO0io-0004Bc-6T; Fri, 25 Oct 2019 14:37:47 +0000
Date:   Fri, 25 Oct 2019 16:37:37 +0200
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
Subject: Re: [PATCH v7 08/17] xfs: merge freeing of mp names and mp
Message-ID: <20191025143737.GD22076@infradead.org>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190347727.27074.15948763811572596699.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157190347727.27074.15948763811572596699.stgit@fedora-28>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 03:51:17PM +0800, Ian Kent wrote:
> In all cases when struct xfs_mount (mp) fields m_rtname and m_logname
> are freed mp is also freed, so merge these into a single function
> xfs_mount_free().
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
