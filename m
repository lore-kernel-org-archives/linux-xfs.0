Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616A9C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 14:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbiECO7a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 10:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237561AbiECO73 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 10:59:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD6B34BB4
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 07:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CQSvDsg3bPmadZ/cau4lV5v/FX
        Dc7nbd/L63BX0gSpbUCiUNRP/7awAYVnx///Pn8lGmeK+KNT5rZt4jSgGcY+EuHT8ImmTAaKPX02W
        mAeoU0akJbZtzHEs58j2z31URq4WN88hjEi9HPDuaNbdDohYaKLtUk1713SgTuBs/nqHYboyv+VfO
        3K8hRGLoFEvazBi3egb6vgy1q67N2mCDaOBigsI1FU7+YbgeaVnxL4vnBEnzSNG+pys2Sp8qRt12w
        IWVEZUkObdzoeJ2rHAPCEWFKDtp+qPi5G0SVlzN1doWaYUcDhRhm9KZ0WYl8wrCPLDOFGKmiOIvJO
        xtrkbSqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nltwQ-006Mnx-V2; Tue, 03 May 2022 14:55:54 +0000
Date:   Tue, 3 May 2022 07:55:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: validate inode fork size against fork format
Message-ID: <YnFCevkwAaLtmukO@infradead.org>
References: <20220502082018.1076561-1-david@fromorbit.com>
 <20220502082018.1076561-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502082018.1076561-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
