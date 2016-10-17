Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35406 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757570AbcJQMNU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 08:13:20 -0400
MIME-Version: 1.0
In-Reply-To: <20161017120843.GA9906@infradead.org>
References: <1476699404-5977-1-git-send-email-geert@linux-m68k.org> <20161017120843.GA9906@infradead.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 17 Oct 2016 14:13:17 +0200
Message-ID: <CAMuHMdWXQ0ms2wBheK=_h2QdyUvTJbyUUpB6rDcP0Xc6QW8xFw@mail.gmail.com>
Subject: Re: [PATCH] xfs: Fix uninitialized variable in xfs_reflink_reserve_cow_range()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi Christoph,

On Mon, Oct 17, 2016 at 2:08 PM, Christoph Hellwig <hch@infradead.org> wrot=
e:
> On Mon, Oct 17, 2016 at 12:16:44PM +0200, Geert Uytterhoeven wrote:
>> with gcc 4.1.2:
>>
>>     fs/xfs/xfs_reflink.c: In function =E2=80=98xfs_reflink_reserve_cow_r=
ange=E2=80=99:
>>     fs/xfs/xfs_reflink.c:327: warning: =E2=80=98error=E2=80=99 may be us=
ed uninitialized in this function
>>
>> Indeed, if "count" is zero, the function will return an uninitialized
>> error value.
>>
>> While "count" is unlikely to be zero, this function is called through
>> the public iomap API. Hence fix this by preinitializing error to zero.
>
> The iomap API should never call in with a zero count, but I think the
> initialization is a fine safety net anyway:

Exactly my thought.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

> Btw, what compiler did you get this from?  I haven't seen it, but then
> again I recently missed a lot of initializers without compiler warnings,
> so either something changed in the Debian stable gcc or our build
> system recently..

m68k-linux-gnu-gcc version 4.1.2 20061115 (prerelease) (Ubuntu 4.1.1-21)

Stoneage, but it did find 4 real bugs introduced in v4.9-rc1...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
