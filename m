Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B84C5DF65
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 19:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34F0D217F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 19:34:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MwbE77lF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfKFTel (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 14:34:41 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30327 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727547AbfKFTel (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 14:34:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573068880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qEO1LlS+wx20cugYICVdXzykrKwgfNh8MhubhOzG8Ws=;
        b=MwbE77lFngTG6Dsq8xUz5kzfSbOyaNWI3YESv3YJL4sbCdWKUr7KaYe9RJzW4b9nWkYECq
        PvSB6W4Jz8AZVsHBV7udsYf0py6B/Rm7YWVV+3HAuM1QEaPxviSNufmIIuO+7alMo2dFr4
        gNoKNTkSvKyL/tHwQgGqwxBzB4suK9k=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-CUQm_jziNJGeALLR2cNdJg-1; Wed, 06 Nov 2019 14:34:39 -0500
Received: by mail-ot1-f70.google.com with SMTP id s5so15269439otk.19
        for <linux-xfs@vger.kernel.org>; Wed, 06 Nov 2019 11:34:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2+4oqdhQ7XrescyUouTmBb2WkDtFgojtFKKsRM3EtqU=;
        b=RwmA7PFdnjPdTDV96li3NeyKGesB5Ctk5D0bsN8bsqfU/xpWYJMuKdFESeE1SCfyC6
         Qa0TnNZmeLaYrnpHBW9m4RRFaYw28mZMQ9Sb/UnjHMBmA3CBGvDnGrJ2y2fH83EwGMCf
         HHJDGd+CiM7/IZBD8G7ErTjFSw4o8Q+K+OrHLHLCqWMUnyQ1dEEgK8n+tW2YPOcOCg57
         FpEDU7IfIUsOFPjC5erXjW0aEeHRSm1fzXmCqsKEomBZG4DzgWzhF25X0l3THZaSaeAd
         glIk7UMu0PmMUvW53awO2ydBByA3AxZXmMRp0gZp0O6Bg+TKO3UAyEtXmiWEDCCELrz1
         kM4w==
X-Gm-Message-State: APjAAAUs1YSTQLXqpSWsiDMIdOX+NOAs4XRTFIj8boYZ2xEWbYbZFksI
        xT38HobgWMs2R0A4DfyzYGOYHWfjGVNfwYkWbqsyxwnqD0eI5x3EXyHq5zj1WzhtKOr55FhGM+F
        rpUmH3yCwt88inH1fSDImfKlWgRvIQZnxaRrd
X-Received: by 2002:a05:6808:1cf:: with SMTP id x15mr3807582oic.147.1573068878067;
        Wed, 06 Nov 2019 11:34:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqwPzYD92f6MsHAshLnXaaJ+RPJgHkX6+wC94uNc+LizG8qwMH31bwK+IWqpoAuDU814qf9pItQs92dqpJwrbxw=
X-Received: by 2002:a05:6808:1cf:: with SMTP id x15mr3807551oic.147.1573068877746;
 Wed, 06 Nov 2019 11:34:37 -0800 (PST)
MIME-Version: 1.0
References: <20191106190400.20969-1-agruenba@redhat.com> <20191106191656.GC15212@magnolia>
In-Reply-To: <20191106191656.GC15212@magnolia>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 6 Nov 2019 20:34:26 +0100
Message-ID: <CAHc6FU4BXZ7fiLa_tVhZWZmqoXNCJWQwUvb7UPzGrWt_ZBBvxQ@mail.gmail.com>
Subject: Re: [PATCH] iomap: Fix overflow in iomap_page_mkwrite
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
X-MC-Unique: CUQm_jziNJGeALLR2cNdJg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 6, 2019 at 8:17 PM Darrick J. Wong <darrick.wong@oracle.com> wr=
ote:
> On Wed, Nov 06, 2019 at 08:04:00PM +0100, Andreas Gruenbacher wrote:
> > On architectures where ssize_t is wider than pgoff_t, the expression
>
> ssize_t?  But you're changing @offset, which is loff_t.   I'm confused.

Oops, should have been loff_t instead of ssize_t.

> Also, which architectures are you talking about here?

From the kernel headers:

#define pgoff_t unsigned long
typedef long long __kernel_loff_t;
typedef __kernel_loff_t loff_t;

So for example, sizeof(loff_t) > sizeof(pgoff_t) on x86.

Thanks,
Andreas

