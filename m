Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53280C4332D
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 00:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B1DC64E02
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 00:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhBMArK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 19:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbhBMArJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Feb 2021 19:47:09 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BB7C061574
        for <linux-xfs@vger.kernel.org>; Fri, 12 Feb 2021 16:46:29 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id j3so1380636qkk.9
        for <linux-xfs@vger.kernel.org>; Fri, 12 Feb 2021 16:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TAQsF7Gk7en9VLMiM89I/Qt7SqRMy0dbMlTaoMzF8cg=;
        b=YhnQEj2p6ceurnmgMcjyf+UfNpPtK8D0cBtcYosQ8aQsIEIBQcAQrEuYUc/HTG1SCQ
         IDJfcnJn8diDPmV7YfyOh5oIHqynb8iRZXTIawVlrK6v5a8JT0brJvkNAN8K/ETWI+qw
         OnJU0Wv3J7ISinS1iZH2pydg4YmwdjlK/vWog=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TAQsF7Gk7en9VLMiM89I/Qt7SqRMy0dbMlTaoMzF8cg=;
        b=cWFLoqK8d22UroCYz9j3JLPLxDSc1obNvA48uZBAs8Lv1btGv70Gvz8fySpwUliMKa
         ufAHm3UXyAMEyBO0rZ05h+ULbFd7zzWB9qMbmhfuJk4kUfFqgNsg/oF3CmvcUyCf9cTi
         +eU7VTrinLJ8etfspovdCaTLmYzHbzqS3NzqDUD96HpW/+XQ5sRhXqOOwmVi1ESIIVP/
         n0AKbHxkd02N7ozJnOynxhxdpfWUFQrjqNBZel/DZB4o5V/2SbftdrS9Ac/O0ZUWdGki
         RhTQAsNBvT8YbZvtFph6XXg+GmTzXNXKOjeoSefbs08SsGaNfCDldfGFQ/ZscCLyOstW
         U+fg==
X-Gm-Message-State: AOAM531V/5VjmxPuNjsErCvFWfosdftHrTdIG6hmf4x7Oiboh8KiJB9b
        UJ6irvWpigPAdQvJwD2yoe8t7nTDR6moKZIBV766K2wlEPRxCg==
X-Google-Smtp-Source: ABdhPJzCvYyDDA3RIfcCrWK/qHv1/KraJbvbkhwTMNjCmT7HU3FsL3K2YR5ClGy/yAYI9zlmRAOd29bsLdHsw4Jc2Qo=
X-Received: by 2002:a37:78d:: with SMTP id 135mr5499871qkh.472.1613177188323;
 Fri, 12 Feb 2021 16:46:28 -0800 (PST)
MIME-Version: 1.0
References: <20210212204849.1556406-1-mmayer@broadcom.com> <CAGt4E5tbyHpDEPtEGK8SYoB4w4srAfHpiBADkR+PpkQyguiLPg@mail.gmail.com>
 <36f95877-ad2d-a392-cacd-0a128d08fb44@sandeen.net> <CAGt4E5uA6futY0+AySLJTHsmoUp7OceNca=7ReXAg-o8mw0=7Q@mail.gmail.com>
 <20210212224542.GA4662@dread.disaster.area>
In-Reply-To: <20210212224542.GA4662@dread.disaster.area>
From:   Markus Mayer <mmayer@broadcom.com>
Date:   Fri, 12 Feb 2021 16:46:17 -0800
Message-ID: <CAGt4E5ubFCWL2QxzP2ocuRtNF129obbLyKCUDTqed-K+2nUPTw@mail.gmail.com>
Subject: Re: [PATCH] include/buildrules: substitute ".o" for ".lo" only at the
 very end
To:     david@fromorbit.com
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Linux XFS <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 12 Feb 2021 at 14:45, Dave Chinner <david@fromorbit.com> wrote:
>
> So there's a rule like this generated:
>
> bitmap.lo: bitmap.c ../include/xfs.h ../include/xfs/linux.h \
>  ../include/xfs/xfs_types.h ../include/xfs/xfs_fs_compat.h \
>  ../include/xfs/xfs_fs.h ../include/platform_defs.h avl64.h \
>  ../include/list.h bitmap.h
>
> The sed expression is:
>
> $(SED) -e 's,^\([^:]*\)\.o,\1.lo,'
>
> Which means it is supposed to match from the start of line to a ".o",
> and store everything up to the ".o" in register 1.
>
> And the problem is that it is matching a ".o" in the middle of a
> string.
>
> So existing behaviour:
>
> $ echo "foo.o/bitmap.o: bitmap.c ../include/xfs.h ../include/xfs/linux.h" | sed -e 's,^\([^:]*\)\.o,\1.lo,'
> foo.o/bitmap.lo: bitmap.c ../include/xfs.h ../include/xfs/linux.h
> $
>
> Looks correct until the dependency line is split and the first entry
> in the split line is something like "foo.o/uuid.h"
>
> Your modified version:
>
> $ echo "bitmap.o: bitmap.c ../include/xfs.h ../include/xfs/linux.h" | sed -e 's,^\([^:]*\)\.o$$,\1.lo,'
> bitmap.o: bitmap.c ../include/xfs.h ../include/xfs/linux.h
> $
>
> Doesn't work for the case we actually need the substitution for.
>
> So, really, I think we need to match against the full target
> specification rather than just ".o".
>
> Something like
>
> $SED -e 's,^\([^:]*\)\.o: ,\1.lo: ,'
>
> $ echo "foo.o/bitmap: bitmap.c ../include/xfs.h ../include/xfs/linux.h" | sed -e 's,^\([^:]*\)\.o: ,\1.lo: ,'
> foo.o/bitmap: bitmap.c ../include/xfs.h ../include/xfs/linux.h
> $ echo "foo.o/bitmap.o: bitmap.c ../include/xfs.h ../include/xfs/linux.h" | sed -e 's,^\([^:]*\)\.o: ,\1.lo: ,'
> foo.o/bitmap.lo: bitmap.c ../include/xfs.h ../include/xfs/linux.h

Thanks. I just tried your suggestion. Looks like it's working for my
situation. I'll submit a v2 of the patch.

Regards,
-Markus
