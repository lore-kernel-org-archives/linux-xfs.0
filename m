Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99914C43140
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 15:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22F642137B
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 15:44:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q2fQiZ7A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390717AbfIEPoc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 11:44:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:32876 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390707AbfIEPoc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 11:44:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pI264VgxCZ2L4ULXvjBM7jnNfXVLaxnVcTEOSWnFf+s=; b=q2fQiZ7AwtHAfBXL3NXsBfMX0
        J4oGI+fp0f18F60mQpSFS5RY7+Cu9Adq/9dxbc8POhZ86NcuezQUgYsPmyI9qpNMlGR9m6u0wQ10p
        Rtr+zzfYBYAPjn3kAIpts+mu+fhXkYlSOCyqRrc3VMl8RC9IsZTyjl7VRxCOmQ/s7RDAzRUCThgpP
        ljpYNruHH6wPY1dizaQCxYkl5x+8fp++4NdsxATQVK+cZZXgWRVNeR2gOu28yjTL/qfGBSwjKEd8+
        hbdaF7XfCt1RaBv3DaQJRMEGfkSpL0Mosj7eaQsgq7NJiS6GH/+TD0L2TRZgswo1NSqTZxy0FddXW
        M9fxaMVDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5tvz-0004II-Mv; Thu, 05 Sep 2019 15:44:31 +0000
Date:   Thu, 5 Sep 2019 08:44:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8 v2] xfs: log race fixes and cleanups
Message-ID: <20190905154431.GA15118@infradead.org>
References: <20190905084717.30308-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905084717.30308-1-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With this series generic/530 works for me.
