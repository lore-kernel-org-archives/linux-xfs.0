Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180C4C3F68F
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 18:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA7FB20702
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 18:29:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fqWrgsXk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgA2S3g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 13:29:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33346 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgA2S3g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 13:29:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HxbF5906WTegzWfCsYTqOhEUFbfUWrzQx5/26KGGH/o=; b=fqWrgsXk6AsrM1ZYi1CWogmuT
        a6N+CD/CYhiKcdFWr63U/oG0geT/ZTDiM9N9zjIaNRhlbF+ijEbbtdxabNC+G7GhOl+XnURX3CLrw
        iNjv3jyDYa5WPFVOrkKHXVk9QYIUuBh8R6xtlqPYN2VL+2JN+ZHP2yFYHgn+7U9etNQAdRk+rRvfU
        QDRBlTVJyrcdhiEbcz+EZUwxg8xPfGnXLRRJMoFxW4Y2ArX3e+tfmcXa0DHasy2LL0EzxkHE0S1dW
        m29A3dgi9ifEyATQQzvorhL/caWynKVGxhWEFzWw3YIcL2uO1M2SJ1TLbzGgGxtHKy+mwNj9LfRVn
        mJ+vUMYAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iws5o-00049b-2t; Wed, 29 Jan 2020 18:29:36 +0000
Date:   Wed, 29 Jan 2020 10:29:36 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 V2] xfs: don't take addresses of packed xfs_rmap_key
 member
Message-ID: <20200129182936.GE14855@infradead.org>
References: <65e48930-96ae-7307-ba65-6b7528bb2fb5@redhat.com>
 <89743aba-ca7f-340c-c813-b8d73cb25cd7@redhat.com>
 <b44b9c6e-4c40-2670-8c38-874a79e0d066@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b44b9c6e-4c40-2670-8c38-874a79e0d066@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 12:15:06PM -0600, Eric Sandeen wrote:
>  {
>  	uint64_t		off;
> +	xfs_agblock_t		start;
>  	int			adj;
>  
>  	adj = be32_to_cpu(rec->rmap.rm_blockcount) - 1;
>  
>  	key->rmap.rm_startblock = rec->rmap.rm_startblock;
> -	be32_add_cpu(&key->rmap.rm_startblock, adj);
> +	start = be32_to_cpu(key->rmap.rm_startblock) - adj;
> +	key->rmap.rm_startblock = cpu_to_be32(start);

Do we really need the local variable?  Why not:

	key->rmap.rm_startblock =
		cpu_to_be32(be32_to_cpu(key->rmap.rm_startblock) - adj);
