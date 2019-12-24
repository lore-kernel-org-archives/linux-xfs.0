Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA1CC2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 12:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52DAD206B7
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 12:18:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cT3cKlNr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfLXMSb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 07:18:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40110 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfLXMSa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 07:18:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TxuOKJ/gEg94RlO6q0qmkLkbs6DTcCdAKdGPmdpUog4=; b=cT3cKlNrHNwMGNoXfa7XEL7Zg
        i2KZATibFPcjLll/cdtRrnfiC3pUBON70sLLRHLqj1q1FMzk0IkpSJUnPZIw5+2WvVK7/j5xbu+65
        AuMGeARVlM6zt2yMc7cTZT9znNqzQsTxpPPtPL3whDtgM08qL9dVhNm30BaNuCDcPUy0WGb/9dkw/
        DH1OLsMxhz1oIE4yJcOPL9c8MwJxu9AO6v5qN60eMnPYFH87ykO8nzBVaABqLRnAqRN30DXPOC4H5
        KTV6rK7BZYJhfREvfyY7Cce+BzQ2t6OduPKkF3vDo5Cc3iW74ZKBrkHTKFL9jJinXdA3fFGr/GjdK
        8gj/H31Dg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijj8w-0003y7-HB; Tue, 24 Dec 2019 12:18:30 +0000
Date:   Tue, 24 Dec 2019 04:18:30 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 04/14] xfs: Add xfs_has_attr and subroutines
Message-ID: <20191224121830.GD18379@infradead.org>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-5-allison.henderson@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 11, 2019 at 09:15:03PM -0700, Allison Collins wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch adds a new functions to check for the existence of
> an attribute.  Subroutines are also added to handle the cases
> of leaf blocks, nodes or shortform.  Common code that appears
> in existing attr add and remove functions have been factored
> out to help reduce the appearance of duplicated code.  We will
> need these routines later for delayed attributes since delayed
> operations cannot return error codes.

Can you explain why we need the ahead of time check?  The first
operation should be able to still return an error, and doing
a separate check instead of letting the actual operation fail
gracefully is more expensive, and also creates a lot of additional
code.  As is I can't say I like the direction at all.
