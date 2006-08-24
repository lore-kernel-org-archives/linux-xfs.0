Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 06:43:45 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [66.45.37.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7ODhTDW005115
	for <xfs@oss.sgi.com>; Thu, 24 Aug 2006 06:43:31 -0700
Date: Thu, 24 Aug 2006 09:42:53 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: xfs bug in 2.6.17.9?
In-Reply-To: <92b7ea0a0608240245v700f19dex6ecb688efcab657b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0608240942180.30908@p34.internal.lan>
References: <92b7ea0a0608240245v700f19dex6ecb688efcab657b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: liste@jordet.nu
Cc: xfs@oss.sgi.com

Aug 24 09:22:09 buick kernel: xfs_da_do_buf: bno 16777216

That is the bug from 2.6.17 -> 2.6.17.6.

It was patched in 2.6.17.7, but I assume(?) if you never fixed your FS to 
begin with, you will still have the problem.  Read the XFS FAQ, and backup 
your data before you do that :)

Justin.

On Thu, 24 Aug 2006, Stian Jordet wrote:

> I got this on my server today, while it was not doing anything in
> particular...
>
> Aug 24 09:22:09 buick kernel: xfs_da_do_buf: bno 16777216
> Aug 24 09:22:09 buick kernel: dir: inode 14715927
> Aug 24 09:22:09 buick kernel: Filesystem "rd/c0d0p1": XFS internal error
> xfs_da_do_buf(1) at line 2119 of file fs/xfs/xfs_da_btree.c.  Caller
> 0xc029d81c
> Aug 24 09:22:09 buick kernel:  <c029d2ef> xfs_da_do_buf+0x4ff/0x980
> <c029d81c> xfs_da_read_buf+0x3c/0x40
> Aug 24 09:22:09 buick kernel:  <c02aacc8>
> xfs_dir2_leafn_lookup_int+0x2e8/0x520  <c02aacc8>
> xfs_dir2_leafn_lookup_int+0x2e8/0x520
> Aug 24 09:22:09 buick kernel:  <c02a538d>
> xfs_dir2_data_log_unused+0x6d/0x90  <c029d81c> xfs_da_read_buf+0x3c/0x40
> Aug 24 09:22:09 buick kernel:  <c02a8dd8>
> xfs_dir2_node_removename+0x368/0x5b0  <c02a8dd8>
> xfs_dir2_node_removename+0x368/0x5b0
> Aug 24 09:22:09 buick kernel:  <c02a3389> xfs_dir2_removename+0x129/0x130
> <c02cd593> xfs_icsb_modify_counters_int+0x73/0x1d0
> Aug 24 09:22:09 buick kernel:  <c02d4beb> xfs_trans_ijoin+0x3b/0x90
> <c02de404> xfs_remove+0x314/0x510
> Aug 24 09:22:09 buick kernel:  <c016e220> vfs_permission+0x20/0x30
> <c02e8e9a> xfs_vn_unlink+0x3a/0x70
> Aug 24 09:22:09 buick kernel:  <c02da26f> xfs_access+0x4f/0x60  <c02e91e6>
> xfs_vn_permission+0x26/0x30
> Aug 24 09:22:09 buick kernel:  <c016cff3> permission+0x73/0x110  <c016d7f3>
> may_delete+0x43/0x130
> Aug 24 09:22:09 buick kernel:  <c016dea1> vfs_unlink+0xc1/0x120  <c01700c1>
> do_unlinkat+0xe1/0x170
> Aug 24 09:22:09 buick kernel:  <c0102fcf> syscall_call+0x7/0xb
> Aug 24 09:22:09 buick kernel: Filesystem "rd/c0d0p1": XFS internal error
> xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c.  Caller 0xc02de475
> Aug 24 09:22:09 buick kernel:  <c02d2d2b> xfs_trans_cancel+0x10b/0x140
> <c02de475> xfs_remove+0x385/0x510
> Aug 24 09:22:09 buick kernel:  <c02de475> xfs_remove+0x385/0x510  <c016e220>
> vfs_permission+0x20/0x30
> Aug 24 09:22:09 buick kernel:  <c02e8e9a> xfs_vn_unlink+0x3a/0x70
> <c02da26f> xfs_access+0x4f/0x60
> Aug 24 09:22:09 buick kernel:  <c02e91e6> xfs_vn_permission+0x26/0x30
> <c016cff3> permission+0x73/0x110
> Aug 24 09:22:09 buick kernel:  <c016d7f3> may_delete+0x43/0x130  <c016dea1>
> vfs_unlink+0xc1/0x120
> Aug 24 09:22:09 buick kernel:  <c01700c1> do_unlinkat+0xe1/0x170  <c0102fcf>
> syscall_call+0x7/0xb
> Aug 24 09:22:09 buick kernel: Filesystem "rd/c0d0p1": Corruption of
> in-memory data detected.  Shutting down filesystem: rd/c0d0p1
> Aug 24 09:22:09 buick kernel: Please umount the filesystem, and rectify the
> problem(s)
>
> I'll update to latest 2.6.17.11 tonight, but I wonder if this is a known
> bug? I did upgrade the memory on this server from 2GB to 4GB about a week
> ago, there is a slight chance there's faulty ram in there, but I don't think
> that's the problem. And please, if this is the wrong place for problems like
> this, I'm really sorry.
>
> And after I went home in my lunch to restart it, it came up fine, but now
> it's dead again. Need to investigate more tonight...
>
> Any thoughts?
>
> Best regards,
> Stian
>
>
> [[HTML alternate version deleted]]
>
>
