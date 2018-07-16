Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:40834 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbeGPJ4e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Jul 2018 05:56:34 -0400
Received: by mail-pf0-f182.google.com with SMTP id e13-v6so12624805pff.7
        for <linux-xfs@vger.kernel.org>; Mon, 16 Jul 2018 02:30:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAKAc_Gwh-KMdnK6LqX3kE9jTmSHsg8_kzQE5fPsnL3xETD1O+w@mail.gmail.com>
 <3895eebe-3fa2-a977-4021-3bd6ef645fdd@sandeen.net> <CAKAc_GwXi4U=WceoWo_6dsjT_ThTYKbebOzxkcTAW2_-vfgt=g@mail.gmail.com>
In-Reply-To: <CAKAc_GwXi4U=WceoWo_6dsjT_ThTYKbebOzxkcTAW2_-vfgt=g@mail.gmail.com>
From: Filippo Giunchedi <fgiunchedi@wikimedia.org>
Date: Mon, 16 Jul 2018 11:29:51 +0200
Message-ID: <CAKAc_GxsR9UxswqJMLhPOqR6HeYLi-rHZiEY8LLxs-hj0n=uMQ@mail.gmail.com>
Subject: Re: Recently-formatted XFS filesystems reporting negative used space
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 11, 2018 at 10:31 AM Filippo Giunchedi
<fgiunchedi@wikimedia.org> wrote:
> > that sb_fdblocks really is ~17T which indicates the problem
> > really is on disk.
> >
> > 4461713825
> > 100001001111100000101100110100001
> > 166746529
> >      1001111100000101100110100001
> >
> > you have a bit flipped in the problematic value... but you're running
> > with CRCs so it seems unlikely to have been some sort of bit-rot (that,
> > and the fact that you're hitting the same problem on multiple nodes).
>
> Ouch, indeed we've seen this problem on multiple nodes, said hosts
> belong to the same and latest shipment from the OEM. We'll run
> hardware diagnostics on these hosts and others we've received at
> another datacenter (which haven't shown issues so far but don't serve
> reads either).

Update on this: we've ran hw diagnostics and couldn't find anything
wrong, xfs_repair does fix the issue so we'll be going ahead with
that. Is there anything we can do to help debugging in case this
happens again?

thanks a lot!
Filippo
