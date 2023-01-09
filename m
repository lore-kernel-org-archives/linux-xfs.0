Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6EFEC61DB3
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Jan 2023 17:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbjAIRG0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Jan 2023 12:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237391AbjAIQ7n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2023 11:59:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CB5E0DC
        for <linux-xfs@vger.kernel.org>; Mon,  9 Jan 2023 08:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673283536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y7DKy4vOeCO8Sem/CefZNHXeGVX6UXQGeGnokxcES9k=;
        b=LXBpbRjkyKwxpXMd2t9G1kcg0OsTxILHsnwcY63R7dtgkXJq9BRBQalwqFIh47+HOnmMO9
        yAH9I2glKeUXEm321SWGnu5ESdJB4EOY/OhhdGmWyZOz+rT1Gb6qPlTuVJx3DvvL/mVLHU
        LWZl7Uc87KeMmkFtPKOJv56Hqy6RbLY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-263-VSlrDaAVObyQSBUBXdzN5w-1; Mon, 09 Jan 2023 11:58:55 -0500
X-MC-Unique: VSlrDaAVObyQSBUBXdzN5w-1
Received: by mail-ed1-f69.google.com with SMTP id e6-20020a056402190600b0048ee2e45daaso5636659edz.4
        for <linux-xfs@vger.kernel.org>; Mon, 09 Jan 2023 08:58:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y7DKy4vOeCO8Sem/CefZNHXeGVX6UXQGeGnokxcES9k=;
        b=FetyDU4aZGMvxey7X2AUy8oniXRKUiTa845lnACFYZ+iAad6P13BQbEWtRJa4w+064
         qtMmW5OVEf35+8yy2LFMdAmn2xryk5RkjAaR/1lV3bTz5iVLChNlD+je4LkmnFOnuPPk
         oE+aYONZyt9wFYHkIbNnPfkZya/9Gya69NYTIZdcxq7D3daoBB+cEd9PvGWHzqCtUJjK
         Nt7NQcgWYcksN3T1uOPwMgN82tlxguUt2KtP29iIDoVIBAZ6crlVJwjjxIHm6/VFRj0U
         T420APR1SqO73svgspOLuxLc+PQEmzOKtZKeiNUKOM3dV/p+KfPQfYi1SIU2vD+uvSPE
         WezA==
X-Gm-Message-State: AFqh2kp7RDayob9SUo6clU5ZSBC00ISgQtTbEtV4Y4zD3SKTLq/h4/g5
        9RC3Xo3r6a7CynL79Uq/NwYKiwfnck75q3T2AG5TMzVHnsfa9jVnAIZgULMY9nPnDZjmqoATLm8
        f4u5eIJLlTiTgVuU/Z7I=
X-Received: by 2002:a17:907:a4c3:b0:84d:150d:5006 with SMTP id vq3-20020a170907a4c300b0084d150d5006mr13353603ejc.49.1673283534307;
        Mon, 09 Jan 2023 08:58:54 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuOeAlXgZiVxDJIkM4CJlSFeuYh+a6mL+BWtu2R4kRZIgQk863QLnt66+pciqQgu8HF5AhFtw==
X-Received: by 2002:a17:907:a4c3:b0:84d:150d:5006 with SMTP id vq3-20020a170907a4c300b0084d150d5006mr13353595ejc.49.1673283534157;
        Mon, 09 Jan 2023 08:58:54 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id c2-20020a17090618a200b0077a8fa8ba55sm3928923ejf.210.2023.01.09.08.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 08:58:53 -0800 (PST)
Date:   Mon, 9 Jan 2023 17:58:52 +0100
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 09/11] iomap: fs-verity verification on page read
Message-ID: <20230109165852.cndsmzlkqevdgc46@aalbersh.remote.csb>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-10-aalbersh@redhat.com>
 <Y5jMYxgFARhStFrb@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5jMYxgFARhStFrb@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 11:02:59AM -0800, Eric Biggers wrote:
> On Tue, Dec 13, 2022 at 06:29:33PM +0100, Andrey Albershteyn wrote:
> > Add fs-verity page verification in read IO path. The verification
> > itself is offloaded into workqueue (provided by fs-verity).
> > 
> > The work_struct items are allocated from bioset side by side with
> > bio being processed.
> > 
> > As inodes with fs-verity doesn't use large folios we check only
> > first page of the folio for errors (set by fs-verity if verification
> > failed).
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  fs/iomap/buffered-io.c | 80 +++++++++++++++++++++++++++++++++++++++---
> >  include/linux/iomap.h  |  5 +++
> >  2 files changed, 81 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 91ee0b308e13d..b7abc2f806cfc 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/bio.h>
> >  #include <linux/sched/signal.h>
> >  #include <linux/migrate.h>
> > +#include <linux/fsverity.h>
> >  #include "trace.h"
> >  
> >  #include "../internal.h"
> > @@ -42,6 +43,7 @@ static inline struct iomap_page *to_iomap_page(struct folio *folio)
> >  }
> >  
> >  static struct bio_set iomap_ioend_bioset;
> > +static struct bio_set iomap_readend_bioset;
> >  
> >  static struct iomap_page *
> >  iomap_page_create(struct inode *inode, struct folio *folio, unsigned int flags)
> > @@ -189,9 +191,39 @@ static void iomap_read_end_io(struct bio *bio)
> >  	int error = blk_status_to_errno(bio->bi_status);
> >  	struct folio_iter fi;
> >  
> > -	bio_for_each_folio_all(fi, bio)
> > +	bio_for_each_folio_all(fi, bio) {
> > +		/*
> > +		 * As fs-verity doesn't work with multi-page folios, verity
> > +		 * inodes have large folios disabled (only single page folios
> > +		 * are used)
> > +		 */
> > +		if (!error)
> > +			error = PageError(folio_page(fi.folio, 0));
> > +
> >  		iomap_finish_folio_read(fi.folio, fi.offset, fi.length, error);
> > +	}
> 
> fs/verity/ no longer uses PG_error to report errors.  See upstream commit
> 98dc08bae678 ("fsverity: stop using PG_error to track error status").

Thanks! Missed that.

> 
> - Eric
> 

-- 
- Andrey

