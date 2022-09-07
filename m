Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73573C6FA86
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Sep 2022 14:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiIGOGs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Sep 2022 10:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiIGOGs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Sep 2022 10:06:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B72A897C
        for <linux-xfs@vger.kernel.org>; Wed,  7 Sep 2022 07:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=S2sXMdsdm1ABo9brRSLD3gLKlI
        1cMN0kAGlMg7Vh5tC3ndPDC3QRRD/cF6aIYxB16eb1hzLZcjSby/zGUfMbn7AwZN2rjVAhnOim4ZR
        JZG0vhLjYE5+V/OdIRmMpR/ilcIK/vrBKmEyML1UOFfPmZ/41JwdRmlE6xoDarTFdKyA2xx/AUU/T
        vk+kULwGZCOTumwXcIAL6DG1xLoxL4NZacXJ+T/RWFF0LkJ9P6D+ScTt7Y+BpZBcy+95NVDJTlogp
        uJtjR5lVccje81QaPhmjHwiq9PPLyujXDRz7ZdXoyG+q9GZD7rlpELJotg5I0afLiek/F07yNqSdR
        OlB23A2A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVvhX-006ia6-AC; Wed, 07 Sep 2022 14:06:47 +0000
Date:   Wed, 7 Sep 2022 07:06:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: ensure log tail is always up to date
Message-ID: <Yxild6OD7G7X6oKa@infradead.org>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809230353.3353059-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
