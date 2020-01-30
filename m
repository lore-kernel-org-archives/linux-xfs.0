Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81377C2D0DB
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 18:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57B102082E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 18:18:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L5iXtFfF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgA3SSk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 13:18:40 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48322 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728937AbgA3SSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 13:18:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TW7I1+6xjYK1zoT/1wYAgraw3vZOhUJkiRfe+mW4TGc=; b=L5iXtFfFbsmNOozs1Doe0jmia
        I6hJJ0l7hz9i8Ht1O9b6JlmIeaJfNvxTWZfaysQt6TqtwDkDRizC2v/Zzdt7g5alBgT/rjo6ESHm4
        vABYL4Ak+NcujyRPk378Nq6NxDqF157n9g9LERZKZOIxLOhMXI48aSjtMMsznA63fGyFy/LXULbhS
        //Rq4MQZK2ZpmhLdAsepeE4ysYBmjYw92W0Q76t6GQaP6K9t/U1OPapkB/09sMPAsS8mNGvlramoI
        /OzZiTU2LfijsOQZ25JbP1zLQMeMUi4yfuybEZ7g746PN5Odmv+X9kvKT1/xnOA58ZDbKJFHhorV/
        L5TsHytxA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ixEOl-0007Is-Nx; Thu, 30 Jan 2020 18:18:39 +0000
Date:   Thu, 30 Jan 2020 10:18:39 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/8] xfs_io: fix integer over/underflow handling in
 timespec_from_string
Message-ID: <20200130181839.GB27318@infradead.org>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <20200128155648.GN3447196@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128155648.GN3447196@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 28, 2020 at 07:56:48AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're filling out the struct timespec, make sure we detect when the
> string value cannot be represented by a (potentially 32-bit) seconds
> field in struct timespec.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
