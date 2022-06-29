Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DF8C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 06:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbiF2G7i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 02:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbiF2G7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 02:59:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2531035AB5
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 23:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rLoK94oMdVTzg5c5SRGyw51CV/
        xw5WZgLJWNJBAkeWEl2KqoigbEa9G1M3ZnPfMt2Khso6TPhaa/bEZg6kAXo00odkQ8kb9fL15+/2G
        asPurKEym2zMJRP1zeGDTnEjdIkbbq/mNTWMS0r+Blu8Qfs+9MlSl6kmz3ZWOYvqIuoI208jF2CiY
        Yl1KvJ1aYh12m/8wzGzob9HtQrZC21+iLskIUYDvMQnCq45aRCJ5QklzXVwfFt/qRlLN+fjhP1w8g
        NGF3BXTx8u4jgLVwn836oloW6QUuNN0a/SMvgXNE+CjgjJWJqPSlgy//gNJEDnrLGwZOOEih9voOU
        stQsSWHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6ReD-009xA4-1F; Wed, 29 Jun 2022 06:58:01 +0000
Date:   Tue, 28 Jun 2022 23:58:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] xfs: pass perag to xfs_alloc_read_agf()
Message-ID: <Yrv3+NiVaYkM+sjj@infradead.org>
References: <20220627001832.215779-1-david@fromorbit.com>
 <20220627001832.215779-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627001832.215779-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
