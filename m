Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751C0C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 08:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F7FD20738
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 08:54:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+9YCkfr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbgFWIyv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 04:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731775AbgFWIyv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 04:54:51 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7EFC061573
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2020 01:54:51 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id l6so18602789ilo.2
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2020 01:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vyPf0OavDJyqshKON8q+p9hMKZ0UxaqV8bM+GP4HFEM=;
        b=Y+9YCkfrcOR08hDoDcS1EYWdhV77JcFLi8nZI78Iu8oC3FP7H24TnMq8QUVojYwB2d
         mXvaSTGX7uwrbiG3nuEF92X4E2cO1thetWWmwi7LHWSGj6CL1U5T6/WKWkU+eB91TXeq
         m+d5Cm+KVubVz1qX0PVtUM4j3a7te3Ieur3uIerEhuhy5bBOWoIESdpD1OeFaIXVKQJ+
         w0T52N1LyUkZnCgW6sxHqDrqgmq48oSZj6d0ln1JI3vgiwSC8JPXnV2wg3ANOWEunQJS
         FeHoRFOw4gSLY2oe40jhKAQfJYnakI717MiN0/hVUSxpIetK86yJEkfN1ObLr212TyDu
         mGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vyPf0OavDJyqshKON8q+p9hMKZ0UxaqV8bM+GP4HFEM=;
        b=osF+dLbZ/cVuJkmzWEVGn0ikvQEXC+P6mOcuLRhM4ALcjs1SNzrtor84XGLvcFFebR
         7h5611u/WwLlfnTHt1MdhIudFtUSpB8N8N5ksTJv3l7wL24KF+j2sk7dpIzXNvmr4O9W
         Zhb0iWvQM/pMWwb4wM1pB5entprcABwKBVS22JOSS7cOMCtld2rqXzXjBqfrUgMKZuyD
         7SPtz/+4vDJI3hGDPa33OKFwhIl+A1+ZpGmCiT8lgjBVtrN87oq9t+NuBy1OEfISLgv2
         0kSeUqZzQIz/s4SspitGRqyopnlm4Ymy22u1sk4aq23iAmATZ2S9/AejFc0ESJDYj5zz
         mI3A==
X-Gm-Message-State: AOAM533n6G9rgNKL2d2l4ueVraEUIbzsFaoscQL4ebLq52AOZL5BwuEX
        PeFtIHs5EO1vFbm1jirJhKq1c8HqW1GnXUVYfGpNLQQs
X-Google-Smtp-Source: ABdhPJxn7AwdquqEs83TMEkO129HfWp5pSBsh66/KXJTHwR5fQT+56EBqxTWdwIYIeznWc0pKsvOpHoVHCDSmZQl92w=
X-Received: by 2002:a92:c9ce:: with SMTP id k14mr21523389ilq.250.1592902490613;
 Tue, 23 Jun 2020 01:54:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200623052059.1893966-1-david@fromorbit.com>
In-Reply-To: <20200623052059.1893966-1-david@fromorbit.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 23 Jun 2020 11:54:39 +0300
Message-ID: <CAOQ4uxgbdgqsomb=2c7HFwV7=GD_K6mRHw9GqHLTzBKW1iNa-Q@mail.gmail.com>
Subject: Re: [PATCH] xfs: use MMAPLOCK around filemap_map_pages()
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 8:21 AM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> The page faultround path ->map_pages is implemented in XFS via
> filemap_map_pages(). This function checks that pages found in page
> cache lookups have not raced with truncate based invalidation by
> checking page->mapping is correct and page->index is within EOF.
>
> However, we've known for a long time that this is not sufficient to
> protect against races with invalidations done by operations that do
> not change EOF. e.g. hole punching and other fallocate() based
> direct extent manipulations. The way we protect against these
> races is we wrap the page fault operations in a XFS_MMAPLOCK_SHARED
> lock so they serialise against fallocate and truncate before calling
> into the filemap function that processes the fault.
>
> Do the same for XFS's ->map_pages implementation to close this
> potential data corruption issue.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

I wonder... should xfs_file_fadvise(POSIX_FADV_WILLNEED) also be taking
XFS_MMAPLOCK_SHARED instead of XFS_IOLOCK_SHARED?

Not that it matters that much?

Thanks,
Amir.
