Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B52C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Dec 2021 01:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhLICC2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Dec 2021 21:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhLICC2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Dec 2021 21:02:28 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11AFC061746
        for <linux-xfs@vger.kernel.org>; Wed,  8 Dec 2021 17:58:55 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id i12so4040343pfd.6
        for <linux-xfs@vger.kernel.org>; Wed, 08 Dec 2021 17:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L1T5kw0pZcNts8FOP/PfwU4eyj9hIko4e2Jf8qhaR54=;
        b=Am1lWsGbBD8k6Gs6ODuIUg2RL/OgQkiCvVyy+TGCnSjjaya/C4UIEKYczYZJInND5q
         NEzMQSYXefk8ofo6cX1eYWFf2M2u+mDOgvBGYc3A6CY5UsLMIfWle8rnVwAT/EMp+XMg
         ifeiXM1HzJSNTrIpPCZCNL4yKEhvyICcW2qRrW0Lm7Mv9lRiMb9GjV7EfoQri/pY4miw
         BX6KoiLnmZel7/Tf1dRQguVFSpFyshdj4rnQrdiNlmyR8RTeMPZtRbV39xo3Uw5kv6Kn
         rycicUNV+7xlGGVNkkM0OfwBaIMyB6/tQG+z5NoPSHzta5JiglKPceqAoC+2B9Qd6s/L
         NjHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L1T5kw0pZcNts8FOP/PfwU4eyj9hIko4e2Jf8qhaR54=;
        b=ImWTfOwxN9b0X2HKTXs2gXUbs313qaDnM6jMXPxp7OlOwyhCMxgI4DNLEOkwrvbNov
         OQndGM+poNa3Ga87PjRdoMeSiS5UurEzYVtpJ6xnhfLvD35CcJ37tb5k7i68wqRzac6o
         p1B1D1tUJtGCon/RRKbiuMU8gs1HElBRQB3SnfCvW4lb+N2PCjEr/HsSyz8nXSCCjYmz
         68UOR/iJp5GIXGylxTqv7lP5ffdBQ2Metv9IBaTu+w9/TW5KfgDiODJcSe01er7Ig6NI
         r6VRpH0xD++WrQWzDGAFoEIzA+hK5pbt/D0GoX/F7vloZv7u8gF6NvV44mx4zD3BvgPi
         Wf2w==
X-Gm-Message-State: AOAM531jMxvm0TEi6eKeB1FGkZetAntxG93G272ZauJ/dMYkZJzx7SxJ
        7UN80ADWG+tI4jVFz87bVnVNnc+k7bK/mJVyXYpj3A==
X-Google-Smtp-Source: ABdhPJzAnoM9tgR/eh2HsITyJR3hItduz1eHZo9++I+GO7sFsnQRiKr7UiulUnv9YeK06rwF3wnyl2FTdM1vcsOiXQ8=
X-Received: by 2002:a63:c052:: with SMTP id z18mr29045322pgi.74.1639015135135;
 Wed, 08 Dec 2021 17:58:55 -0800 (PST)
MIME-Version: 1.0
References: <20211208091203.2927754-1-hch@lst.de> <20211209004846.GA69193@magnolia>
 <20211209005559.GB69193@magnolia>
In-Reply-To: <20211209005559.GB69193@magnolia>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 8 Dec 2021 17:58:43 -0800
Message-ID: <CAPcyv4g3OG3cSpOEm9J1HLZjzRBhSWotSyV5RZxt5FYV_0=Knw@mail.gmail.com>
Subject: Re: [PATCH] iomap: turn the byte variable in iomap_zero_iter into a ssize_t
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 8, 2021 at 4:56 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Wed, Dec 08, 2021 at 04:48:46PM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 08, 2021 at 10:12:03AM +0100, Christoph Hellwig wrote:
> > > bytes also hold the return value from iomap_write_end, which can contain
> > > a negative error value.  As bytes is always less than the page size even
> > > the signed type can hold the entire possible range.
> > >
> > > Fixes: c6f40468657d ("fsdax: decouple zeroing from the iomap buffered I/O code")
>
> ...waitaminute, ^^^^^^ in what tree is this commit?  Did Linus merge
> the dax decoupling series into upstream without telling me?
>
> /me checks... no?
>
> Though I searched for it on gitweb and came up with this bizarre plot
> twist:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c6f40468657d16e4010ef84bf32a761feb3469ea
>
> (Is this the same as that github thing a few months ago where
> everybody's commits get deduplicated into the same realm and hence
> anyone can make trick the frontend into sort of making it look like
> their rando commits end up in Linus' tree?  Or did it get merged and
> push -f reverted?)
>
> Ok, so ... I don't know what I'm supposed to apply this to?  Is this
> something that should go in Christoph's development branch?
>
> <confused, going to run away now>
>
> On the plus side, that means I /can/ go test-merge willy's iomap folios
> for 5.17 stuff tonight.

This commit is in the nvdimm.git tree and is merged in linux-next.
