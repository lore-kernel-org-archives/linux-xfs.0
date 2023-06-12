Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEAE6C7EE2E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 16:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236817AbjFLQml (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 12:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237306AbjFLQmi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 12:42:38 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3801710D5
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 09:42:35 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b219ed9915so53432731fa.3
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 09:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1686588153; x=1689180153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DHlw26Nr3iiAXr4x4uSWEbvlq1xJxnXY00baLa5A/xY=;
        b=TpDE9u2f5G2kHCBrXcxJQ4ESNSxbzwsM68eafuFVBuGCAm6khd+lN0LB+3yE8JnKIR
         rc4zhn3Q2vg6s0+/NyQGb1K3q4OwiC5kbhxg12p/Z8CaYkbNbRYclhKoIDS9ItTeYtrc
         /lHeDy3wipdVjb1RFa/GVEHwGKKhudUPrKHaI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686588153; x=1689180153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DHlw26Nr3iiAXr4x4uSWEbvlq1xJxnXY00baLa5A/xY=;
        b=ExBqBw3yjKBItPL+1uW+sUWnCPyj6HNMkOJ95Q5zlSO7ikcm8xSN6gD75uVItiq85Y
         JPa+g+RkalK0pRyF13ajPK8UqYlwZPGP0jkqEVOwmXtpBl4L9dDhKc6DYKmEUPXLhyrb
         fafp06PXvtlNFKJuqUNPH/fTTcx+yedfI4A2SDfU4NnedP5zMa3vXn7I8UxAX0X8DsBo
         Mhn9J8Uoknl5GnUDZHCAUgrZpkGKyuSNrjQLmghZJrwqRMq38kLQoiAjvCeTxBrvTIvE
         OyIEHO/0WDJm78duxso9SqtkGA0Kw8BDT6UtHcdr6CPJ5vKvGzD4b0+Fsnb631bhuBln
         y6NA==
X-Gm-Message-State: AC+VfDxhB8e5hFK/JRfQQt1idUSIDPfAD5+cLFWoa8oof1d5uR4+hJ8G
        2teyadE4xZmUYLmiKOjGAF4/keK32QZW8J6u3JgkqY0i
X-Google-Smtp-Source: ACHHUZ49x9ices+b4/1BUtNl/ND0vpvdi46QXI2Hu32axbnEmOuPZC0Dtw4TzxhT4Y2j/nXm99yjYA==
X-Received: by 2002:a2e:8e81:0:b0:2ad:9783:bca with SMTP id z1-20020a2e8e81000000b002ad97830bcamr3080358ljk.27.1686588153178;
        Mon, 12 Jun 2023 09:42:33 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id jt5-20020a170906dfc500b0097462d8dc04sm5451752ejc.100.2023.06.12.09.42.32
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 09:42:32 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5149c76f4dbso8023380a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 09:42:32 -0700 (PDT)
X-Received: by 2002:a05:6402:78b:b0:518:5f8e:4d2c with SMTP id
 d11-20020a056402078b00b005185f8e4d2cmr793438edy.27.1686588152188; Mon, 12 Jun
 2023 09:42:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
 <ZIZSPyzReZkGBEFy@dread.disaster.area> <20230612015145.GA11441@frogsfrogsfrogs>
 <ZIaBQnCKJ6NsqGhd@dread.disaster.area> <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
 <20230612153629.GA11427@frogsfrogsfrogs> <CAHk-=wiN-JcUh4uhDNmA4hp26Mg+c2DTuzgWY2fZ6hytDtOMCg@mail.gmail.com>
 <af31cadf-8c15-8d88-79fb-066dc87f0324@kernel.dk> <13d9e4f2-17c5-0709-0cc0-6f92bfe9f30d@kernel.dk>
In-Reply-To: <13d9e4f2-17c5-0709-0cc0-6f92bfe9f30d@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 12 Jun 2023 09:42:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgdBfqyNHk0iNyYpEuBUdVgq1KMzHMuEqn=ADtfyK_pkQ@mail.gmail.com>
Message-ID: <CAHk-=wgdBfqyNHk0iNyYpEuBUdVgq1KMzHMuEqn=ADtfyK_pkQ@mail.gmail.com>
Subject: Re: [6.5-rc5 regression] core dump hangs (was Re: [Bug report]
 fstests generic/051 (on xfs) hang on latest linux v6.5-rc5+)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 12, 2023 at 9:38=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> Quick peek would suggest that it's because io-wq clears PF_IO_WORKER on
> exit, and now we fail the check in coredump_task_exit() that was added.

Oh, that makes sense.

Well, it makes sense for the bug, but that whole

        preempt_disable();
        current->flags &=3D ~PF_IO_WORKER;
        preempt_enable();

thin in io_worker_exit() does *not* make sense to me.

Does removing those three lines make things "JustWork(tm)"?

               Linus
