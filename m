Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 15:59:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2AMx2rS008835
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 15:59:04 -0700
Date: Mon, 10 Mar 2008 23:59:27 +0100
From: Andreas Kotes <count@flatline.de>
Subject: Re: XFS internal error
Message-ID: <20080310225927.GP14256@slop.flatline.de>
References: <470831E6.4030704@fastmail.co.uk> <20071008001452.GX995458@sgi.com> <20080310122216.GG14256@slop.flatline.de> <20080310223018.GA155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310223018.GA155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hello Dave,

* David Chinner <dgc@sgi.com> [20080310 23:30]:
> On Mon, Mar 10, 2008 at 01:22:16PM +0100, Andreas Kotes wrote:
> > * David Chinner <dgc@sgi.com> [20080310 13:18]:
> > > Yes, but those previous corruptions get left on disk as a landmine
> > > for you to trip over some time later, even on a kernel that has the
> > > bug fixed.
> > > 
> > > I suggest that you run xfs_check on the filesystem and if that
> > > shows up errors, run xfs_repair onteh filesystem to correct them.
> > 
> > I seem to be having similiar problems, and xfs_repair is not helping :(
> 
> xfs_repair is ensuring that the problem is not being caused by on-disk
> corruption. In this case, it does not appear to be caused by on-disk
> corruption, so xfs_repair won't help.

ok, too bad - btw, is it a problem that I'm doing the xfs_repair on a
mounted filesystem with xfs_repair -f -L after a remount rw?

> > I always run into:
> > 
> > [  137.099267] Filesystem "sda2": XFS internal error xfs_trans_cancel at line 1132 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff80372156
> > [  137.106267]
> > [  137.106268] Call Trace:
> > [  137.113129]  [<ffffffff803692f0>] xfs_trans_cancel+0x100/0x130
> > [  137.116524]  [<ffffffff80372156>] xfs_create+0x256/0x6e0
> > [  137.119904]  [<ffffffff80341e09>] xfs_dir2_isleaf+0x19/0x50
> > [  137.123269]  [<ffffffff8037e145>] xfs_vn_mknod+0x195/0x250
> > [  137.126607]  [<ffffffff8028f32c>] vfs_create+0xac/0xf0
> > [  137.129920]  [<ffffffff80292b3c>] open_namei+0x5dc/0x700
> > [  137.133227]  [<ffffffff8022a443>] __wake_up+0x43/0x70
> > [  137.136477]  [<ffffffff802851bc>] do_filp_open+0x1c/0x50
> > [  137.139693]  [<ffffffff8028524a>] do_sys_open+0x5a/0x100
> > [  137.142838]  [<ffffffff80220a83>] sysenter_do_call+0x1b/0x67
> > [  137.145964]
> > [  137.149014] xfs_force_shutdown(sda2,0x8) called from line 1133 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff8036930e
> > [  137.163485] Filesystem "sda2": Corruption of in-memory data detected.  Shutting down filesystem: sda2
> > 
> > directly after booting.
> 
> Interesting. I think I just found a cause of this shutdown under
> certain circumstances:
> 
> http://marc.info/?l=linux-xfs&m=120518791828200&w=2
> 
> To confirm it might be the same issue, can you dump the superblock of this
> filesystem for me?  i.e.:
> 
> # xfs_db -r -c 'sb 0' -c p /dev/sda2

certainly:

magicnum = 0x58465342
blocksize = 4096
dblocks = 35613152
rblocks = 0
rextents = 0
uuid = 62dae5fa-4085-4edc-ad76-5652d9fb00ae
logstart = 33554436
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 2225822
agcount = 16
rbmblocks = 0
logblocks = 17389
versionnum = 0x3084
sectsize = 512
inodesize = 256
inopblock = 16
fname = "s2g-serv\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 22
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 15232
ifree = 2379
fdblocks = 5942436
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 0
features2 = 0

> Also, what the mount options you are using are?

rw,noatime ...

if you want more info, just let me know :)

Kind regards from Berlin,

   Andreas

-- 
flatline IT services - Andreas Kotes - Tailored solutions for your IT needs
