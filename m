Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868D4C88CB2
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 16:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbjFLQps (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 12:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbjFLQpo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 12:45:44 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBFA1B8
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 09:45:42 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-51458e3af68so7724902a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 09:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1686588341; x=1689180341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NAwyfHdqq2XpGv1HfLFhZYNBkK1lnw38Ar7GumbG5W8=;
        b=DOV8V8WzRlbYSCaSWcJrxnzEoCDXraXQ3wJ5iUbYMP9Y/Y9VI7CzRqX1ssqq2zF0SK
         Fnck9R1mnZkJ8MspuOCrJt5zK07w/aDqQAvoxwq3LpfNtpHPec46RJgP1Rhu4Cge/q9w
         GVxNsVyax3Bso6SxBcJlniy+2rB8nRRcCkXfs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686588341; x=1689180341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NAwyfHdqq2XpGv1HfLFhZYNBkK1lnw38Ar7GumbG5W8=;
        b=PROrP0vdn+PT+DpNyZnxXajzAwyFzpmQlR4NxRsnwBhgimiH6881W1cxhIEi3Alcxs
         EbDgcdd+taJdW/8XpJNWJzeKYGMTA3TvqfZ4R7I195A0c3RJFYLljDedp/M5KcJWD41d
         5+ItzRq4x8OsloNmvJ5rqw7caxY23lHTsVAcLadp7w/h3Ii6UbUqUaVvRN2/b4gfUYlr
         fzFeYrfdCLD8TIkU+IH9AxxspWC/2Ik2TDRK7Q5L20u/tzLWC7w/qzD2iJFl1b2TwJ75
         OFVgrULclAycOkymTPB83/ZBdPUlqgpXDV/6e10rjy/U04r2sc7xDscLT0evKaPEUiqU
         aSkQ==
X-Gm-Message-State: AC+VfDxd+KZmIb3/QkX6+mKhJkVGx771QrLKXNw89T2DXj3JK7fpM0uj
        9donxZxytq7nQHLzmZ7RsuUI2cc68A9SjRItcWOQCPnr
X-Google-Smtp-Source: ACHHUZ4ec8rNTUCOBHGshbwEySK/LDEVe4Zkyvb1M3V7Ma3riD+0tJDWDm4RGTVwZSj+s64115X0bA==
X-Received: by 2002:a17:907:1c91:b0:96a:43b9:95b1 with SMTP id nb17-20020a1709071c9100b0096a43b995b1mr12397819ejc.59.1686588340972;
        Mon, 12 Jun 2023 09:45:40 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id b8-20020a170906194800b009750b9ff97asm5412832eje.55.2023.06.12.09.45.39
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 09:45:40 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5149c51fd5bso7726939a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 09:45:39 -0700 (PDT)
X-Received: by 2002:a50:ef13:0:b0:514:80b9:793b with SMTP id
 m19-20020a50ef13000000b0051480b9793bmr5781986eds.19.1686588339613; Mon, 12
 Jun 2023 09:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
 <ZIZSPyzReZkGBEFy@dread.disaster.area> <20230612015145.GA11441@frogsfrogsfrogs>
 <ZIaBQnCKJ6NsqGhd@dread.disaster.area> <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
 <20230612153629.GA11427@frogsfrogsfrogs> <CAHk-=wiN-JcUh4uhDNmA4hp26Mg+c2DTuzgWY2fZ6hytDtOMCg@mail.gmail.com>
 <af31cadf-8c15-8d88-79fb-066dc87f0324@kernel.dk> <13d9e4f2-17c5-0709-0cc0-6f92bfe9f30d@kernel.dk>
 <CAHk-=wgdBfqyNHk0iNyYpEuBUdVgq1KMzHMuEqn=ADtfyK_pkQ@mail.gmail.com>
In-Reply-To: <CAHk-=wgdBfqyNHk0iNyYpEuBUdVgq1KMzHMuEqn=ADtfyK_pkQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 12 Jun 2023 09:45:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi3ucaR0GXt6iaAX6tKO=iHcbe6jDzf2Mgz1petZMc=rw@mail.gmail.com>
Message-ID: <CAHk-=wi3ucaR0GXt6iaAX6tKO=iHcbe6jDzf2Mgz1petZMc=rw@mail.gmail.com>
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

On Mon, Jun 12, 2023 at 9:42=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Well, it makes sense for the bug, but that whole
>
>         preempt_disable();
>         current->flags &=3D ~PF_IO_WORKER;
>         preempt_enable();
>
> thin in io_worker_exit() does *not* make sense to me.

Oh, it looks like that goes back to the original io_worker
implementation, when io_worker_start() would set the PF_IO_WORKER bit,
and  io_worker_exit() would clear it, and they were otherwise created
like normal kthreads.

It *looks* all entirely historical to me, and removing those three
lines as left-over baggage smells like the right thing.

              Linus
