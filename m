Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62F1C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B097F2083E
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="NuUGQOHx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgHaQCG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbgHaQCE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:02:04 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1706CC061575
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 09:02:04 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id v54so3637699qtj.7
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 09:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=szyBZmXmGTfhNbvEwHNrOEoyR6ZVqLq4aSXH4RxuP/w=;
        b=NuUGQOHxyfqfMJUN82zrksWb8lPBil57bkrhwOwi9HrnrM305tAW7ZTvinRCmW8ntx
         GDwP698CZW7qroPU3cIlSkjc0xqDq/mYioEzHXYWx1q68VaVBgpKJ4T+1CnZXhGa9Kqe
         jSq2fj5vtbnRlsp1bKweEpUH3we26uOqQm4JhXtxt3HVM9bhoUcLdfKYlQPrYJWQe2DO
         3puXqUK9qh1zQNZDKGIvz9Q6FBu2ypq5LCNxHhn/NZQjW5Bq8i30dP1uKSQtEqub3gcr
         7qw/ly98IFJafxtRe3kU1V4dS2ww1hCzbFJtsNqOrHO8AarB1BA7BYm3VYBuZU9COGH6
         ZuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=szyBZmXmGTfhNbvEwHNrOEoyR6ZVqLq4aSXH4RxuP/w=;
        b=okBy2HxGT2l6ZTzoxoWAab0amMZAZ+5xC/gVtXS3JBAZhnbR71ZnuSSeIXSIp4BLt9
         MkRPtcPK/J2b4lLB9qafLxBFYzDSLGT+MQx9yzf089dXtZ8yN7f02tzmOkGSWzu8pJjC
         9y5d4/22T9dA2QRnKUALSyMEdf+L8DxJO8xdOFpuyhNa3RVsHuVGcp2kh5CIov9ivtpv
         GJCQwmRrbfeuWzdfWBgOlPLT6j8NthfBOWMjPbXAtZFC2c9y/A0p2h1GqsZZkdCkEi86
         3fo6nBUlGKUH0JKYv6upOs+LadX7PF2TPCo3O7zxKJf8Vl4Aud+I1oSDRXW8YDq9wT49
         Mscg==
X-Gm-Message-State: AOAM5338BM9Q0CvHinamLw8ECX+2AOf9/CRxlqVx25aFPwZkpj0X7QK6
        7Ct7cBVizt6L+M+PHgOERw72Ng==
X-Google-Smtp-Source: ABdhPJwgW/w1RFlFAb2nTVP6gOrwqGGnH7eA7HzonF2C/qJlWUVmcq0S9YcX8jXnTG3mrmSkcfE+Zw==
X-Received: by 2002:ac8:142:: with SMTP id f2mr1918414qtg.191.1598889723060;
        Mon, 31 Aug 2020 09:02:03 -0700 (PDT)
Received: from lca.pw (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id g64sm7050652qkf.71.2020.08.31.09.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 09:02:01 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:01:55 -0400
From:   Qian Cai <cai@lca.pw>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     darrick.wong@oracle.com, hch@infradead.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iomap: Fix WARN_ON_ONCE() from unprivileged users
Message-ID: <20200831160154.GA4080@lca.pw>
References: <20200831014511.17174-1-cai@lca.pw>
 <d34753a2-57bf-8013-015a-adeb3fe9447c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d34753a2-57bf-8013-015a-adeb3fe9447c@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 10:48:59AM -0500, Eric Sandeen wrote:
> On 8/30/20 8:45 PM, Qian Cai wrote:
> > It is trivial to trigger a WARN_ON_ONCE(1) in iomap_dio_actor() by
> > unprivileged users which would taint the kernel, or worse - panic if
> > panic_on_warn or panic_on_taint is set. Hence, just convert it to
> > pr_warn_ratelimited() to let users know their workloads are racing.
> > Thanks Dave Chinner for the initial analysis of the racing reproducers.
> > 
> > Signed-off-by: Qian Cai <cai@lca.pw>
> > ---
> > 
> > v2: Record the path, pid and command as well.
> > 
> >  fs/iomap/direct-io.c | 17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> > index c1aafb2ab990..66a4502ef675 100644
> > --- a/fs/iomap/direct-io.c
> > +++ b/fs/iomap/direct-io.c
> > @@ -374,6 +374,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
> >  		void *data, struct iomap *iomap, struct iomap *srcmap)
> >  {
> >  	struct iomap_dio *dio = data;
> > +	char pathname[128], *path;
> >  
> >  	switch (iomap->type) {
> >  	case IOMAP_HOLE:
> > @@ -389,7 +390,21 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
> >  	case IOMAP_INLINE:
> >  		return iomap_dio_inline_actor(inode, pos, length, dio, iomap);
> >  	default:
> > -		WARN_ON_ONCE(1);
> 
> It seems like we should explicitly catch IOMAP_DELALLOC for this case, and leave the
> default: as a WARN_ON that is not user-triggerable? i.e.
> 
> case IOMAP_DELALLOC:
> 	<all the fancy warnings>
> 	return -EIO;
> default:
> 	WARN_ON_ONCE(1);
> 	return -EIO;
> 
> > +		/*
> > +		 * DIO is not serialised against mmap() access at all, and so
> > +		 * if the page_mkwrite occurs between the writeback and the
> > +		 * iomap_apply() call in the DIO path, then it will see the
> > +		 * DELALLOC block that the page-mkwrite allocated.
> > +		 */
> > +		path = file_path(dio->iocb->ki_filp, pathname,
> > +				 sizeof(pathname));
> > +		if (IS_ERR(path))
> > +			path = "(unknown)";
> > +
> > +		pr_warn_ratelimited("page_mkwrite() is racing with DIO read (iomap->type = %u).\n"
> > +				    "File: %s PID: %d Comm: %.20s\n",
> > +				    iomap->type, path, current->pid,
> > +				    current->comm);
> 
> This is very specific ...
> 
> Do we know that mmap/page_mkwrite is (and will always be) the only way to reach this
> point?

I don't know, so this could indeed be a bit misleading.

> 
> It seems to me that this message won't be very useful for the admin; "pg_mkwrite" may
> mean something to us, but doubtful for the general public.  And "type = 1" won't mean
> much to the reader, either.
> 
> Maybe something like:
> 
> "DIO encountered delayed allocation block, racing buffered+direct? File: %s Comm: %.20s\n"
> 
> It just seems that a user-facing warning should be something the admin has a chance of
> acting on without needing to file a bug for analysis by the developers.
> 
> (though TBH "delayed allocation" probably doesn't mean much to the admin, either)

I agree with your suggestions. I'll submit a new version.
