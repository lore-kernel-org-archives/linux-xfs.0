Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750928AbcKNM44 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Nov 2016 07:56:56 -0500
Date: Mon, 14 Nov 2016 07:56:54 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS_WANT_CORRUPTED_GOTO
Message-ID: <20161114125654.GA37689@bfoster.bfoster>
References: <004eca882d70d671bce9dff6f25633cc.squirrel@mail2.postbox.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004eca882d70d671bce9dff6f25633cc.squirrel@mail2.postbox.xyz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris <chris2014@postbox.xyz>
Cc: linux-xfs@vger.kernel.org

On Sat, Nov 12, 2016 at 11:52:02AM +0100, Chris wrote:
> All,
> 
> I've already restored this partition from backup. Nevertheless, out of
> curiosity: maybe someone has an idea why this happened in the first place.
> 
> It's an Ubuntu 14.04.4 LTS Trusty Tahr machine (3.19.0-58-generic x86_64).
> The 33 TB partition is shared by Samba, not NFS. It was created on an
> older server. I don't know the exact XFS (tools) versions used then. I
> couldn't find any issues in RAID controller or FC switch logs. Samba logs
> aren't available.
> 
> The first occurence of the issue is:
> 
> Nov  8 23:58:30 fs1 kernel: [17576062.991425] XFS: Internal error
> XFS_WANT_CORRUPTED_GOTO at line 3141 of file
> /build/linux-lts-vivid-GISjUd/linux-lts-vivid-3.19.0/fs/xfs/libxfs/xfs_btree.c.

This is a distro kernel and the reported line number doesn't exactly
match up with a generic v3.19 kernel. From the stack, I'm guessing that
you have free space btree corruption and thus failure to insert a freed
extent into one of the btrees. E.g., we've seen reports of such attempts
to free already freed space in older kernels.

We don't currently know what the issue is and it is a challenge because
this kind of corruption can sit latent in the filesystem for quite some
time, going undetected until you happen to remove the file that contains
the offending extent.

