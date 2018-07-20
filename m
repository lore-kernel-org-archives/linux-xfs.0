Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f174.google.com ([209.85.215.174]:38202 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbeGTLIa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jul 2018 07:08:30 -0400
Received: by mail-pg1-f174.google.com with SMTP id k3-v6so6506283pgq.5
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jul 2018 03:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAKAc_Gwh-KMdnK6LqX3kE9jTmSHsg8_kzQE5fPsnL3xETD1O+w@mail.gmail.com>
 <3895eebe-3fa2-a977-4021-3bd6ef645fdd@sandeen.net> <CAKAc_GwXi4U=WceoWo_6dsjT_ThTYKbebOzxkcTAW2_-vfgt=g@mail.gmail.com>
 <CAKAc_GxsR9UxswqJMLhPOqR6HeYLi-rHZiEY8LLxs-hj0n=uMQ@mail.gmail.com> <20180717092626.pxb6wzhcswf2f77p@odin.usersys.redhat.com>
In-Reply-To: <20180717092626.pxb6wzhcswf2f77p@odin.usersys.redhat.com>
From: Filippo Giunchedi <fgiunchedi@wikimedia.org>
Date: Fri, 20 Jul 2018 12:20:41 +0200
Message-ID: <CAKAc_Gx5RaiEC1C8aSYZXAcZcyyPHPNWHy6ALuzOJvkgkg5nkA@mail.gmail.com>
Subject: Re: Recently-formatted XFS filesystems reporting negative used space
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Tue, Jul 17, 2018 at 11:26 AM Carlos Maiolino <cmaiolino@redhat.com> wrote:
> > > Ouch, indeed we've seen this problem on multiple nodes, said hosts
> > > belong to the same and latest shipment from the OEM. We'll run
> > > hardware diagnostics on these hosts and others we've received at
> > > another datacenter (which haven't shown issues so far but don't serve
> > > reads either).
> >
> > Update on this: we've ran hw diagnostics and couldn't find anything
> > wrong, xfs_repair does fix the issue so we'll be going ahead with
> > that. Is there anything we can do to help debugging in case this
> > happens again?
> >
>
> There is a patch being discussed on list to help catch these bit corruptions
> before they reach the disk, but, bear in mind we can only improve the validation
> of our metadata. Nothing actually forbids these bit flips are occurring on your
> data, and you are actually writing corrupted data into your files.

We've found no other cases of bit flips or corruption in metadata or
the data itself though.
To recap what we've seen, hardware bit flipping is extremely unlikely:
the same type of sb_fdblocks corruption has appeared on four different
hosts affecting at most one third of xfs filesystems per host. Also
the corruption looks always the same, namely the 33rd bit flipped
which also seems suspicious.

HTH,
Filippo
