Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB7EDC3A5A2
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 17:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9558221019
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 17:15:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="blZ3otDA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733288AbfHWRPV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 13:15:21 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44057 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731264AbfHWRPU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Aug 2019 13:15:20 -0400
Received: by mail-io1-f66.google.com with SMTP id j4so13404375iog.11
        for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2019 10:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=SxHATtRu926HugxjAu6BiOlPt8IATF6kzeMEpmUwmWc=;
        b=blZ3otDAIjHG7ycJLz+zd4Jofwj2etlStIogu+DHpa3jrnnKrJUwb6nFDGS4rCB4al
         iAnojb0O2CnDDLyAGjsOUG0eSErnoxernFfnsBoZ1J/ozXrdVCDFKtzU6ZfDSSd8gU4j
         1If6I75wP1kJno81uBpmRtxltmYOE65NFxlTtkxzGbSUfRwPF64IMZ5MWl99Nz8QoZaT
         LRgW/2nBLiAXCTWZC5SKT5UoWHsDrAKe0sQfL61yg34LDgCnRHuZxJsiaruA4F2gQRHR
         /98zJuc5/Q8tUoVueJQGNrkq1YGM/6hmwrZFFzx1Py4OWzs7BK4a8V5lQU485HK9Oii4
         GFJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=SxHATtRu926HugxjAu6BiOlPt8IATF6kzeMEpmUwmWc=;
        b=tHu9FzgTqmEcKoHmHZAfrZX+wGw95KxxZ7EJobaoEy0yGQUDJwTY3qW7mssZvnpwgm
         FWqKthfnMthhf1LcYubvfhiVQVCiaA3yCZurmDKTzY5+GOS0cIfKCpkDAb8t/oyxBVkq
         TfsgnDxBbTJUE+qYgeWndFcoXyapmZX4/FWAAe6XXVfJpCIqpjsYSua6rTLf16VyKnj7
         8ttSc9kkUZ/RqKqXdmoKcA6UgbIlbaTewh6LROrdqBgSVt2B4nNFChuL+lhes4/skjL1
         wyrqa5qFFrDGc6YFdDXP37xq1xoZ7Tr1/LvihYcPbfKOZspUteGcRPHhTYWbXKz3lDrQ
         OnXA==
X-Gm-Message-State: APjAAAVoHPuJRMN2CqsaUlxrVs0LXyro+mLxT3dbkmJZQrANyzIbJZhE
        mZG2Z86h0zYU4IOrIzT8zctBytpZvrSqMK95w7s=
X-Google-Smtp-Source: APXvYqwZqzrIqER/b+cnNyI/M8GMSd7WJncrZ3FefoF+esi1F9kSHQ6F3vxBo0qY0PSNiuQrQncAlZRo3SNmRTUvL9c=
X-Received: by 2002:a5d:9a97:: with SMTP id c23mr8363807iom.260.1566580520026;
 Fri, 23 Aug 2019 10:15:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a02:d4a:0:0:0:0:0 with HTTP; Fri, 23 Aug 2019 10:15:19 -0700 (PDT)
In-Reply-To: <CAHk-=wiE1zyj89=gpoCn8L0hy8WpS68s+13GOsHQ5Eq3DPWqEw@mail.gmail.com>
References: <20190823035528.GH1037422@magnolia> <CAHk-=wiE1zyj89=gpoCn8L0hy8WpS68s+13GOsHQ5Eq3DPWqEw@mail.gmail.com>
From:   Benjamin Moody <benjamin.moody@gmail.com>
Date:   Fri, 23 Aug 2019 17:15:19 +0000
Message-ID: <CAAk6P0Xhuyj+FBDWaYpj15RhfrgxAHG8uJxCkuCEbcR23_18Fg@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix missing ILOCK unlock when xfs_setattr_nonsize
 fails due to EDQUOT
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        Ben Hutchings <benh@debian.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/23/19, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Thu, Aug 22, 2019 at 8:55 PM Darrick J. Wong <darrick.wong@oracle.com>
> wrote:
>>
>> ...which is clearly caused by xfs_setattr_nonsize failing to unlock the
>> ILOCK after the xfs_qm_vop_chown_reserve call fails.  Add the missing
>> unlock.
>
> Thanks for the quick fix.
>
> I assume there's no real embargo on this, and we can just add it asap
> to the xfs tree and mark it for stable, rather than do anything
> outside the usual development path?

As the person who reported the issue, I don't see a problem with
that.  I reported it to the Debian security team just to be on
the safe side, in case the problem was something bigger than what
I was seeing.

I haven't yet tested the patch, but thank you, Darrick, for the
quick response!

Benjamin
