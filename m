Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05590C761A6
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 18:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbjDDSHT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbjDDSHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 14:07:19 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9876B59D2
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 11:06:47 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id eg48so133964910edb.13
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 11:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680631605; x=1683223605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTi2sQ5YeK1u9vNF+L7tDWhuy5E9qvrfi392HTt793Q=;
        b=bsbzeVzokl18I/EhiK7i0kKdEsc8bZQ7cylodfNWSpv02CiBByAY0EWIl9ee7caS9C
         8cZ3mf7ftQAPi39XDCmnLBZ8kZMjMFOV9C7DT0DVsCbFik226UtMCyrI3epgBo7Z06yZ
         rUNCSz+9mx/p1mZqr7dTmbE55sr+NHxW9V8JM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680631605; x=1683223605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uTi2sQ5YeK1u9vNF+L7tDWhuy5E9qvrfi392HTt793Q=;
        b=0N+RqWiB6pSrE6bnN82CiPGwS+g+KyvQ8umBjTSA/IqjWU2M0Uv99ywAYgBGt7IcCO
         Z9Sk+RNVkJUx34XZwQEE9tmUoOHVQKHygaxdfXZASqDCXFy4eEotpwK+mMDKI/aCxg5K
         Krymnon2XRXHbJegsycfJ/vYbfjxFNVMG10tOgnLI4RazGrWdY4xrYBttvnjsVbLq+L7
         i5bxkbfKgv6V6ZAkqVe67YAfWAaj+vh1GAAfKG9ubh39T4rT5E9zJlrFhtvq+D0yhvHV
         8sL3aP75qSpSbrv/bYuBAqdnPHr1delrKhjowob0p+Kms7UqXnHf2UEvqvX2NT4xq34i
         IObg==
X-Gm-Message-State: AAQBX9ejGil+wEj4L/M+arGz5laLGmBHzhfhpJzCYXnXhnGK299eRkch
        N+yauea1wsFL2EXx3d5+N7lIEzsW1vJV+XQVY/z65Q==
X-Google-Smtp-Source: AKy350b6D+hVGdbOfT9iXn7LZ56E6E6TwhITqkdaZ51mWBuIGKUcgZ7sqvQQY2suoX9vT59UmGCMBQ==
X-Received: by 2002:a17:906:9387:b0:947:79b3:c2fa with SMTP id l7-20020a170906938700b0094779b3c2famr310439ejx.17.1680631605160;
        Tue, 04 Apr 2023 11:06:45 -0700 (PDT)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id gh5-20020a170906e08500b009475bf82935sm6226073ejb.31.2023.04.04.11.06.44
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 11:06:44 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id eg48so133964646edb.13
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 11:06:44 -0700 (PDT)
X-Received: by 2002:a17:907:2075:b0:947:72cd:9325 with SMTP id
 qp21-20020a170907207500b0094772cd9325mr208906ejb.15.1680631604122; Tue, 04
 Apr 2023 11:06:44 -0700 (PDT)
MIME-Version: 1.0
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs> <168062803200.174368.4290650174353254767.stgit@frogsfrogsfrogs>
In-Reply-To: <168062803200.174368.4290650174353254767.stgit@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 Apr 2023 11:06:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi-W-zJkW-URTQoLcLnRuwzmWj4MRqV6SHXmjKDV2zXFg@mail.gmail.com>
Message-ID: <CAHk-=wi-W-zJkW-URTQoLcLnRuwzmWj4MRqV6SHXmjKDV2zXFg@mail.gmail.com>
Subject: Re: [PATCH 2/3] xfs: test the ascii case-insensitive hash
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 4, 2023 at 10:07=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
\> Now that we've made kernel and userspace use the same tolower code for
> computing directory index hashes, add that to the selftest code.

Please just delete this test. It's really really fundamentally wrong.

The fact that you even *think* that you use the same tolower() as user
space does shows just that you don't even understand how user space
works.

Really. The only thing this series shows is that you do not understand
the complexities.

Lookie here: compile and run this program:

    #include <stdio.h>
    #include <ctype.h>
    #include <locale.h>

    int main(int argc, char **argv)
    {
        printf("tolower(0xc4)=3D%#x\n", tolower(0xc4));
        setlocale(LC_ALL, "C");
        printf("tolower(0xc4)=3D%#x\n", tolower(0xc4));
        setlocale(LC_ALL, "sv_SE.iso88591");
        printf("tolower(0xc4)=3D%#x\n", tolower(0xc4));
    }

and on my machine, I get this:

    tolower(0xc4)=3D0xc4
    tolower(0xc4)=3D0xc4
    tolower(0xc4)=3D0xe4

and the important thing to note is that "on my machine". The first
line could be *different* on some other machine (and the last line
could be too: there's no guarantee that the sv_SE locale even exists).

So this whole "kernel and userspace use the same tolower code"
sentence is simply completely and utterly wrong. It's not even "wrong"
in the sense fo "that's not true". It's "wrong" in the sense "that
shows that you didn't understand the problem at all".

Put another way: saying "5+8=3D10" is wrong. But saying "5+8=3Dtiger" is
nonsensical.

Your patches are nonsensical.

               Linus