>  Caller xfs_free_ag_extent+0x3ff/0x750 [xfs]
> Nov  8 23:58:30 fs1 kernel: [17576063.010347] CPU: 14 PID: 38238 Comm:
> smbd Not tainted 3.19.0-58-generic #64~14.04.1-Ubuntu
> Nov  8 23:58:30 fs1 kernel: [17576063.010350] Hardware name: Dell Inc.
> PowerEdge R430/0HFG24, BIOS 1.5.4 10/05/2015
> Nov  8 23:58:30 fs1 kernel: [17576063.010352]  0000000000000000
> ffff8802bc9bbad8 ffffffff817b6c3d ffff880216d1f450
> Nov  8 23:58:30 fs1 kernel: [17576063.010357]  ffff880216d1f450
> ffff8802bc9bbaf8 ffffffffc06c5f2e ffffffffc0684b9f
> Nov  8 23:58:30 fs1 kernel: [17576063.010361]  ffff8802bc9bbbec
> ffff8802bc9bbb78 ffffffffc069ffbb 0000000000015140
> Nov  8 23:58:30 fs1 kernel: [17576063.010365] Call Trace:
> Nov  8 23:58:30 fs1 kernel: [17576063.010375]  [<ffffffff817b6c3d>]
> dump_stack+0x63/0x81
> Nov  8 23:58:30 fs1 kernel: [17576063.010409]  [<ffffffffc06c5f2e>]
> xfs_error_report+0x3e/0x40 [xfs]
> Nov  8 23:58:30 fs1 kernel: [17576063.010431]  [<ffffffffc0684b9f>] ?
> xfs_free_ag_extent+0x3ff/0x750 [xfs]
> Nov  8 23:58:30 fs1 kernel: [17576063.010456]  [<ffffffffc069ffbb>]
> xfs_btree_insert+0x17b/0x190 [xfs]
> Nov  8 23:58:30 fs1 kernel: [17576063.010477]  [<ffffffffc0684b9f>]
> xfs_free_ag_extent+0x3ff/0x750 [xfs]
> Nov  8 23:58:30 fs1 kernel: [17576063.010498]  [<ffffffffc0686071>]
> xfs_free_extent+0xe1/0x110 [xfs]
> Nov  8 23:58:30 fs1 kernel: [17576063.010528]  [<ffffffffc06bf19f>]
> xfs_bmap_finish+0x13f/0x190 [xfs]
> Nov  8 23:58:30 fs1 kernel: [17576063.010560]  [<ffffffffc06d5a4d>]
> xfs_itruncate_extents+0x16d/0x2e0 [xfs]
> Nov  8 23:58:30 fs1 kernel: [17576063.010588]  [<ffffffffc06c0134>]
> xfs_free_eofblocks+0x1d4/0x250 [xfs]
> Nov  8 23:58:30 fs1 kernel: [17576063.010617]  [<ffffffffc06d5d7e>]
> xfs_release+0x9e/0x170 [xfs]
> Nov  8 23:58:30 fs1 kernel: [17576063.010645]  [<ffffffffc06c7425>]
> xfs_file_release+0x15/0x20 [xfs]
> Nov  8 23:58:30 fs1 kernel: [17576063.010651]  [<ffffffff811f0947>]
> __fput+0xe7/0x220
> Nov  8 23:58:30 fs1 kernel: [17576063.010656]  [<ffffffff811f0ace>]
> ____fput+0xe/0x10
> Nov  8 23:58:30 fs1 kernel: [17576063.010660]  [<ffffffff8109338c>]
> task_work_run+0xac/0xd0
> Nov  8 23:58:30 fs1 kernel: [17576063.010666]  [<ffffffff81016007>]
> do_notify_resume+0x97/0xb0
> Nov  8 23:58:30 fs1 kernel: [17576063.010671]  [<ffffffff817bea2f>]
> int_signal+0x12/0x17
> Nov  8 23:58:30 fs1 kernel: [17576063.010676] XFS (sde1):
> xfs_do_force_shutdown(0x8) called from line 135 o
> f file
> /build/linux-lts-vivid-GISjUd/linux-lts-vivid-3.19.0/fs/xfs/xfs_bmap_util.c.
>  Return address = 0xfffffff
> fc06bf1d8
> Nov  8 23:58:30 fs1 kernel: [17576063.011070] XFS (sde1): Corruption of
> in-memory data detected.  Shutting
> down filesystem
> Nov  8 23:58:30 fs1 kernel: [17576063.023605] XFS (sde1): Please umount
> the filesystem and rectify the prob
> lem(s)
> 
> Now, the kernel thread seems to hang-up. Unmounting isn't possible. The
> following line was repeating until reboot:
> 
> Nov  8 23:58:52 fs1 kernel: [17576084.848420] XFS (sde1): xfs_log_force:
> error -5 returned.
> 

The hang problem is likely the EFI/EFD reference counting problem
discussed in the similarly reported issue here:

  http://www.spinics.net/lists/linux-xfs/msg01937.html

In a nutshell, upgrade to a v4.3 kernel or newer to address that
problem.

> xfs_db -c "sb 0" -c "p blocksize" -c "p agblocks" -c "p agcount"
> /dev/disk/by-uuid/7f28333d-8d2e-4c13-afe0-4cf16b34a676 showed the
> following:
> 
> blocksize = 4096
> agblocks = 268435455
> agcount = 33
> cache_node_purge: refcount was 1, not zero (node=0x1ceb5e0)
> 
> and a warning, that v1 dirs being used. "Realtime-Bitmap-Inode and
> root-Inode (117) couldn't be read". (Machine isn't set to English. Don't
> ask.)
> 
> I tried XFS-repair, but it couldn't find the first or second super block
> after four hours.
> 

That sounds like something more significant is going on either with the
fs, the storage or xfs_repair has been pointed in the wrong place. The
above issue should at worst require zeroing the log, dealing with the
resulting inconsistency and rebuilding the fs btrees accurately.

I suspect it's too late to inspect what's going on there if you have
already restored from backup. In the future, you can use xfs_metadump to
capture a metadata only image of a broken fs to share with us and help
us diagnose what might have gone wrong.

> I could restore everything from backup, so it's not that important, but
> I've some similar XFS partitions on the same machine and have to avoid
> that this happens again.
> 

I'd suggest to run "xfs_repair -n" on those as soon as possible to see
if they are affected by the same problem. It might also be a good idea
to run it against the fs you've restored from backup to see if it
returns and possibly get an idea on what might have caused the problem.

Brian

> 
> Thank you in advance.
> 
> - Chris
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
