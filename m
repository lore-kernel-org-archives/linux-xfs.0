Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85FBFC432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 18:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55F38208C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 18:20:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k+JoIUtd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfKTSUF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 13:20:05 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51492 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728026AbfKTSUE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 13:20:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=s4/pV/+70Odk++8ysGjZVBXQuurhJFRyrGTGZ4vE+gU=; b=k+JoIUtd6c1XGieJaZghfMjs1
        2Y9k3cHebgGgr8mGLElBukUgTvvkNXrLl4vXQFRo1p5/JYGYyufDS9yCqbEJvkHvxYrcZ0O3W4Pnl
        zhiofxaXBAU/jYv0ZiUm/a+OuyiJF0EoxbOXAPhrNwoA91yhiDqedTTy+eNN+qeVzAoDhPB27E8cg
        U8gwqOZx4hoGwEpMMIq3vBvHfcjJOcmuyy/PnOTh9Q/+71sPHy3ssjOfTrXdp4wFld1LlHOTp1/Q3
        l8XyBnCS6XS0YrJA6hYUNI5zEsqoDqDRh4UK8bvbFyNmq3DTMN0Aisg6TtwiyMpMG5c2x/1ZKhR9B
        BakJAk5cQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXUaC-0005sa-Hf; Wed, 20 Nov 2019 18:20:04 +0000
Date:   Wed, 20 Nov 2019 10:20:04 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 02/17] xfs: Replace attribute parameters with struct
 xfs_name
Message-ID: <20191120182004.GA5349@infradead.org>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-3-allison.henderson@oracle.com>
 <20191111174924.GB28708@infradead.org>
 <c2571406-6a30-e4ea-496a-71572199f906@oracle.com>
 <a6562837-01f4-d852-0abe-74fda32e4b2c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6562837-01f4-d852-0abe-74fda32e4b2c@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 08:12:50AM -0700, Allison Collins wrote:
> What if I added an xfs_name_init to reduce LOC. and then dropped patch 3?
> What would people think of that?

I think we should just pass the da_args to the attr ops from the highest
level and remove the churn of passing the xfs_name there.

I've pushed out a compile tested only series here to illustrate what
I mean:

http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-attr-cleanup
