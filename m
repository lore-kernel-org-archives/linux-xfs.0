Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACB0C433E2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 09:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE1562071B
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 09:14:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FiFkc5X3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgICJOj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 05:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgICJOj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 05:14:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDE8C061244
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 02:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RBfqzGbqmPxYhjlKqmFmAVf24io94vqhDv4wO2oqAh8=; b=FiFkc5X3AZ9GydpWVgVB8bFWD0
        6IW2VfOhkFy5PCOd2UfxmEoqSRQEtsECBrKXHiTBgQcgcT9ovIjVrojxCka2stzoWYATrNI5VOAzQ
        55yzvEMTkVSrDcgI/kUJwk05WsmjRu6ejoN/MS6v2TFGhTX0LN0G9WNFqpCLpv86iN2bFDeVv1bXw
        thsE/vP9W68iqf9so947s1Lc3XJDbRGdekACJePnCFBcKczFw42nh5IiUlNLTKhbxBBLH8wlv/YXl
        30hHj3BTuy0p1irmdSDL0qlBxBHPPs33eoDj6Vya6DA9vCORtCSZTeTCdLZ20EawQ84feXfPjsxo7
        +B8Kiohg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDlKG-00045a-TJ; Thu, 03 Sep 2020 09:14:36 +0000
Date:   Thu, 3 Sep 2020 10:14:36 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 4/4] xfs: Convert xfs_attr_sf macros to inline
 functions
Message-ID: <20200903091436.GD10584@infradead.org>
References: <20200902144059.284726-1-cmaiolino@redhat.com>
 <20200902144059.284726-5-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902144059.284726-5-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +/* total space in use */
> +static inline int xfs_attr_sf_totsize(struct xfs_inode *dp) {
> +	struct xfs_attr_shortform *sf =
> +		(struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
> +	return be16_to_cpu(sf->hdr.totsize);
> +}

The opening curly brace should go on a line of its own.

> +/* space name/value uses */
> +static inline int xfs_attr_sf_entsize_byname(uint8_t nlen, uint8_t vlen) {
> +	return sizeof(struct xfs_attr_sf_entry) + nlen + vlen;
> +}
> +
> +/* space an entry uses */
> +static inline int xfs_attr_sf_entsize(struct xfs_attr_sf_entry *sfep) {
> +	return struct_size(sfep, nameval, sfep->namelen + sfep->valuelen);
> +}
> +
> +/* next entry in struct */
> +static inline struct xfs_attr_sf_entry *
> +xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep) {
> +	return (struct xfs_attr_sf_entry *)((char *)(sfep) +
> +					    xfs_attr_sf_entsize(sfep));
> +}

Same for these.  Also if you cast to void * instead of char * in
xfs_attr_sf_nextentry (and gcc extension we make heavy use of), you
don't need the case back.
