Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0B5C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 08:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B0296115A
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 08:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhKKINj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Nov 2021 03:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhKKINi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Nov 2021 03:13:38 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C20C061766
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=HZlQGu/dLnULLaRrS+84fPDPeD
        D72FfPwAVXGBgSEx45SQKdN3z6Qnt6lXR0XCaIApMOlvOGKJFy5cBzKln8vQiFbKjq+7QSJTcF0Er
        LqMofdv1k+QdGwUlTYaVM5cKJPFS6zRpAZjbuVrIZ1iTRHkpRYaJRfc1eMI6C8tnkJEd9oGB+99Y3
        2Fh5B5xeRyT9mRhhNEFrQvZ35Dtdq68PsjYIExDxJ7WJR7Btcw5IqwgTVtTqagIqYMa2BWFvdC8yM
        E5R+eJnOuCdJ9JsL94GERA3zxOKhlapeNGPjkZ/SZ7XDZ73NhUE/NpByWUtQPN7zfacN2FUDOVKC4
        excO1ffA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ml5AX-007TH9-U4; Thu, 11 Nov 2021 08:10:49 +0000
Date:   Thu, 11 Nov 2021 00:10:49 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/16] xfs: pass lv chain length into xlog_write()
Message-ID: <YYzQCThK9Qs0fUMs@infradead.org>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109015055.1547604-10-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
