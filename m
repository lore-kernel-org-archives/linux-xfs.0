Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6AA2C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 729CA2189D
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:18:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BuQpb4bI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfH2ISY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 04:18:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57998 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfH2ISY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 04:18:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+nN7LOG/9+PKf4MO2yNXSDt1shVfEIbqMZtjoPPRqmk=; b=BuQpb4bI2JGUOh8Mn3/Sw74zB
        RPpCQpwnQA8gJQRLqYO7yK1qZcgp/nG0UTmo3zkcc62gOoKwMvFKJsgcxpR1xwlEji7BFq0yxinAE
        ABzTl2OgPgOyL5PrlA38UwwJ9E5Ts27dPHEfOSSelBEfMMYYNcqwsCn/aDEKMPKw55Y1D2p4ADzLV
        tiBf2ZlKvZd2YjjOEp2MMSq4YH4E7F8ZHK+hA77KrzjNkkL4NBOpcnqxlgpcNCuIhv3qgRpxYAxfF
        4LyqdFgbRtjyi3rNJDWKt7LWjek+HhaDe/j+L40gQcQ9h6kR8Q2ScU2S8tNERxyR0gnZB26Q0ZFfL
        r6yYYtT7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3FId-0004Td-4D; Thu, 29 Aug 2019 07:56:55 +0000
Date:   Thu, 29 Aug 2019 00:56:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Use WARN_ON rather than BUG() for bailout
 mount-operation
Message-ID: <20190829075655.GD18966@infradead.org>
References: <20190828064749.GA165571@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828064749.GA165571@LGEARND20B15>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 28, 2019 at 03:47:49PM +0900, Austin Kim wrote:
> If the CONFIG_BUG is enabled, BUG() is executed and then system is crashed.
> However, the bailout for mount is no longer proceeding.
> 
> For this reason, using WARN_ON rather than BUG() could prevent this situation.
> ---
>  fs/xfs/xfs_mount.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 322da69..10fe000 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -213,8 +213,7 @@ xfs_initialize_perag(
>  			goto out_hash_destroy;
>  
>  		spin_lock(&mp->m_perag_lock);
> -		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
> -			BUG();
> +		if (WARN_ON(radix_tree_insert(&mp->m_perag_tree, index, pag))){

Please make this a WARN_ON_ONCE so that we don't see a flodding of
messages in case of this error.

