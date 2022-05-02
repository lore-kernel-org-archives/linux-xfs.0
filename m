Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EDBC4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 12:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbiEBMXh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 08:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385028AbiEBMXf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 08:23:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0E7E18B25
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 05:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651494005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3TGDNNtvvmPBYk9bbgLa7c3X0Q+E4dpJoXPbL4ofXFs=;
        b=dQocX5znCwnxjQMsRli1M/hadQfdh40ZlALCcMnn95mbLkTs5NI6AnE6a/sobGpWDPhzws
        ClvHEqiiEnYm1cVpoG2pCDP1sir89UIyYzTdOnJhRdRYA6gMvwaaFTuYgTRW8sY6LenvxH
        bKujc2j4Pd05zYHkPBnwLNbk73qEjK0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-KKWEZApHP0OeUtydnX_mzg-1; Mon, 02 May 2022 08:20:04 -0400
X-MC-Unique: KKWEZApHP0OeUtydnX_mzg-1
Received: by mail-qk1-f198.google.com with SMTP id o13-20020a05620a0d4d00b0069f47054e58so9983199qkl.13
        for <linux-xfs@vger.kernel.org>; Mon, 02 May 2022 05:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3TGDNNtvvmPBYk9bbgLa7c3X0Q+E4dpJoXPbL4ofXFs=;
        b=xb4u9Iwty37Oz2FZbB3s5WVhbKcLsbDnckgYHX2+U0EZ1lEX+GkvNXlzdmZNOt3afP
         aDrUfiGwx4Swiq2MYzaQ+cQtjzj008hYwWU649UR2mrjFGftjqfPptC3aZJcTqzqVJo9
         c+6rwzE4h/LbNK+Yu4D4CFTOsfZKvnrAplZB55tNycYlo+rjUxkXqgtvCI71B53kRhUV
         tb5sv7aWpRenoGC5LWNTR2ayoS4nQwHRWbR3SUdWgsV55vx7HnvT4OqfRTt4hIYaUjQI
         jT/z+fug7jyagq05g1so5TrC2Pwgpruke1UYceDhwxG2fovcnI4VD0jDYSgiKATyXLbS
         T2yg==
X-Gm-Message-State: AOAM532Ddhz5NFGJz2TcbQQ+Gc1o65HGUiF/3W3VXD9VHn5wn2Oz68SG
        c6ue6CCdzoBojn67/GhxeRI3jLTUj63HxSmEim0RyTVM0mGgDPH3BOYX+V0JJ3oI6nHvarJ0Mwl
        fhUtEbWYhvwv6VJhy8NdO
X-Received: by 2002:a05:6214:2266:b0:456:2c5a:b45f with SMTP id gs6-20020a056214226600b004562c5ab45fmr9286735qvb.24.1651494004302;
        Mon, 02 May 2022 05:20:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFqNqjh3v1glNJulhtCzg12Stp86C68pY3HLcevbS9IUwIJqpC96g9aEBp/rP9LriOe387XA==
X-Received: by 2002:a05:6214:2266:b0:456:2c5a:b45f with SMTP id gs6-20020a056214226600b004562c5ab45fmr9286644qvb.24.1651494002828;
        Mon, 02 May 2022 05:20:02 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id m6-20020a37bc06000000b0069fc13ce207sm4219773qkf.56.2022.05.02.05.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 05:20:02 -0700 (PDT)
Date:   Mon, 2 May 2022 08:20:00 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: generic/068 crash on 5.18-rc2?
Message-ID: <Ym/McFNCTzmsLBak@bfoster>
References: <20220413033425.GM16799@magnolia>
 <YlbjOPEQP66gc1WQ@casper.infradead.org>
 <20220418174747.GF17025@magnolia>
 <20220422215943.GC17025@magnolia>
 <Ymq4brjhBcBvcfIs@bfoster>
 <Ymywh003c+Hd4Zu9@casper.infradead.org>
 <Ym2szx2S3ontYsBf@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ym2szx2S3ontYsBf@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 30, 2022 at 10:40:31PM +0100, Matthew Wilcox wrote:
> On Sat, Apr 30, 2022 at 04:44:07AM +0100, Matthew Wilcox wrote:
> > (I do not love this, have not even compiled it; it's late.  We may be
> > better off just storing next_folio inside the folio_iter).
> 
> Does anyone have a preference for fixing this between Option A:
> 

After seeing the trace in my previous mail and several thousand
successful iterations of the test hack, I had reworked it into this
(which survived weekend testing until it ran into some other XFS problem
that looks unrelated):

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 278cc81cc1e7..aa820e09978e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -269,6 +269,7 @@ struct folio_iter {
 	size_t offset;
 	size_t length;
 	/* private: for use by the iterator */
+	struct folio *_next;
 	size_t _seg_count;
 	int _i;
 };
