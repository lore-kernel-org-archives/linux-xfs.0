Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8DB7C6FD1D
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 00:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236405AbjDEARa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 20:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbjDEAR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 20:17:29 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA4644A8
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 17:17:28 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id fi11so13480800edb.10
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 17:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680653847; x=1683245847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qnmfqkpqVY660n/DfvoFiLZqra7ar0FpX0Vxu8JLLok=;
        b=NmwMhPK3jNlphfwzIN5tOrAjxSidTvlb+juZOGF4xh3/evD/KOcDDHgquQdtlUQLvZ
         QLmU3eIDRRxD6ZvrHhDtw4mlE2LBpJSQj0p7Xr52uH4b98EAxUHVI95nPme6vWIyfL++
         HoQKMb6xReoOnvLukWPL+oQBjz8PXjLpz9ryM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680653847; x=1683245847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qnmfqkpqVY660n/DfvoFiLZqra7ar0FpX0Vxu8JLLok=;
        b=OmNbmLa0QhE4ptmuw88F+hcvZJqFZPkCjlQtfkHcuAo1kdsAgkWWqcjcvER0EzbEdi
         pGJYIOhSZEkhjerZL8A59b53g9s0uiAGI181qSKRDUW+g/3AglSm98ogUNpYiB8dO/Co
         aQELx44PzBCNknv/p+Ie/qduZ2iC8CGOSYtcWLY5qPhSBJnDSjt2ozZZrxn/8ZQ8cSvH
         p9zJ0Z9sO9bX4dFDxC50lUYFgS3PNU1s3XBTy/Gt4VmqpeVSk3V0e7WGRezOk15f9Fp7
         b0C5SJnPFRyGP94vybYG/rjhz89AapfO0t/KNkIATfRTRtQeEWDP/bFUELrpcmhdGOi1
         ygDg==
X-Gm-Message-State: AAQBX9fEX3YS66CzmxObkdxHwIw+/AgfZcPRC+5QHO8rIxz+r8+wGRFk
        sMceDYku/o/DE1gMa0Iq+nFMuWCjXlHmR+LKotHp/w==
X-Google-Smtp-Source: AKy350YDgk9Tjquv6GsRkI6Uwv9f+U7Az+Oi7TOJ1Ev/aEMu4DH9qJ6PJy7jJMkiSKY+kdLujLeynA==
X-Received: by 2002:a17:906:c450:b0:933:3cd8:a16f with SMTP id ck16-20020a170906c45000b009333cd8a16fmr1217750ejb.75.1680653847051;
        Tue, 04 Apr 2023 17:17:27 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id u25-20020a1709060b1900b0093e39b921c8sm6549649ejg.164.2023.04.04.17.17.26
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 17:17:26 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id eg48so136866421edb.13
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 17:17:26 -0700 (PDT)
X-Received: by 2002:a17:906:95cf:b0:933:f6e8:26d9 with SMTP id
 n15-20020a17090695cf00b00933f6e826d9mr690218ejy.15.1680653845958; Tue, 04 Apr
 2023 17:17:25 -0700 (PDT)
MIME-Version: 1.0
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
 <CAHk-=whe9kmyMojhse3cZ-zpHPfvGf_bA=PzNfuV0t+F5S1JxA@mail.gmail.com>
 <20230404183214.GG109974@frogsfrogsfrogs> <20230404233032.GL3223426@dread.disaster.area>
In-Reply-To: <20230404233032.GL3223426@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 Apr 2023 17:17:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgOjLLJ6PqTfnAbvrYXDUO1ifADKiP0D8R+D5n_XMXHgg@mail.gmail.com>
Message-ID: <CAHk-=wgOjLLJ6PqTfnAbvrYXDUO1ifADKiP0D8R+D5n_XMXHgg@mail.gmail.com>
Subject: Re: [PATCH 1/3] xfs: stabilize the tolower function used for ascii-ci
 dir hash computation
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 4, 2023 at 4:30=E2=80=AFPM Dave Chinner <david@fromorbit.com> w=
rote:
>
> Because of the inherent problems with CI and UTF-8 encoding, etc, it
> was decided that Samba would be configured to export latin1
> encodings as that covered >90% of the target markets for the
> product. Hence the "ascii-ci" casefolding code could be encoded into
> the XFS directory operations and remove all the overhead of
> casefolding from Samba.

Ahh. Ugh. All right, that at least explains the code.

Maybe this is documented somewhere, but I'm not finding anything
talking about that latin1 choice.

It may well have been just so obvious back in the day that people
didn't even bother saying so, and it's presumably close to what the
in-kernel tolower() has mostly done (even if that is probably a bad
thing).

I *would* ask that the xfs function that does "tolower" really then be
named "latin1". Not "ascii".

I'm not loving it, but hey, compatibility is certainly always a good reason=
.

               Linus
