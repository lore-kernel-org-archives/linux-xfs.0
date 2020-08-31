Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE422C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 08:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA7A0206F0
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 08:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RhzBgCb0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgHaIHi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 04:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgHaIH2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 04:07:28 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55204C061575
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 01:07:26 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z25so2225786iol.10
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 01:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0JNLe56CbCGm4XvCoLyh75xipq6M5chRS47yiYOapUQ=;
        b=RhzBgCb0PYlBo8h8B3oy18q62GBB3DxxVSX9SL7LVVhHHnDmlsgP3ChKF9JowVaARq
         tQ5TuCyDDy2M+oc5agUXs4Iji8aZEKgz4N9pGN5mPr08GZSER/wmCPz54fG6OeKME3Fn
         bkGE1sFl2NcrzONuBwQvV/t0aEq0TsGwGkMlfPCUF3MG/7dzY6awjgeGNHy1ls5kiMIf
         KboMNgmuh4RbC5uZLpoHzqhnmf/WrKfGwXJg6E80bK14rSvyRXdEb6bac00epCr+5VIe
         vDc0lCj4TuYdzeZV/lqKkiK1hxslUBEW5z7L0IO86Ka4kKodqJ+N4tMK71FMTRct10om
         C14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0JNLe56CbCGm4XvCoLyh75xipq6M5chRS47yiYOapUQ=;
        b=gqp5Ay2OFI4W9oWkHsQLQlr7BZ5HjLBUrCWQThgAjSLLWHB7kVwQJ8tEQZhbzH+s9E
         vRhHO7cT5Dyo/T5ikR2qvh+djumncKkV7IBhluFIL91RLYaljiEbfZft03G4gVHjOiC2
         x5/FF6q6RZcN8e5eMhhY9rYx/JA/ABO79fUX9lIXOKLAsgYit2cwGoKRehkvY6/LtH5L
         yjGWFVcLtFFnJe4BNLFBr0v50KCBuCGjEqNOqaGsnoOQ+TN8AFkhYVh63mLAZNuLdC+D
         fBHtKCDx+cRXifWbQ7Esgl1jFt3U+wud/PAX/w2WP25b5YJOOoU066DUEjN47xRGsd/B
         if4A==
X-Gm-Message-State: AOAM531sjprWe1BnIsGgaoZZC5jiFZ8WAoRCPB0k/ZzVWxU02J3z/0Ue
        TPFxrs0+AP7QGRUTxIvRFvvbH/bemTLckt+pvXarjBm/
X-Google-Smtp-Source: ABdhPJzUx4tL6EDu0zaNrGwtMnU7iJuY5aesFBTEHg33FBJsdA8cUf5FuSGjwYXwvjJD1LRnne36MuwWnFbbCNCxPQw=
X-Received: by 2002:a05:6602:1d6:: with SMTP id w22mr398273iot.64.1598861245571;
 Mon, 31 Aug 2020 01:07:25 -0700 (PDT)
MIME-Version: 1.0
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
In-Reply-To: <159885400575.3608006.17716724192510967135.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 31 Aug 2020 11:07:14 +0300
Message-ID: <CAOQ4uxh+fLzGTVbXEB8L__jVQCbw53GxcYYv96=2N0-piHz4-Q@mail.gmail.com>
Subject: Re: [PATCH v5 00/11] xfs: widen timestamps to deal with y2038
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Allison Collins <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 9:08 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> Hi all,
>
> This series performs some refactoring of our timestamp and inode
> encoding functions, then retrofits the timestamp union to handle
> timestamps as a 64-bit nanosecond counter.  Next, it adds bit shifting
> to the non-root dquot timer fields to boost their effective size to 34
> bits.  These two changes enable correct time handling on XFS through the
> year 2486.
>
> On a current V5 filesystem, inodes timestamps are a signed 32-bit
> seconds counter, with 0 being the Unix epoch.  Quota timers are an
> unsigned 32-bit seconds counter, with 0 also being the Unix epoch.
>
> This means that inode timestamps can range from:
> -(2^31-1) (13 Dec 1901) through (2^31-1) (19 Jan 2038).
>
> And quota timers can range from:
> 0 (1 Jan 1970) through (2^32-1) (7 Feb 2106).
>
> With the bigtime encoding turned on, inode timestamps are an unsigned
> 64-bit nanoseconds counter, with 0 being the 1901 epoch.  Quota timers
> are a 34-bit unsigned second counter right shifted two bits, with 0
> being the Unix epoch, and capped at the maximum inode timestamp value.
>
> This means that inode timestamps can range from:
> 0 (13 Dec 1901) through (2^64-1 / 1e9) (2 Jul 2486)
>
> Quota timers could theoretically range from:
> 0 (1 Jan 1970) through (((2^34-1) + (2^31-1)) & ~3) (16 Jun 2582).
>
> But with the capping in place, the quota timers maximum is:
> max((2^64-1 / 1e9) - (2^31-1), (((2^34-1) + (2^31-1)) & ~3) (2 Jul 2486).
>
> v2: rebase to 5.9, having landed the quota refactoring
> v3: various suggestions by Amir and Dave
> v4: drop the timestamp unions, add "is bigtime?" predicates everywhere
> v5: reintroduce timestamp unions as *legacy* timestamp unions

I went over the relevant patches briefly.
I do not have time for thorough re-review and seems like you have enough
reviewers already, but wanted to say that IMO v5 is "approachable" for
novice xfs developers and I can follow the conversions easily, so that's
probably a good thing ;-)

Thanks,
Amir.
