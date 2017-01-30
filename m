Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753632AbdA3PwT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jan 2017 10:52:19 -0500
Date: Mon, 30 Jan 2017 10:43:27 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: WARNING: CPU: 11 PID: 7966 at fs/xfs/libxfs/xfs_bmap.c:5408
 xfs_bmap_del_extent+0xdc8/0xe80 [xfs] and having a call trace
Message-ID: <20170130154326.GB8737@bfoster.bfoster>
References: <CAEtPA0AOfhTGM76vhLHDiQbXyHywbypk5hOLhq=AWvwVAQPO3g@mail.gmail.com>
 <20170130140535.GA7136@bfoster.bfoster>
 <CAEtPA0DG+D+_+FFKhNa_XKTwcWcphQA8WVCDrzMueajNjQRRrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEtPA0DG+D+_+FFKhNa_XKTwcWcphQA8WVCDrzMueajNjQRRrg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Patrick Dung <mpatdung@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 30, 2017 at 11:07:58PM +0800, Patrick Dung wrote:
> Hi Brian,
> 
> Resent in plain text mode.
> The mailing list could not accept email in html format.
> 
> For your information:
> 
> 1) The cp command was issued at '2017-01-30 03:02:49'
> $ cp --sparse=always -rp 'source' 'destination'
> I was copying a 55GB folder including two vmare images from a ext4
> file system to a XFS file system
> 
> $ stat disk1.vmdk
>   File: 'disk1.vmdk'
>   Size: 50465865728     Blocks: 97561480   IO Block: 262144 regular file
> 
> $ stat disk2.vmdk
>   File: 'disk2.vmdk'
>   Size: 3825795072      Blocks: 7470568    IO Block: 262144 regular file
> 
> By looking at the number of blocks reported by command stat, those
> files should be sparse files.
> 

Thanks. This should only happen once per-copy. Was this run and
reproduced multiple times across reboots?

While sparse, it does look like those images are mostly allocated. Could
you provide the fiemap info for both (e.g., 'xfs_io -c "fiemap -v"
<file>')?

Brian

> 2) kernel log at:
> Jan 30 03:03:05 home kernel: [39331.104014] WARNING: CPU: 11 PID: 7966
> at fs/xfs/libxfs/xfs_bmap.c:5408 xfs_bmap_del_extent+0xdc8/0xe80 [xfs]
> 
> 3) The mount options for XFS is:
> defaults,relatime,logbufs=8,logbsize=262144,largeio
> 
> Thanks,
> Patrick
> 
> On Mon, Jan 30, 2017 at 10:05 PM, Brian Foster <bfoster@redhat.com> wrote:
> > On Mon, Jan 30, 2017 at 03:45:27AM +0800, Patrick Dung wrote:
> >> Hello
> >>
> >> I have encounter this warning message twice in recently.
> >> Do you know what is it about?
> >>
> >> [39331.103938] ------------[ cut here ]------------
> >> [39331.104014] WARNING: CPU: 11 PID: 7966 at
> >> fs/xfs/libxfs/xfs_bmap.c:5408 xfs_bmap_del_extent+0xdc8/0xe80 [xfs]
> >> [39331.104122] CPU: 11 PID: 7966 Comm: cp Tainted: G           OE
> >> 4.9.3-200.fc25.x86_64 #1
> >
> > This warning is related to the extra blocks that are stashed away with
> > delayed allocation extents to cover bmap btree insertion. When a
> > delalloc extent is created, a particularly sized block reservation is
> > stashed along with it to help cover bmapbt block allocation when the
> > extent is converted to real blocks and inserted to the on-disk btree.
> >
> > If the delalloc extent is modified before it is ultimately converted, if
> > a hole is punched (as the stack below shows) and it is split in two for
> > example, then the existing reservation must be shared across the two
> > extents. This warning fires when we encounter a situation where we're
> > left with a delalloc extent with zero reserved blocks.
> >
> > This is not a catastrophic error in and of itself as not every bmbt
> > insertion requires bmbt block allocation. It is not expected nor ideal
> > however. The warning exists so we have notification that there is still
> > an allocation pattern (and I have a suspicion from reviewing the code)
> > that leads to this risky state and we can try to address it. The stack
> > suggests a cp is freeing up space... can you describe what exactly you
> > are doing when this tends to occur? A quick look at coreutils source
> > suggests that cp calls fallocate() to punch a hole and explicitly work
> > around XFS preallocation when copying sparse files. Given that, it
> > wouldn't surprise me if copying a particular source file tends to
> > reproduce this more than others.
> >
> > Also note that this is a WARN_ON_ONCE(), which means once it fires
> > you'll have to reboot before it will reproduce.
> >
> > Brian
> >
> >> [39331.104127]  ffff9ddbb7ba3ab8 ffffffff843f3ddd 0000000000000000
> >> 0000000000000000
> >> [39331.104132]  ffff9ddbb7ba3af8 ffffffff840a202b 00001520b7ba3ca8
> >> ffff900c5a598400
> >> [39331.104136]  ffff9ddbb7ba3ca0 0000000000001cc0 0000000000000000
> >> 0000000000000000
> >> [39331.104140] Call Trace:
> >> [39331.104150]  [<ffffffff843f3ddd>] dump_stack+0x63/0x86
> >> [39331.104154]  [<ffffffff840a202b>] __warn+0xcb/0xf0
> >> [39331.104158]  [<ffffffff840a215d>] warn_slowpath_null+0x1d/0x20
> >> [39331.104198]  [<ffffffffc0ba9018>] xfs_bmap_del_extent+0xdc8/0xe80 [xfs]
> >> [39331.104237]  [<ffffffffc0bad3bd>] __xfs_bunmapi+0x5bd/0xb90 [xfs]
> >> [39331.104274]  [<ffffffffc0bad9bb>] xfs_bunmapi+0x2b/0x40 [xfs]
> >> [39331.104320]  [<ffffffffc0be3056>] xfs_free_file_space+0x256/0x300 [xfs]
> >> [39331.104366]  [<ffffffffc0bea79a>] xfs_file_fallocate+0x18a/0x3b0 [xfs]
> >> [39331.104370]  [<ffffffff84256077>] vfs_fallocate+0x157/0x220
> >> [39331.104373]  [<ffffffff84256e88>] SyS_fallocate+0x48/0x80
> >> [39331.104376]  [<ffffffff842591a7>] ? SyS_lseek+0x87/0xb0
> >> [39331.104383]  [<ffffffff8481bbf7>] entry_SYSCALL_64_fastpath+0x1a/0xa9
> >> [39331.104386] ---[ end trace 964857cd95d3bbff ]---
> >>
> >> Thanks.
> >> Patrick
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
