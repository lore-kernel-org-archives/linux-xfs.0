Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:36506 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751498AbdFGLLQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2017 07:11:16 -0400
Received: by mail-ua0-f179.google.com with SMTP id h39so4302060uaa.3
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jun 2017 04:11:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f7faea7d-4258-9310-4fcd-c75ed7455181@sandeen.net>
References: <CAG3eYYQMTdmCK9EdJA4hfYSSPStLSC=YBK+tvk67r6Vn4-UcxQ@mail.gmail.com>
 <f7faea7d-4258-9310-4fcd-c75ed7455181@sandeen.net>
From: =?UTF-8?B?UMOpdGVyIEFuZHLDoXMgRmVsdsOpZ2k=?= <petschy@gmail.com>
Date: Wed, 7 Jun 2017 13:11:14 +0200
Message-ID: <CAG3eYYRk2n9B6yiu3KuSnywOjsC1Ttb=hUJ-bX3R7H5mDsPHMA@mail.gmail.com>
Subject: Re: My XFS volume died, please help!
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,

On 05/06/2017, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 6/2/17 6:21 PM, P=C3=A9ter Andr=C3=A1s Felv=C3=A9gi wrote:
>> Hello,
>>
>> after a power outage, the mount replayed the journal and no errors
>> were reported, but the mounted XFS volume had suspiciously little free
>> space.
>
> Did it happen to be your root filesystem, or some other?

Some other. It's a raid+lvm+luks volume.

>> So I unmounted, and ran xfs_repair which crashed in phase 5
>
> Did it happen to find corruption before that?

I ran xfs_repair twice, it crashed each time in phase 5 with the same
message. I don't recall it found corruption, but the log zeroing
printed different numbers.

If I run xfs_repair 4.11 with -n, it skips phase 5 altogether :S

> # xfs_metadump -o /dev/dm-2 - | xfs_mdrestore - dm-2.img

Metadata corruption detected at block 0x2dd04801/0x200
xfs_metadump: cannot init perag data (117). Continuing anyway.
Metadata CRC error detected at block 0x20b95802/0x200
Metadata CRC error detected at block 0x23ff1402/0x200
Metadata CRC error detected at block 0x2744d002/0x200
Metadata CRC error detected at block 0x2a8a8c02/0x200
Metadata corruption detected at block 0x2dd04801/0x200
Metadata CRC error detected at block 0x2dd04802/0x200
Metadata CRC error detected at block 0x31160402/0x200
Metadata CRC error detected at block 0x345bc002/0x200
Metadata corruption detected at block 0x37a17c01/0x200
Metadata CRC error detected at block 0x37a17c02/0x200
Metadata CRC error detected at block 0x3ae73802/0x200
Metadata CRC error detected at block 0x3e2cf402/0x200
Metadata CRC error detected at block 0x4172b002/0x200
Metadata CRC error detected at block 0x44b86c02/0x200
Metadata CRC error detected at block 0x47fe2802/0x200
Metadata CRC error detected at block 0x4b43e402/0x200
Metadata CRC error detected at block 0x4e89a002/0x200
Metadata CRC error detected at block 0x51cf5c02/0x200
Metadata CRC error detected at block 0x55151802/0x200
Metadata CRC error detected at block 0x585ad402/0x200
Metadata CRC error detected at block 0x5ba09002/0x200
Metadata CRC error detected at block 0x5ee64c02/0x200
Metadata CRC error detected at block 0x622c0802/0x200
Metadata CRC error detected at block 0x6571c402/0x200

Isn't this too many blocks for this kind of failure? There was no
activity on the volume except for compressing a single large file.

> # xfs_repair dm-2.img
Phase 5 ran without error. After Phase 7 it printed this:
Maximum metadata LSN (11:170112) is ahead of log (1:64).
Format log to cycle 14.

> # mkdir -p mnt/
> # mount -o loop dm-2.img mnt/

> and see how that looks (metadata only, the image created
> above will contain no file data)

Seems OK :)

After running the repair on dm-2, the mount failed, my heart dropped,
but luckily this was just due to the duplicate fs UUIDs, as the dumped
meta image was still mounted.

So the fs is mounted, everything looks OK so far.

THANK YOU!

Kind regards, Peter
