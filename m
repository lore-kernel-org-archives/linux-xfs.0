Return-Path: <SRS0=1/fZ=7H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C883AC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 05:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B86C207DA
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 05:00:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oXyLNnMC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgEYFAw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 May 2020 01:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgEYFAv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 May 2020 01:00:51 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98297C061A0E;
        Sun, 24 May 2020 22:00:51 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b91so13975936edf.3;
        Sun, 24 May 2020 22:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=50Epmor9kAHw3TRqR6ikhX5aKUzMYS5VsliqcmruboU=;
        b=oXyLNnMC+ilSxlsvL7dik8LdbERvwdF9VQ9aAi7DcUNeN4YER18lugb1gO3OSq46Sa
         pSTromtok/rcz45UL6158umCtYGOKv7+jphzZ+nndfFVjeVONlV25aNJs9OHjAKGs4Tr
         HOCtMrCKMhKMn89OTCpjdDFWswAUVV/yPWa531Zdif1bRyUbAkZoqlXJRM8io2wf05zr
         t56k6BUsSALTz+ZjpsaZceA1lGx3szt4pgNnPbPasKgdYRTYx4qGMBi21A7NDfOT8i8J
         1W5PLQvpIoQ1hIEmbc5UtiLLDxf3WxXvuE00vl4vINXsAU7r+0O02TqFhb4Q47XgmOhC
         zN2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=50Epmor9kAHw3TRqR6ikhX5aKUzMYS5VsliqcmruboU=;
        b=JKZRZc+OuZ9acbumqHLK0URPhHJcXR1BROzkpnq1uHef8FgejF9o/vsMCUUKJT85jZ
         TcZQ0hWsBUbzfhUcJXmD6htYaj0y/OJHGyEOnKCgsZVnOykn8STBmwm1TH5yyofxuApm
         IQN4iJvIohmsj1cnsNlQPW639IIlYhQloqHiy4bZYCXb3MkYfUaVVkgs+Isd6tvPOyON
         TOPnJq6GVbgWQ/xoD2ofyhZ+hX0TFY0LdABNzonIFdctZjIshDHlcZSqu4bJKewp+oJ0
         iEuVLV0O8rRvSLXX2h57kuZj79nWq7zgH8exUOy7bJ8zOBf/C4qwA8f0RB2SsrmEZMD4
         wdaQ==
X-Gm-Message-State: AOAM532j82NlwfpM+qSi4hBxAGtXWz+r7O/vLNFWEk5vywZwR3AmdOmU
        P+KcFXaPlUCl4XW22umj2WXWgEkIoS8aMWyJt9Y5oQ==
X-Google-Smtp-Source: ABdhPJzuqkMtQU0OIfoXAxpu4pT73Nt2MVW8v+HneaNsJ3Afe/aaVi48PvkQN0jCXF5uPsrSg4DFsu3u+/EF7MLKh6g=
X-Received: by 2002:aa7:d54c:: with SMTP id u12mr13185852edr.298.1590382850250;
 Sun, 24 May 2020 22:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAPM=9tyy5vubggbcj32bGpA_h6yDaBNM3QeJPySTzci-etfBZw@mail.gmail.com>
 <20200521231312.GJ17635@magnolia> <20200522003027.GC2040@dread.disaster.area> <20200522205116.GD8230@magnolia>
In-Reply-To: <20200522205116.GD8230@magnolia>
From:   Dave Airlie <airlied@gmail.com>
Date:   Mon, 25 May 2020 15:00:39 +1000
Message-ID: <CAPM=9tywrqCchmVkNxzQQVSphB5MYgKvr3dNwhysntQ2P9BSfg@mail.gmail.com>
Subject: Re: lockdep trace with xfs + mm in it from 5.7.0-rc5
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, 23 May 2020 at 06:51, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> OTOH, it didn't take that long to whip up a patch.
>
> Dave, does this fix your problem?

I reproduced with 5.7.0-rc7, and tried this patch on top in the same
VM doing the same thing.

with this patch I no longer see the lockdep trace.

Tested-by: Dave Airlie <airlied@gmail.com>

Thanks,
Dave.
