Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEE4EB64D9
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jun 2023 15:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjF0PvL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 11:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbjF0PvD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 11:51:03 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8762D4E
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 08:50:52 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2b5d0b3e288so9977501fa.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 08:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687881051; x=1690473051;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mb1j6DFE/gC6WopRLNbpI5U1MMHo5Qb/CvfJ6QI4v54=;
        b=rUulqPWbG4aedkgghCjVesIJIIx9wl7brEq1jM8ZS5IdaK2B1FNV6gEIJjGe+v7pHu
         Q4hyel26QHf1RjN1bTqAGMfYE9LWkiHh8RVLmnY46YC2MO0xrw40Pv+r/mYNE9NNygxw
         hHD3/VO0M1gvnN5D/u+TivAiG0ctSUQxsHNSJykl+OYpfi9Dpv5uUFw5/kLZs+RdMSXk
         Ij+z/Y3DM6fK42EMiblLkiauoRNkGQzHabIZpWjvPb9Q372fXaqXCxhjY/IfLayBJkrd
         vdnycHH+/sBdKmwCkqCFWtf0rDak4oMK2WmWeWN+kVEXW2OzZcteI8qJTlkf1Jzg7X1j
         4vcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687881051; x=1690473051;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mb1j6DFE/gC6WopRLNbpI5U1MMHo5Qb/CvfJ6QI4v54=;
        b=jVzq2qs1+gjY7MgapAPyRJONT8j3gbxxkDEPONdDhZwQrawGaILwZPVwEH/pZ2iOX/
         VeYsBryzxVauYo9fLdad0HR5O3nUz1ONoMAVtN/tao9lh/UvqcOlzJbEs1JP7MUP+Cm6
         po53TOoblPeXI1/60/oKIJOgiYu2N3oZOLXmP7RehbrHLGxi5/IB56+RVtR73Dm2ylkk
         tcWJVn8vQjFISXxdnrFfduUNKUNCBDEIOoCodARv+Oi8g4EBgPkZQTJ+45kj2sy0gaaQ
         taDY5ddoXIj1RIY2Ts2ICao3bEJmBn5A7nnQZuhxC7biguEyslPRamBlbIO32TZkstMK
         Gd0g==
X-Gm-Message-State: AC+VfDxWeqmsT9vzPV7tSIhV4QBfdH0xQfL1j0mlXuajqRqpi9lJOOO9
        1JyomQA5PqCWbEE3IC762kQvYiW+wJ14Qsvg5j3oj/m0
X-Google-Smtp-Source: ACHHUZ5/maxIMoxV0koiA9SZ6BfRTmKPNjZ+B9H4lF76SR6l4eXKiwK8/nLLf5SoKBnrYYgjuDnERwfITrwfTzvhtZg=
X-Received: by 2002:a2e:a27a:0:b0:2b6:99a7:2fb4 with SMTP id
 k26-20020a2ea27a000000b002b699a72fb4mr4418820ljm.0.1687881050485; Tue, 27 Jun
 2023 08:50:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
 <ZJTrrwirZqykiVxn@dread.disaster.area> <CAD21AoC9=8Q2o3-+ueuP05+8298z--5vgBWtvSxMHHF2jdyr_w@mail.gmail.com>
 <3f604849-877b-f519-8cae-4694c82ac7e4@sandeen.net>
In-Reply-To: <3f604849-877b-f519-8cae-4694c82ac7e4@sandeen.net>
From:   Masahiko Sawada <sawada.mshk@gmail.com>
Date:   Wed, 28 Jun 2023 00:50:13 +0900
Message-ID: <CAD21AoBHd35HhFpbh9YBHPsLN+F_TZX5b47iy+-s44jPT+fyZQ@mail.gmail.com>
Subject: Re: Question on slow fallocate
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 27, 2023 at 12:32=E2=80=AFAM Eric Sandeen <sandeen@sandeen.net>=
 wrote:
>
> On 6/25/23 10:17 PM, Masahiko Sawada wrote:
> > FYI, to share the background of what PostgreSQL does, when
> > bulk-insertions into one table are running concurrently, one process
> > extends the underlying files depending on how many concurrent
> > processes are waiting to extend. The more processes wait, the more 8kB
> > blocks are appended. As the current implementation, if the process
> > needs to extend the table by more than 8 blocks (i.e. 64kB) it uses
> > posix_fallocate(), otherwise it uses pwrites() (see the code[1] for
> > details). We don't use fallocate() for small extensions as it's slow
> > on some filesystems. Therefore, if a bulk-insertion process tries to
> > extend the table by say 5~10 blocks many times, it could use
> > poxis_fallocate() and pwrite() alternatively, which led to the slow
> > performance as I reported.
>
> To what end? What problem is PostgreSQL trying to solve with this
> scheme? I might be missing something but it seems like you've described
> the "what" in detail, but no "why."

It's for better scalability. SInce the process who wants to extend the
table needs to hold an exclusive lock on the table, we need to
minimize the work while holding the lock.

Regards,

--=20
Masahiko Sawada
Amazon Web Services: https://aws.amazon.com
