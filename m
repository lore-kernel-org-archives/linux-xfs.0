Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F08CDB47E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 08:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbjJLIrJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 04:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbjJLIrI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 04:47:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541CB90
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 01:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Jm46StFb79wpvGnF3uA+WIG1WA
        T3Kz2IYOJa17HIvSDOP/GLa8eWLD72IqAwwh3fxUngAURl8kqXFqmpF3PHfpT+64TP6sjQnek/jcO
        q/ukC0oTHIaJXw+cTbSxnMHxiQOUnvrWXfV7wF8JGY88OCcd8B3lo+l2q17H4wtbRZ13oe9qMWrKW
        naCR8d1bvJgqVQchW/bt+CGZ86fyeEDA+z4+XToAyUw8qpDATGy/4yArcjLgAbuEPEn+7U8VRJ1FJ
        xDLKTvZVQaIap2UkOVZp24jTdCo05tqzI051BXUulAf5SsLQfryAgKH4bxWZt7Glk5Aj5O4VkM1JG
        or8q3Rkg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qqrLW-000GPg-0i;
        Thu, 12 Oct 2023 08:47:06 +0000
Date:   Thu, 12 Oct 2023 01:47:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: track log space pinned by the AIL
Message-ID: <ZSeyipRdjASmPvil@infradead.org>
References: <20230921014844.582667-1-david@fromorbit.com>
 <20230921014844.582667-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921014844.582667-8-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
