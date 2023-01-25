Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEB9C54E94
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Jan 2023 11:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbjAYLJv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Jan 2023 06:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235668AbjAYLJl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2023 06:09:41 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D02A4ED39
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 03:09:40 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 200so13160393pfx.7
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 03:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=97WsFQuFDTXZ80Go3qg/RkB6NOUrVwTXg0uiEXA3yVM=;
        b=WX99hmGB/4H2KrrBZZSb2TlgkEbWCFx0bNfXnKXVAout5DmThbTCL5BFqZV083xcOQ
         y5NBCCoIM+xqQDTYQdXOje4venOndbvLf4637mQomSXTPiFEKTPHSEr7bCMqQFKuZvUe
         eDqaoI5dgXwf9raYnBwGHsm1w1Z1vx2MFKWITNe/ltVtnYSfCqujaFbkXHM+eIiOm5dw
         YEbQUlAMpt0ssV2TyLI7BR+RSZAZNKCobSXtUK7vt0vUfVZzf2/EcYm0ApWxGwnJIRx6
         ISlibNAJMtVTUBSbIxE0D4l+TOSAivaXQqp/BUHKbjB+t2BhtdIWeeNief6f0pMqB8eS
         WzbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=97WsFQuFDTXZ80Go3qg/RkB6NOUrVwTXg0uiEXA3yVM=;
        b=srGY7HmeZcLgx8wB7KN++35Bj7gF53Ehe36n9FtGKn4bWBqlEM+XVzmvDwVAIKXG30
         9CNOQDOIooikprDOzIRcVWCKWx+oTfA6KpghCdRn4GnVy2qtngobAR10EBU178XZHdgE
         YCAsEdObeBPmyXkhjkq2CpDB9AbY9PIrFax9pqJbEEDjyQQjyOKJAMcAhSw6xrr3a60s
         F9dDHla+SPG4EnuR/QQcckznXsq/khIebVLYHCZj2ipWdTNyovXTvYkTCEVjjw+q5BwF
         FEaai4mPkvmPVBkJruIqQYaTqtW+yMqhrWN8y24LFL/JjKLXCFNac1ys4PYkEPH3vq2u
         IJjA==
X-Gm-Message-State: AFqh2kpzGxK6G8pOcNGtGeaLQrv+YcPAmIM/4J9S6FWaDDm62IucU5Gd
        zQI9yfBWgjzmzKnYZlrGAT3HtYkxe4NeuPglnHO83/ES3zAIJw==
X-Google-Smtp-Source: AMrXdXuUmwl14a8jWJ4gPXsZuBo/0oC3/6km/xr+x8tszoqo1CfvPOy/OtXDjP9IU/szqfpSDqGG7TjDbnFxW0kEbtY=
X-Received: by 2002:a62:b618:0:b0:58d:e397:67a2 with SMTP id
 j24-20020a62b618000000b0058de39767a2mr3497798pff.9.1674644979547; Wed, 25 Jan
 2023 03:09:39 -0800 (PST)
MIME-Version: 1.0
References: <CAO8sHc=t1nnLrQDL26zxFA5MwjYHNWTg16tN0Hi+5=s49m5Xxg@mail.gmail.com>
 <Y9CLq0vtmwIDUl92@magnolia>
In-Reply-To: <Y9CLq0vtmwIDUl92@magnolia>
From:   Daan De Meyer <daan.j.demeyer@gmail.com>
Date:   Wed, 25 Jan 2023 12:09:28 +0100
Message-ID: <CAO8sHckmTuVktyoB6fT42ohTt-L41Gt3=E2wGhpydBfWbrtJ0g@mail.gmail.com>
Subject: Re: mkfs.xfs protofile and paths with spaces
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> ...

While a "-d" switch would be great to have, it'd also be great if we
could make the protofile format work with escaped spaces. That way we
can just add escaping for spaces in our tooling that calls mkfs.xfs
and we don't have to do ugly version checks on the mkfs binary version
to figure out which option to use.

On Wed, 25 Jan 2023 at 02:53, Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Mon, Jan 23, 2023 at 10:13:12PM +0100, Daan De Meyer wrote:
> > Hi,
> >
> > We're trying to use mkfs.xfs's "-p" protofile option for unprivileged
> > population of XFS filesystems. However, the man page does not specify
> > how to encode filenames with spaces in them. Spaces are used as the
> > token delimiter so I was wondering if there's some way to escape
> > filenames with spaces in them?
>
> Spaces in filenames apparently weren't common when protofiles were
> introduced in the Fourth Edition Unix in November 1973[1], so that
> wasn't part of the specification for them:
>
>     "The prototype file contains tokens separated by spaces or new
>      lines."
>
> The file format seems to have spread to other filesystems (minix, xenix,
> afs, jfs, aix, etc.) without anybody adding support for spaces in
> filenames.
>
> One could make the argument that the protofile parsing code should
> implicitly 's/\// /g' in the filename token since no Unix supports
> slashes in directory entries, but that's not what people have been
> doing for the past several decades.
>
> At this point, 50 years later, it probably would make more sense to
> clone the mke2fs -d functionality ("slurp up this directory tree") if
> there's interest?  Admittedly, at this point it's so old that we ought
> to rev the entire format.
>
> [1] https://dspinellis.github.io/unix-v4man/v4man.pdf (page 274)
> or https://man.cat-v.org/unix-6th/8/mkfs
>
> --D
>
> > Cheers,
> >
> > Daan De Meyer
