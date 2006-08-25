Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 23:16:31 -0700 (PDT)
Received: from buick.jordet.net (buick.jordet.net [217.8.143.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7P6GEDW024637
	for <xfs@oss.sgi.com>; Thu, 24 Aug 2006 23:16:15 -0700
Subject: Re: xfs bug in 2.6.17.9?
From: Stian Jordet <liste@jordet.net>
In-Reply-To: <20060825115858.A3029472@wobbly.melbourne.sgi.com>
References: <92b7ea0a0608240245v700f19dex6ecb688efcab657b@mail.gmail.com>
	 <Pine.LNX.4.64.0608240942180.30908@p34.internal.lan>
	 <1156463263.19666.7.camel@localhost.localdomain>
	 <20060825115858.A3029472@wobbly.melbourne.sgi.com>
Content-Type: text/plain
Date: Fri, 25 Aug 2006 08:15:38 +0200
Message-Id: <1156486538.6854.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

fre, 25,.08.2006 kl. 11.58 +1000, skrev Nathan Scott:
> On Fri, Aug 25, 2006 at 01:47:43AM +0200, Stian Jordet wrote:
> > tor, 24,.08.2006 kl. 09.42 -0400, skrev Justin Piszcz:
> > > Aug 24 09:22:09 buick kernel: xfs_da_do_buf: bno 16777216
> > > 
> > > That is the bug from 2.6.17 -> 2.6.17.6.
> > > 
> > > It was patched in 2.6.17.7, but I assume(?) if you never fixed your FS to 
> > > begin with, you will still have the problem.  Read the XFS FAQ, and backup 
> > > your data before you do that :)
> > 
> > As I just wrote to Martin, I did run a couple of those kernels. But even
> > with updated xfsprogs I can't fix the errors... Is that "normal", or am
> > I in deep trouble?
> 
> This is likely to be lost+found being recreated each time, its
> normal if you don't do something about the lost+found files -
> once those are renamed/removed, it should run cleanly.

You seem to be right about that :)

But when I wake up this morning, I had my logs full of this:

0x0: 24 73 74 61 74 73 20 3d 20 7b 0a 20 20 27 73 68
Filesystem "rd/c0d1p1": XFS internal error xfs_da_do_buf(2) at line 2212
of file fs/xfs/xfs_da_btree.c.  Caller 0xc029d81c
 <c02b0b0b> xfs_corruption_error+0x10b/0x140  <c029d81c> xfs_da_read_buf
+0x3c/0x40
 <c02e10a1> kmem_zone_alloc+0x61/0xe0  <c029cd9a> xfs_da_buf_make
+0xfa/0x150
 <c029d719> xfs_da_do_buf+0x929/0x980  <c029d81c> xfs_da_read_buf
+0x3c/0x40
 <c029d81c> xfs_da_read_buf+0x3c/0x40  <c02a05fd> xfs_da_node_lookup_int
+0xcd/0x3b0
 <c02a05fd> xfs_da_node_lookup_int+0xcd/0x3b0  <c02a899f>
xfs_dir2_node_lookup+0x3f/0xc0
 <c02a325a> xfs_dir2_lookup+0x12a/0x130  <c02e91e6> xfs_vn_permission
+0x26/0x30
 <c016e220> vfs_permission+0x20/0x30  <c016e84a> __link_path_walk
+0x8a/0xfa0
 <c02d58cc> xfs_dir_lookup_int+0x4c/0x130  <c02da1fe> xfs_lookup
+0x7e/0xa0
 <c02e963e> xfs_vn_lookup+0x4e/0x90  <c016e119> __lookup_hash+0xe9/0x120
 <c0170088> do_unlinkat+0xa8/0x170  <c0168947> sys_stat64+0x27/0x30
 <c0102fcf> syscall_call+0x7/0xb

Don't know how many times, but many! Is that related to anything...?

Thanks!

Best regards,
Stian
