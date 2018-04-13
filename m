Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:42138 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750761AbeDMGkV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Apr 2018 02:40:21 -0400
Received: by mail-yw0-f182.google.com with SMTP id z82so3696989ywd.9
        for <linux-xfs@vger.kernel.org>; Thu, 12 Apr 2018 23:40:21 -0700 (PDT)
From: Kirubakaran Kaliannan <kirubak@zadarastorage.com>
References: ac41fcc0ce75c5d9621e03adeb9695bc@mail.gmail.com
In-Reply-To: ac41fcc0ce75c5d9621e03adeb9695bc@mail.gmail.com
MIME-Version: 1.0
Date: Fri, 13 Apr 2018 12:10:19 +0530
Message-ID: <c126c0a025db7e4011b4461c1ff26601@mail.gmail.com>
Subject: statvfs() return large f_bavail on a 10TB drive
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi All,

I have couple of =C2=A0xfs filesystem =C2=A0on a 10TB STAT drive.

After 50% of filesystem is full, the df =E2=80=93kH is returning a large f_=
bavail.


Filesystem=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Size=C2=A0 Used Avail Use% Mou=
nted on
/dev/dm-4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 10T=C2=A0 -12T=C2=A0=
=C2=A0 22T=C2=A0=C2=A0=C2=A0 - /mnt/a
/dev/dm-3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 10T=C2=A0 -12T=C2=A0=
=C2=A0 22T=C2=A0=C2=A0=C2=A0 - /mnt/b

I tried statvfs() and got the same large f_bavail as well,

       =C2=A0total filesystem size =3D 9763506176 KB
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0total Available size =3D 21=
279656740 KB
        total used size =3D -11516150564 KB

We are using Ubuntu 3.18.19 Linux kernel/xfs.

If I unmount and mount the filesysem back, the f_bavail values are back to
normal.

Can you please point me, if this is something a known issue got fixed in
XFS in the later version, or any lead may help.
It is difficult at this point of time to upgrade the XFS for this specific
issue.

Thanks,
-kiru
