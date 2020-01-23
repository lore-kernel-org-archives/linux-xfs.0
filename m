Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B2EC33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32631207FF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:41:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hwWidT12"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgAWWli (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:41:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53240 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWWli (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 17:41:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FRjfym2e+fn2N1Lm8M8MNAItFjVtdozpdCWE8JTOMto=; b=hwWidT12WB6Fh6JzpU+4W02EZ
        s783RFJL1taOH9tmnVLVEQ3cjEd+/66NE4wLzYMp3ooNFede2MnjNvCrQspAc8JNSELalcTQBGsPt
        ulx/EvHMHK88l0bJH1QvulIe1URDyrw8qUO+1V2rvi5H3XJzJkN8Zx8bbrcYtONzPMoD5mrjwceBQ
        9AtN4efKND72mBnptfV3zLXB8wduDYwvaMhw6eY1GkiR2JlOI9yPRP7BfEJxLaHeQODkkx2n1YHoJ
        KOdPcVNO3nZ7PIZ0moVbCtUOvrLucFE/bUvSXYIjf8sHAIsPhB9s8MDLzWH9KOOiuN8uySeOIoCU6
        cs1Gk6NaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iulAP-0004xE-49; Thu, 23 Jan 2020 22:41:37 +0000
Date:   Thu, 23 Jan 2020 14:41:37 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 16/29] xfs: factor out a xfs_attr_match helper
Message-ID: <20200123224137.GG2669@infradead.org>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-17-hch@lst.de>
 <20200121182743.GP8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121182743.GP8247@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 21, 2020 at 10:27:43AM -0800, Darrick J. Wong wrote:
> > -/*
> > - * If namespace bits don't match return 0.
> > - * If all match then return 1.
> > - */
> > -STATIC int
> > -xfs_attr_namesp_match(int arg_flags, int ondisk_flags)
> > +static bool
> 
> /me wonders if this ought to be static inline but otherwise,

I'll let the compiler decide..
