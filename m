Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55375 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730040AbeGQJ6K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jul 2018 05:58:10 -0400
Received: by mail-wm0-f65.google.com with SMTP id f21-v6so744406wmc.5
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jul 2018 02:26:30 -0700 (PDT)
Date: Tue, 17 Jul 2018 11:26:26 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Recently-formatted XFS filesystems reporting negative used space
Message-ID: <20180717092626.pxb6wzhcswf2f77p@odin.usersys.redhat.com>
References: <CAKAc_Gwh-KMdnK6LqX3kE9jTmSHsg8_kzQE5fPsnL3xETD1O+w@mail.gmail.com>
 <3895eebe-3fa2-a977-4021-3bd6ef645fdd@sandeen.net>
 <CAKAc_GwXi4U=WceoWo_6dsjT_ThTYKbebOzxkcTAW2_-vfgt=g@mail.gmail.com>
 <CAKAc_GxsR9UxswqJMLhPOqR6HeYLi-rHZiEY8LLxs-hj0n=uMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKAc_GxsR9UxswqJMLhPOqR6HeYLi-rHZiEY8LLxs-hj0n=uMQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Filippo Giunchedi <fgiunchedi@wikimedia.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 16, 2018 at 11:29:51AM +0200, Filippo Giunchedi wrote:
> On Wed, Jul 11, 2018 at 10:31 AM Filippo Giunchedi
> <fgiunchedi@wikimedia.org> wrote:
> > > that sb_fdblocks really is ~17T which indicates the problem
> > > really is on disk.
> > >
> > > 4461713825
> > > 100001001111100000101100110100001
> > > 166746529
> > >      1001111100000101100110100001
> > >
> > > you have a bit flipped in the problematic value... but you're running
> > > with CRCs so it seems unlikely to have been some sort of bit-rot (that,
> > > and the fact that you're hitting the same problem on multiple nodes).
> >
> > Ouch, indeed we've seen this problem on multiple nodes, said hosts
> > belong to the same and latest shipment from the OEM. We'll run
> > hardware diagnostics on these hosts and others we've received at
> > another datacenter (which haven't shown issues so far but don't serve
> > reads either).
> 
> Update on this: we've ran hw diagnostics and couldn't find anything
> wrong, xfs_repair does fix the issue so we'll be going ahead with
> that. Is there anything we can do to help debugging in case this
> happens again?
> 

There is a patch being discussed on list to help catch these bit corruptions
before they reach the disk, but, bear in mind we can only improve the validation
of our metadata. Nothing actually forbids these bit flips are occurring on your
data, and you are actually writing corrupted data into your files.

Cheers

> thanks a lot!
> Filippo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
