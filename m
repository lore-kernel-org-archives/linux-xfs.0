Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F98C88CB2
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 18:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbjFLSfi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 14:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237822AbjFLSfA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 14:35:00 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E3D198D
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 11:34:48 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-51870dc6333so210017a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 11:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1686594886; x=1689186886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dd62pmi6vde4J9GeAbTB+1XNz/5Y4SFzi53ndiAQrHU=;
        b=NS7S4u5cz2qj3dc1Gt+QteeddIkMeO0wFy7nbS5DDIEKxk1gy/jQ7u3VmHA2s4Rpsr
         X1KywOGQ0ozpRy9W71JPfF1PXSkGXjDh8bj0CTRYDsrP83t5VUuSju8bB+j4bFogaG0b
         LBT94dzCGD66JPiXPowtCOrNHQkQMI3GMvYn4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686594886; x=1689186886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dd62pmi6vde4J9GeAbTB+1XNz/5Y4SFzi53ndiAQrHU=;
        b=gCt1m++U8c9jxuLtv0WPb7FnKpW0GyVoDiiYw4vqthaIKh6BpGcLj1WoVP0U+gmQgA
         gThxnN6rWxMaUQ2ZcEmyxaWb+yn7lZezIkKMk8+MoNisN+5jeWqYD9HLsTnuHHhrZnuK
         HK3IXAE01yw4AP1PGyGDKXL7SdxdO+L+OAcEsClYaxyTUBFH4o+PK14U6NhrTjeiqOvu
         efDLvzrhdHzi6JdctjZtZPrtBab4Os2zf5mxeRljxIHnQj+6uqLHaJ515Eur9qxH9S57
         JZZdKFzxIOh1iR/Jybco1QqNHkCS1jt/rp2ky9ZN8Zux7i/9wY5j6KGynZWtNGQ4ziFj
         996w==
X-Gm-Message-State: AC+VfDwkB4w/Udcayh2Ls5ESxPFdAHyw0665wwxLTyDaegt+2BZfk607
        QQw0dWmV6dVcfQ+8PEooKYI0bSdEybU9/XUrE7VeHsaH
X-Google-Smtp-Source: ACHHUZ6yN/GuKH3jVT6jOc6+wZbABQcOGv61LHBDIgNOpYKTjaaymtpapOJL7wqLxmp7cM7Vsa5iFQ==
X-Received: by 2002:a05:6402:44d:b0:510:f462:fc47 with SMTP id p13-20020a056402044d00b00510f462fc47mr5714178edw.7.1686594886465;
        Mon, 12 Jun 2023 11:34:46 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id dy28-20020a05640231fc00b0050bc6c04a66sm5368859edb.40.2023.06.12.11.34.45
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 11:34:45 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-51491b87565so8017459a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 11:34:45 -0700 (PDT)
X-Received: by 2002:aa7:c0d6:0:b0:514:8e4a:15a9 with SMTP id
 j22-20020aa7c0d6000000b005148e4a15a9mr5698676edp.5.1686594885420; Mon, 12 Jun
 2023 11:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
 <ZIZSPyzReZkGBEFy@dread.disaster.area> <20230612015145.GA11441@frogsfrogsfrogs>
 <ZIaBQnCKJ6NsqGhd@dread.disaster.area> <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
 <20230612153629.GA11427@frogsfrogsfrogs> <CAHk-=wiN-JcUh4uhDNmA4hp26Mg+c2DTuzgWY2fZ6hytDtOMCg@mail.gmail.com>
 <af31cadf-8c15-8d88-79fb-066dc87f0324@kernel.dk> <13d9e4f2-17c5-0709-0cc0-6f92bfe9f30d@kernel.dk>
 <CAHk-=wgdBfqyNHk0iNyYpEuBUdVgq1KMzHMuEqn=ADtfyK_pkQ@mail.gmail.com>
 <212a190c-f81e-2876-cf14-6d1e37d47192@kernel.dk> <CAHk-=wh0hrFjcU5C8uHvLBThrT5vQsFHb7Jk6HRP3LAJqdNx1A@mail.gmail.com>
 <ff34a007-fdd0-8575-8482-919ead39fc88@kernel.dk> <CAHk-=whXt9+-YfhgjBYxT9_ATjHbMDZ0yJdK7umrJGU8zBVZ9w@mail.gmail.com>
In-Reply-To: <CAHk-=whXt9+-YfhgjBYxT9_ATjHbMDZ0yJdK7umrJGU8zBVZ9w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 12 Jun 2023 11:34:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjqVEdigZWMoOUMr0J179vfA4G=MwafFh8UStsA-3mHBw@mail.gmail.com>
Message-ID: <CAHk-=wjqVEdigZWMoOUMr0J179vfA4G=MwafFh8UStsA-3mHBw@mail.gmail.com>
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

On Mon, Jun 12, 2023 at 10:51=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Ok, can you (and the fsstress people) confirm that this
> whitespace-damaged patch fixes the coredump issue:

The proper patch from Jens is now in my tree, and I'm archiving this
thread on the assumption that it's all good.

Dave/Zorro - if you still see any issues with that patch in place, holler.

                   Linus