@@ -279,6 +280,7 @@ static inline void bio_first_folio(struct folio_iter *fi, struct bio *bio,
 	struct bio_vec *bvec = bio_first_bvec_all(bio) + i;
 
 	fi->folio = page_folio(bvec->bv_page);
+	fi->_next = folio_next(fi->folio);
 	fi->offset = bvec->bv_offset +
 			PAGE_SIZE * (bvec->bv_page - &fi->folio->page);
 	fi->_seg_count = bvec->bv_len;
@@ -290,13 +292,15 @@ static inline void bio_next_folio(struct folio_iter *fi, struct bio *bio)
 {
 	fi->_seg_count -= fi->length;
 	if (fi->_seg_count) {
-		fi->folio = folio_next(fi->folio);
+		fi->folio = fi->_next;
+		fi->_next = folio_next(fi->folio);
 		fi->offset = 0;
 		fi->length = min(folio_size(fi->folio), fi->_seg_count);
 	} else if (fi->_i + 1 < bio->bi_vcnt) {
 		bio_first_folio(fi, bio, fi->_i + 1);
 	} else {
 		fi->folio = NULL;
+		fi->_next = NULL;
 	}
 }

So FWIW, that is just to say that I find option A to be cleaner and more
readable.

Brian

> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 49eff01fb829..55e2499beff6 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -269,6 +269,7 @@ struct folio_iter {
>         size_t offset;
>         size_t length;
>         /* private: for use by the iterator */
> +       struct folio *_next;
>         size_t _seg_count;
>         int _i;
>  };
> @@ -280,19 +281,23 @@ static inline void bio_first_folio(struct folio_iter *fi,
> struct bio *bio,
> 
>         fi->folio = page_folio(bvec->bv_page);
>         fi->offset = bvec->bv_offset +
> -                       PAGE_SIZE * (bvec->bv_page - &fi->folio->page);
> +                       PAGE_SIZE * folio_page_idx(fi->folio, bvec->bv_page);
>         fi->_seg_count = bvec->bv_len;
>         fi->length = min(folio_size(fi->folio) - fi->offset, fi->_seg_count);
>         fi->_i = i;
> +       if (fi->_seg_count > fi->length)
> +               fi->_next = folio_next(fi->folio);
>  }
> 
>  static inline void bio_next_folio(struct folio_iter *fi, struct bio *bio)
>  {
>         fi->_seg_count -= fi->length;
>         if (fi->_seg_count) {
> -               fi->folio = folio_next(fi->folio);
> +               fi->folio = fi->_next;
>                 fi->offset = 0;
>                 fi->length = min(folio_size(fi->folio), fi->_seg_count);
> +               if (fi->_seg_count > fi->length)
> +                       fi->_next = folio_next(fi->folio);
>         } else if (fi->_i + 1 < bio->bi_vcnt) {
>                 bio_first_folio(fi, bio, fi->_i + 1);
>         } else {
> 
> 
> and Option B:
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 49eff01fb829..554f5fce060c 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -290,7 +290,8 @@ static inline void bio_next_folio(struct folio_iter *fi, struct bio *bio)
>  {
>         fi->_seg_count -= fi->length;
>         if (fi->_seg_count) {
> -               fi->folio = folio_next(fi->folio);
> +               fi->folio = __folio_next(fi->folio,
> +                               (fi->offset + fi->length) / PAGE_SIZE);
>                 fi->offset = 0;
>                 fi->length = min(folio_size(fi->folio), fi->_seg_count);
>         } else if (fi->_i + 1 < bio->bi_vcnt) {
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index de32c0383387..9c5547af8d0e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1642,6 +1642,12 @@ static inline long folio_nr_pages(struct folio *folio)
>         return compound_nr(&folio->page);
>  }
> 
> +static inline struct folio *__folio_next(struct folio *folio,
> +               unsigned long nr_pages)
> +{
> +       return (struct folio *)folio_page(folio, nr_pages);
> +}
> +
>  /**
>   * folio_next - Move to the next physical folio.
>   * @folio: The folio we're currently operating on.
> @@ -1658,7 +1664,7 @@ static inline long folio_nr_pages(struct folio *folio)
>   */
>  static inline struct folio *folio_next(struct folio *folio)
>  {
> -       return (struct folio *)folio_page(folio, folio_nr_pages(folio));
> +       return __folio_next(folio, folio_nr_pages(folio));
>  }
> 
>  /**
> 
> 
> Currently running Option A through its paces.
> 

