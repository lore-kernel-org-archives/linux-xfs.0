Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF45EC11F65
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 14:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEECB611CA
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 14:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhF3Osf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Jun 2021 10:48:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58722 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235177AbhF3Osb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 10:48:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625064361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y4vf1yqzrS3vFpHReQKYOpbBl+OSfAyb+Khv5JrEsWA=;
        b=AqCEOH7nbEb/FU0NLcp0bLXQHuBAhQSxZO1eEY1HiOies2QJf/zxX9ikBcgDmaQe9xVLqb
        +58rMwFry2rjflBfj9SKERNRNjNlzehu25iObBE2rIj0Sr+iaMZDVmXnd/13YX1wpsQ/CE
        5Z97+FAiJEYZYr/k34J6e6za/zi8N5U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-mOcbEWGPNMSZDjuwHn3sUQ-1; Wed, 30 Jun 2021 10:45:58 -0400
X-MC-Unique: mOcbEWGPNMSZDjuwHn3sUQ-1
Received: by mail-wr1-f70.google.com with SMTP id l12-20020a5d410c0000b029012b4f055c9bso837688wrp.4
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jun 2021 07:45:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y4vf1yqzrS3vFpHReQKYOpbBl+OSfAyb+Khv5JrEsWA=;
        b=ijBATL5mSyh3BJs3fsPDTOZRRTxYbIaLKSnWCa6+a1iB+xh21TiRZmyCxZMq8vN8Fj
         BZwyEfF2MmMLi+QTzFW+NTmUqMMlYUJLSbi5UKzgg1yUdoLUclgiD/82dSPwmO901FqE
         PBxY8LbwhHcdIQPodQIFdZ9TLK3ZM8cCRfyMdFheZtgVIJFIvQE6rw8BWUwkKzqU2v7a
         gBO81RxfsWCwrmPto/ZTf/f7H4ajCOa+Cw/ipzmywbkTkRItckSLiHTAT5HMYhEZNylq
         E8PKxqCaUXXwhKOGG82d+sXess16Cnt57vnJ9KKX6L2DYaoHD2xDtKhw2AE/7stpCnP+
         biog==
X-Gm-Message-State: AOAM5329WpsAXLaIMmsP2K7XX9OA31+zorxeGlXsPFQl/KeTGDa0LeJS
        A+5pLR4TymxlPJfQk23WbFOnfAiCwAKSOiahlu6gsIrtivfTquzSNCtUOhVhP3AazhQ6Ckbdb6B
        tIFZ4YkDN/wzCS2EI22T1ZNvs7PR2Ihs/wmmW
X-Received: by 2002:a5d:5745:: with SMTP id q5mr13230652wrw.329.1625064357357;
        Wed, 30 Jun 2021 07:45:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgU5oFUHVMXKdZBHHmE78pYqUjAWgIPUUXK096keRw4Ekq8bzPm3W555Qgaz0gc7LPesnRODsUtpLUc8qY2+Y=
X-Received: by 2002:a5d:5745:: with SMTP id q5mr13230628wrw.329.1625064357193;
 Wed, 30 Jun 2021 07:45:57 -0700 (PDT)
MIME-Version: 1.0
References: <YNoJPZ4NWiqok/by@casper.infradead.org> <20210628172727.1894503-1-agruenba@redhat.com>
 <20210629091239.1930040-1-agruenba@redhat.com> <YNx69luCAxlLMDAG@casper.infradead.org>
In-Reply-To: <YNx69luCAxlLMDAG@casper.infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 30 Jun 2021 16:45:45 +0200
Message-ID: <CAHc6FU4_eQMQinMfTHG42phuW6r7PTtyecDfMESp-KziaicL8w@mail.gmail.com>
Subject: Re: [PATCH 0/2] iomap: small block problems
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 30, 2021 at 4:09 PM Matthew Wilcox <willy@infradead.org> wrote:
> On Tue, Jun 29, 2021 at 11:12:39AM +0200, Andreas Gruenbacher wrote:
> > Below is a version of your patch on top of v5.13 which has passed some
> > local testing here.
> >
> > Thanks,
> > Andreas
> >
> > --
> >
> > iomap: Permit pages without an iop to enter writeback
> >
> > Permit pages without an iop to enter writeback and create an iop *then*.  This
> > allows filesystems to mark pages dirty without having to worry about how the
> > iop block tracking is implemented.
>
> How about ...
>
> Create an iop in the writeback path if one doesn't exist.  This allows
> us to avoid creating the iop in some cases.  The only current case we
> do that for is pages with inline data, but it can be extended to pages
> which are entirely within an extent.  It also allows for an iop to be
> removed from pages in the future (eg page split).
>
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
>
> Co-developed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Sure, that works for me.

Thanks,
Andreas

