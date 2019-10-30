Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2907FCA9EC7
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 21:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1AB62067D
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 21:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hOv712Ni"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfJ3VcD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 17:32:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35826 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbfJ3VcD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 17:32:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BHDhMFY4nO4AOc5bgXi/fTmZguR67fGQC4Lgx/De+hY=; b=hOv712Nit3W2Qa69qtVnsJ9XE
        lIcnBMFeSJozs80p8+tALY82Ds3ODMNpLMu9Fef50J2fXak/P4jaoByK6NLh2oeIFkfTqeTcARwhF
        damZDgx63Q4I/pTe/ZJYloXa27kJa6pAwzblniUig9Bi90+xuMTamvpLFKQ1h6sHySHA2R3+6rDW2
        eb4bxwCfK6gMnk286Y8vG9hZ3OpwiQkPpIT8LtqSvXmCky4J8H1T4SEKRbsi6u/UL8cXEUhRTUcRL
        ytCYhLPcAAxhW4m7xy02pOrSPYJG6OBjcmUAidA4aCuyf1j5QTzhZk2b0T49FPCy9E31EHmdHktmb
        GSFKBeGXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPvZT-0006aF-0F; Wed, 30 Oct 2019 21:32:03 +0000
Date:   Wed, 30 Oct 2019 14:32:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: namecheck directory entry names before listing
 them
Message-ID: <20191030213202.GA24872@infradead.org>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
 <157198050564.2873445.4054092614183428143.stgit@magnolia>
 <20191025125628.GD16251@infradead.org>
 <20191025160448.GI913374@magnolia>
 <20191029071615.GB31501@infradead.org>
 <20191029162330.GD15222@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029162330.GD15222@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 29, 2019 at 09:23:30AM -0700, Darrick J. Wong wrote:
> > So we'll at least need to document that for now.  And maybe find a way
> > to not do the work twice eventually in a way that doesn't break repair.
> 
> What if we promote EFSCORRUPTED and EFSBADCRC to the vfs (since 5
> filesystems use them now); change the VFS check function to return that;
> and then we can just drop the xfs readdir calls to dir2_namecheck?

EFSCORRUPTED should have moved to common code a long time ago, so that
is overdue.  Not sure about EFSBADCRC, but that might not be a horrible
idea either.
