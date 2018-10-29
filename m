Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39409 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729058AbeJ2Pox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Oct 2018 11:44:53 -0400
MIME-Version: 1.0
References: <CAE5jQCc3hrq6E-Ff1oiYUOSDA08PMrqnu80XQtaD5adcUQvV8w@mail.gmail.com>
 <20181029012058.GK19305@dastard>
In-Reply-To: <20181029012058.GK19305@dastard>
From: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Date: Mon, 29 Oct 2018 09:57:20 +0300
Message-ID: <CAE5jQCeT4hONkK8cmkMoReoW-HqVLqnYN6c3YrxDjwNAf=nfEA@mail.gmail.com>
Subject: Re: XFS: Hang and dmesg flood on mounting invalid FS image
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

> How did the corruption occur?

It is a fuzzed image. Most probably, it was artificially "patched" by
fuzzer. Or do you mean "what particular bytes were changed"?

Best regards
Anatoly
=D0=BF=D0=BD, 29 =D0=BE=D0=BA=D1=82. 2018 =D0=B3. =D0=B2 4:32, Dave Chinner=
 <david@fromorbit.com>:
>
> On Sun, Oct 28, 2018 at 08:50:46PM +0300, Anatoly Trosinenko wrote:
> > Hello,
> >
> > When mounting a broken XFS image, the kernel hangs and floods dmesg
> > with stack traces.
>
> How did the corruption occur?
>
> $ sudo xfs_logprint -d /dev/vdc
> xfs_logprint:
>     data device: 0xfd20
>     log device: 0xfd20 daddr: 131112 length: 6840
>
>      0 HEADER Cycle 1 tail 1:000000 len    512 ops 1
> [00000 - 00000] Cycle 0xffffffff New Cycle 0x00000001
>      2 HEADER Cycle 1 tail 1:000002 len    512 ops 5
>      4 HEADER Cycle 1 tail -2147483647:000002 len    512 ops 1
>                            ^^^^^^^^^^^^
>      6 HEADER Cycle 0 tail 1:000000 len      0 ops 0
> [00000 - 00006] Cycle 0x00000001 New Cycle 0x00000000
>      7 HEADER Cycle 0 tail 1:000000 len      0 ops 0
>
> Ok, so from this the head of the log is block 4, and it has a
> corrupt tail pointer it points to:
>
>
> $ sudo xfs_logprint -D -s 4 /dev/vdc |head -10
> xfs_logprint:
>     data device: 0xfd20
>     log device: 0xfd20 daddr: 131112 length: 6840
>
> BLKNO: 4
>  0 bebaedfe  1000000  2000000    20000  1000000  3610000  1000080  200000=
0
>                                                  ^^^^^^^       ^   ^
>                                                  wrong       wrong wrong
>
>  8 2f27bae6  2000000  1000000 dabdbab0        0        0        0        =
0
> 10        0        0        0        0        0        0        0        =
0
> 18        0        0        0        0        0        0        0        =
0
> 20        0        0        0        0        0        0        0        =
0
>
> They decode as:
>
> cycle: 1        version: 2              lsn: 1,24835    tail_lsn: 2147483=
649,2
>
> So the tail LSN points to an invalid log cycle and the previous
> block. IOWs, the block number in the tail indicates the whole log is
> valid and needs to be scanned. but the cycle is not valid.
>
> And that's the problem. Neither the head or tail blocks are
> validated before they are used. CRC checking of the head and tail
> blocks comes later....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
