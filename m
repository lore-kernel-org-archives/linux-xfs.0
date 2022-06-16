Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1BFCCA47A
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 13:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377337AbiFPNz4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 09:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377328AbiFPNzz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 09:55:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6345039B99;
        Thu, 16 Jun 2022 06:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LGr90G6faJQ2p5SA3n28l6GxCe
        Lr7RXihwQqLKq7KeKFdVz/8bOqfJbfirSkd2K91IupEcNvj2Wqv98Uw/OWiugXgP7mA/gi1060VV3
        XyR7a02Rir0P2ZYzMB/pTWxEjtjktee0TVwOyTZdPctAlCfMwgfGZDVYtx2J2TVhS2zM9afoYLMcz
        Z6sThmNsGL1hDMYorbBTmF0I/BLwnRz5Aj+eQ/jN+io0uyEYHtOQN7d+76KUAhdKsRgq/fmIHmDWU
        9gkDKP9dUiZnWcfZYbcc6Mt/K5TexAKvzzEEpTApGZWH83cKhBqZHzzJ3TE8crAngelbG2KtdJSMK
        LIlWaSAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1pyK-002dS0-Uk; Thu, 16 Jun 2022 13:55:44 +0000
Date:   Thu, 16 Jun 2022 06:55:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, djwong@kernel.org, dan.j.williams@intel.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2 2/2] dax: set did_zero to true when zeroing
 successfully
Message-ID: <Yqs2YOAd/8s51p3D@infradead.org>
References: <1655387680-28058-1-git-send-email-kaixuxia@tencent.com>
 <1655387680-28058-3-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655387680-28058-3-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
