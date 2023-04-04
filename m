Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3426AC761A6
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 18:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbjDDS6g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbjDDS6f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 14:58:35 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E060C124
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 11:58:32 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id t10so134481263edd.12
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 11:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680634711; x=1683226711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+iDJemCeX2qJtJl1VGwM/oIwzqzqC/aZhqD7+wq21gA=;
        b=T1XgxUp5g98I5JERLcaNyzPTKy9bur0o9LVfE/Swd/DOi3T7jsJK5tYqfqeiDGbFgX
         1r0LExmpnBxt7isBW7xdbQ4kAYt2bSWPoLNs+ExIvJiafcmcWMWnvHa89v42BH4z7/FG
         DpeR35g+KJ2OB5ah/DnEQHctBVBpMvYUcimU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680634711; x=1683226711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+iDJemCeX2qJtJl1VGwM/oIwzqzqC/aZhqD7+wq21gA=;
        b=n0m35bmhCruw7eLJ5oHeM4fGG7nn6dvjtYm9Pqw4qsXV3POPvdPw2HsvK/AAKPpYfA
         V15S6Atu4U6HP3aeNF6HiClaIeFl8zYNZGa3WdHq6JqR7K6+zdb9mmV6pmTu+M/wod1N
         zkZNv5sJwb3lG2LmS0rnYzeg/sY6CEc3IZ6QaFkenyzGS3/77OkI8KL7CWmYd/90jkSY
         vW6Ew+GADTLpPir2Woas7fU+i41tTiSL4kKyIKIPKXZcMK3h1HKvK3q/j9qY+7pmGI4o
         YCVzus38MlPhWTjICcDqMrsyo7mf62ZYEDsyPwjZULei03w+5PFGh2UOoTef8tpw06lp
         KVOQ==
X-Gm-Message-State: AAQBX9enY7beMan/OozDUOquZzNSfkiwy2tXB00dZoI7YJKXBR40Um62
        Z0iKZosW9Kj5WG/YO+kJ82LxdBCRNOA2oE9KBhEmgQ==
X-Google-Smtp-Source: AKy350Yj9YfF6LhIqQSFoszvlPiopKQDAT0eX8Dw0q+pGszLi3uE39+FtqljFVPQeqNVULxL/X856A==
X-Received: by 2002:a17:906:4e89:b0:933:1134:be1e with SMTP id v9-20020a1709064e8900b009331134be1emr528005eju.53.1680634711147;
        Tue, 04 Apr 2023 11:58:31 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id jg9-20020a170907970900b00947ae870e78sm5928712ejc.203.2023.04.04.11.58.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 11:58:30 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id eh3so134588713edb.11
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 11:58:30 -0700 (PDT)
X-Received: by 2002:a17:906:3b07:b0:935:3085:303b with SMTP id
 g7-20020a1709063b0700b009353085303bmr275561ejf.15.1680634709924; Tue, 04 Apr
 2023 11:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
 <CAHk-=whe9kmyMojhse3cZ-zpHPfvGf_bA=PzNfuV0t+F5S1JxA@mail.gmail.com> <20230404183214.GG109974@frogsfrogsfrogs>
In-Reply-To: <20230404183214.GG109974@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 Apr 2023 11:58:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiTyTeHpn-zDkKmd2Cq53p=M3OVOJVbh-3AJd-nuAGyjA@mail.gmail.com>
Message-ID: <CAHk-=wiTyTeHpn-zDkKmd2Cq53p=M3OVOJVbh-3AJd-nuAGyjA@mail.gmail.com>
Subject: Re: [PATCH 1/3] xfs: stabilize the tolower function used for ascii-ci
 dir hash computation
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 4, 2023 at 11:32=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> >
> > And when you compare to glibc, you only compare to "some random locale
> > that happens to be active rigth n ow". Something that the kernel
> > itself cannot and MUST NOT do.
>
> What then is the point of having tolower in the kernel at all?

It's perfectly fine for US-ASCII. So together with 'isascii()' is is just f=
ine.

Now, if you ask me why the data itself isn't then just limited to
US-ASCII, I can only say "history and bad drugs".

The Linux tolower() goes back to Linux-0.01, and my original version
actually got this right, and left all the upper 128 characters as 0 in
the _ctype[] array.

But then at some point, we failed at life, and started filling in the
upper bit cases too.

Looking around, it was at Linux-2.0.1, back in 1996. It's way before
we had good changelogs, so I can't really say *why* we did that
change, but I do believe that bad taste was involved.

But at least it was *somewhat* reasonable to do a Latin1-based ctype
back in 1996:

  --- v2.0.0/linux/lib/ctype.c Mon Nov 27 15:53:48 1995
  +++ linux/lib/ctype.c Tue Jul  2 19:08:43 1996

I would not object to going back to the proper US-ASCII only version
today, but I fear that we might have a lot of subtle legacy use ;(

                   Linus

PS Heh, and now that I look at my original ctype.h, find the bug.
Clearly that wasn't *used*:

  #define tolower(c) (_ctmp=3Dc,isupper(_ctmp)?_ctmp+('a'+'A'):_ctmp)
  #define toupper(c) (_ctmp=3Dc,islower(_ctmp)?_ctmp+('A'-'a'):_ctmp)

and they weren't fixed until 0.11 - probably because nothing actually used =
them.
