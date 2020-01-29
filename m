Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8006AC2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 18:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54B3120678
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 18:36:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U+BqfcLh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgA2SgL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 13:36:11 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33972 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgA2SgK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 13:36:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wwufNhqmMEk/wo4Vzskjnke3JzLwyyd+S0vKqoozf1o=; b=U+BqfcLhhuku5DnNLuLCy5XOc
        pjzC81RZ+p+sjKAtpkvz4IDPkQ0pZ8a2Sp15Adc6kKpOXORP1xtjozX6ExK2nXwxTJh76PmkiRzN5
        YjZRlnCgVmJZ5sOSnSIvlC1W4ubOZMvJPKVunBsRHWFYg2v6tj82lrZBioOIyZm6yh6aEDkOGOqle
        Nq3UbC6EYOAUoAkp9uAHsQVo6vwxUZ6ZSYOvHLN7kVhDB4u77T2GAyQgRwuklmwrbcwn6EfEM/Ujv
        yL1Dlvzhv8I6g7Sqds7JqcS1OAJbCguRzQ5JIsZMcnmo0aV/gUhDByb5LwA0CuUm+/eBRTRd1sM5Q
        ikel5N/HA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwsCA-00075g-4w; Wed, 29 Jan 2020 18:36:10 +0000
Date:   Wed, 29 Jan 2020 10:36:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 V3] xfs: don't take addresses of packed xfs_rmap_key
 member
Message-ID: <20200129183610.GA27200@infradead.org>
References: <65e48930-96ae-7307-ba65-6b7528bb2fb5@redhat.com>
 <89743aba-ca7f-340c-c813-b8d73cb25cd7@redhat.com>
 <b44b9c6e-4c40-2670-8c38-874a79e0d066@redhat.com>
 <06b937e3-afaf-41c0-3477-a4b1a88fee48@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06b937e3-afaf-41c0-3477-a4b1a88fee48@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 12:35:21PM -0600, Eric Sandeen wrote:
> gcc now warns about taking an address of a packed structure member.
> 
> This happens here because of how be32_add_cpu() works; just open-code
> the modification instead.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
