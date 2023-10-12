Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F574CDB47E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 08:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbjJLIxe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 04:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbjJLIxd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 04:53:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F1E90
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 01:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=77JHsqi+KPcchqSDVBeM5yKcbzRPToc05JJpcwcloHE=; b=eewCPoJAPzqBKIjc5zE9dQIWa+
        ETzd8NXMmHTXax2ATLbLyCFIQ7DV92g0NXl7UOQ3Aq7lNWCUGcVhO735BoVptlGIp01iQgAMI5qjo
        /EsV8hv5lAPjMJIpYNe2+n7UE+6bZ4rC1z2faCGUMcyo7bpya5zKM3HP48P0spMAdifGATWZ9flI1
        oUf3vGO0fjA/E3KQSvut6A6H9jI40QYL2/A5TTKG0mnxauMhxiqFgOHH5Hqh5ysXdbAaKfC9rK39X
        Eay54Mp3p7tvstf2pL2okYTCEgCGm1ir/epgLJOQ/Lfg0sq8iePTzJph23J5V1tZYvYB6cSliui4e
        Ym0VCTtQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qqrRi-000HEZ-1A;
        Thu, 12 Oct 2023 08:53:30 +0000
Date:   Thu, 12 Oct 2023 01:53:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: grant heads track byte counts, not LSNs
Message-ID: <ZSe0Cp16HDFGldmp@infradead.org>
References: <20230921014844.582667-1-david@fromorbit.com>
 <20230921014844.582667-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921014844.582667-10-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(modulo the old comment about the now unused paramters to the
spae tracking helpers)
