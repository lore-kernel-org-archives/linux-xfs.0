Return-Path: <SRS0=rRn/=BB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4008FC433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 14:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FC1320709
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 14:13:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="itjgFqge"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbgGVONs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jul 2020 10:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728351AbgGVONs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jul 2020 10:13:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52990C0619DC
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2020 07:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=R4q9JIbPMEvG1r8TauWb0aaLNFYeWnMrJ8d6qpEvkAw=; b=itjgFqgeCzNiAijRabyn6eOiX9
        Gzlzu9J5vBya+XyW+i7J0EyEbI9uFoyYvgMqNHEhGhj2Axu8JanmKaaVpCPTPDWdWdLj86CptXQcA
        xzKth4QrmtegABqBhnR8voQWrkgH8OqQd6ybNWerHg7wgQySlyuzQDQ5qfY5UCwo1Z9SLD3JkeTeZ
        Yw5L1lDc+Kv6HnIhZ0s84C4B+ilp7MwSnjf4Up2VJ60u+LcSHGhX6QU3DzX7JgV9Eb9sxxqWianyI
        NsO0l2xPnPB/2q/WCPDMl56pa6sMG5tY5NIt+SukkKuqBPtSdZV1stsrCI9dUBquG5dBXp/s2iSVf
        dEO7n49g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyFVC-0005Jw-Gj; Wed, 22 Jul 2020 14:13:46 +0000
Date:   Wed, 22 Jul 2020 15:13:46 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: Remove kmem_zone_alloc() usage
Message-ID: <20200722141346.GA20266@infradead.org>
References: <20200722090518.214624-1-cmaiolino@redhat.com>
 <20200722090518.214624-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722090518.214624-2-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 22, 2020 at 11:05:14AM +0200, Carlos Maiolino wrote:
> -	/*
> -	 * if this didn't occur in transactions, we could use
> -	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
> -	 * code up to do this anyway.
> -	 */
> -	ip = kmem_zone_alloc(xfs_inode_zone, 0);
> -	if (!ip)
> -		return NULL;
> +	ip = kmem_cache_alloc(xfs_inode_zone, GFP_KERNEL | __GFP_NOFAIL);
> +

I would have kept a version of this comment.  But if this on your
radar for the next merge window anyway this should be ok:

Reviewed-by: Christoph Hellwig <hch@lst.de>
