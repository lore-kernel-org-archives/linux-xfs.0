Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5ADC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 07:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiKBHS2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 03:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiKBHS1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 03:18:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD874C5C;
        Wed,  2 Nov 2022 00:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=M18BszLNrlBywvLrgE18hKdQTI
        eWfVIhnkM9JFtD4HAPHRamTS/tyHqzvxnYvxTDL2+UidhjrH5bQUGAes2TSKChrSdMUTJnpkLKPen
        Xp/GdmKg8/Df3cPakkMuX4RDac/R3UvJH6XlK++MVxbmDBIW6+kI2TNqmMeVnEGGJw+gqKOOWtXDK
        6aQ1Nb+CcGX2zq2m55a37xwxwLl4touowkNe/rhkQTBNkPHS8iSUObVYVng6HBwo9oQOhatq2t5j1
        mNhJChS1eO1a7ANVqd79U01Smwe2zhr3nt/gF8K9+iABSrtyPrGGJFsxG/PvkQeanNgT7onQvY+9q
        G8pL4Kzw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oq814-008bcL-Bt; Wed, 02 Nov 2022 07:18:26 +0000
Date:   Wed, 2 Nov 2022 00:18:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: punching delalloc extents on write failure is
 racy
Message-ID: <Y2IZwr5a3FYAptVS@infradead.org>
References: <20221101003412.3842572-1-david@fromorbit.com>
 <20221101003412.3842572-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101003412.3842572-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
