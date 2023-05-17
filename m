Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D61B6C77B75
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 12:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjEQMsY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 08:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjEQMsU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 08:48:20 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5254E1FC2
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 05:48:17 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id 71dfb90a1353d-44ffef66dabso524301e0c.2
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 05:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684327696; x=1686919696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+sP0kp6U+Lt8lpOjCMXvxhkktltBy0myNm15y0RKMk8=;
        b=Jq9jIvtwFzetoSbT/H5PaVdWRsrv22a/A0M5Zq/+/V2NqLm02RC/EIm7vNjfQIkGx5
         8fHGJCo2g/KHjFtYz8vtg9+m9UUFoqaag54vGorxZW0bC5GuztyTkUHcc9kY+JOTSvFV
         Q5JS/42CZNeJuBY6R/WtujVzYWvmmWGww2LkDI1sedJuoJH8LzdMwWf8CxjcmMzu2VNy
         pcdUCR83FKssevHzy7WiwjtKCIr+7MCGaSufva7aCIuY9mZUp5Sloy7ZwcKtol6AW1PF
         ql0RkUqvkovEdrlKElYzodbk/2Pog66KEor6DQ51eurJvu+gYejfi03iCn6G2LZzyBHh
         J5bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684327696; x=1686919696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+sP0kp6U+Lt8lpOjCMXvxhkktltBy0myNm15y0RKMk8=;
        b=Cqw1yU59OAv6MmtIcU2CO3m6Dyaa09pZP63JZ+/DbWXG8+pI0UEjCa87ZI7LkkNUI8
         Oi3sRI2PkwRDxFF8ZShbK0R8j37GwPaz5bzFSmIUTwHbaRIC9nEqymuYIFxkNIfY8GB0
         JTGd7jdUI8/AKVLOikXmNGeWGfmYZdocTBviezR0N78/l2EubrEQq72dvMjeDGCizTcF
         2hGOvOu+jtlIPVu3iPfohP7PyzgkTlK9PVXnVDI++b0Kc+6QMA4b5ncL3SV6Uiu6O3h+
         VAJOG/oP+cSNWqJyWFi/azHOn0NV4Ueuej78ufti4T0H/3WkM0i1Tf9KB7fs3rudlRTu
         WnxA==
X-Gm-Message-State: AC+VfDwe0rfPfv1t8n52JYB6FkK37ZikqwkFyScJEdYr9xb1WlKlFwJf
        KtqDLTgTnlJhZab1IPjDzLOzujHp1Hj63Num3KYBXQ3c
X-Google-Smtp-Source: ACHHUZ4JToWEaRNigSP25hrH2G4horWzuVBtKkq0HjzkNbuyMhhqBJy5opLun5l/c4jYzfEqMYA12xqNhAgqIOLZK3Q=
X-Received: by 2002:a67:f698:0:b0:434:7357:deb with SMTP id
 n24-20020a67f698000000b0043473570debmr14818343vso.10.1684327696392; Wed, 17
 May 2023 05:48:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230517000449.3997582-1-david@fromorbit.com> <CAOQ4uxiJ-sYPpGcPpVzz0hScUNdZ4bs8=GUsncNOXdeEAOCaCQ@mail.gmail.com>
 <ZGS7yaaI7knS0QdM@dread.disaster.area>
In-Reply-To: <ZGS7yaaI7knS0QdM@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 17 May 2023 15:48:05 +0300
Message-ID: <CAOQ4uxigoSsir8XoMNmyzfP9wpTcCG1T7YcV+VgPHLpWhPOAJA@mail.gmail.com>
Subject: Re: xfs: bug fixes for 6.4-rcX
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <lrumancik@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 17, 2023 at 2:34=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Wed, May 17, 2023 at 10:07:55AM +0300, Amir Goldstein wrote:
> > On Wed, May 17, 2023 at 3:08=E2=80=AFAM Dave Chinner <david@fromorbit.c=
om> wrote:
> > >
> > > Hi folks,
> > >
> >
> > Hi Dave,
> >
> > > The following patches are fixes for recently discovered problems.
> > > I'd like to consider them all for a 6.4-rc merge, though really only
> > > patch 2 is a necessary recent regression fix.
> > >
> > > The first patch addresses a long standing buffer UAF during shutdown
> > > situations, where shutdown log item completions can race with CIL
> > > abort and iclog log item completions.
> > >
> >
> > Can you tell roughly how far back this UAF bug goes
> > or is it long standing enough to be treated as "forever"?
>
> Longer than I cared to trace the history back.
>
> > > The second patch addresses a small performance regression from the
> > > 6.3 allocator rewrite which is also a potential AGF-AGF deadlock
> > > vector as it allows out-of-order locking.
> > >
> > > The third patch is a change needed by patch 4, which I split out for
> > > clarity. By itself it does nothing.
> > >
> > > The fourth patch is a fix for a AGI->AGF->inode cluster buffer lock
> > > ordering deadlock. This was introduced when we started pinning inode
> > > cluster buffers in xfs_trans_log_inode() in 5.8 to fix long-standing
> > > inode reclaim blocking issues, but I've only seen it in the wild
> > > once on a system making heavy use of OVL and hence O_TMPFILE based
> > > operations.
> >
> > Thank you for providing Fixes and this summary with backporing hints :)
>
> I don't think you're going to be able to backport the inode cluster
> buffer lock fix. Nothing prior to 5.19 has the necessary
> infrastructure or the iunlink log item code this latest fix builds
> on top of. That was done to fix a whole class of relatively easy to
> hit O_TMPFILE related AGI-AGF-inode cluster buffer deadlocks.  This
> fix avoids an entirely different class of inode cluster buffer
> deadlocks using the infrastructure introduced in the 5.19 deadlock
> fixes.
>

Even better. Less work for us ;)

Thanks,
Amir.
