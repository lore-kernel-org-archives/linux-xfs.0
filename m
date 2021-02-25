Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A26C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECB1164EDC
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235870AbhBYJPF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 04:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbhBYJM6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 04:12:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45422C061574
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 01:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=cON3NFGabsnPDD4hboksVop5TY
        aoA9ds9XvJNfUAAaSyuOjUbyupLJHYn1+C0Qswhh5a7DAZ/QK/+Qri0FbleqBzn46YF0Ab37ZlZ1y
        UbwSQsXZ+PpStB3fDuBAL3zBL3E90sLlv4ZwcR3bcMP1QSt/cae1CIfzjRgFFcVGfNv+EAH7kBcNC
        owGr/UfISSLD98D5exZXPawrkCb3iTerNPdOnFM1TUz32Y8lzYOJ3yuUZnrdzqi+odOw6NM7/qsz2
        OR+YhZB1G75Jb11pPFFR98Zc5FNZvJ3Rqi4QGVFoGVY2+tPMJ6JnjzsnbCSOc4ZIp2aPfg/Wntobf
        a6GK7qMA==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFCgP-00AVR2-UU; Thu, 25 Feb 2021 09:11:49 +0000
Date:   Thu, 25 Feb 2021 10:09:25 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: reduce debug overhead of dir leaf/node checks
Message-ID: <YDdpRZ0G+EgVpt/S@infradead.org>
References: <20210223054748.3292734-1-david@fromorbit.com>
 <20210223054748.3292734-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223054748.3292734-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
