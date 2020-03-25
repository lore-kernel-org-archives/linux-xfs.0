Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A5CC1975A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 14:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 323E8208E0
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 14:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="YUccMzib"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgCYOnO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 10:43:14 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38645 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727721AbgCYOnO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 10:43:14 -0400
Received: by mail-io1-f67.google.com with SMTP id m15so2464602iob.5
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 07:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BYoi0GgKGrZ5Iy05aE5oc1zP5UUaQTjapju/izAR4hI=;
        b=YUccMzib2IwajwEuyLBHygiEi2x+yWevlxfsequqpaIt/Mza/TxUmFkitS3U4FkfKx
         P1XwXxBJ8Cx5HEmhYoBLdWFHhmr6xou5YR2utppkELKcqyaDd4EOavtJNBW3boLnPkzx
         WgZmdQ9YRsyheNZWEZrba/miSYKYdDAaziYyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BYoi0GgKGrZ5Iy05aE5oc1zP5UUaQTjapju/izAR4hI=;
        b=YYWU442jFcBJq3EECRZSJX4J13Uh3zgNb+PUlwq4OSenJrjGsV6aY0fYAjD5sCYb09
         8GMvn1mlK8tCRfGzJN3dFxxaBopaRwQBOT2zVgKijbK9i3UgfmFqXX6FDj2Tl9yCc30t
         1sgQ+TE7UjTI8GEjVkxLPImYsMydaYR8LO2J2oUA5LeFxnX2SCAi33tTeQ6yQPBeal9k
         OBLgO2QWk67ysyjxrpY1ROrAQ44wZ97/hIo9MJqzwHV1RJr5W/cf6XrBsiYsxqrsP+KR
         TsWE4zvcr1NnAm07p95HepZH83g0dA2H9mdp728YuTvsd3gmiA1Jt2cowOy+w7CU4peO
         eV2A==
X-Gm-Message-State: ANhLgQ3c2/RxMsk3AiUa6ngUzr9Th1EQxrqQ/e8qxj93i3kjfLOcb346
        s3VYzLC6dCEDFSEtUwdbiQwxU+12vs6z+K6Mw9a0nQ==
X-Google-Smtp-Source: ADFU+vsgMMqodCZqPGFNfCT+HdNRTtLLlUdy5AMnDcVBoatxWj+vZY48emoAVNd+HvHliFjTkg/kdF6pmkOGcZxuC6s=
X-Received: by 2002:a6b:3a07:: with SMTP id h7mr3235359ioa.191.1585147393572;
 Wed, 25 Mar 2020 07:43:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200323202259.13363-1-willy@infradead.org> <20200323202259.13363-25-willy@infradead.org>
 <CAJfpegu7EFcWrg3bP+-2BX_kb52RrzBCo_U3QKYzUkZfe4EjDA@mail.gmail.com> <20200325120254.GA22483@bombadil.infradead.org>
In-Reply-To: <20200325120254.GA22483@bombadil.infradead.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 25 Mar 2020 15:43:02 +0100
Message-ID: <CAJfpegshssCJiA8PBcq2XvBj3mR8dufHb0zWRFvvKKv82VQYsw@mail.gmail.com>
Subject: Re: [PATCH v10 24/25] fuse: Convert from readpages to readahead
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        William Kucharski <william.kucharski@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 1:02 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Mar 25, 2020 at 10:42:56AM +0100, Miklos Szeredi wrote:
> > > +       while ((page = readahead_page(rac))) {
> > > +               if (fuse_readpages_fill(&data, page) != 0)
> >
> > Shouldn't this unlock + put page on error?
>
> We're certainly inconsistent between the two error exits from
> fuse_readpages_fill().  But I think we can simplify the whole thing
> ... how does this look to you?

Nice, overall.

>
> -       while ((page = readahead_page(rac))) {
> -               if (fuse_readpages_fill(&data, page) != 0)
> +               nr_pages = min(readahead_count(rac), fc->max_pages);

Missing fc->max_read clamp.

> +               ia = fuse_io_alloc(NULL, nr_pages);
> +               if (!ia)
>                         return;
> +               ap = &ia->ap;
> +               __readahead_batch(rac, ap->pages, nr_pages);

nr_pages = __readahead_batch(...)?

This will give consecutive pages, right?

Thanks,
Miklos
