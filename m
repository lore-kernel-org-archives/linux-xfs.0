Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07A3CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 08:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbjJLIur (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 04:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbjJLIuq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 04:50:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AB691
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 01:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=e4sV2n3pjzDUy1v+iWJgBgEZ9rRycY26JS4/IdqwgJI=; b=d3aoMZIG1csUoXgZi5yX8aFxOv
        iE44gDgWVHtqQqyvgGjUB6t8q+Tvk7rFgfWLjl9qRXASQow5paXTwakPeeFbbz5NOGbaV4Ne1+bxl
        CqQbTYKHux3GXYkxjOXSKOoXMoGygIL3Ggvpcy2xF1N0ILNEU/lr3hnDKNItFXONxGDNa7bimjum3
        jHBb9BUejiuI/9bAF/L73K26dYPygSHiYe9jbfQtS9e48SD8w97LyegPUma2DWJx5CQxKprRghnYD
        m5SvOGQFgIwoblIQ6l5E2j9ybJkkNVKSuL/8nTi+cTZQ81/T0OKjLGNaapdYvm1mghOH+yt8xs8og
        gGwhOmMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qqrP1-000GvQ-24;
        Thu, 12 Oct 2023 08:50:43 +0000
Date:   Thu, 12 Oct 2023 01:50:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: pass the full grant head to accounting functions
Message-ID: <ZSezYzktb39PapLR@infradead.org>
References: <20230921014844.582667-1-david@fromorbit.com>
 <20230921014844.582667-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921014844.582667-9-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks ok:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(still not my preferred split after all thee months, though :))
