Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFC6C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 19:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4AB661178
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 19:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhIOTBa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 15:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbhIOTB3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Sep 2021 15:01:29 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956C9C061575
        for <linux-xfs@vger.kernel.org>; Wed, 15 Sep 2021 12:00:10 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t4so2273307plo.0
        for <linux-xfs@vger.kernel.org>; Wed, 15 Sep 2021 12:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R1Ip78sCYtHj3yJwGZCy7ffy06/ayIKBrBMUmgckdIg=;
        b=uMos9aMSxmIrJfrIkAZCQhpUQPxlU/AIaYM4t4HjY94fTEU9Ry4rOcC6yQb67J+JyS
         EllzN90UfzP186ufauR8jJL6cmxqKNHbOyhED6G1QIIXYBA3EGo2/eukDMXLYN8yX2P+
         J4CeSVgbJXY6ZUrJgrxQEUvsaDfZTX++cJtNY5Gv9zUkE2eWEvI7HmuhbCTSUybjw36S
         7IAQVeMQD7FJ7ixQ1pijlQu+hwBhMS6jqrBVW145gUAge6QABCLa80cA+LqbVoohSdMI
         /5AVO2hTCWXotxB73AgKkHeUpu9U821GB+eMg/PXOTRNbMY99G+xLX8jUSfJJb8JEmWl
         WLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R1Ip78sCYtHj3yJwGZCy7ffy06/ayIKBrBMUmgckdIg=;
        b=SKCW0fJxK7/2tPo7IvUvgYi+WPp88twJKhEWfxLcOlizPznt5GySPRIyuJ0Rdv+3QE
         xn0vM7xzcKHuG6R77kczT7VKscZx1RJHYe+CNsr/XTTFtLzVH3nz8VfWdY/euWmBLhvg
         uasAr1k3J2bg95+PpJK0VPrYf6sT1QkodoCEkXpcoeC5k4iBpY2fvRkdxp/KladnucmH
         Sd2GlrfzzWPIkLxq0K+eGpQu+OP8UZMfqe+ybA0LdCylh9Pi8HvHesnDWnrUyLRnnM8K
         b2GTACodnrHkHUOk7HzCWRvQ+sHHAAfatx/2Q9rwEO1sOGjJVTJnuBGxB2W/rNmMzDvl
         n41w==
X-Gm-Message-State: AOAM5306wam4jT6kOCgedEC62i5nwNrnCQAM8GSDJBYGbwMQVtW6xjlF
        Gd9YgAtRhYtjpZWk3VFnNDUnSH91G1U1x4whI/rWwg==
X-Google-Smtp-Source: ABdhPJw1OwWewVzJ5FYjAwYkMCx0B/xv9jCvXgt9Moc92aEP+mIOH7HVPjHW6QN41eLe9iiVGVwLjnjE3yIt43pD14I=
X-Received: by 2002:a17:90a:f18f:: with SMTP id bv15mr1333640pjb.93.1631732410071;
 Wed, 15 Sep 2021 12:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <1631726561-16358-1-git-send-email-sandeen@redhat.com>
 <CAPcyv4gZqnp6CPh71o621sQ5Q9LZEr3MhkFYftW9LpuuMtAPRA@mail.gmail.com> <cb13be1c-66f1-8452-e7ab-c1278c8e51e0@sandeen.net>
In-Reply-To: <cb13be1c-66f1-8452-e7ab-c1278c8e51e0@sandeen.net>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 15 Sep 2021 11:59:59 -0700
Message-ID: <CAPcyv4gFB_nefaEMVaPb4x4Q61Rr3Q1JdOr7cytBmQcbpaUJng@mail.gmail.com>
Subject: Re: [PATCH 0/3 RFC] Remove DAX experimental warnings
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 15, 2021 at 11:49 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 9/15/21 1:35 PM, Dan Williams wrote:
> > On Wed, Sep 15, 2021 at 10:23 AM Eric Sandeen <sandeen@redhat.com> wrote:
> >>
> >> For six years now, when mounting xfs, ext4, or ext2 with dax, the drivers
> >> have logged "DAX enabled. Warning: EXPERIMENTAL, use at your own risk."
> >>
> >> IIRC, dchinner added this to the original XFS patchset, and Dan Williams
> >> followed suit for ext4 and ext2.
> >>
> >> After brief conversations with some ext4 and xfs developers and maintainers,
> >> it seems that it may be time to consider removing this warning.
> >>
> >> For XFS, we had been holding out for reflink+dax capability, but proposals
> >> which had seemed promising now appear to be indefinitely stalled, and
> >> I think we might want to consider that dax-without-reflink is no longer
> >> EXPERIMENTAL, while dax-with-reflink is simply an unimplemented future
> >> feature.
> >
> > I do regret my gap in engagement since the last review as I got
> > distracted by CXL, but I've recently gotten my act together and picked
> > up the review again to help get Ruan's patches over the goal line [1].
> > I am currently awaiting Ruan's response to latest review feedback
> > (looks like a new posting this morning). During that review Christoph
> > identified some cleanups that would help Ruan's series, and those are
> > now merged upstream [2]. The last remaining stumbling block (further
> > block-device entanglements with dax-devices) I noted here [2]. The
> > proposal is to consider eliding device-mapper dax-reflink support for
> > now and proceed with just xfs-on-/dev/pmem until Mike, Jens, and
> > Christoph can chime in on the future of dax on block devices.
> >
> > As far as I can see we have line of sight to land xfs-dax-reflink
> > support for v5.16, does anyone see that differently at this point?
>
> Thanks for that update, Dan. I'm wondering, even if we have renewed
> hopes and dreams for dax+reflink, would it make sense to go ahead and
> declare dax without reflink non-experimental, and tag dax+reflink as
> a new "EXPERIMENTAL feature if and when it lands?

As I replied to the xfs patch in your series, I say "yes" EXPERIMENTAL
can go now, because the concern was reflink support might regress
dax-semantics wrt MAP_SYNC and the like. That concern seems to be
avoided by the current direction.
