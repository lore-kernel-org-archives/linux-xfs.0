Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A15C38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 07:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48794206B9
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 07:14:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ome/glba"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgEHHON (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 03:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725991AbgEHHOM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 03:14:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984D9C05BD43
        for <linux-xfs@vger.kernel.org>; Fri,  8 May 2020 00:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=r/LyrlXb5rdgMeSw8DJxERe3oZsYhQmr0s7bqhgyiHs=; b=ome/glbaHxDUpsVwpE8NyBpZ9k
        QrGqgtoT/7QyGaWKui+HA/PcNdE7uDkSWk1EH16//ISgbazC75aHyjVsChgDcHSA9yL5yVNppfg64
        9T45PAxg3Rexv4Wo0J1h4KbwQypSLQ5z/FJVhRIUwScG1LhE0F88MoP0bzBLK1vcPXMHwAT4+MP0n
        EKcrkFyTDRby6AcPf8hGXABnbek2JWfZ/XeoU2TpisV7BoM6ogLF+qccQgOCAOOEFVU2safaIGBZS
        H8OtOd+Z6XA9Uls/sbIbZAKB+74hjR17iCL1jyxMmheciL1xqbtiK8cDrPeRsyRrKeQ+Q+6AgDmIb
        Z+wEqt5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWxD2-0007Qe-GR; Fri, 08 May 2020 07:14:12 +0000
Date:   Fri, 8 May 2020 00:14:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: remove XFS_QMOPT_ENOSPC flag
Message-ID: <20200508071412.GB26853@infradead.org>
References: <447d7fec-2eff-fa99-cd19-acdf353c80d4@redhat.com>
 <11a44fb8-d59d-2e57-73bd-06e216efa5e7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11a44fb8-d59d-2e57-73bd-06e216efa5e7@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 07, 2020 at 11:00:34PM -0500, Eric Sandeen wrote:
> The only place we return -EDQUOT, and therefore need to make a decision
> about returning -ENOSPC for project quota instead, is in xfs_trans_dqresv().
> 
> So there's no reason to be setting and clearing XFS_QMOPT_ENOSPC at higher
> levels; if xfs_trans_dqresv has failed, test if the dqp we were were handed
> is a project quota and if so, return -ENOSPC instead of EDQUOT.  The
> complexity is just a leftover from when project & group quota were mutually
> exclusive and shared some codepaths.
> 
> The prior patch was the trivial bugfix, this is the slightly more involved
> cleanup.

Nice:

Reviewed-by: Christoph Hellwig <hch@lst.de>
