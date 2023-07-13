Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A562EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 04:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbjGMEre (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 00:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbjGMEre (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 00:47:34 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561041FFC
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 21:47:32 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id ada2fe7eead31-44504b2141bso141478137.2
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 21:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689223651; x=1691815651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LpNgB1voI7hKdia0fRjNp1lEKpj6n51ToXzdpFUT0lw=;
        b=RaE7vW4ZwEM++IRvRVCFG/T6dB4B6LosZt/IVa4qNiK1SFSVVf8/DGO2h9kG/F7CxP
         16AQuMi5znDibf9N66nk3aVL7GL7nZjSC+ZqvK+OY6PaUmWYTa49mmFO+SNCIG/AQjNK
         dGLZbHman/uEG2qnbyORtYP5voYsJ9d6xPKaoYEj4IMPeF1hDqC2oXRvskxOCJWL44zW
         hPwybJjP/hCZZ4a+WkaHnIQyas/oSMNop2He4R/C1HRgLWy/U0evea4eojfJ6POVgM7Z
         AH9wv26HdPl7SsU1anYKHAcFF3RrERPL1olAG7X2xoTZKR+nqlXiUEknH5f0TD6IzE22
         WnAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689223651; x=1691815651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LpNgB1voI7hKdia0fRjNp1lEKpj6n51ToXzdpFUT0lw=;
        b=i+kJwfrK4vzm3BfdsG40r5iLtXtop1m+uomnYADaAZqF5sNw+XNYd2TBdtwqMkkceg
         VdnY81S6/2vgledCzo29lzGPkV/Mm0k9lJBd2wUTCIy/jAWjJrVofehlZ330T1djQrDN
         hiiluS2S6x0IsLMCidZ7eHntErHXZY5kHm6UOezhr7UkYk1hNKqO18uvR7GIoSd2UV9G
         cLP5KE6Q9uAYH7/PwRrN0tKCzKNu/FsqvDuMSUOCRa8JwwIbzBLQr6FARDBU6D6uMwyc
         BLoBkuZRJFAJoCorS5bqnC0g0sqedqRhGsb4UuaospEIbkYhEN4Yftf4WMHYMLIvWGFH
         xP9Q==
X-Gm-Message-State: ABy/qLbkvxaBA3GBHRA+LFVOrDVmPlpLhdxgke7GLi4ZtKilTnCZmUIx
        c4TdjmY1+MWq6+VQ7MyHw44VDyjwjsW5RB1NCgOkrHWi
X-Google-Smtp-Source: APBJJlEE23ssOlNhy8BzREq5ifes6eoCzMgdO5iVzk1kU4sz0vOpGi9F+jdI4h7P1o8tyXVL1wAiXpoYrs3Ads/3qwg=
X-Received: by 2002:a67:fc41:0:b0:443:8549:163e with SMTP id
 p1-20020a67fc41000000b004438549163emr277888vsq.34.1689223651293; Wed, 12 Jul
 2023 21:47:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230712094733.1265038-1-amir73il@gmail.com> <20230712154453.GE108251@frogsfrogsfrogs>
In-Reply-To: <20230712154453.GE108251@frogsfrogsfrogs>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 13 Jul 2023 07:47:20 +0300
Message-ID: <CAOQ4uxhJuhLfk9WhkJ+bZtmk+9qwci1-AF=yMeFevvx1n_nANg@mail.gmail.com>
Subject: Re: [PATCH 6.1 CANDIDATE 0/3] xfs inodegc fixes for 6.1.y (from v6.4)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 6:44=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Wed, Jul 12, 2023 at 12:47:30PM +0300, Amir Goldstein wrote:
> > Darrick,
> >
> > These are the patches we discussed that Leah requested for the 5.15.y
> > backport of non-blocking inodegc pushes series [1].
> >
> > They may or may not help the 5.15.y -> 6.1.y regression that was
> > reported by Chris [2].
> >
> > Note that I did not include:
> > 2d5f38a31980 ("xfs: disable reaping in fscounters scrub")
> > in this backport set, because I generally do not want to deal with
> > backporting fixes for experimental features.
>
> I don't agree with this decision because the comment for
> xfs_inodegc_stop now says that callers must hold s_umount.
> xchk_stop_reaping definitely does /not/ hold that lock, which means it's
> now buggy.  Someone downstream could be using scrub, even if it's still
> experimental.
>
> I've generally said not to bother with scrub fixes, but I don't think
> it's correct to introduce a bug in an LTS kernel.  Please backport
> 2d5f38a31980 since all it does is removes the offending call and turns
> off code in fscounters.c.
>

Makes sense.
Will do.

Thanks,
Amir.
