Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E37C6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 21:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbjDDVWC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 17:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236314AbjDDVWB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 17:22:01 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F6319BC
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 14:21:56 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id y4so136159780edo.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 14:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680643314; x=1683235314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DEHm3j6FHNzOV7UQgEK4HrPb8zLKCoPFgoX5U/zaBA=;
        b=GNnql8BuayVyHZmimQ8JK5hf6RvPvV+S71JrfdbQlZZbR0OvgAn183pynR3qIUHZeq
         vpk08rlQbbJz37M1IJyQcysntdHwGDfWmr3rJaFX/3zNRmXvAT4c6jNEmoMBFhtc4+3y
         +qhA2ZLMzSsXndnmTFquPkPNhWFb/KSoxPOjc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643314; x=1683235314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+DEHm3j6FHNzOV7UQgEK4HrPb8zLKCoPFgoX5U/zaBA=;
        b=fHN2D6ZW5dgRiLWMolkPJyogAJSO8zcPQ7O0J+QvALgQsH1tHTPC/A6zf3SK8FneMt
         g7Hre0x3U9LdxG4qmsdPUfC5l+wCzQvstb4ggkWLiasaWKZTq2yS3vGdbyOb1J/0jbnG
         ubR5vLiih7R/A5QfUwUw9cLeOFZhLvmGr1XddfmsPLUsdgG3lEKbQnLNaj6X3VOmst9L
         H5Jnv9hTXFRFfIuJCUCJaNyOZgJWJX8ZBBYi0MMa1adxL3EfaAMPWZBXl36fZH5Ck7lU
         2gDdCuXP6pLKDF+ZfWi4reDhw29MOXlS8NhfjZaoiGoYa3iUBqcCgo8Jzb8LFzMhb05D
         w6nQ==
X-Gm-Message-State: AAQBX9cd3gb7j6+5aLrGgGcdgaET07Iwq/6WNUtvcAJsU2TbHr5tvQMD
        0Iq8lH6tRlXx3PQTwHWvFj+Kr46bOT8/Km7O3bLiXA==
X-Google-Smtp-Source: AKy350bU0nEv1q/HNPz62TL9V2h6yVbhUj6ozRcvnVXWMJGb/U7fD+Emme5XqeLCgf5Lx5o5dZBcIA==
X-Received: by 2002:a17:906:5906:b0:906:3373:cfe9 with SMTP id h6-20020a170906590600b009063373cfe9mr1029233ejq.10.1680643314174;
        Tue, 04 Apr 2023 14:21:54 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id le3-20020a170907170300b0093b8c0952e4sm6417824ejc.219.2023.04.04.14.21.53
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 14:21:54 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id y4so136159578edo.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 14:21:53 -0700 (PDT)
X-Received: by 2002:a17:907:2075:b0:947:72cd:9325 with SMTP id
 qp21-20020a170907207500b0094772cd9325mr493845ejb.15.1680643313001; Tue, 04
 Apr 2023 14:21:53 -0700 (PDT)
MIME-Version: 1.0
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <168062803200.174368.4290650174353254767.stgit@frogsfrogsfrogs>
 <CAHk-=wi-W-zJkW-URTQoLcLnRuwzmWj4MRqV6SHXmjKDV2zXFg@mail.gmail.com> <20230404205136.GA110000@frogsfrogsfrogs>
In-Reply-To: <20230404205136.GA110000@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 Apr 2023 14:21:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiKYQuwJpUBNEsc73jaf4-3b3xL5-MD=YXgEBn+31KDKg@mail.gmail.com>
Message-ID: <CAHk-=wiKYQuwJpUBNEsc73jaf4-3b3xL5-MD=YXgEBn+31KDKg@mail.gmail.com>
Subject: Re: [PATCH 2/3] xfs: test the ascii case-insensitive hash
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 4, 2023 at 1:51=E2=80=AFPM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> Wrong.  I'm well aware that userspace tolower and kernel tolower are
> *NOT* the same thing.  I'm trying to **STOP USING** tolower in XFS.

Ok, so you're not actually talking about "userspace tolower()".

You are actually talking about just the same function in xfstools and
the kernel, and neither is really "tolower()", but is a
"xfs_hashprep()".

Fair enough. That works. I still think it should be made to be
US-ASCII only, in order to not have any strange oddities.

Do you really have to support that "pseudo-latin1" thing? If it's
literally just a "xfs_hashprep()" function, and you arbitrarily pick
one random function, why make it be a known-broken one?

            Linus
