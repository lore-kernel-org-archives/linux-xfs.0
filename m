Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA7D6C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 18:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B211207DE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 18:46:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qD7uzVs0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814504AbgJ0SqG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 14:46:06 -0400
Received: from casper.infradead.org ([90.155.50.34]:53072 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1799391AbgJ0Soy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 14:44:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=qD7uzVs0OgSyjrtA36JoYQw33o
        dCId0ZT8H4+DXBWVIFzl031IWshH9UwALvH1f4DXGeXpoKY/lCVjq0ZxZu3zSr9hXZltaRroRLU3r
        JbRsiX6v3XtbPiVKz7P/nI7R8HmAD1rV9doq8lciwSEYJL5WNulnMt8XAtboVkmxUPA5FwsvX7dnb
        NfoDRRsUCPLrLGM9Jq2VuDCvcA/v+jIMhniUbtKGj7yDRmfKK1WSAj9NXN0/FKrLad5G71E8iU1wm
        Bx8GaJsRmdna22OnoUwOOprqEkTyWTHhKiIlvBE4De44RkxwqirCZgf9XyEw9rVqxosBYvpZMbJXL
        Z1W7ktVw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXTxY-0003St-Gy; Tue, 27 Oct 2020 18:44:40 +0000
Date:   Tue, 27 Oct 2020 18:44:40 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove the unused BBMASK macro
Message-ID: <20201027184440.GA12824@infradead.org>
References: <1603100845-12205-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603100845-12205-1-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
