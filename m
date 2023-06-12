Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EB0C88CB2
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 17:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbjFLR4t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 13:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbjFLR4s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 13:56:48 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C33DB
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 10:56:47 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f644dffd71so5575708e87.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 10:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1686592605; x=1689184605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0Jw3FHM9EacxH/mZ/iMD9+z20+OQwgYNEZ4cddG8cQ=;
        b=QhZpX/rju1hLcL9rV1UHZJRWDdHtqLHv5zuxlQIbNLeNhkiKC8y9MCV4BgfX0HJYwO
         u6tgfU6QmDNpYvyB/tS3ktK96aoL9rMb0U7SX1XHb3kXhOMnEevghcUsFswZbarcfrkI
         Jb2W/EbfMXh0Lw/++iprfdfwZR5M9QbI+/t10=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686592605; x=1689184605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C0Jw3FHM9EacxH/mZ/iMD9+z20+OQwgYNEZ4cddG8cQ=;
        b=kjG9cE5jUeepi3qAnQkf0qNfkP8maXyd0viZrUS58SZsIU2pKjk9lJoCgAamil1KcL
         tgEGsSTPyimLHcdyut9kbJRNghddVICs02/5JFPna+L+gLg8nMlhCVsrkb8I1yRj9zd0
         MJ7QPO8QiUc4srJYHnFUduicLjwOGGtd/fCQSAzotZ9uahUdf1jj29OKpMkTsov4ZbUh
         Hzvn6McTuudfYdoyOf721RYXfhLfuuqi7k7HuNyVUr4fhayW4VtikvsgDdxHgppOZtgy
         5QXbt5AZ09QZAUxJsJy2C02AlwnzLdddkNzMExzEBIg3UQhAhT3qCwq61ZpE7F/mOATN
         XJbQ==
X-Gm-Message-State: AC+VfDxYcFeV7Oz7GpMLyx+j28iuF93+GfPXjB8qje4mh/kTs9vhBuP5
        t3XnKE+ohfrQwoqSqQ2bnGaVMKtr6SefLAZXXdTBn7CT
X-Google-Smtp-Source: ACHHUZ4hXRGMwniS/FTPhTn+TUG8X4CZyA0XNyby5VyvGC1UhgrC1mojLzKwJ9zqtz6LpiHCK2wb8w==
X-Received: by 2002:a19:4409:0:b0:4f4:4533:8535 with SMTP id r9-20020a194409000000b004f445338535mr4112607lfa.67.1686592605191;
        Mon, 12 Jun 2023 10:56:45 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id m29-20020a056512015d00b004f6366cbe72sm1486068lfo.228.2023.06.12.10.56.44
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 10:56:44 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-4f644dffd71so5575658e87.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 10:56:44 -0700 (PDT)
X-Received: by 2002:ac2:5dc9:0:b0:4ec:8816:f4fc with SMTP id
 x9-20020ac25dc9000000b004ec8816f4fcmr4979969lfq.6.1686592603732; Mon, 12 Jun
 2023 10:56:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
 <ZIZSPyzReZkGBEFy@dread.disaster.area> <20230612015145.GA11441@frogsfrogsfrogs>
 <ZIaBQnCKJ6NsqGhd@dread.disaster.area> <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
 <20230612153629.GA11427@frogsfrogsfrogs> <CAHk-=wiN-JcUh4uhDNmA4hp26Mg+c2DTuzgWY2fZ6hytDtOMCg@mail.gmail.com>
 <af31cadf-8c15-8d88-79fb-066dc87f0324@kernel.dk> <13d9e4f2-17c5-0709-0cc0-6f92bfe9f30d@kernel.dk>
 <CAHk-=wgdBfqyNHk0iNyYpEuBUdVgq1KMzHMuEqn=ADtfyK_pkQ@mail.gmail.com>
 <212a190c-f81e-2876-cf14-6d1e37d47192@kernel.dk> <CAHk-=wh0hrFjcU5C8uHvLBThrT5vQsFHb7Jk6HRP3LAJqdNx1A@mail.gmail.com>
 <ff34a007-fdd0-8575-8482-919ead39fc88@kernel.dk> <CAHk-=whXt9+-YfhgjBYxT9_ATjHbMDZ0yJdK7umrJGU8zBVZ9w@mail.gmail.com>
 <8a97ca5d-69ef-d716-9f61-2b9b2a26dd14@kernel.dk>
In-Reply-To: <8a97ca5d-69ef-d716-9f61-2b9b2a26dd14@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 12 Jun 2023 10:56:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjVQVkunhPL00iSzBnx8xrdW=94EYoOW24zT0ofGv3m2g@mail.gmail.com>
Message-ID: <CAHk-=wjVQVkunhPL00iSzBnx8xrdW=94EYoOW24zT0ofGv3m2g@mail.gmail.com>
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

On Mon, Jun 12, 2023 at 10:54=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> Something like that was/is my worry. Let me add some tracing to confirm
> it's fine, don't fully trust just my inspection of it. I'll send out the
> patch separately once done, and then would be great if you can just pick
> it up so it won't have to wait until I need to send a pull later in the
> week. Particularly as I have nothing planned for 6.4 unless something
> else comes up of course.

Ack, sounds good.

                   Linus
