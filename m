Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FE0C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 11:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 467CE20772
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 11:41:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BSrTyxWl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbgCYLlz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 07:41:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56312 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbgCYLlz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 07:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zvmkiI7fVjvk1S1c8Ujs4x4bw5mvh4WqXhERXoWOhjs=; b=BSrTyxWl+fsCWg286aP4j7n3YU
        qOW8xnqFJ+yIRPfZzzyzyIUEn/+q+NN2RJ5s2yJGndXGUkZRZ9ph7LuwRlXN3O8GrZzE0Iw1jMGrt
        PImH4zvZ/JCc8FRdwKBMTSqe617PXvYfOYshifA8ZVAt/SzCv68oh4peHS5N9caCBVlWKeDvM5RWN
        MFj87Uun0td5Z1BAB+pgbFUz+sbekaheONO1UkbJFs+feTRDwjAalqr4ZQnztf4eyeZiJpLO/2Rsf
        v9JZCOXr7b4kwNtnNTho2G8jRluC1Tl9eevVh4uZd5owyQKGl8gWgMiNp+vw1BsEmspsggQOBQrRr
        3bbITd8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jH4Pz-00022S-FZ; Wed, 25 Mar 2020 11:41:55 +0000
Date:   Wed, 25 Mar 2020 04:41:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: shutdown on failure to add page to log bio
Message-ID: <20200325114155.GA32563@infradead.org>
References: <20200324165700.7575-1-bfoster@redhat.com>
 <20200325071225.GA17629@infradead.org>
 <20200325112502.GB10922@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325112502.GB10922@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 07:25:02AM -0400, Brian Foster wrote:
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 2a90a483c2d6..92a58a6bc32b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1703,7 +1703,7 @@ xlog_bio_end_io(
>  		   &iclog->ic_end_io_work);
>  }
>  
> -static void
> +static int
>  xlog_map_iclog_data(
>  	struct bio		*bio,
>  	void			*data,
> @@ -1714,11 +1714,14 @@ xlog_map_iclog_data(
>  		unsigned int	off = offset_in_page(data);
>  		size_t		len = min_t(size_t, count, PAGE_SIZE - off);
>  
> -		WARN_ON_ONCE(bio_add_page(bio, page, len, off) != len);
> +		if (bio_add_page(bio, page, len, off) != len)
> +			break;

I'd just return -EIO here.

>  
>  		data += len;
>  		count -= len;
>  	} while (count);
> +
> +	return count;

And 0 here.  Returning the remaining count obviously works as well,
but it feels a little unintuitive to me and would warrant a comment.
