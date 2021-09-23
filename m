Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC16C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Sep 2021 05:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3350560FC1
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Sep 2021 05:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239201AbhIWFn5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 01:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhIWFnz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Sep 2021 01:43:55 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C42C061757
        for <linux-xfs@vger.kernel.org>; Wed, 22 Sep 2021 22:42:25 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s11so5164872pgr.11
        for <linux-xfs@vger.kernel.org>; Wed, 22 Sep 2021 22:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GIeswu2kPZeMqIRSa83Ms0km/4F7Tf+r++V3y3fcOFU=;
        b=jsLYrvv0vM8Vx25YhzrFK8nZMFePboSHvbJoHCUZ19pahlhDV37JwulIOJIUBjsOoY
         IwxouG8cTRfy6bqzI2MyOmlwJQU5iH6tZn9a/kUd8bEuTIugm3BISsT7DmR7DQQVN0d2
         Hp8noekCagVPbEmOl+agCcQFzy41Eu4Vp+M+APf6DZCWgYpxwTDTUgVFiSSblFbOrOD5
         7RsKAN13lcl8S0a83epRtQPgSBawOQorSdxyyZ39K6M8bMb/Owd0yeEKMKrdEVhWZqei
         IfJi/AyLjEumWr9i6eEhRiVkY3aNzdXBpvDkHpmCjte5KL1pjbMrVPaFSpn33KMDrxgH
         MmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GIeswu2kPZeMqIRSa83Ms0km/4F7Tf+r++V3y3fcOFU=;
        b=ZAHjIFwIBWa4yrN9rES7yneFbeQ13QdEyzc+bloTqIaabSRB9tGW1JmE0bQKH6fJHB
         3ze9s522mvejv1oa6OZEgGQ+ALvLdfkbPJtbRq2x1n3GfBOX6xnu2qCAe/qeFCZsb31P
         VS7XuVQDuBDCHLMhjorQDr04tH5HrizNgklbJx5uthoa4raVXWiGCL8C60bRXh0154MD
         shVGFJC5asDKp4CTHdK7Fxr2BgbQGVSYTbaPsz+bxEUpX7D5rhQASZSQ04h5N801nkl/
         dlVgwn4y2ybDfwrYOfACCbOemHQ6j7ygX/GVb//565CCNgIQUEtRKclVn8YocPEsDvR3
         7B3w==
X-Gm-Message-State: AOAM5315by3mrEzXvDjLmWv9Mf+NAGegzd3hFOrM4C2K2BweY+1qtaWs
        nw9/m1HqFIi5gOGDsrWY5cyi70v7vpqkzl5ioxT2pg==
X-Google-Smtp-Source: ABdhPJwYgyp6Mh9HCnuRK/sKHAPHJlmd78V8lsW+htD76tFuXvFRyisy4kC6BMOY/ncY7vO4Ehu8wlbqufVEXgR0Xsc=
X-Received: by 2002:a62:7f87:0:b0:444:b077:51ef with SMTP id
 a129-20020a627f87000000b00444b07751efmr2693613pfd.61.1632375744469; Wed, 22
 Sep 2021 22:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <163192866125.417973.7293598039998376121.stgit@magnolia>
 <20210921004431.GO1756565@dread.disaster.area> <YUmYbxW70Ub2ytOc@infradead.org>
 <CAPcyv4jF1UNW5rdXX3q2hfDcvzGLSnk=1a0C0i7_UjdivuG+pQ@mail.gmail.com>
 <20210922023801.GD570615@magnolia> <20210922035907.GR1756565@dread.disaster.area>
 <20210922041354.GE570615@magnolia> <20210922054931.GT1756565@dread.disaster.area>
 <20210922212725.GN570615@magnolia> <20210923000255.GO570615@magnolia>
 <20210923014209.GW1756565@dread.disaster.area> <CAPcyv4j77cWASW1Qp=J8poVRi8+kDQbBsLZb0HY+dzeNa=ozNg@mail.gmail.com>
In-Reply-To: <CAPcyv4j77cWASW1Qp=J8poVRi8+kDQbBsLZb0HY+dzeNa=ozNg@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 22 Sep 2021 22:42:11 -0700
Message-ID: <CAPcyv4in7WRw1_e5iiQOnoZ9QjQWhjj+J7HoDf3ObweUvADasg@mail.gmail.com>
Subject: Re: [PATCH 3/5] vfs: add a zero-initialization mode to fallocate
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jane Chu <jane.chu@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 22, 2021 at 7:43 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Wed, Sep 22, 2021 at 6:42 PM Dave Chinner <david@fromorbit.com> wrote:
> [..]
> > Hence this discussion leads me to conclude that fallocate() simply
> > isn't the right interface to clear storage hardware poison state and
> > it's much simpler for everyone - kernel and userspace - to provide a
> > pwritev2(RWF_CLEAR_HWERROR) flag to directly instruct the IO path to
> > clear hardware error state before issuing this user write to the
> > hardware.
>
> That flag would slot in nicely in dax_iomap_iter() as the gate for
> whether dax_direct_access() should allow mapping over error ranges,
> and then as a flag to dax_copy_from_iter() to indicate that it should
> compare the incoming write to known poison and clear it before
> proceeding.
>
> I like the distinction, because there's a chance the application did
> not know that the page had experienced data loss and might want the
> error behavior. The other service the driver could offer with this
> flag is to do a precise check of the incoming write to make sure it
> overlaps known poison and then repair the entire page. Repairing whole
> pages makes for a cleaner implementation of the code that tries to
> keep poison out of the CPU speculation path, {set,clear}_mce_nospec().

This flag could also be useful for preadv2() as there is currently no
way to read the good data in a PMEM page with poison via DAX. So the
flag would tell dax_direct_access() to again proceed in the face of
errors, but then the driver's dax_copy_to_iter() operation could
either read up to the precise byte offset of the error in the page, or
autoreplace error data with zero's to try to maximize data recovery.
