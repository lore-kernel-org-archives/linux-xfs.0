Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEC2C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 08:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A3AE60F4F
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 08:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhKKIas (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Nov 2021 03:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhKKIar (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Nov 2021 03:30:47 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89E6C061766
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=JSngI4KmZsepR/RKaZy4fsiDbo
        X8jSX4REgj7SQ1w8tfKzcP0VgumuFLpca7NAns3VNPfI4F51MNEab1dAZawVEDmEd0OfY3GDsad1/
        jD1QsozqtKEmOCaqanog4hpRcuKdULBrw7vhrmDCrMaSo+TWc4S/MR+hK5Nos5QxhbHz5WLVPIMiB
        rhqJ8SjN4/u6aNiqp7kck8iTbVAW5QORP2mIR+0FpgTLfN6DG76XZiwWsbv6gAoa1E6f9Ka6Xo7Jh
        RZPrDT5/+YXSIBxkR5ef0GK1cIfwlXYPIRtB2CTuSmREcp/OesjIvgnJoQ/05vnvpyH5AFpJ9etzr
        woBmP7wA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ml5R8-007V9D-9e; Thu, 11 Nov 2021 08:27:58 +0000
Date:   Thu, 11 Nov 2021 00:27:58 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/16] xfs:_introduce xlog_write_partial()
Message-ID: <YYzUDs+el4kLDFLu@infradead.org>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-13-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109015055.1547604-13-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
