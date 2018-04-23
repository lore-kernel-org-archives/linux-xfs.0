Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:33329 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750756AbeDWE1B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Apr 2018 00:27:01 -0400
Received: by mail-qk0-f178.google.com with SMTP id c70so6046414qkg.0
        for <linux-xfs@vger.kernel.org>; Sun, 22 Apr 2018 21:27:01 -0700 (PDT)
From: Kirubakaran Kaliannan <kirubak@zadarastorage.com>
References: <c126c0a025db7e4011b4461c1ff26601@mail.gmail.com> <20180413154313.GC32099@magnolia>
In-Reply-To: <20180413154313.GC32099@magnolia>
MIME-Version: 1.0
Date: Mon, 23 Apr 2018 09:56:58 +0530
Message-ID: <3bd0697599c117cfd4db6431a2cba270@mail.gmail.com>
Subject: RE: statvfs() return large f_bavail on a 10TB drive
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Hi Darrick,

Yes this looks like the bitflip !
Do you have seen any occurrence of this before or maybe something related t=
o
a in-memory corruption ?

Thaks
-kiru

-----Original Message-----
From: Darrick J. Wong [mailto:darrick.wong@oracle.com]
Sent: Friday, April 13, 2018 9:13 PM
To: Kirubakaran Kaliannan
Cc: linux-xfs@vger.kernel.org
Subject: Re: statvfs() return large f_bavail on a 10TB drive

On Fri, Apr 13, 2018 at 12:10:19PM +0530, Kirubakaran Kaliannan wrote:
> Hi All,
>
> I have couple of  xfs filesystem  on a 10TB STAT drive.
>
> After 50% of filesystem is full, the df =E2=80=93kH is returning a large =
f_bavail.
>
>
> Filesystem                   Size  Used Avail Use% Mounted on
> /dev/dm-4                     10T  -12T   22T    - /mnt/a
> /dev/dm-3                     10T  -12T   22T    - /mnt/b
>
> I tried statvfs() and got the same large f_bavail as well,
>
>         total filesystem size =3D 9763506176 KB
>         total Available size =3D 21279656740 KB

21279656740KB =3D 0x100000000000 | (about 50% of the space) ?

Bitflip?

--D

>         total used size =3D -11516150564 KB
>
> We are using Ubuntu 3.18.19 Linux kernel/xfs.
>
> If I unmount and mount the filesysem back, the f_bavail values are back t=
o
> normal.
>
> Can you please point me, if this is something a known issue got fixed in
> XFS in the later version, or any lead may help.
> It is difficult at this point of time to upgrade the XFS for this specifi=
c
> issue.
>
> Thanks,
> -kiru
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
