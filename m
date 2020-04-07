Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 523C5C2BB55
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 10:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F9A120731
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 10:09:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="ei665XDJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgDGKJf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 06:09:35 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:38475 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728196AbgDGKJf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 06:09:35 -0400
Received: by mail-io1-f52.google.com with SMTP id e79so2762950iof.5
        for <linux-xfs@vger.kernel.org>; Tue, 07 Apr 2020 03:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=etruzh97g0ePi5MmdfaX16wSZNVsPuUhCD3aCJkNyvU=;
        b=ei665XDJSqRPqhUale0X+Rdo779B/wRmekCejkih2NFpIgu5Wmje8Zdbs25btA8GH4
         BTsA6J2TZqH2J8UKZFeRXtR6mO4oW43tpck5GF1+aqTLQKg7iqzOQv3UksTcnph5gRz6
         tXk6Ojx8Lpxhx2DFh9PvnVUAWoPDO4kbayF88LGrAgtnBJZw7kK5WuY+NoPJ5Y1MIjTQ
         sKpLDESbpLj2IBl8+sM++ErRWHfq46F4YA8KziuKDes5D0XzE0+kzKsgdFOzPvPWJtxA
         HCYyq/ZKqKBXtGRke94W6RUDK/kN4mP+3ETdDo44t9blugH9itPF3bBPZ8gKwaXrSbLh
         Zjag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=etruzh97g0ePi5MmdfaX16wSZNVsPuUhCD3aCJkNyvU=;
        b=qa19Xijtfc+lgKX+7QuGbcOrZpgPaTQnHMdPf3EimoFt1z5hEbcecLQuNwC1thMYpr
         0HRaIiPaG3z5eUWnJxV5wq+m+041GbT0UDp2bWLqPxmd9XL8R8mGCJaIj8Vi92KezXr6
         s3DBtb3K4bg5S2D7cW+pCOKzFbZWHB19BFptMj6Dl96MOth9EiwkU//gTGZbjPnXjBqE
         TYCwI98Uw1dx5mwDBiJeSRgAnQyd5EFyB3t/Y5tud0TQ9u7hMnJvbaGg3VAjjdV5g9rK
         5240wxIzNbYF4+WjNsddav7xvTq/8T3+DiCxNZjxVcvMvc5mb8z9ZUHDfkeiYI5UJMoC
         AuvA==
X-Gm-Message-State: AGi0Pubhsym93gsjPVAZPQUToDPxzXCXMpzFyhZ5dezBUDZxQMnVJGQt
        4K1hPOsNq9BC4msr5YeelSn4NQ1Tm7KfzoVw4JyJ
X-Google-Smtp-Source: APiQypIEn5fh7xJK0NbGcbZJR9Ul083PzmnN8yrz4AopBK405wrAjxXASIKwAWouEPsisisaGVm0sMwJDYBlQLeI5Sc=
X-Received: by 2002:a02:55c5:: with SMTP id e188mr1156940jab.57.1586254174040;
 Tue, 07 Apr 2020 03:09:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200406232440.4027-1-chaitanya.kulkarni@wdc.com> <20200406232440.4027-2-chaitanya.kulkarni@wdc.com>
In-Reply-To: <20200406232440.4027-2-chaitanya.kulkarni@wdc.com>
From:   Danil Kipnis <danil.kipnis@cloud.ionos.com>
Date:   Tue, 7 Apr 2020 12:09:23 +0200
Message-ID: <CAHg0Huz0sy7u0=eM40ca1ye6mBgVjDscx=9kxQKViN7dm51crA@mail.gmail.com>
Subject: Re: [PATCH 1/2] block: add bio based rw helper for data buffer
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc:     linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In __blkdev_issue_rw():
> +               bio = blk_next_bio(bio, nr_pages, gfp_mask);

Doesn't this already submits the bio even before the pages are added?

> +       error = __blkdev_issue_rw(b, buf, sector, nr_sects, op, opf, mask, &bio);
> +       if (!error && bio) {
> +               error = submit_bio_wait(bio);

And then the bio is submitted again in blkdev_issue_rw()...

Or do I understand it wrong?
