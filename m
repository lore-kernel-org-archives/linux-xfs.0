Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:33800 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033133AbdAEUEN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jan 2017 15:04:13 -0500
Received: by mail-it0-f65.google.com with SMTP id q186so26248itb.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Jan 2017 12:03:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <78985020-cef8-9d2c-431c-201b8d02c173@sandeen.net>
References: <CABPa+v3fgLjBo2CLBXxg8xE3D5tWdjk2C3gM2o1-xEFT45_Rkg@mail.gmail.com>
 <de4f0e6b-bd01-5bf5-42f6-ca2562c564cb@sandeen.net> <20170105191316.GD17846@birch.djwong.org>
 <78985020-cef8-9d2c-431c-201b8d02c173@sandeen.net>
From: Xingbo Wu <wuxb45@gmail.com>
Date: Thu, 5 Jan 2017 14:02:50 -0600
Message-ID: <CABPa+v16RayQZ+aD+xixWs8C4TfdAXX0tQhGmnozgj5yNRK8tg@mail.gmail.com>
Subject: Re: [BUG] xfs.mkfs recognizes wrong disk size
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Jan 5, 2017 at 1:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 1/5/17 1:13 PM, Darrick J. Wong wrote:
>>>> It later leads to IO error:
>>>> `dmesg`:
>>>> [1807875.741674] blk_update_request: I/O error, dev sdf, sector 293026=
6664
>>>> [1807875.741732] blk_update_request: I/O error, dev sdf, sector 293026=
6664
>> The kernel complains about "sector 2930266664", which is in 512-byte blo=
cks.
>>
>> 2930266664 * 512 =3D 1500296531968, or halfway across your 3TB disk.
>>
>> Makes sense since the log generally ends up halfway across the disk.
>> Not sure if there's any output before 1807875.741674 but this sort of
>> looks like a disk error or something?
>
> Oh, right.  Like my physics teacher said, "think units before you think
> numbers!"  ;)  I usually remember ...
>
> This doesn't look like a size mismatch problem, this looks like a failing
> disk problem.
>
> -Eric

It looks I need to scan for bad blocks. Thanks for your time :)

--=20

Regards,
        Wu, Xingbo (=E5=90=B4=E5=85=B4=E5=8D=9A)  <wuxb45@gmail.com>
