Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 253F7C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 08:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiFHIhh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 04:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiFHIgJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 04:36:09 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2254514AF4A
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jun 2022 00:56:36 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id 90so6641247uam.8
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jun 2022 00:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gnto89XOKt+hyq37gx9BINxvc51J1AW5aQpldrLwhGs=;
        b=q3ppcw0Scp/59RxYx+cE7jiYq1JLRArwwpJX4b2ETEsLcCTxbl2pU4273KnwDJUtXR
         M7EPCVJGluhMjUT80pEU6qSBerGSbXCZQjBVeAsmY9ynFPFi3Nn954gu/4suiMEL7iaa
         ZsxXInq29NzcRvrLV7bKo6hmDfg0M8qteOeuUjezEgXg99YdZcraIqtgesInNTjQrbay
         2mO3FdQnOlmglsIISUyuXQPzdzpxLlKQ8nyGY72uH1tA8R1OEQiJV16dYH+LGtpWpERg
         4dDKgILmuGF9XWHikEzLAavUJZALRHNEcydIYqO8YSW9Zd7jlX5MzFyAk1R1TyodCwVE
         00Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gnto89XOKt+hyq37gx9BINxvc51J1AW5aQpldrLwhGs=;
        b=lsWmtc4NOkGa63tIsXD3YZzGe/o3fMV709tR0CAUuzYnplL/lrctJy2SlyIZuLpMjo
         6IkLjpf543hvHir48Xoy3sW2UWp5b5kuPa+PRHNzzwzrgZ0LM20LYLqlViGbyuYVG8Vu
         SL37BHv90X0gIp2vpRfPTgD45Au8O8XQKdoBHkSAxN2Bpq0f5t2IwVna9RHe9SRMphQI
         GKh4KaHv104Adw7zoEw0NKQc0cyxXyLSU1RCSFOeaCVJw10CjAhygLebBaQUb/UFU39c
         R0oilUIoUivK5TilxRe7wJR2STovwbzhTTu2GBV9kmB71nakORXWX4rxFhO9ldwVNJSR
         amsQ==
X-Gm-Message-State: AOAM531/NKhbKiJ9ZKEG+5JYvjcKRVFbIBTAoX5VUq5mRv/SnP83sy6s
        ROW0jVFM9h14svgIzpp3kOB6p5+KokD6TjcjCs8=
X-Google-Smtp-Source: ABdhPJyuVz/EuT8VhtNOl+4+ZOa7GiTOmuI3+v4sDwKWgb7fVX8E0muDCfqZPh1eANi1Se4AAOMvtnjkudW4ahcWIdg=
X-Received: by 2002:ab0:3da8:0:b0:35d:1e90:ee26 with SMTP id
 l40-20020ab03da8000000b0035d1e90ee26mr36492833uac.80.1654674988117; Wed, 08
 Jun 2022 00:56:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220603184701.3117780-1-leah.rumancik@gmail.com>
 <CAOQ4uxjzq1BQeO3-BkzLVKi8=95ohVU-UHJhR_zWZze5O_G=gA@mail.gmail.com> <Yp48nGoE0cbdbteU@google.com>
In-Reply-To: <Yp48nGoE0cbdbteU@google.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 8 Jun 2022 10:56:17 +0300
Message-ID: <CAOQ4uxhJfcZQcy0xNBi2Fp7e+z4V9CAqEW26f8ZxctruN0tFFQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/15] xfs stable candidate patches for 5.15.y
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 6, 2022 at 8:42 PM Leah Rumancik <leah.rumancik@gmail.com> wrote:
>
> On Sat, Jun 04, 2022 at 11:38:35AM +0300, Amir Goldstein wrote:
> > On Sat, Jun 4, 2022 at 6:53 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> > >
> > > From: Leah Rumancik <lrumancik@google.com>
> > >
> > > This first round of patches aims to take care of the easy cases - patches
> > > with the Fixes tag that apply cleanly. I have ~30 more patches identified
> > > which will be tested next, thanks everyone for the various suggestions
> > > for tracking down more bug fixes. No regressions were seen during
> > > testing when running fstests 3 times per config with the following configs:
> >
> > Hi Leah!
> >
> > I'll let the xfs developers comment on the individual patches.
> > General comments about stable process and collaboration.
> >
> > Some of the patches in this series are relevant to 5.10 and even apply
> > cleanly to 5.10 (see below).
> > They are in my queue but I did not get to test them thoroughly yet,
> > because I am working chronologically.
> >
> > To avoid misunderstanding with stable maintainers, when you post to
> > stable, please make sure to state clearly in the cover letter that those
> > patches have only been tested on 5.15.y and should only be applied
> > to 5.15.y.
> > I know you have 5.15 in subject, but I would rather be safe than sorry.
>
> Fair concern, will do.
>
> >
> > Luis has advised me to post up to 10 patches in each round.
> > The rationale is that after we test and patches are applied to stable
> > regressions may be detected and reported by downstream users.
> >
> > Regressions will be easier to bisect if there are less fixes in every
> > LTS release. For this reason, I am holding on to my part 2 patches
> > until 5.10.120 is released. LTS releases are usually on weekly basis
> > so the delay is not much.
> >
> > I don't think that this series is terribly big, so I am fine with you
> > posting it at one go, but please consider splitting it pre 5.16
> > and post 5.16 or any other way that you see fit when you post
> > to stable, but let's wait for xfs developers review - if they tell you to
> > drop a few patches my comment will become moot ;-)
> >
>
> Sure, that is no problem for me, I'll go ahead and split into sets of 10
> or fewer.
>

FWIW, the following subset of your 5.15 patches (or backported version thereof)
have been sitting in my xfs-5.10.y-8 tag since Saturday and have been
spinning in kdevops since (~20 auto runs) with no regressions observed
from v5.10.y baseline:

xfs: punch out data fork delalloc blocks on COW writeback failure
xfs: remove all COW fork extents when remounting readonly
xfs: prevent UAF in xfs_log_item_in_current_chkpt
xfs: only bother with sync_filesystem during readonly remount
xfs: use setattr_copy to set vfs inode attributes
xfs: check sb_meta_uuid for dabuf buffer recovery
xfs: use kmem_cache_free() for kmem_cache objects
xfs: Fix the free logic of state in xfs_attr_node_hasname

So perhaps you could use that as the smaller subset for first posting.
To reduce review burden on xfs maintainers, I could break out of the
chronological patches order and use the same subset for my next set
of candidates for 5.10 after testing them in isolation on top of xfs-5.10.y-3
(at least the ones that apply out of order).

Thanks,
Amir.
