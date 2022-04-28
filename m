Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C229C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 12:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346564AbiD1Msv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 08:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346613AbiD1Mss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 08:48:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7404926ADC
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 05:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tFNfVbCs9MEAHzK7tDMsIcXkre
        gvOeDP67Qp2hHLGDvN/7k6Gu4QokCXB1RY4bhoiGS2jk65LuVESUVxHd+lzWcUwxS9WBA7u/4bhrY
        YIXJqWTnNsRvSO+YxGvfR/+/kEV7uPDeua3uyhj/dntHObnyBxbip7ed2CDOLSW67U0fq3+xFzaXw
        HA1fvplBRDUiD9N9brE+s3Cr+nZKkr6t+9tYKNEr+Jq+Z0rNx+3MWLYHH8MDwIyRnN0C14UzsGmyX
        FpWKdXL8SU2EvpXn/JCZ3osj7A6HeoWDR+1JErCFcOq8h4+5pNZDhp7QU9CjR3zgqoGh84737SQ7S
        fu/iw+hg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3WL-006r68-D9; Thu, 28 Apr 2022 12:45:21 +0000
Date:   Thu, 28 Apr 2022 05:45:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: speed up write operations by using
 non-overlapped lookups when possible
Message-ID: <YmqMYfLyZaiwrrRJ@infradead.org>
References: <165102068549.3922526.15959517253241370597.stgit@magnolia>
 <165102070826.3922526.7040761074869734523.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165102070826.3922526.7040761074869734523.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
