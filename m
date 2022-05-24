Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19E1C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 08:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiEXIOp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 04:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiEXIOn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 04:14:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03337A83C
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 01:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gT+5Mxqcm3b3vhM+kCaQ2T0pE6
        CmIrb8YVkXQQ5/Byvdg0oqD3Ko9wBHu5A4U9j7A5YmjxTlaVZuc/FXPz2pyjIVD9gumymHkdxcCcP
        2PaeRT2tyt4SyPyh6js5Ka/EdfGJrG/EgmBk/+WjWqdpqXf4Xm5qyv9r0N2VLEqOOR0GMs4DLNd2t
        3OTjmYzpgL0hbHaOm9XFt7MALAGG94XSHKBUk+70S1mfVwHFPUAnrMZPluLA2GskwyAbuE1zXFfuX
        hcLbZpzOjBiKgnkEdmjy/EfrufyHU1kZ0y/1gZWUuZBOn8TE9jYwwLgH51ZwLOOL8Pn4YWish0y37
        veIpqZ9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntPgg-007DVD-Fn; Tue, 24 May 2022 08:14:42 +0000
Date:   Tue, 24 May 2022 01:14:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: don't assert fail on perag references on
 teardown
Message-ID: <YoyT8rjGQQfFWwt+@infradead.org>
References: <20220524022158.1849458-1-david@fromorbit.com>
 <20220524022158.1849458-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524022158.1849458-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
