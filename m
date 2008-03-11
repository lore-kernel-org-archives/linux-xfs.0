Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 01:08:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2B885HK002377
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 01:08:09 -0700
Received: from wx-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76506682E6F
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 01:08:35 -0700 (PDT)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.236]) by cuda.sgi.com with ESMTP id lpJKIxI3l7zoErKD for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 01:08:35 -0700 (PDT)
Received: by wx-out-0506.google.com with SMTP id s9so2307964wxc.32
        for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 01:08:34 -0700 (PDT)
Message-ID: <1a4a774c0803110108u3f01813fs7f9540f886be055@mail.gmail.com>
Date: Tue, 11 Mar 2008 09:08:31 +0100
From: "=?ISO-8859-1?Q?Christian_R=F8snes?=" <christian.rosnes@gmail.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
In-Reply-To: <20080310222135.GZ155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com>
	 <20080213214551.GR155407@sgi.com>
	 <1a4a774c0803050553h7f6294cfq41c38f34ea92ceae@mail.gmail.com>
	 <1a4a774c0803060310w2642224w690ac8fa13f96ec@mail.gmail.com>
	 <1a4a774c0803070319j1eb8790ek3daae4a16b3e6256@mail.gmail.com>
	 <20080310000809.GU155407@sgi.com>
	 <1a4a774c0803100302y17530814wee7522aa0dfd7668@mail.gmail.com>
	 <1a4a774c0803100134k258e1bcfma95e7969bc44b2af@mail.gmail.com>
	 <20080310222135.GZ155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Mar 10, 2008 at 11:21 PM, David Chinner <dgc@sgi.com> wrote:

>  You've got a filesystem with stripe alignment set. In xfs_ialloc_ag_alloc()
>  we attempt inode allocation by the following rules:
>
>         1. a) If we haven't previously allocated inodes, fall through to 2.
>            b) If we have previously allocated inode, attempt to allocate next
>               to the last inode chunk.
>
>         2. If we do not have an extent now:
>                 a) if we have stripe alignment, try with alignment
>                 b) if we don't have stripe alignment try cluster alignment
>
>         3. If we do not have an extent now:
>                 a) if we have stripe alignment, try with cluster alignment
>                 b) no stripe alignment, turn off alignment.
>
>         4. If we do not have an extent now: FAIL.
>
>  Note the case missing from the stripe alignment fallback path - it does not
>  try without alignment at all. That means if all those extents large enough
>  that we found above are not correctly aligned, then we will still fail
>  to allocate an inode chunk. if all the AGs are like this, then we'll
>  fail to allocate at all and fall out of xfs_dialloc() through the last
>  fragment I quoted above.
>
>  As to the shutdown that this triggers - the attempt to allocate dirties
>  the AGFL and the AGF by moving free blocks into the free list for btree
>  splits and cancelling a dirty transaction results in a shutdown.
>
>  Now, to test this theory. ;) Luckily, it's easy to test. mount the
>  filesystem with the mount option "noalign" and rerun the mkdir test.
>  If it is an alignment problem, then setting noalign will prevent
>  this ENOSPC and shutdown as the filesystem will be able to allocate
>  more inodes.
>
>  Can you test this for me, Christian?

Thanks. Unfortunately noalign didn't solve my problem:

# mount | grep /data
/dev/sdb1 on /data type xfs (rw,noatime,noalign,logbufs=8,nobarrier)

# mkdir /data/test

results in:

Filesystem "sdb1": XFS internal error xfs_trans_cancel at line 1163 of
file fs/xfs/xfs_trans.c.  Caller 0xc021a010
Pid: 17889, comm: mkdir Not tainted 2.6.24.3FC #7
 [<c0212678>] xfs_trans_cancel+0x5d/0xe6
 [<c021a010>] xfs_mkdir+0x45a/0x493
 [<c021a010>] xfs_mkdir+0x45a/0x493
 [<c01cbb8f>] xfs_acl_vhasacl_default+0x33/0x44
 [<c0222d70>] xfs_vn_mknod+0x165/0x243
 [<c0217b9e>] xfs_access+0x2f/0x35
 [<c0222e6d>] xfs_vn_mkdir+0x12/0x14
 [<c016057b>] vfs_mkdir+0xa3/0xe2
 [<c0160644>] sys_mkdirat+0x8a/0xc3
 [<c016069c>] sys_mkdir+0x1f/0x23
 [<c01025ee>] syscall_call+0x7/0xb
 [<c03b0000>] atm_reset_addr+0xd/0x83
 =======================
xfs_force_shutdown(sdb1,0x8) called from line 1164 of file
fs/xfs/xfs_trans.c.  Return address = 0xc0212690
Filesystem "sdb1": Corruption of in-memory data detected.  Shutting
down filesystem: sdb1
Please umount the filesystem, and rectify the problem(s)


I'll try to add some printk statements to the codepaths you mentioned,
and see where it leads.

Christian
