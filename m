Return-Path: <SRS0=I2eC=74=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292F0C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Jun 2020 05:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 044E9206D7
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Jun 2020 05:20:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DNZ6JKGs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgFOFU0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Jun 2020 01:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbgFOFUZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jun 2020 01:20:25 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409E2C061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 14 Jun 2020 22:20:25 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id i25so16499632iog.0
        for <linux-xfs@vger.kernel.org>; Sun, 14 Jun 2020 22:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Le9ILI/UBxYfwYQQH/bq9ozgMgyVwNkbtsCsqyKAQeM=;
        b=DNZ6JKGsfwB3eSUfqC2U5rFriTokhfsHjEOPtjQH08mAbX3jkitlEcRaozSdlSKL3W
         dDeGR0n0Av++5z7nONy4HSBchmbianmgEWGiWzgKEgkLivP/FOENUXqyCz8QHu2vs0/v
         s6ojFQGBnn3GP9FfAU2z1kkd5i2G03AS5qKy3qzQGhwBOSqD1Fc5RgFeWoOc62+5+uXT
         eAfWEsfX4rZpbJHNUx280uhGNAxNv8CI4vYBP8cMdBLVAAt7Yictp6dRHNAycF7o7ueU
         vd4uRUyduAAaRftjxVHIR9zx1+Zh6XkD91Saebw+ezCZxV53ke15J+1Kg8QyCRjANbVy
         /x2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Le9ILI/UBxYfwYQQH/bq9ozgMgyVwNkbtsCsqyKAQeM=;
        b=rXVs10nbvJ3aRQytneiYMadN4qpXWaAxkS7zLdjxmNUDALYfRNoOKhCQOhHFLYwx59
         qtVPuC+VIgD/SOTgmvkUcf1UTaRfihgsgaKDIQPZBtNwhvYuGhPuc5lXH0Xyeso8JnCk
         fEHVrePd6cUyE5xLp5on39w2N3s+gppu4a3dM4h02jYTgKb3E1CSREnmq26dznJL9r9c
         ZL0VGVZG9jkpIpSWxC0XZiC7ZSFzKCKBuAKf7MFm3ChC1s/K2Qnddv8UdEF8QaKJzE02
         9hU4Q5gGqwZM5x2cicCjOaBBfyrLH4lGoLFzz2uCdlpfME39u1I/ZEIBPPIOqmLn9tIB
         Pm1Q==
X-Gm-Message-State: AOAM530aoHZji5nOMmtNPAetTZ01YENEeKSxl6zwErB45Kf+u1wHMKtB
        qfZonVxB3kWYii4QkN6f5fMzQItpdIU67SoczodK+d2l
X-Google-Smtp-Source: ABdhPJwDaZUFmrYvIblu+yk4XT96qVk/mJCI+lYUgZ/CBUI8pw0627/A/URJgTqWmYoPrTSWd5GrXF4bjSPS1B0OS2M=
X-Received: by 2002:a05:6602:491:: with SMTP id y17mr25914877iov.72.1592198424638;
 Sun, 14 Jun 2020 22:20:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200604074606.266213-1-david@fromorbit.com> <20200604074606.266213-30-david@fromorbit.com>
 <20200609131249.GC40899@bfoster> <20200609221431.GK2040@dread.disaster.area>
 <20200610130833.GB50747@bfoster> <20200611001622.GN2040@dread.disaster.area>
 <20200611140709.GB56572@bfoster> <20200615014957.GU2040@dread.disaster.area>
In-Reply-To: <20200615014957.GU2040@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 15 Jun 2020 08:20:13 +0300
Message-ID: <CAOQ4uxhzd5T39NQ=SD85ahvQ3ZMy3ZNXNTksABBotERGvGCG2w@mail.gmail.com>
Subject: Re: [PATCH 29/30] xfs: factor xfs_iflush_done
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 15, 2020 at 4:50 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Thu, Jun 11, 2020 at 10:07:09AM -0400, Brian Foster wrote:
> >
> > TBH, I think this patch should probably be broken down into two or three
> > independent patches anyways.
>
> To what end? The patch is already small, it's simple to understand
> and it's been tested. What does breaking it up into a bunch more
> smaller patches actually gain us?
>
> It means hours more work on my side without any change in the end
> result. It's -completely wasted effort- if all I'm doing this for is
> to get you to issue a RVB on it. Fine grained patches do not come
> for free, and in a patch series that is already 30 patches long
> making it even longer just increases the time and resources it costs
> *me* to maintian it until it is merged.
>

This links back to a conversation we started about improving the
review process.

One of the questions was regarding RVB being too "binary".
If I am new to the subsystem, obviously my RVB weights less, but
both Darrick and Dave expressed their desire to get review by more
eyes to double check the "small details".

To that end, Darrick has suggested the RVB be accompanied with
"verified correctness" "verified design" or whatnot.

So instead of a binary RVB, Brian could express his review
outcome in a machine friendly way, because this:
"TBH, I think this patch should probably be broken down..."
would be interpreted quite differently depending on culture.

My interpretation is: "ACK on correctness", "ACK on design",
"not happy about patch breakdown", "not a NACK", but I could
be wrong.

Then, instead of a rigid rule for maintainer to require two RVB
per patch, we can employ more fine grained rules, for example:
- No NACKs
- Two RVB for correctness
- One RVB for design
- etc..

Also, it could help to write down review rules for the subsystem
in a bureaucratic document that can be agreed on, so that not
every patch needs to have the discussion about whether breaking
this patch up is mandatory or not.

There is a big difference between saying: "this patch is too big for
me to review, I will not be doing as good a job of review if it isn't
split into patches" and "this patch has already been reviewed,
I already know everything there is to know about it, there are no
bisect-ability issues, but for aesthetics, I think it should be broken down".
I am not saying that latter opinion should not be voiced, but when said
it should be said explicitly.

High coding standards have gotten xfs very far, but failing to maintain a
healthy balance with pragmatism will inevitably come with a price.
Need I remind you that the issue that Dave is fixing has been affecting
real users and it has been reported over three years ago?

Thanks,
Amir.
