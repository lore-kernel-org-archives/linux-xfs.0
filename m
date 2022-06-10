Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B0DC43334
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jun 2022 05:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238858AbiFJFqK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 01:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235507AbiFJFqI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 01:46:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188CEB4B5;
        Thu,  9 Jun 2022 22:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fQQYd8rH7yJgcH0WS5t7Iydx1WYbX6aTpNe9zlkn5xY=; b=knb9VjPHC+6O7WDiHU1GAHcTAG
        vRgrANbZCRTzUEEFNEjFJ1RdGOfNA/zo2JrBBPC+yL6tSluDm289+6nyXfosJtKmlyZlBieC7vkkz
        QE+AGKTlV/bfs9e2X6gg8YTXmB+lbg9RldomOdR9TXR7wcDPHzZYjcFA9ivk5gypnNfJ+PG8MIqWv
        jb3fC56WsabH27bAKa+26acnxmxXetekXbR4k99gDJ1eLm8bsipbbeON7lqnj3i1K4QksMVFK2MiX
        UWkr5+1IN9mWvoqKgH+esAlnwDVxmlsDwGC2wYggJwT9uExQr93/yAyGe32WwmBfYGoeEox9EeC0X
        fd4876rA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nzXTB-0061yU-Ai; Fri, 10 Jun 2022 05:46:05 +0000
Date:   Thu, 9 Jun 2022 22:46:05 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH] xfs: fail dax mount if reflink is enabled on a partition
Message-ID: <YqLanVuXPaIJOtAW@infradead.org>
References: <20220609143435.393724-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609143435.393724-1-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 09, 2022 at 10:34:35PM +0800, Shiyang Ruan wrote:
> Failure notification is not supported on partitions.  So, when we mount
> a reflink enabled xfs on a partition with dax option, let it fail with
> -EINVAL code.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
