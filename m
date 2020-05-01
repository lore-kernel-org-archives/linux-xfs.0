Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E39DCC4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 07:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9B0E20787
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 07:56:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZB6tg4KK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgEAH4n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 03:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgEAH4n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 03:56:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA7DC035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 00:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FWXCXYRgnx+FXlNJBgn5ddLjI3xQvqz1lVo2TCKoN+k=; b=ZB6tg4KKp1zroyvUXQ4Z5M7WFq
        xGHZo/HNaFJa8WqkSUCA9sU60Bn9cpJBM3f2BJGDgSOlSa82NiloWYDNhFkTXBrwuYxSaBGn2fLNr
        WX+MP1pSfsP02/rs+VJn4kfdI83CvU80u+MY6wssEsHGb/ujdUI99J7dmvaVPZrIvCGYTqrGr5OTL
        Np/ZBDy5zbY222OEimwJgTmHZ98SuGkPEHRq6CY/fv4TbtLij61MsT5VAZ1WR9iXz5+qy1HAfqAZO
        jIqvkn7b9FUZQ+Y0mFYsjwn5Rt4UBFp2RO9fl1Uj9JS6lRtHL/iVxu/WYG9ZzaVeym28h1/MTyP1L
        j3VvgPIw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQXL-0000xg-0b; Fri, 01 May 2020 07:56:43 +0000
Date:   Fri, 1 May 2020 00:56:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 11/17] xfs: use delete helper for items expected to be
 in AIL
Message-ID: <20200501075642.GF29479@infradead.org>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-12-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-12-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:47PM -0400, Brian Foster wrote:
> Various intent log items call xfs_trans_ail_remove() with a log I/O
> error shutdown type, but this helper historically checks whether an
> item is in the AIL before calling xfs_trans_ail_delete(). This means
> the shutdown check is essentially a no-op for users of
> xfs_trans_ail_remove().
> 
> It is possible that some items might not be AIL resident when the
> AIL remove attempt occurs, but this should be isolated to cases
> where the filesystem has already shutdown. For example, this
> includes abort of the transaction committing the intent and I/O
> error of the iclog buffer committing the intent to the log.
> Therefore, update these callsites to use xfs_trans_ail_delete() to
> provide AIL state validation for the common path of items being
> released and removed when associated done items commit to the
> physical log.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
