Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46693C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 15:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 196C020709
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 15:44:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t+yHCYnp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbfKTPoD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 10:44:03 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45612 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729330AbfKTPoC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 10:44:02 -0500
Received: by mail-lj1-f194.google.com with SMTP id n21so27976750ljg.12
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2019 07:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6KZe0VuEQfT5FVik0sUCEHYgZe2g86bETOKRlARFyRI=;
        b=t+yHCYnpYiGG2Bl4B/0glEWkH0mNuTDBizLH23BsNHpQBkvY+exeMBYQKxe8c6Izwd
         1X3QLTmmkEvdwCb4FHRHbSNtFN0OzkvrhvKKdQk/Jg7uoVXrseXTp6WYoV8zKhCKmx8X
         euBYIXsDQ4DpOzlmKAhx/1EW4CPVpfIDNwS58IlAlxmX+6HmW3KVv6bUqlg389vgk7XL
         SB6V9ROnp7bTqKIMT1N7uFQXK+DsDZv9nye09gMCZ3wuAXDzb3cDblnTJe/CZrqK7YTK
         rISiDyxdAj7eFyNhVWpmDaJ7RYI2zHyEWGdyCT5koXW+y+qS7gzPscsmsmOSwOn+cDKu
         E0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6KZe0VuEQfT5FVik0sUCEHYgZe2g86bETOKRlARFyRI=;
        b=szc4HVT3XAUceL7rcT5RaxZHlqNvehHuIlSHFmGPixAjyVt+GM1XrZXohVbgsWtD4+
         cV/MXjbARYjMBlvklZR/adCyLhrluP5Uq9AAVUiTCFOrJjmjEdns9MF4eW0mf7ubsOrS
         FkbxHst0Kvi3ByViNg87v/DLAr/SLcWOecx8WMIhaxhsQE6bLd2hSwpEE52ec7wEFZlq
         y1VvlvpWMrtmq+30n1o43H1/I2d2UQCXImcJY7aOoF7NeeYqO8MmCxh1HIz5xemHPazi
         sO6zmeT/WYY9n5dBpPgP9pJVxI0xnmkelHoZNZ7zyspJuikjoNagmCD/XEzj1bPXE+3N
         bOIQ==
X-Gm-Message-State: APjAAAW4EhaJhGNUkIq9W4nZgd1Bh71BzV+cKni+E+6PFcO+GdxFPBxi
        CdFAh8ky7PsbT+AAV1rWD1CSaJSiILPpVfA3TmGYvm+B
X-Google-Smtp-Source: APXvYqz/ItjmKqQ710E6OArzq90Juf6Onxi9OPGPaEasK3raASlW/ZR/G7wlST5kYrB4neaNdt6im3xsgoZKZjEFdTo=
X-Received: by 2002:a2e:9097:: with SMTP id l23mr3383820ljg.103.1574264639904;
 Wed, 20 Nov 2019 07:43:59 -0800 (PST)
MIME-Version: 1.0
References: <CAKQeeLMxJR-ToX5HG9Q-z0-AL9vZG-OMjHyM+rnEEBP6k6nxHw@mail.gmail.com>
 <CAKQeeLNewDe6hu92Tu19=Opx_ao7F_fbpxOsEHaUH9e2NmLWaQ@mail.gmail.com>
 <e6222784-03a5-6902-0f2e-10303962749c@sandeen.net> <20191115234333.GP4614@dread.disaster.area>
 <CAKQeeLNm51r0g=hyH7xpe811nMTS7SP_AwAtAZMCZ0t3Fz4=4Q@mail.gmail.com>
 <CAKQeeLPzked5nptbF6HKdt=u_LkOU-RqOQ8V0r1f7PBS1xWejQ@mail.gmail.com> <20191119202038.GX4614@dread.disaster.area>
In-Reply-To: <20191119202038.GX4614@dread.disaster.area>
From:   Andrew Carr <andrewlanecarr@gmail.com>
Date:   Wed, 20 Nov 2019 10:43:48 -0500
Message-ID: <CAKQeeLMnkvx94ssht-nt0S8eU1uCFqVL4w2yxwY4M5X59RSROA@mail.gmail.com>
Subject: Re: Fwd: XFS Memory allocation deadlock in kmem_alloc
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Genius Dave, Thanks so much!

On Tue, Nov 19, 2019 at 3:21 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Nov 19, 2019 at 10:49:56AM -0500, Andrew Carr wrote:
> > Dave / Eric / Others,
> >
> > Syslog: https://pastebin.com/QYQYpPFY
> >
> > Dmesg: https://pastebin.com/MdBCPmp9
>
> which shows no stack traces, again.
>
>
>
> Anyway, you've twiddled mkfs knobs on these filesystems, and that
> is the likely cause of the issue: the filesystem is using 64k
> directory blocks - the allocation size is larger than 64kB:
>
> [Sun Nov 17 21:40:05 2019] XFS: nginx(31293) possible memory allocation d=
eadlock size 65728 in kmem_alloc (mode:0x250)
>
> Upstream fixed this some time ago:
>
> $ =E2=96=B6 gl -n 1 -p cb0a8d23024e
> commit cb0a8d23024e7bd234dea4d0fc5c4902a8dda766
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Tue Mar 6 17:03:28 2018 -0800
>
>     xfs: fall back to vmalloc when allocation log vector buffers
>
>     When using large directory blocks, we regularly see memory
>     allocations of >64k being made for the shadow log vector buffer.
>     When we are under memory pressure, kmalloc() may not be able to find
>     contiguous memory chunks large enough to satisfy these allocations
>     easily, and if memory is fragmented we can potentially stall here.
>
>     TO avoid this problem, switch the log vector buffer allocation to
>     use kmem_alloc_large(). This will allow failed allocations to fall
>     back to vmalloc and so remove the dependency on large contiguous
>     regions of memory being available. This should prevent slowdowns
>     and potential stalls when memory is low and/or fragmented.
>
>     Signed-Off-By: Dave Chinner <dchinner@redhat.com>
>     Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



--=20
With Regards,
Andrew Carr

e. andrewlanecarr@gmail.com
w. andrew.carr@openlogic.com
c. 4239489206
a. P.O. Box 1231, Greeneville, TN, 37744
