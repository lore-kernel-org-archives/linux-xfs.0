Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74572C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 07:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiFPH2j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 03:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiFPH2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 03:28:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E214F47F;
        Thu, 16 Jun 2022 00:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qyudK9RHzHd0FIczh0aVX4a/5A3C+DJ8JynCKqV8fww=; b=11ryEfpGZsM2WSo4FIu09RIUfh
        iFdyiaA5LbnWO1SMdODF8+EI4N+WTm4MhDL+l6ovDkAsCKdLf3CayceRpZo6D161YBAy2/BUyxhVW
        0vdmwAoJ4VHRmsqSofX008uOoCFvuoB5TWMoWd6Z6ULNAD6XL8MSQhzhWnc+yTX/ND1iAT2IF1DwB
        OADPBraaAPB5xGosAdPXJR0wOPRZwsVZhijLPjt11JfOWG2/h3Y6q0VaFAGscTLizTiiZ/8mlEWoX
        ORgTJ/5D9t9KJuHxfoJuxccK7GEYiX9b8JhpQWkOtrdCm2yoJ7NhEe4WKOGS4NDP/SyiL6zlF95Ze
        7RlWxbJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1jvW-0012yz-PZ; Thu, 16 Jun 2022 07:28:26 +0000
Date:   Thu, 16 Jun 2022 00:28:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, hch@infradead.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] iomap: set did_zero to true when zeroing successfully
Message-ID: <YqrbmiZ4HMiuvl17@infradead.org>
References: <1655198062-13288-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655198062-13288-1-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 14, 2022 at 05:14:22PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> It is unnecessary to check and set did_zero value in while() loop,
> we can set did_zero to true only when zeroing successfully at last.

Looks good, but this really should be separate patches for dax and
iomap.
