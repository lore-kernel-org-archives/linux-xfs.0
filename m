Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f43.google.com ([209.85.221.43]:33522 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbfGJSDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 14:03:24 -0400
Received: by mail-wr1-f43.google.com with SMTP id n9so3474349wru.0
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 11:03:23 -0700 (PDT)
MIME-Version: 1.0
References: <958316946.20190710124710@a-j.ru> <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
 <1373677058.20190710182851@a-j.ru> <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
 <1015034894.20190710190746@a-j.ru> <CAJCQCtSTPaor-Wo6b1NF3QT_Pi2rO7B9QMbfudZS=9TEt-Oemw@mail.gmail.com>
 <CAJCQCtQn17ktjatXU5vvFjfsfEJx8EDrq1+b8+O1yvAf7ij96w@mail.gmail.com> <816157686.20190710201614@a-j.ru>
In-Reply-To: <816157686.20190710201614@a-j.ru>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 10 Jul 2019 12:03:11 -0600
Message-ID: <CAJCQCtQ08-hu7Cr2Li4v07r8v1isxZu=_hP3aQpHqJw4D2jCmg@mail.gmail.com>
Subject: Re: Need help to recover root filesystem after a power supply issue
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrey Zhunev <a-j@a-j.ru>
Cc: Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>

On Wed, Jul 10, 2019 at 11:16 AM Andrey Zhunev <a-j@a-j.ru> wrote:
>
> Wednesday, July 10, 2019, 7:47:55 PM, you wrote:
>
> > On Wed, Jul 10, 2019 at 10:46 AM Chris Murphy <lists@colorremedies.com> wrote:
> >>
> >> # smartctl -l scterc,900,100
> >> # echo 180 > /sys/block/sda/device/timeout
>
>
> > smartctl command above does need a drive specified...
>
> Indeed! :)
>
> With the commands above, you are increasing the timeout and then fsck
> will try to re-read the sectors, right?

More correctly, the drive firmware won't timeout, and will try longer
to recover the data *if* the sectors are marginally bad. If the
sectors are flat out bad, then the firmware will still (almost)
immediately give up and at that point nothing else can be done except
zero the bad sectors and hope fsck can reconstruct what's missing.

Thing is, 68 sectors has a low likelihood of impacting fs metadata,
because it's a smaller target than your actual data, or free space if
there's a lot of it.


> As for the SMART status, the number of pending sectors was 0 before.
> It started to grow after the PSU incident yesterday. Now, since I'm
> doing a ddrescue, all the sectors will be read (or attempted to be
> read). So the pending sectors counter may increase further.

It's a good and valid tactic to just use ddrescue with the previously
mentioned modifications for SCT ERC and kernel timeouts, rather than
directly use fsck on a drive that's clearly dying.


> As I understand, when a drive cannot READ a sector, the sector is
> reported as pending. And it will stay like that until either the
> sector is finally read or until it is overwritten. When either of
> these happens, the Pending Sector Counter should decrease.

Sounds about right.

> In theory, it can go back to 0 (although I didn't follow this closely
> enough, so I never saw a drive like that).

It can and should go to zero once all the pending sectors are
overwritten with either good data or zeros. It's possible the write
succeeds to the same sector, in which case it's no longer pending and
not remapped. It's possible internally the write fails and the drive
firmware does a remap to make the write succeed, in which case it's no
longer pending.

If a write fails (externally reported write failure to the kernel),
then pending sectors will get pinned at that point and only ever go up
as the drive continues to get worse.


> If a drive can't WRITE to a sector, it tries to reallocate it. If it
> succeeds, Reallocated Sectors Counter is increased. If it fails to
> reallocate - I guess there should be another kind of error or a
> counter, but I'm not sure which one.

You get essentially the same UNC type of error you've seen except it's
a write error instead of read. That's widely considered fatal because
having a drive that can't write is just not usable for anything (well,
read only).

>
> When reallocated sectors appear - it's clearly a bad sign. If the
> number of reallocated sectors grow - the drive should not be used.
> But it's not that obvious for the pending sectors...

They're both bad news. It's just a matter of degree. Yes a
manufacturer probably takes the position that pending sectors is and
even remapping is normal drive behavior. But realistically it's not
something anyone wants to have to deal with. It's useful for
curiousity. Use it for Btrfs testing :-D


-- 
Chris Murphy
