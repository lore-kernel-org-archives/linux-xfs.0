Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f41.google.com ([209.85.221.41]:33363 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfGJTaY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 15:30:24 -0400
Received: by mail-wr1-f41.google.com with SMTP id n9so3712374wru.0
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 12:30:23 -0700 (PDT)
MIME-Version: 1.0
References: <958316946.20190710124710@a-j.ru> <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
 <1373677058.20190710182851@a-j.ru> <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
 <1015034894.20190710190746@a-j.ru> <CAJCQCtSTPaor-Wo6b1NF3QT_Pi2rO7B9QMbfudZS=9TEt-Oemw@mail.gmail.com>
 <CAJCQCtQn17ktjatXU5vvFjfsfEJx8EDrq1+b8+O1yvAf7ij96w@mail.gmail.com>
 <816157686.20190710201614@a-j.ru> <CAJCQCtQ08-hu7Cr2Li4v07r8v1isxZu=_hP3aQpHqJw4D2jCmg@mail.gmail.com>
 <e1dea87a-a2d8-4f4c-8807-4027a1a03a41@telefonica.net>
In-Reply-To: <e1dea87a-a2d8-4f4c-8807-4027a1a03a41@telefonica.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 10 Jul 2019 13:30:11 -0600
Message-ID: <CAJCQCtS0EfAghBGoL-YVTEANfAXV4Oy7Q+4Q0Jp3xOF-uQhixA@mail.gmail.com>
Subject: Re: Need help to recover root filesystem after a power supply issue
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Carlos E. R." <robin.listas@telefonica.net>
Cc: xfs list <linux-xfs@vger.kernel.org>

On Wed, Jul 10, 2019 at 12:35 PM Carlos E. R.
<robin.listas@telefonica.net> wrote:
>
> On 10/07/2019 20.03, Chris Murphy wrote:
> > On Wed, Jul 10, 2019 at 11:16 AM Andrey Zhunev <a-j@a-j.ru> wrote:
>
> ...
>
> >> When reallocated sectors appear - it's clearly a bad sign. If the
> >> number of reallocated sectors grow - the drive should not be used.
> >> But it's not that obvious for the pending sectors...
> >
> > They're both bad news. It's just a matter of degree. Yes a
> > manufacturer probably takes the position that pending sectors is and
> > even remapping is normal drive behavior. But realistically it's not
> > something anyone wants to have to deal with. It's useful for
> > curiousity. Use it for Btrfs testing :-D
>
> I have used some disks with some reallocated sectors for several years
> after the "event", with not even a single failure afterwards. It should
> not be fatal. For me, the criteria is that the number does not increase,
> and that it is not large.

That is true but it also takes mitigation effort beyond what most
people are willing or capable of doing. But also there's no way to
know in advance. SMART just isn't a good predictor.

There may have been a brief period period where some of these
marginally bad sectors could have been remapped automatically, but
didn't because of the default short SCT ERC since these are intended
to be NAS drives, not boot/system drives.

And also, the default kernel command time out of 30 seconds is
inappropriate for a single boot or system drive. It should be quite a
bit longer. 30s makes sense only if the drive SCT ERC is shorter than
that, and it's some kind of RAID setup.

Thus far no one's been willing to budget on setting better defaults.
Distros say the kernel should default to something safe. And kernel
developers pretty much say defaults like this one should never be
changed and it's a distro + use case responsibility to change it. And
the end result of that going nowhere is users consistently have a
suboptimal experience, especially the desktop/laptop  use case.


-- 
Chris Murphy
