Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A0F2C4320A
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 18:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 110AF613D0
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 18:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhHWSs0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 14:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbhHWSsY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Aug 2021 14:48:24 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6DDC061575
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 11:47:41 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id e7so17471580pgk.2
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 11:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r54pHmxmjGri522v1PTJT3wgqKLwaTSuYN7KqNeOshc=;
        b=ON0Ulal5HgyBW6cTYVJVpFVeEknnHV2b+ct6UfJ6exaBr/kDhaiOpzwwr8mE1X+ftG
         yPgh8gE6jDzcJ1g7pOYTIqOpKhhBy6qoKCVzKNWbCsH7nerKcTiz/0qRdPflFtj7rpOn
         TOutZH8U7o3//PAf3veh4KzsMBh+k7AtIBWx7p+96JYNtLQ4WL5AvSqPt+4VLJq0Mwhu
         IK8GuHp767hRzY4t5tJUgyDxieGLHIocbNliT5hx4QE5MzhfhbvhOkfbhc2w1sYCCdpk
         IZH5DRWYU6KH7vcc4s642VXtiosILos3qzTun3RQGz0Wijao65Kdp4C/SA0InLbTkXnt
         9baQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r54pHmxmjGri522v1PTJT3wgqKLwaTSuYN7KqNeOshc=;
        b=gNk+xZwfg0xY1kX232ytH47+v+XYO1QJwmK4blVOv6K5v0/GANfKAr686GI+xe1cWP
         wCAljnmvGSf2codyrLH2jx6FYMaqU/W+tEUkVyH9oAVvYSFww/SIzvhh7CnqnUqykr4F
         j4nYK+gCH0L2nmUePWfZVqOJHCDA46eUdXzZsIc72KAs424lTwi8JGaLg15BU+npThS1
         MMyXTRsDADC/fSpa5uUqfMCBb8KwWEMhL4agycLpojNYpKbAoZDwCOK10jJ7KRCQquGf
         VS9HHgGYWUmBgMgF7Dx6Qg5omCqDGuDiVv8XEOwY9cSQu1N3X7LfyZ7pCExMDVg3A+bX
         FagQ==
X-Gm-Message-State: AOAM531XOw3rI15JXW/CaRUotuLAuwiZiAe/KCZ6f1fj4pTQTlCC1TmM
        JwLIM9n/awp8pswZfSvC7RtEV+IkMTPDjcGq9wzgcw==
X-Google-Smtp-Source: ABdhPJzDVavO1D0cuxFMJfc7vAR6mGcyWNFXeb0k5SW+uv+Pt4QHySWz8XFkNATSzrUwGSt4zomLq2aChoPEcZrN8qg=
X-Received: by 2002:a63:dd0e:: with SMTP id t14mr32045829pgg.279.1629744460943;
 Mon, 23 Aug 2021 11:47:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-3-hch@lst.de>
In-Reply-To: <20210823123516.969486-3-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 23 Aug 2021 11:47:30 -0700
Message-ID: <CAPcyv4jGqOh3bq=5bgkAaOjp5SUOVGKQyXYsPsurtGtDiY2a9A@mail.gmail.com>
Subject: Re: [PATCH 2/9] dax: stop using bdevname
To:     Christoph Hellwig <hch@lst.de>
Cc:     Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 23, 2021 at 5:37 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Just use the %pg format specifier instead.
>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
