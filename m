Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D465CC1975A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 18:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABC0320738
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 18:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BmCIZeXU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgCQSno (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 14:43:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgCQSnn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 14:43:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=BmCIZeXUrehUfIu9J6gkIhM5zi
        98lALFnXWhKoQt6hqTnIQn9r9PI41THCVdoE/o5GkoeuU3Ec1kAvqMqqc7EPh8J0tK72XHPpaceIP
        C9xgBWIzknutAG/UhxFJNhyC4pGTztYQeeh3PXncS4uadFleN/yeX6Duyle1ElSooqmeVWs248e+j
        MOfAjLsVKsBgEe/gqiruz1HRwC5fGfu7ApQYoAtTTCQ4c+OXbOX0roQVM81I2XhLTmOFceA2X2FMx
        Wpo1wdmpEQT6nKjYaT579E6YDvc2PdJryvzpDoGamhJpm+Ez8k5XvHs5EehdLFjYR5nltvvWcdimk
        e7II+RAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEHBn-0004F9-KK; Tue, 17 Mar 2020 18:43:43 +0000
Date:   Tue, 17 Mar 2020 11:43:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix unmount hang and memory leak on shutdown
 during quotaoff
Message-ID: <20200317184343.GD23580@infradead.org>
References: <20200316170032.19552-1-bfoster@redhat.com>
 <20200316170032.19552-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316170032.19552-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
