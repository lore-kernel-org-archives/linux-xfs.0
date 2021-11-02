Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2371AC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Nov 2021 07:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B1DE60E08
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Nov 2021 07:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhKBHPP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Nov 2021 03:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhKBHPO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Nov 2021 03:15:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58931C061714;
        Tue,  2 Nov 2021 00:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=eN/niMLZF16oHyF1KleDkIkgdP
        O+rUpW0iM4O36KC6UqklssDMmecCFVwo/DVPMEp+VOURp0zejCBq0TEHPCS72zlL7V66FR2xo/jnE
        AN0H58I3+yJZxHeShRrSK/wxt3i3AWx/Z8nZ5jWVmIL1gLvhzn1rhy0Ty6+/HE4LRNoIOK455nmHe
        PAJm+ZiI/agizFX7RhME+x1PEG8o99FzRiau+l4q6+t/SQN+wH4ABCuuRQY2qLsif0qTZ2/SvNbHT
        +p6kf7KmTdJ+Lwt47P0dw4LLL787NlYmAG4Xxb+/KGOh27GczZTHmb86bIfnluohD3FzxuTow3WTk
        EFc2r4YQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhnyG-000jHp-41; Tue, 02 Nov 2021 07:12:36 +0000
Date:   Tue, 2 Nov 2021 00:12:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/21] block: Add bio_add_folio()
Message-ID: <YYDk5K6weDu19rgs@infradead.org>
References: <20211101203929.954622-1-willy@infradead.org>
 <20211101203929.954622-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101203929.954622-3-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
