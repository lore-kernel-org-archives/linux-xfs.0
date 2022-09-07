Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC783C54EE9
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Sep 2022 14:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiIGOLn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Sep 2022 10:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIGOLm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Sep 2022 10:11:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B9E33372
        for <linux-xfs@vger.kernel.org>; Wed,  7 Sep 2022 07:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qy6mdF3uSb8kHWag09xJCwjJ4c
        a7ypor8Ioo29TMot62EMz8+18iv69quZVnPA5BncqoymAeYVQLWlrNSqswuJBMHNh4xEUw1GCaqq0
        yhGX/4NEE7yKYb3KG76IrD8GGVro22vgSGfLESbKqCVM2Al68S8aAYoOs9bjP2C84Al/DQ/7t9+4I
        xlB6+NJ1t+VPR2ttwUxb2yBuoF9nwQ9PIVPrb837EY1yRMe7AYK0w24RgKzVj588zzVLum6y81sle
        YoZB89hSm6dSNB2JapnnAm6snhwG+441v0CtE6ebKNLPuZvtCKAhaoSPC6f/qf0u/XvpXeFpmfo4W
        1onwVZgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVvmH-006kEK-Bp; Wed, 07 Sep 2022 14:11:41 +0000
Date:   Wed, 7 Sep 2022 07:11:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: l_last_sync_lsn is really AIL state
Message-ID: <YximnUHbY0HOzpiV@infradead.org>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809230353.3353059-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
