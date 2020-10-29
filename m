Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B66FC2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB7902076E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:48:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qIBxx2W0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgJ2JsH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 05:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgJ2JsH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:48:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FC0C0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+FuUyHOgp1be8xPFWGyFxor7vXtvYsf/T1SJT6h67Hs=; b=qIBxx2W0nr5C4rZmXzAZUMP1G/
        YXPzOk0kuFyZIqJPrH6YfIxHogaxocvOkMfjY1TXCojncWY7TBOPV9SGUykAGrtV6L4mrNOL8HKVy
        fFVKC41zXDnVxhjoUTyTTRpbIVvWdfqwOqht5vY6nk4yC7SIuoyAOJxZDMRyd1esMC4XtjffVr7g3
        Ys3ru+1w0orQlAqI66JIX84L6n8sUi9imRS9b+cnRNNINHg1jNfkgtaz5MgyB1iZtglIP+dZhSetS
        qmrGGAyB93lf+pW6BFGmS7Q2uwSnZyEQq25MjmJF2mSOAI0P1qovAPKrpuw1Y3EYUu7FtzjSsCdE0
        EC+hFYiQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4XK-0001ZM-56; Thu, 29 Oct 2020 09:48:02 +0000
Date:   Thu, 29 Oct 2020 09:48:02 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/26] xfs_db: refactor quota timer printing
Message-ID: <20201029094802.GK2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375529066.881414.13277074782068895997.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375529066.881414.13277074782068895997.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks as good as the xfs_db filed printing mess can..

Reviewed-by: Christoph Hellwig <hch@lst.de>
