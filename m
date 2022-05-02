Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77430C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 12:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbiEBMWA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 08:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiEBMV7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 08:21:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6421715FC7
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 05:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651493909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/MPF4SlHJTSwOs9uq+qeW8/MK0NYqARQeWoIqaF+luw=;
        b=TEQNmI59tZ+844qLGOZQSWoJg6GnynsXa4fIg/g7f96V+ewyCe1v6v3QlD60dc8paEaXMU
        qzZbOmqAicJNphPlPYLSuCAgQ46LAPT2huP65xFgXmPFkBtwxPZ6nHTAnfBQcHdX6TxLOC
        GlYRwXrgLSddBWVhEatYzvtuyGk/62c=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-iw_ZmHGpM2Gyt9EryMyG7w-1; Mon, 02 May 2022 08:18:28 -0400
X-MC-Unique: iw_ZmHGpM2Gyt9EryMyG7w-1
Received: by mail-qv1-f71.google.com with SMTP id s19-20020ad44b33000000b00456107e1120so10944179qvw.0
        for <linux-xfs@vger.kernel.org>; Mon, 02 May 2022 05:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/MPF4SlHJTSwOs9uq+qeW8/MK0NYqARQeWoIqaF+luw=;
        b=w0SQUIzSD+jGeOzpZseZCF7XeangR9gM79cCwn0fp6BL6bDUY3bShUEnNe0TR7AHQT
         E09HwibwbaUd5MBxqwDSAU93tstnt4f6NXY3u7rZIy834+9Py5VhPVIzmnWuJsKPVi9I
         C78Y5Y/CfgWiPI7IGj4eYUSvMNaQAeDS776k9at1F8jkBbefdfTzVa7XCislHlWaUtNR
         BuxKu1eRlLi4rXtvKExxSU17/PgT8pjTS9PBYd/YJJkrqrVKYlXsJggpUqtIcHZjpEB+
         n7N0b6ksucCsKsscW2KEXoT3SKhqgo+yb3xROUZ6Xv5N2rV2OFkYTsRacin2oKrtlTuf
         8hag==
X-Gm-Message-State: AOAM531lbRFJ/TUtwXV9yEY/APs5wm224LQcF+cDpLWi3ZaIsGaMZQFE
        JFWQaxL2gGApgdYan0XW20CaYZLGJ+5jQe6mH5i9hjQGLbvGcS6++vIIsJ3KqDGxe0AK0DJIPIh
        rDm/tro8RpMRQKTl5k8Ad
X-Received: by 2002:a05:622a:1211:b0:2f2:167:55dc with SMTP id y17-20020a05622a121100b002f2016755dcmr9756402qtx.105.1651493907288;
        Mon, 02 May 2022 05:18:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkMF9lcc6DS6FBWLWUIVap+Xc5D8aaV20ZYaG7Q/z0wEek99nyXbS8Zkj7RgwqXcS5qEOKUg==
X-Received: by 2002:a05:622a:1211:b0:2f2:167:55dc with SMTP id y17-20020a05622a121100b002f2016755dcmr9756380qtx.105.1651493907034;
        Mon, 02 May 2022 05:18:27 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id c5-20020ac86605000000b002f39b99f6a0sm4038090qtp.58.2022.05.02.05.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 05:18:26 -0700 (PDT)
Date:   Mon, 2 May 2022 08:18:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: generic/068 crash on 5.18-rc2?
Message-ID: <Ym/MEBfa0szil3hW@bfoster>
References: <20220413033425.GM16799@magnolia>
 <YlbjOPEQP66gc1WQ@casper.infradead.org>
 <20220418174747.GF17025@magnolia>
 <20220422215943.GC17025@magnolia>
 <Ymq4brjhBcBvcfIs@bfoster>
 <Ymywh003c+Hd4Zu9@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymywh003c+Hd4Zu9@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 30, 2022 at 04:44:07AM +0100, Matthew Wilcox wrote:
> On Thu, Apr 28, 2022 at 11:53:18AM -0400, Brian Foster wrote:
> > The above is the variant of generic/068 failure I was reproducing and
> > used to bisect [1]. With some additional tracing added to ioend
> > completion, what I'm seeing is that the bio_for_each_folio_all() bvec
> > iteration basically seems to go off the rails. What happens more
> > specifically is that at some point during the loop, bio_next_folio()
> > actually lands into the second page of the just processed folio instead
> > of the actual next folio (i.e. as if it's walking to the next page from
> > the head page of the folio instead of to the next 16k folio). I suspect
> > completion is racing with some form of truncation/reclaim/invalidation
> > here, what exactly I don't know, that perhaps breaks down the folio and
> > renders the iteration (bio_next_folio() -> folio_next()) unsafe. To test
> > that theory, I open coded and modified the loop to something like the
> > following:
> > 
> >                 for (bio_first_folio(&fi, bio, 0); fi.folio; ) {
> >                         f = fi.folio;
> >                         l = fi.length;
> >                         bio_next_folio(&fi, bio);
> >                         iomap_finish_folio_write(inode, f, l, error);
> >                         folio_count++;
> >                 }
> > 
> > ... to avoid accessing folio metadata after writeback is cleared on it
> > and this seems to make the problem disappear (so far, I'll need to let
> > this spin for a while longer to be completely confident in that).
> 
> _Oh_.
> 
> It's not even a terribly weird race, then.  It's just this:
> 
> CPU 0				CPU 1
> 				truncate_inode_partial_folio()
> 				folio_wait_writeback();
> bio_next_folio(&fi, bio)
> iomap_finish_folio_write(fi.folio)
> folio_end_writeback(folio)
> 				split_huge_page()
> bio_next_folio()
> ... oops, now we only walked forward one page instead of the entire folio.
> 

Yep, though once I noticed and turned on the mm_page_free tracepoint, it
looked like it was actually the I/O completion path breaking down the
compound folio:

   kworker/10:1-440     [010] .....   355.369899: iomap_finish_ioend: 1090: bio 00000000bc8445c7 index 192 fi (00000000dc8c03bd 0 16384 32768 27)
   ...
    kworker/10:1-440     [010] .....   355.369905: mm_page_free: page=00000000dc8c03bd pfn=0x182190 order=2
    kworker/10:1-440     [010] .....   355.369907: iomap_finish_ioend: 1090: bio 00000000bc8445c7 index 1 fi (00000000f8b5d9b3 0 4096 16384 27)

I take that to mean the truncate path executes while the completion side
holds a reference, folio_end_writeback() ends up dropping the last
reference, falls into the free/split path and the iteration breaks from
there. Same idea either way, I think.

Brian

> So ... I think we can fix this with:
> 
> +++ b/include/linux/bio.h
> @@ -290,7 +290,8 @@ static inline void bio_next_folio(struct folio_iter *fi, struct bio *bio)
>  {
>         fi->_seg_count -= fi->length;
>         if (fi->_seg_count) {
> -               fi->folio = folio_next(fi->folio);
> +               fi->folio = (struct folio *)folio_page(fi->folio,
> +                               (fi->offset + fi->length) / PAGE_SIZE);
>                 fi->offset = 0;
>                 fi->length = min(folio_size(fi->folio), fi->_seg_count);
>         } else if (fi->_i + 1 < bio->bi_vcnt) {
> 
> (I do not love this, have not even compiled it; it's late.  We may be
> better off just storing next_folio inside the folio_iter).
> 

