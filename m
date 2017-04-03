Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37106 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751912AbdDCIPd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Apr 2017 04:15:33 -0400
Date: Mon, 3 Apr 2017 10:15:15 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS race on umount
Message-ID: <20170403081515.s27ok7rwi6yutpkf@eorzea.usersys.redhat.com>
References: <20170310120406.GU16870@chrystal>
 <20170310140535.GB27272@bfoster.bfoster>
 <20170310143846.GA7971@chrystal.oracle.com>
 <20170310145254.GC27272@bfoster.bfoster>
 <20170320123350.xmtcaodhrbwpfgmu@eorzea.usersys.redhat.com>
 <20170324121348.GH32546@chrystal.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170324121348.GH32546@chrystal.oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: linux-xfs@vger.kernel.org

> > > > > > 
> > > > > > We've been using XFS recently on our build system because we found that it
> > > > > > scales pretty well and we have good use for the reflink feature :)
> > > > > > 
> > > > > > I think our setup is relivatively unique in that on every one of our build
> > > > > > server, we mount hundreds of XFS filesystem from NBD devices in parallel,
> > > > > > where our build environment are stored on qcow2 images and connected with
> > > > > > qemu-nbd, then umount them when the build is finished.  Those qcow2 images
> > > > > > are stored on a NFS mount, which leads to some (expected) hickups when
> > > > > > reading/writing blocks where sometimes the NBD layer will return some
> > > > > > errors to the block layer, which in turn will pass them on to XFS.  It
> > > > > > could be due to network contention, very high load on the server, or any
> > > > > > transcient error really, and in those cases, XFS will normally force shut
> > > > > > down the filesystem and wait for a umount.
> > > > > > 
> > > > > > All of this is fine and is exactly the behaviour we'd expect, though it
> > > > > > turns out that we keep hiting what I think is a race condition between
> > > > > > umount and a force shutdown from XFS itself, where I have a umount process
> > > > > > completely stuck in xfs_ail_push_all_sync():
> > > > > > 
> > > > > >   [<ffffffff813d987e>] xfs_ail_push_all_sync+0x9e/0xe0
> > > > > >   [<ffffffff813c20c7>] xfs_unmountfs+0x67/0x150
> > > > > >   [<ffffffff813c5540>] xfs_fs_put_super+0x20/0x70
> > > > > >   [<ffffffff811cba7a>] generic_shutdown_super+0x6a/0xf0
> > > > > >   [<ffffffff811cbb2b>] kill_block_super+0x2b/0x80
> > > > > >   [<ffffffff811cc067>] deactivate_locked_super+0x47/0x80
> > > > > >   [<ffffffff811ccc19>] deactivate_super+0x49/0x70
> > > > > >   [<ffffffff811e7b3e>] cleanup_mnt+0x3e/0x90
> > > > > >   [<ffffffff811e7bdd>] __cleanup_mnt+0xd/0x10
> > > > > >   [<ffffffff810e1b39>] task_work_run+0x79/0xa0
> > > > > >   [<ffffffff810c2df7>] exit_to_usermode_loop+0x4f/0x75
> > > > > >   [<ffffffff8100134b>] syscall_return_slowpath+0x5b/0x70
> > > > > >   [<ffffffff81a2cbe3>] entry_SYSCALL_64_fastpath+0x96/0x98
> > > > > >   [<ffffffffffffffff>] 0xffffffffffffffff
> > > > > > 
> > 
> > This actually looks pretty much with the problem I've been working on, or with
> > the previous one where we've introduced fail_at_unmount syscall config to avoid
> > such problems like this.
> > 
> > Can you confirm if fail_at_unmount is active and if it can avoid the above
> > problem to happen? If it doesn't avoid the problem to happen there, then, I'm
> > almost 100% sure it's the same problem I've been working on with AIL items not
> > being retried, but FWIW, this only happens if some sort of IO error happened
> > previously, which looks like to be your case too.
> > 
> 
> I have not tried fail_at_umount yet but I could reproduce similar umount
> hangs using NBD and NFS:
> 

Do you have the whole stack dump from the system where you trigger this problem?
Also, please try to use fail_at_unmount, it has been designed to prevent such
cases, when we have EIOs and the filesystem can get into an hang state during
unmounting process.

Which kernel version are you using btw?


>   # Create an image with an XFS filesystem on it
>   qemu-img create -f qcow2 test-img.qcow2 10GB
>   qemu-nbd -c /dev/nbd0 test-img.qcow2
>   mkfs.xfs /dev/nbd0
>   qemu-nbd -d /dev/nbd0
> 
> Quentin
> 



-- 
Carlos
