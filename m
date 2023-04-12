Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CC7C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 12:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjDLMKc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 08:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjDLMKa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 08:10:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF2959D3
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 05:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oJiQ2FtjeSyrIgleGWv/qLbqcQMOJGQ7h2XgDVk6x6k=; b=kHqGPIIr09rhpNp0GnLdYK0gFY
        KuSgvClthjEunAgvRyCcJJTMuDW09oMajJdnNod9JlajPTXvRCe91oppUEabwUCsKDb8mTpJ82mSC
        0DCnSBOePIkTnp+ynDT8mB2xasHfB0jSUpMIjSwg7u190usPkFMU9yqgLEj4lVAvkuYqyqd2vYKqh
        rByZX0xIIzfxpJnzgb603TtC8gNsCQJdYyjKlV2od9rk/G3tsb5s6YQCAliWFdX0EF1Efs948LVSx
        gb64W2qsZ/xvyHmG8Z2RfoMXIvXbjecYQbReDfnvjn0L2WiVil6nidoU+wFCE4RkA5ueP/kN6Le0S
        RJ6QRzzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pmZIp-0032gU-15;
        Wed, 12 Apr 2023 12:10:19 +0000
Date:   Wed, 12 Apr 2023 05:10:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove WARN when dquot cache insertion fails
Message-ID: <ZDafq+psGOwbQP95@infradead.org>
References: <20230411232342.233433-1-david@fromorbit.com>
 <20230411232342.233433-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411232342.233433-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 09:23:41AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It just creates unnecessary bot noise these days.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
