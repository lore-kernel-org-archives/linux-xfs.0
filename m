Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793FDC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 08:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D4D961177
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 08:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhKKIbW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Nov 2021 03:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbhKKIbV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Nov 2021 03:31:21 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DD7C061766
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=YIpZKGhSwDh2A6OR0AZxUzcov6
        g9/wPg+wlL7OGDNLdoNALlu0HEysNsfr33ojuizDAsBBMJ9qcMgVMelYVySF7PwYDDxIduxLFyx58
        4JZnIuh9rAnEmo2PhroKAdMfhmvgKkUO6RcJWT7jDvq+oC/snJNyqvlf0qWyUgqwYqq4H56EwUzCo
        TT5+c2x6NDZonB7TlFHWDPsUQ6hfoe/DRknFiWNPS1hia+aTGjOOhYWrlnFB/LeJlQpJtkqUWDOka
        7ha36w+kfjCM1BhADcGbXTnMcXtIorvtxZFiRdjJ1oTTQie+bXt1F11AhEroh65iBj7QXL1r4Hr6v
        8k0eHauQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ml5Rg-007VFc-36; Thu, 11 Nov 2021 08:28:32 +0000
Date:   Thu, 11 Nov 2021 00:28:32 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/16] xfs: xlog_write() no longer needs contwr state
Message-ID: <YYzUMPeSZR1DAKih@infradead.org>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-15-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109015055.1547604-15-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
