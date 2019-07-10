Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from egyptian.birch.relay.mailchannels.net ([23.83.209.56]:26765
        "EHLO egyptian.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbfGJRQe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 13:16:34 -0400
Date: Wed, 10 Jul 2019 20:16:14 +0300
From: Andrey Zhunev <a-j@a-j.ru>
Message-ID: <816157686.20190710201614@a-j.ru>
Subject: Re: Need help to recover root filesystem after a power supply issue
In-Reply-To: <CAJCQCtQn17ktjatXU5vvFjfsfEJx8EDrq1+b8+O1yvAf7ij96w@mail.gmail.com>
References: <958316946.20190710124710@a-j.ru>
  <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
  <1373677058.20190710182851@a-j.ru>
  <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
  <1015034894.20190710190746@a-j.ru>
  <CAJCQCtSTPaor-Wo6b1NF3QT_Pi2rO7B9QMbfudZS=9TEt-Oemw@mail.gmail.com>
  <CAJCQCtQn17ktjatXU5vvFjfsfEJx8EDrq1+b8+O1yvAf7ij96w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>

Wednesday, July 10, 2019, 7:47:55 PM, you wrote:

> On Wed, Jul 10, 2019 at 10:46 AM Chris Murphy <lists@colorremedies.com> w=
rote:
>>
>> # smartctl -l scterc,900,100
>> # echo 180 > /sys/block/sda/device/timeout


> smartctl command above does need a drive specified...

Indeed! :)

With the commands above, you are increasing the timeout and then fsck
will try to re-read the sectors, right?

As for the SMART status, the number of pending sectors was 0 before.
It started to grow after the PSU incident yesterday. Now, since I'm
doing a ddrescue, all the sectors will be read (or attempted to be
read). So the pending sectors counter may increase further.

As I understand, when a drive cannot READ a sector, the sector is
reported as pending. And it will stay like that until either the
sector is finally read or until it is overwritten. When either of
these happens, the Pending Sector Counter should decrease.
In theory, it can go back to 0 (although I didn't follow this closely
enough, so I never saw a drive like that).

If a drive can't WRITE to a sector, it tries to reallocate it. If it
succeeds, Reallocated Sectors Counter is increased. If it fails to
reallocate - I guess there should be another kind of error or a
counter, but I'm not sure which one.

When reallocated sectors appear - it's clearly a bad sign. If the
number of reallocated sectors grow - the drive should not be used.
But it's not that obvious for the pending sectors...

Anyway, as you noted, the drive isn't new already:


>   9 Power_On_Hours          -O--CK   022   022   000    -    56941
>
> 56941=C3=B78760 =3D 6.5 years ?
>
> Doubtful it's under warranty.


Mmm... yeah... I guess it was one of the early WD30EFRX drives...
This model was launched about 7 years ago, if I'm not mistaken... :)


---
Best regards,
 Andrey
