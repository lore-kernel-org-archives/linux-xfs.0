Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 02:16:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8N9GfiX004706
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 02:16:42 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1661E46FE73
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 02:18:15 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id o930lEvsQfGwVCAy for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 02:18:15 -0700 (PDT)
Date: Tue, 23 Sep 2008 19:18:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1138 of file
	fs/xfs/xfs_trans.c
Message-ID: <20080923091811.GE5448@disturbed>
References: <48D6A0AD.3040307@kevinjamieson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D6A0AD.3040307@kevinjamieson.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kevin Jamieson <kevin@kevinjamieson.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 21, 2008 at 12:29:49PM -0700, Kevin Jamieson wrote:
> The forced shutdown is also reproducible with this file system mounted  
> on a more recent kernel version -- here is a stack trace from the same  
> file system mounted on a 2.6.26 kernel built from oss.sgi.com cvs on Sep  
> 19 2008:
>
> Sep 21 06:35:41 gn1 kernel: Filesystem "loop0": XFS internal error  
> xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 
> 0xf93c8195
> Sep 21 06:35:41 gn1 kernel:  [<f93c2fc0>] xfs_trans_cancel+0x4d/0xd3 [xfs]
> Sep 21 06:35:41 gn1 kernel:  [<f93c8195>] xfs_create+0x49b/0x4db [xfs]
> Sep 21 06:35:41 gn1 kernel:  [<f93c8195>] xfs_create+0x49b/0x4db [xfs]
> Sep 21 06:35:41 gn1 kernel:  [<f93d166b>] xfs_vn_mknod+0x128/0x1e3 [xfs]
> Sep 21 06:35:41 gn1 kernel:  [<c0170e9d>] vfs_create+0xb4/0x117
> Sep 21 06:35:41 gn1 kernel:  [<c0172c46>] do_filp_open+0x1a0/0x671
> Sep 21 06:35:41 gn1 kernel:  [<c01681da>] do_sys_open+0x40/0xb6
> Sep 21 06:35:41 gn1 kernel:  [<c0168294>] sys_open+0x1e/0x23
> Sep 21 06:35:41 gn1 kernel:  [<c0104791>] sysenter_past_esp+0x6a/0x99
> Sep 21 06:35:41 gn1 kernel:  [<c02b0000>] unix_listen+0x8/0xc9
> Sep 21 06:35:41 gn1 kernel:  =======================
> Sep 21 06:35:41 gn1 kernel: xfs_force_shutdown(loop0,0x8) called from  
> line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xf93c2fd6
> Sep 21 06:35:41 gn1 kernel: Filesystem "loop0": Corruption of in-memory  
> data detected.  Shutting down filesystem: loop0

Oh, that's interesting. I've been trying to track down the problem
on TOT kernels without much luck recently.

> Tracing through the XFS code, the ENOSPC error is returned here from  
> fs/xfs/xfs_da_btree.c:
>
> xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno)
> {
> ...
> 	if (got != count || mapp[0].br_startoff != bno ||
> 		...
> 	    return XFS_ERROR(ENOSPC);
> 	}
> ...
> }
>
> where got = 0 and count = 1 and xfs_da_grow_inode() is called from  
> xfs_create() -> xfs_dir_createname() -> xfs_dir2_node_addname() ->  
> xfs_da_split() -> xfs_da_root_split()

got = 0 means that xfs_bmapi() returned zero blocks. Given that it
was only being asked for a single block (from the xfs_info output),
that implies that either the FS was out of space or that the order
of AG locking meant we couldn't get to the AGs that had space in
them. Given that the transaction reservation or the
xfs_dir_can_enter() check should ensure we have space availlable,

I'm inclined to think that the free space is in an AG we can't
currently allocate out of because of previous allocations for
other blocks needed by the split....

> xfs_repair -n (the latest version of xfs_repair from cvs, as the SLES 10  
> SP1 version just runs out of memory) does not report any problems with  
> the file system, but after running xfs_repair (without -n) on the file  
> system, the error can no longer be triggered. Based on this, I suspect a  
> problem with the free space btrees, as I understand that xfs_repair  
> rebuilds them. I tried running xfs_check (latest cvs version also) as  
> well but it runs out of memory and dies.

Rebuilding the freespace trees will change the pattern of free space
in each AG, which means the same sequence of events could result in
different allocation patterns.

> Are there any known issues in 2.6.16 that could lead to this sort of  
> problem? If there is any additional information that would be helpful in  
> tracking this down, please let me know. If needed, I can probably make a  
> xfs_metadump of the file system available to someone from SGI later this  
> week.

A metadump will tell us what the freespace patterns are....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
