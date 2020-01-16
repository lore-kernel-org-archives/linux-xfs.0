Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 316C4C33CB1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED7AF2077C
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:28:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LNk6NpVG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgAPQ24 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:28:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:41224 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgAPQ24 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 11:28:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+QlsK9oAT5vA9wNid3L0KEavCrCh7Y+o0oSvfZkTels=; b=LNk6NpVGS3+lZABjQZD2S9tmO
        //NhpjejXL8F9BSSTBGkaFw2MHhuVI/UYW5xjPs+h/bdy+kxySdickE5LoVjsk0wrAXgAOewfYlDA
        7T7l9aGWp/kkUIcEqoxyf7tSSuSMBwtqlN0nCWX46MiaPSLScnwdhE+cGuETKI15fwl2ASjJ6V8ls
        Z93lpnr2W2IGwLnjVcIXauc05sJU13onw83pjfDYK/VpyQrPOcHddxrxiVSt4LYPEd/a7gkHOOd6/
        GFQLGUeyhR+NGYUEqs588Q4Cfsui1dD0dEu9f7oGZik5t1Ya5CEiSpn4AJMvknmyXSOtsjmh3ksae
        JVgdY9xYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is80u-0000J8-4Q; Thu, 16 Jan 2020 16:28:56 +0000
Date:   Thu, 16 Jan 2020 08:28:56 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 6/9] xfs: make xfs_buf_get_map return an error code
Message-ID: <20200116162856.GF3802@infradead.org>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
 <157910785745.2028217.13992797354402280050.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157910785745.2028217.13992797354402280050.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
> -
>  	switch (error) {
>  	case 0:
>  		/* cache hit */
>  		goto found;
> -	case -EAGAIN:
> -		/* cache hit, trylock failure, caller handles failure */
> -		ASSERT(flags & XBF_TRYLOCK);
> -		return NULL;
>  	case -ENOENT:
>  		/* cache miss, go for insert */
>  		break;
> +	case -EAGAIN:
> +		/* cache hit, trylock failure, caller handles failure */
> +		ASSERT(flags & XBF_TRYLOCK);
> +		/* fall through */
>  	case -EFSCORRUPTED:
>  	default:
> -		/*
> -		 * None of the higher layers understand failure types
> -		 * yet, so return NULL to signal a fatal lookup error.
> -		 */
> -		return NULL;
> +		return error;

I think two little if statements would be cleaner with two ifs instead
of the switch statement:

	if (!error)
		goto found;
	if (error != -ENOENT)
		return error;

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
