Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE4CC54FCF
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 07:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 354832145D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 07:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A7Z8e2q2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgCYHMZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 03:12:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57974 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgCYHMZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 03:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DPkkQxfPy5bz+q6n5QCZjio37n8yklEPV2I/ekt0IJY=; b=A7Z8e2q26gxMjrffuq3toTybZj
        djcIQeHJilH+eyZZAvAaZJ2ApHuuxQIL1M2Jf8T8TbZA47CXipmxNsgXWB2Y6ZbjZCi+fL2rH9+hu
        xriepdAmr5TWg2zRmbm4FBo6w8Oy3H3AVnF8tfGCu3afUd0BkZSVw+LUJ3k2gnqQME31WlxLzAmKB
        cMcrLr3muAwtTngxPHLKTy4kU4eIsQ1Zs4PkzDhSDBB6EwJ7nrqBpLvjacN/XF85Du22bvpopC/Le
        2uZQgkpqAt7n4AfP+2EBRfGPOPYTr2OrJSsbYB/7tdPY4e7Qjxw64GB5OhRpAxyl2s24sy2+DuIOH
        K5hRWVag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jH0DB-0006Ho-7P; Wed, 25 Mar 2020 07:12:25 +0000
Date:   Wed, 25 Mar 2020 00:12:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: shutdown on failure to add page to log bio
Message-ID: <20200325071225.GA17629@infradead.org>
References: <20200324165700.7575-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324165700.7575-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 12:57:00PM -0400, Brian Foster wrote:
> Rather than warn about writing out a corrupted log buffer, shutdown
> the fs as is done for any log I/O related error. This preserves the
> consistency of the physical log such that log recovery succeeds on a
> subsequent mount. Note that this was observed on a 64k page debug
> kernel without upstream commit 59bb47985c1d ("mm, sl[aou]b:
> guarantee natural alignment for kmalloc(power-of-two)"), which
> demonstrated frequent iclog bio overflows due to unaligned (slab
> allocated) iclog data buffers.

Weird..

>  static void
>  xlog_map_iclog_data(
> -	struct bio		*bio,
> -	void			*data,
> +	struct xlog_in_core	*iclog,
>  	size_t			count)
>  {
> +	struct xfs_mount	*mp = iclog->ic_log->l_mp;
> +	struct bio		*bio = &iclog->ic_bio;
> +	void			*data = iclog->ic_data;
> +
>  	do {
>  		struct page	*page = kmem_to_page(data);
>  		unsigned int	off = offset_in_page(data);
>  		size_t		len = min_t(size_t, count, PAGE_SIZE - off);
>  
> -		WARN_ON_ONCE(bio_add_page(bio, page, len, off) != len);
> +		if (bio_add_page(bio, page, len, off) != len) {
> +			xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> +			break;
> +		}
>  
>  		data += len;
>  		count -= len;
> @@ -1762,7 +1768,7 @@ xlog_write_iclog(
>  	if (need_flush)
>  		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
>  
> -	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count);
> +	xlog_map_iclog_data(iclog, count);

Can you just return an error from xlog_map_iclog_data and shut down
in the caller?  Besides keeping the abstraction levels similar I had
also hoped to lift xlog_map_iclog_data into the block layer eventually.
