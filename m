Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511B1C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 13:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346791AbiD1NIw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 09:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346771AbiD1NIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 09:08:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA9F88B01
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 06:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=jWoDw4d7U49o7npUhKr1kqgElc
        TJ4Ync5MiG/KgxnIcKNDEeTelTuY8SfxS3NTtSJXvkV1NIRCRevZAjW94CbpeUJD+zhY2ffQ2Giso
        uQqqXJf+nh455RAhRCiqcjYkQp4j513i/OJ8hz+JM5n2UCAmHPd2gAn2l5QhC8whKLQIx2Q+bosH7
        cayX4FsSN4bh2kUqHRZprbrE2ZfD4rZ5r3WczcKvb84wFiogdqP5nwT1QRh3dPBh4cDW65YhXfIjF
        LYolxFL+5y6qs7wytsRjFeMKGFEIwURWwQ8O77fxEdA0Uq9eFe2KJhVoC98ZfhLwT1QcCrc16KEvY
        lGj416cQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3pu-006vdZ-RK; Thu, 28 Apr 2022 13:05:34 +0000
Date:   Thu, 28 Apr 2022 06:05:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: tag transactions that contain intent done items
Message-ID: <YmqRHuWFV5/ckJQG@infradead.org>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427022259.695399-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
