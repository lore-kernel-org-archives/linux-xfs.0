Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544A4C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 12:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbiD1MzD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 08:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbiD1MzD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 08:55:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD3AAAB72
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 05:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iz4baBlDeb2ULfdDdNqF+0mFzL
        Z7pt5e8vhz6wQeVg0Ktj8MaDek4pHvy58zwNWZl8A0VKHVZr2K1WHrxv9VZZ3KrSQdsZfgDnbE8GS
        SxW5tzqI+ooHjczmWJJbfdFWxus5y7oPHBr/N6trjRbHS8meAorFdRgzPDM2ygjh3KPS+cYDxcW4/
        jZ4E06BfPs1IwWd/GTajaBwComNeAICIrftnyOjx+rDvGK9V1do1YjnvyUpqf9znXkOyo/XYLyRM1
        bHcrOsFYzijvCN0cEhSYtK3zRjNImNshogzB1LpWJZ1G572qAv9th+LGljQRtOHxVLdlhjy9ct3aw
        WmVpMyuA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3cZ-006toE-QV; Thu, 28 Apr 2022 12:51:47 +0000
Date:   Thu, 28 Apr 2022 05:51:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: report "max_resp" used for min log size
 computation
Message-ID: <YmqN456dybeKtCeo@infradead.org>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
 <165102074043.3922658.16450368163586208910.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165102074043.3922658.16450368163586208910.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
