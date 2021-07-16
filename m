Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77689C07E95
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jul 2021 09:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F67D6128D
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jul 2021 09:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235401AbhGPJrX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Jul 2021 05:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235490AbhGPJrW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jul 2021 05:47:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A88C06175F
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jul 2021 02:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=d191P0h/tg4YjSgIT+IDzRrYQus55eo1WbH3/dUdAz0=; b=LXCwd9R1dbDPZErSUXC2WghpAu
        fI1V7JRWJSPNP0CiXqt8qjjzZhTkDl4GoPssGBavrnjBRaSimn9HMnabmzN/TuZZnjyPee+YXhapg
        nqX9p/uXmdtnjvamFmRSoKSPZulzDQ93Da+wrnFJTIMOStHxbmglS2aqjLGJKyidnc+0oZok0FFWU
        ye1enDjbdmWcMfxAxP+Z/9jznp/RVS5RvR6NVOf9q+PLr9INVUof/DXDPPBh65z2G356inhIPOQpi
        HgGhmMubMwSE4pqO3OAJS+3VJuBPR7GCcIXdmsHXYa/14bT2TEen4hmQHd25Vh/U8+/ri2GTGKGLa
        5redmShw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4KNU-004MLe-CA; Fri, 16 Jul 2021 09:43:41 +0000
Date:   Fri, 16 Jul 2021 10:43:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/16] xfs: rework attr2 feature and mount options
Message-ID: <YPFUwBEikvw8ee0V@infradead.org>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-4-david@fromorbit.com>
 <YO6LCbZWRz3q4JRg@infradead.org>
 <20210714094533.GY664593@dread.disaster.area>
 <YO/NtwOVVanEl6HE@infradead.org>
 <20210715234715.GI664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715234715.GI664593@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 16, 2021 at 09:47:15AM +1000, Dave Chinner wrote:
> The problem is that I can't kill XFS_MOUNT_ATTR2 until all the
> m_features infrastructure is in place to replace XFS_MOUNT_ATTR2
> being set in m_flags. We still have to check that the mount options
> are valid (i.e. attr2 && noattr2 is not allowed) before we read in
> the superblock and determine if XFS_SB_VERSION_ATTR2BIT is set on
> disk...
> 
> It's a catch-22 situation, and this was the simplest way I could
> come up with to enable a relatively clean change-over...

Ok.
