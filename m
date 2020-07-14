Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5046C433E3
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 08:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87B562075D
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 08:03:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lAYIfmEZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgGNIDL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 04:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgGNIDH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 04:03:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927F4C061755
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f34jDibfUzZ+iWThe6/CuQ9GYoEtkjq0Oj5YY4y6LMc=; b=lAYIfmEZujQdBJ56XguWYAlssM
        vfolpRKdUmQQKuNtuwRnpo5fjY1BFXSzj4balR68HAdmcO33cTSlOjXM9YWanKsBjljyDdEAvzuXm
        ChLwCStyNPdJ+fHHLl2Uyf93J10GlqBCl4aqM+kFfsPRtPxhD/ZUwSAH+fs2jbZoEZsLRph2CtV/B
        uY8QGEc+/yzj5nv8SB8FXw7SixL3ydc6SZlH6pikA9JUw17acVrqjfAfX1BDKnaL6e5307dASJ77k
        GA7sZHSI+GOenp5zu2FB9T6YiaL5xfL8lU1uB3DU9oomskx2i7Nd3BoVAJdbUA2j3jRxszapCLAUN
        EJjs2Q9Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvFu5-00075C-8k; Tue, 14 Jul 2020 08:03:05 +0000
Date:   Tue, 14 Jul 2020 09:03:05 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/26] xfs: actually bump warning counts when we send
 warnings
Message-ID: <20200714080305.GJ19883@infradead.org>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469044854.2914673.13633798084244575953.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159469044854.2914673.13633798084244575953.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 06:34:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Currently, xfs quotas have the ability to send netlink warnings when a
> user exceeds the limits.  They also have all the support code necessary
> to convert softlimit warnings into failures if the number of warnings
> exceeds a limit set by the administrator.  Unfortunately, we never
> actually increase the warning counter, so this never actually happens.
> Make it so we actually do something useful with the warning counts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Time for a test case?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
