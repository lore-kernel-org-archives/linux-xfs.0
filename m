Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0833FC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 13:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377315AbiFPNzp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 09:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377273AbiFPNzp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 09:55:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325F245068;
        Thu, 16 Jun 2022 06:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZjZgB/w9TjLF/+JWNCXQE5NKER
        iSaM7l62e5TTMnu1WDJNynJU7uMD1u8YSIH7mzRpTnulaeTcAZauFODqAcqnQR1jXSGt9JROlJ/Xp
        G7k3o2jA3Qg+gck8r73pkEClO0zy9adFs6wib9NcRRmenlIeEq+0aVE846asOXGntLz6a1tsucxus
        LN+jme/wepwQVSuqG+39JSKXXl2eL+7AFLXj91gQLC6v/XvNa2c5mm/AjI/MXQvGu0RVN13ZNkKYh
        nkXsuv2uUmRdqnCVGd36f4C3k2VPeHZykHwc0DqT8KhT++1dE21qoU66JPjZJ94JSVFEVLZZF9hrC
        mvDGtjmw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1py7-002dLF-QX; Thu, 16 Jun 2022 13:55:31 +0000
Date:   Thu, 16 Jun 2022 06:55:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, djwong@kernel.org, dan.j.williams@intel.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2 1/2] iomap: set did_zero to true when zeroing
 successfully
Message-ID: <Yqs2U6gmmffNL3ix@infradead.org>
References: <1655387680-28058-1-git-send-email-kaixuxia@tencent.com>
 <1655387680-28058-2-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655387680-28058-2-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
