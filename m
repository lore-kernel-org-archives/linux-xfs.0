Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFC7C433E2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 09:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63CB220709
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 09:11:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FbwXv0jA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgICJLm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 05:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgICJLm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 05:11:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201C6C061244
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 02:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uByfdrQqtbZljQObubo5Gt/Lew1UUQYIQpT6USAQh6E=; b=FbwXv0jA2bySaYC8wKK2yK70iq
        FCNUzgUvo2GGN7qbJb6WmN/WSv62xOwiV3rwgQDKs7nl7OjYDvCQ/VsLMhJT/OPTR+mZfzoGKT0SI
        ZUH6U1lAGzb1FLoDE6SE8s9HVC/6lFiNujvkgC7xyXhBxCW8oZwXtS95uZfxH4Xhaju2tKIQFNkvl
        MLFPDiqcbqDEybJhMeH3U6J3bF/TUE8Z80mfyUL3niqmt0eJxavc/tryy3octZ10g6kZr3keDcz+C
        xFEGg9f36SlCUBYM8oowg+Wy/W+RWzNRO/mLIE3EZdUv7fGPnj/BFC5M+hKj7J+nLrl2G90QLUfzt
        +6gnZ5ig==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDlHQ-0003yD-Jj; Thu, 03 Sep 2020 09:11:40 +0000
Date:   Thu, 3 Sep 2020 10:11:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 3/4] xfs: Use variable-size array for nameval in
 xfs_attr_sf_entry
Message-ID: <20200903091140.GC10584@infradead.org>
References: <20200902144059.284726-1-cmaiolino@redhat.com>
 <20200902144059.284726-4-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902144059.284726-4-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 02, 2020 at 04:40:58PM +0200, Carlos Maiolino wrote:
> nameval is a variable-size array, so, define it as it, and remove all
> the -1 magic number subtractions

Looks good, but two little style nitpicks below.

Reviewed-by: Christoph Hellwig <hch@lst.de>

>  		if (be16_to_cpu(name_loc->valuelen) >= XFS_ATTR_SF_ENTSIZE_MAX)
>  			return 0;
> -		bytes += sizeof(struct xfs_attr_sf_entry) - 1
> +		bytes += sizeof(struct xfs_attr_sf_entry)
>  				+ name_loc->namelen
>  				+ be16_to_cpu(name_loc->valuelen);

This can be condensed to:

		bytes += sizeof(struct xfs_attr_sf_entry) + name_loc->namelen +
 				be16_to_cpu(name_loc->valuelen);

> index c4afb33079184..f608a2966d7f8 100644
> --- a/fs/xfs/libxfs/xfs_attr_sf.h
> +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> @@ -27,11 +27,11 @@ typedef struct xfs_attr_sf_sort {
>  } xfs_attr_sf_sort_t;
>  
>  #define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
> -	(((int)sizeof(struct xfs_attr_sf_entry)-1 + (nlen)+(vlen)))
> +	(((int)sizeof(struct xfs_attr_sf_entry) + (nlen)+(vlen)))

We can drop the int cast, but more importantly please add whitespaces
before and after the + operator.

