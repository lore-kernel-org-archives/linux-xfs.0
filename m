Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:41684 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbeGKIe4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jul 2018 04:34:56 -0400
Received: by mail-pf0-f193.google.com with SMTP id c21-v6so13335431pfn.8
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jul 2018 01:31:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAKAc_Gwh-KMdnK6LqX3kE9jTmSHsg8_kzQE5fPsnL3xETD1O+w@mail.gmail.com>
 <3895eebe-3fa2-a977-4021-3bd6ef645fdd@sandeen.net>
In-Reply-To: <3895eebe-3fa2-a977-4021-3bd6ef645fdd@sandeen.net>
From: Filippo Giunchedi <fgiunchedi@wikimedia.org>
Date: Wed, 11 Jul 2018 10:31:35 +0200
Message-ID: <CAKAc_GwXi4U=WceoWo_6dsjT_ThTYKbebOzxkcTAW2_-vfgt=g@mail.gmail.com>
Subject: Re: Recently-formatted XFS filesystems reporting negative used space
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

Thanks Eric and Dave!

On Tue, Jul 10, 2018 at 11:39 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 7/10/18 8:43 AM, Filippo Giunchedi wrote:
> > Hello,
> > a little background: at Wikimedia Foundation we are running a 30-hosts
> > Openstack Swift cluster to host user media uploads, each host has 12
> > spinning disks formatted individually with xfs.
> >
> > Some of the recently-formatted filesystems have started reporting
> > negative usage upon hitting around 70% usage, though some filesystems
> > on the same host kept reporting as expected:
> >
> > /dev/sdn1       3.7T  -14T   17T    - /srv/swift-storage/sdn1
> > /dev/sdh1       3.7T  -13T   17T    - /srv/swift-storage/sdh1
> > /dev/sdc1       3.7T  3.0T  670G  83% /srv/swift-storage/sdc1
> > /dev/sdk1       3.7T  3.1T  643G  83% /srv/swift-storage/sdk1
> >
> > We have experienced this bug only on the last four machines to be put
> > in service and formatted with xfsprogs 4.9.0+nmu1 from Debian Stretch.
> > The remaining hosts were formatted in the past with xfsprogs 3.2.1 or
> > older.
> > We have also a standby cluster in another datacenter with similar
> > configuration and hosts that received write traffic only but not read
> > traffic; the standby cluster hasn't experienced the bug and all
> > filesystems report the correct usage.
> > As far as I can tell the difference in xfsprogs version used for
> > formatting means defaults have changed, (e.g. crc is enabled on the
> > affected filesystems). Have you seen this issue before and do you know
> > how to fix it?
> >
> > I would love to help debugging this issue, we've been detailing the
> > work done so far at https://phabricator.wikimedia.org/T199198
>
> What kernel are the problematic nodes running?

All nodes are running 4.9.82-1+deb9u3

> From your repair output:
>
> root@ms-be1040:~# xfs_repair -n /dev/sde1
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> sb_fdblocks 4461713825, counted 166746529
>         - found root inode chunk
>
> that sb_fdblocks really is ~17T which indicates the problem
> really is on disk.
>
> 4461713825
> 100001001111100000101100110100001
> 166746529
>      1001111100000101100110100001
>
> you have a bit flipped in the problematic value... but you're running
> with CRCs so it seems unlikely to have been some sort of bit-rot (that,
> and the fact that you're hitting the same problem on multiple nodes).

Ouch, indeed we've seen this problem on multiple nodes, said hosts
belong to the same and latest shipment from the OEM. We'll run
hardware diagnostics on these hosts and others we've received at
another datacenter (which haven't shown issues so far but don't serve
reads either).

thanks for your help!

Filippo
