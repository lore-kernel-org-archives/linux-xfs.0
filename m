Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAA6C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 08:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C516109D
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 08:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhKKIcK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Nov 2021 03:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbhKKIcK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Nov 2021 03:32:10 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC72C0613F5
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=tEEKXRXHglj06GOrk13Hjnx1mx
        ZECPRPsPZQTIgDX2F8i5rHMXwUiLlRbG6VR+x5rSAII/IxLn7uqulNIL7lXOmDgmIu/EWqX2ZN54H
        CTVhlzc11RDRIWQjQUmyMEUhHHVnCCD46iEjJqAjPBJkKruRZaanj0FzzNOqVpsIdbSwOHyyFubJf
        YIw2yVfai1pGcv4qWDQQq7c9nU4GA8HTi8F3ggHS0Hx96UgQkNHBHGKEB1qpYqL8mD+wbLnL04q3u
        Rg+OpHMQ6ailI3V7b0WAbk2LCogZXVPQ4AJw3/nyM7oOM82YejTI7QKUYtKeQkVm+vZAhAH2Kof6G
        hvArr+vw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ml5ST-007VIx-HK; Thu, 11 Nov 2021 08:29:21 +0000
Date:   Thu, 11 Nov 2021 00:29:21 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/16] xfs: xlog_write() doesn't need optype anymore
Message-ID: <YYzUYUBfjUp6KMaB@infradead.org>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-16-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109015055.1547604-16-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
