Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38CFC28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1B982080D
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:19:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OQ9u96yU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgEFPTv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729309AbgEFPTu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:19:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E611C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=OQ9u96yUaj8tiefdJ1C0fFAa87
        bWh9q2/48i4GaCXJ2x/OB9CZaRz5LCrOUGaN4vhnCoB39nASntq2xjEnWKky7aUXj/i/PXWtpAH+f
        L5KWuBBBjZ14l4mrruODaNFBMfGXJu+pi87CzMLd6ALFl2/qR4yS6gljABUzPvVO2OPhiWPFcA5yA
        wJvGpWveSWLnPM1ONS2NHlJuiePpgryFRwD+5zHGpziKTWF3M6GibyQnNE89XwcM7Ik7u5sRBcl1s
        qPNERhloUeQLqjYutUtl1jOsWfpIMQRBsVdYDawj/1gWdF1cTRBRLq1c81sfsF/jdAi8CSTK3z9jh
        h3tvbtqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLpu-000085-Cm; Wed, 06 May 2020 15:19:50 +0000
Date:   Wed, 6 May 2020 08:19:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/28] xfs: refactor recovered CUI log item playback
Message-ID: <20200506151950.GU7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864113397.182683.5812513715201193839.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864113397.182683.5812513715201193839.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
