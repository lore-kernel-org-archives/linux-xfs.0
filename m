Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA044C2BA83
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 10:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70D9220848
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 10:21:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YPSEiQCJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbgBMKVx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 05:21:53 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36628 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729662AbgBMKVx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Feb 2020 05:21:53 -0500
Received: by mail-io1-f68.google.com with SMTP id d15so5870831iog.3;
        Thu, 13 Feb 2020 02:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QSvL+5phxy32YJK5uQRteesTVaa2PPbKzaoTbXUhlzM=;
        b=YPSEiQCJMUNngVzlJJvKIBi3cfBrRXx/m8Pox/3aONguDpdMVvnlGalwbIPE7N38a1
         3APjQ7Kam7hJ814w65Irskn3XYGOEjmGhgN2tJBk8NQBV1pSZxEiYswBET47H8kdCgCY
         EvnlkBxLU/aZ85lgw4zsO5adVXpMd0bWkXugzEN3k2UpwcOsX9IYV0YzGOE0cYKbQHaz
         deoeqH0JB1BkESmFTrdA1hM0wRedAcqLhUpvuUV5WrpS6JzdyHA7hWZmIp50befQ+JJ6
         IiJkf71+s0Ntc/vWSApQbwPTsUOjkmj24q8BQYB575rrwMzDucsPi8qwYi3+BVersnQH
         Y3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QSvL+5phxy32YJK5uQRteesTVaa2PPbKzaoTbXUhlzM=;
        b=HBgbE/PxkF7X2AX93n//gQSsfMSyBNLKWTtxw1lFqU3md0zX6qCI+TT8pBPnjCPQ1/
         Y44gHPamdtwdkOMG2ouU98yeFZZTkEj6e0XYoF2tZgxPJm7I/+bacRQ154iq0wNl9JPv
         XibRJ8RqMX+81BeizGhzKjdBYwqblVo4qHlGhzEutlSqbBFQLycoJ+YYdyGlfRrURBUP
         Cvnkvr7EBpTCKxZE1c7BqQwydc3rd/omqHYJCXZagSG/fZidOsVYCZEyKtw4dK+WeIYa
         hPGIyuuj6V37UzDdKFRkaugQq843c1DHSlN2VRatheXlkKrojlijvMNIW4y95BesUGLJ
         qPEg==
X-Gm-Message-State: APjAAAXxl951sr9J7yRW3JnuNOxMqfuYxsa7ymbMwuxLuB4Y37qlGpbR
        pxWSSqGCkI36gcyoxAyhorDr4zYs6NP9QYab1WY=
X-Google-Smtp-Source: APXvYqzSPy+3SjGPIrUXGx43QrVG8Fgwgvb9/7u5baa9dl+XWDCy6Hyf/dm9k9hXwInjoAzOrbhnyeYpzpR38MNXaBY=
X-Received: by 2002:a02:c558:: with SMTP id g24mr22281827jaj.81.1581589312246;
 Thu, 13 Feb 2020 02:21:52 -0800 (PST)
MIME-Version: 1.0
References: <20200131052520.GC6869@magnolia> <CAOQ4uxh=4DrH_dL3TULcFa+pGk0YhS=TobuGk_+Z0oRWvw63rg@mail.gmail.com>
 <20200212224234.GV6870@magnolia>
In-Reply-To: <20200212224234.GV6870@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 13 Feb 2020 12:21:40 +0200
Message-ID: <CAOQ4uxgH0os2t=jZezLqsz-Y01v=AsdDXWSYXLervdHVheXo2Q@mail.gmail.com>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] FS Maintainers Don't Scale
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        lsf-pc@lists.linux-foundation.org,
        Eric Sandeen <sandeen@redhat.com>,
        Eryu Guan <guaneryu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> >
> > Eryu usually posts a weekly status of xfstests review queue, often with
> > a call for reviewers, sometimes with specific patch series mentioned.
> > That helps me as a developer to monitor the status of my own work
> > and it helps me as a reviewer to put the efforts where the maintainer
> > needs me the most.
>
> I wasn't aware of that, I'll ask him to put me on the list.
>

I was talking about the weekly xfstests ANNOUNCE email.
Most of the time, review information amounts to "there are still patches
in my review backlog", but sometimes the information is more
specific with call for specific reviews:
https://lore.kernel.org/fstests/5ddaafc5.1c69fb81.7e284.ad99@mx.google.com/

Thanks,
Amir.
