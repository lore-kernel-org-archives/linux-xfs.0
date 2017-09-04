Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:34841 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753165AbdIDBek (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 21:34:40 -0400
Received: by mail-wr0-f171.google.com with SMTP id y15so11057713wrc.2
        for <linux-xfs@vger.kernel.org>; Sun, 03 Sep 2017 18:34:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9aacc5d8-c935-24f0-4a0b-89993dd48769@sandeen.net>
References: <1504066712-26973-1-git-send-email-ddouwsma@redhat.com> <9aacc5d8-c935-24f0-4a0b-89993dd48769@sandeen.net>
From: Donald Douwsma <ddouwsma@redhat.com>
Date: Mon, 4 Sep 2017 11:34:38 +1000
Message-ID: <CAGPViH+6GYh-JR5wqHy9+X5FE9GxMThWQ0iBGQ6dSjDJMonsnQ@mail.gmail.com>
Subject: Re: [PATCH] mkfs.xfs: Don't stagger AG for a single disk
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 9:54 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 8/29/17 11:18 PM, Donald Douwsma wrote:
>> When sunit and swidth are used mkfs.xfs tries to avoid all allocation
>> groups aligning on the same stripe and will attempt to stagger them
>> across the stripes that make up swidth.  If there is only one stripe
>> then there is no benefit in this optimisation.
>>
>> $ truncate -s10G xfs_10G_su256k_sw1.image
>> $ mkfs.xfs -d su=256k,sw=1 xfs_10G_su256k_sw1.image
>> meta-data=xfs_10G_su256k_sw1.image isize=512    agcount=16, agsize=163776 blks
>>          =                       sectsz=512   attr=2, projid32bit=1
>>          =                       crc=1        finobt=0, sparse=0
>> data     =                       bsize=4096   blocks=2620416, imaxpct=25
>>          =                       sunit=64     swidth=64 blks
>> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>> log      =internal log           bsize=4096   blocks=2560, version=2
>>          =                       sectsz=512   sunit=64 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> A side effect of the optimisation is that the size adjustment used to stager
>> the allocation groups causes the last sunit of storage to be unused.

Actually it shrinks the agsize by one sunit, leading to the
discrepancy of sunit * agcount, for the above example 4MB.

>> $ echo $((2620416*4096))
>> 10733223936
>> $ ls -l xfs_10G_su256k_sw1.image
>> -rw-rw-r--. 1 test test 10737418240 Aug 30 10:54 xfs_10G_su256k_sw1.image
>>
>> Skip this optimisation when sunit == swidth.
>>
>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>
> Interesting.  Yeah, I suppose this makes sense, though I'm surprised
> anyone would notice.  :)

Sysadmins see the dependency and worry that something went wrong. If
you run xfs_growfs on the mounted volume it creates a tiny allocation
group to add this space in, which adds to the confusion.

The broader question is what should mkfs be doing when this
optimisation is active.
The space could be added to the last AG, but I think silently dropping
it is not ideal.
