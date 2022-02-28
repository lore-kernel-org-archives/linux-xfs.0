Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D145C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 15:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbiB1QA0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 11:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbiB1QAZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 11:00:25 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AC370920
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 07:59:46 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a8so25713127ejc.8
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 07:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=udUUwQMYZOQdeQeu7KJflNOXp5UljA8CQOPQlhHKm+Y=;
        b=Ps2g3Rmx7y+RxaExNigUlAShr8r9n4HJx4jXh3jX3l48QN2GGz17bPjHQGFh/RPT/a
         Xe3Y302EzQSNvW7VzbwzWaqmO5xMMVqpxy+XXofnecS/u0ED0x+tbYTlqkSLsLRhSciu
         N6rSkzsDR47sLeOm/7rAJXCL4mb6S7A5gjjMA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=udUUwQMYZOQdeQeu7KJflNOXp5UljA8CQOPQlhHKm+Y=;
        b=5MVKkWBUAgWO2Sgigb6dV6FTRvysUd8uKFzxWIoQ5tG3RfRgC5KrWJzMAMnmq3gpWk
         U5asBkIGr2IC5EBaVup+brWF6xedGF5jW5Ehd7fx6dUNhS1/NpbTd6SMsbLMQir5Bhm1
         6kN3RVlNoTPCO1sHX0RspP4MHbMr1GzgJmtzgG54yAj14ZgXw8I5ApUN4L1QhexrmZzt
         ZWdOzAtydtT+RopbG1rkM+qKJaSPZjO+tXqZJ1zhTYdwI4/qkUcMkfySZ2zSZtoJyJkb
         XnNA0ungvQDbVXaab7/I+TJscmU1sMv4MQbBuBHQ4Kk1u5KZ1bRWsK57u4os+Kb19cUs
         qsjg==
X-Gm-Message-State: AOAM530AKjf2bbXtl7P9eN/ufmrcmpScNGyXbZcA7rg8pDKSeo8syjx7
        YsMr9pAmfXwXvE9WYBMEPtYl3WdQLldW7YfEXVYFlQ==
X-Google-Smtp-Source: ABdhPJzFuwC4cXK43NRFP1CzDPmxJHkeyiho2pckN/boPKiQ0vuUKSn6l1ZxMqIRvXXEFW5bhRCbL2ZNT2f45sLUzvo=
X-Received: by 2002:a17:907:76fc:b0:6ce:a836:34a1 with SMTP id
 kg28-20020a17090776fc00b006cea83634a1mr16312616ejc.663.1646063984879; Mon, 28
 Feb 2022 07:59:44 -0800 (PST)
MIME-Version: 1.0
References: <20220227093434.2889464-1-jhubbard@nvidia.com> <20220227093434.2889464-7-jhubbard@nvidia.com>
In-Reply-To: <20220227093434.2889464-7-jhubbard@nvidia.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 28 Feb 2022 16:59:33 +0100
Message-ID: <CAJfpegsDkpdCQiPmfKfX_b4-bkkj5N5vRhseifEH6woJ7r0S6A@mail.gmail.com>
Subject: Re: [PATCH 6/6] fuse: convert direct IO paths to use FOLL_PIN
To:     jhubbard.send.patches@gmail.com
Cc:     Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, 27 Feb 2022 at 10:34, <jhubbard.send.patches@gmail.com> wrote:
>
> From: John Hubbard <jhubbard@nvidia.com>
>
> Convert the fuse filesystem to support the new iov_iter_get_pages()
> behavior. That routine now invokes pin_user_pages_fast(), which means
> that such pages must be released via unpin_user_page(), rather than via
> put_page().
>
> This commit also removes any possibility of kernel pages being handled,
> in the fuse_get_user_pages() call. Although this may seem like a steep
> price to pay, Christoph Hellwig actually recommended it a few years ago
> for nearly the same situation [1].

This might work for O_DIRECT, but fuse has this mode of operation
which turns normal "buffered" I/O into direct I/O.  And that in turn
will break execve of such files.

So AFAICS we need to keep kvec handing in some way.

Thanks,
Miklos
