Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4068C07E96
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 17:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD3F061C5B
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 17:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhGFRsV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 13:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhGFRsV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jul 2021 13:48:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01A1C061574;
        Tue,  6 Jul 2021 10:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f71s0MO/L7mamKv725cHUlckyYyGdlzB9Ledhycinbs=; b=MS7BD3gEvKuEaV1u7LUAbzoUNr
        eIuvWkGyDoSAqv91tVEiWck+NCSB6wI9CC9Y1uzGD2k9WVspwuvz+z5HYKO2rZ6t0y+U8HAYqErra
        v04av2wj3b1P1XAD+7GEyYTF01FwQrh6UWTLixX83mI7DTog9aZFcIOAo7E/SrgDZYsbtl1y12laZ
        CAX2LQc7ZrLH/mTQO1w5bwTdAQLDSf/X9nS3o617zNxsjzVQSWpYX627ZpFTtLY7UlXyezvI0mSIn
        5hx4YOPDqePrzESX+W4dVxQGxV+VN8UZUOUwBgGBpU5vgRFBJG8BVQmovZN3X/UYGIw+VewDxGGJX
        zdjby6IA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m0p8Z-00Bcwj-Ly; Tue, 06 Jul 2021 17:45:37 +0000
Date:   Tue, 6 Jul 2021 18:45:35 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Leizhen <thunder.leizhen@huawei.com>
Subject: Re: [PATCH 2/2] iomap: remove the length variable in iomap_seek_hole
Message-ID: <YOSWv8mAt9ynRWMB@casper.infradead.org>
References: <20210706050541.1974618-1-hch@lst.de>
 <20210706050541.1974618-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706050541.1974618-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 06, 2021 at 07:05:41AM +0200, Christoph Hellwig wrote:
> The length variable is rather pointless given that it can be trivially
> deduced from offset and size.  Also the initial calculation can lead
> to KASAN warnings.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Leizhen (ThunderTown) <thunder.leizhen@huawei.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
