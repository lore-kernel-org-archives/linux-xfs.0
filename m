Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f42.google.com ([209.85.167.42]:35428 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732906AbeHAGrt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 02:47:49 -0400
Received: by mail-lf1-f42.google.com with SMTP id f18-v6so12373941lfc.2
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 22:04:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dce71dca-0b85-387c-a1c9-f62f6c824b1c@sandeen.net>
References: <CAJCQCtQpeQ_z9gMHhnhSvzJed4HfT=pxpORTTNjJQUogvVjLgA@mail.gmail.com>
 <20180801041204.GH2234@dastard> <CAJCQCtQh3KCpG=PNNj1-3Z9cMKoeavgF++3aDTxZdo7YQ=15KA@mail.gmail.com>
 <dce71dca-0b85-387c-a1c9-f62f6c824b1c@sandeen.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 31 Jul 2018 23:04:05 -0600
Message-ID: <CAJCQCtS56E32e3NhTR++vwt1qdbnrfu9Hcn46W3Hso7iq1Djfg@mail.gmail.com>
Subject: Re: agcount 33 by default for a single HDD?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Murphy <lists@colorremedies.com>, Dave Chinner <david@fromorbit.com>, xfs list <linux-xfs@vger.kernel.org>

On Tue, Jul 31, 2018 at 10:41 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
> On 7/31/18 11:38 PM, Chris Murphy wrote:
>> On Tue, Jul 31, 2018 at 10:12 PM, Dave Chinner <david@fromorbit.com> wro=
te:
>>> On Tue, Jul 31, 2018 at 07:32:50PM -0600, Chris Murphy wrote:
>>>> This seems suboptimal.
>>>
>>> It's actually a very useful optimisation to make on thin devices.
>>>
>>>> Basically this is a 750G thin volume. I don't
>>>> have a plain partition on a device handy to try this out but I'm
>>>> pretty certain the default is 4 AG's in that case, so I'm confused why
>>>> by default 33 AGs are created on a thin volume. The LVM volume group
>>>> is on a dmcrypt PV.
>>>
>>> It's a thin volume, therefore it advertises an optimal IO size and
>>> alignment setting (i.e. the thin volume allocation chunk size).
>>> Hence mkfs.xfs treats it as a "multi-disk device" and sets up
>>> alignment and AG count appropriately.
>>>
>>> This is actually the right optimisation to make for sparse devices -
>>> more AGs increase filesystem concurrency but we normally restrict it
>>> on single spindles because each AG adds more seeks into typical
>>> workloads and slows them down. However, the thin volume already adds
>>> that penalty to the storage stack for us because they don't have a
>>> linear LBA-to-physical location characteristic.  Hence we can
>>> increase filesystem concurrency without addition performance
>>> penalties being incurred.
>>
>> OK so why 33 AG's with xfsprogs 4.15, but 4 AG's with xfsprogs 4.17,
>> when directed to the same thin LV? And also the difference in sunit
>> and swidth?
>>
>
> Did you build 4.17 with --disable-blkid?

Yep, that's what doc/INSTALL recommends. Removing that and rebuilding,
sure enough 33 AGs, sunit 128, swidth 1024, and sectsz 4096. I do get
a build time warning.

Building mkfs
    [CC]     proto.o
    [CC]     xfs_mkfs.o
In function =E2=80=98finish_superblock_setup=E2=80=99,
    inlined from =E2=80=98main=E2=80=99 at xfs_mkfs.c:3937:2:
xfs_mkfs.c:3188:3: warning: =E2=80=98strncpy=E2=80=99 specified bound 12 eq=
uals
destination size [-Wstringop-truncation]
   strncpy(sbp->sb_fname, cfg->label, sizeof(sbp->sb_fname));
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    [LD]     mkfs.xfs



--=20
Chris Murphy
