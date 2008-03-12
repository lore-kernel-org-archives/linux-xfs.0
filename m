Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Mar 2008 10:50:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2CHoPrW031475
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2008 10:50:27 -0700
Date: Wed, 12 Mar 2008 18:50:50 +0100
From: Andreas Kotes <count-linux@flatline.de>
Subject: Re: XFS internal error
Message-ID: <20080312175050.GD14256@slop.flatline.de>
References: <470831E6.4030704@fastmail.co.uk> <20071008001452.GX995458@sgi.com> <20080310122216.GG14256@slop.flatline.de> <20080310223018.GA155407@sgi.com> <20080310225927.GP14256@slop.flatline.de> <20080310234539.GC155407@sgi.com> <20080311134746.GQ14256@slop.flatline.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311134746.GQ14256@slop.flatline.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Hello,

* Andreas Kotes <count-linux@flatline.de> [20080311 14:47]:
> I basically build a PXE image which does an xfs_repair -L /dev/sda2 from
> initrd - and the problem persists. Sigh. Exactly no change.

ok, I cannot find the differences, but I have five machines showing
similiar symptoms:

= a6b =
[1924291.170115] Filesystem "sda2": XFS internal error xfs_trans_cancel
at line 1132 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff80372895
[1924291.176058]
[1924291.176059] Call Trace:
[1924291.182571]  [<ffffffff803692f0>] xfs_trans_cancel+0x100/0x130
[1924291.186252]  [<ffffffff80372895>] xfs_link+0x2b5/0x480
[1924291.190045]  [<ffffffff80290b4a>] __link_path_walk+0x74a/0xe30
[1924291.194073]  [<ffffffff8037dcbd>] xfs_vn_link+0x5d/0xd0
[1924291.197940]  [<ffffffff80369e9b>] xfs_trans_unlocked_item+0x3b/0x60
[1924291.201739]  [<ffffffff8036f5f5>] xfs_lookup+0xa5/0xb0
[1924291.205675]  [<ffffffff8066fe81>] __mutex_lock_slowpath+0x121/0x260
[1924291.209838]  [<ffffffff8037dc4a>] xfs_vn_lookup+0x6a/0x80
[1924291.214218]  [<ffffffff8028ef72>] vfs_link+0xf2/0x140
[1924291.218643]  [<ffffffff802922e1>] sys_linkat+0x151/0x180
[1924291.223179]  [<ffffffff8028a1bd>] vfs_lstat_fd+0x4d/0x70
[1924291.227864]  [<ffffffff80220a83>] sysenter_do_call+0x1b/0x67
[1924291.232745]  [<ffffffff8037d600>] xfs_vn_getattr+0x0/0x110
[1924291.237489]
[1924291.241936] xfs_force_shutdown(sda2,0x8) called from line 1133 of
file fs/xfs/xfs_trans.c.  Return address = 0xffffffff8036930e

= a7b =
[  137.099267] Filesystem "sda2": XFS internal error xfs_trans_cancel at
line 1132 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff80372156
[  137.106267]
[  137.106268] Call Trace:
[  137.113129]  [<ffffffff803692f0>] xfs_trans_cancel+0x100/0x130
[  137.116524]  [<ffffffff80372156>] xfs_create+0x256/0x6e0
[  137.119904]  [<ffffffff80341e09>] xfs_dir2_isleaf+0x19/0x50
[  137.123269]  [<ffffffff8037e145>] xfs_vn_mknod+0x195/0x250
[  137.126607]  [<ffffffff8028f32c>] vfs_create+0xac/0xf0
[  137.129920]  [<ffffffff80292b3c>] open_namei+0x5dc/0x700
[  137.133227]  [<ffffffff8022a443>] __wake_up+0x43/0x70
[  137.136477]  [<ffffffff802851bc>] do_filp_open+0x1c/0x50
[  137.139693]  [<ffffffff8028524a>] do_sys_open+0x5a/0x100
[  137.142838]  [<ffffffff80220a83>] sysenter_do_call+0x1b/0x67
[  137.145964]
[  137.149014] xfs_force_shutdown(sda2,0x8) called from line 1133 of
file fs/xfs/xfs_trans.c.  Return address = 0xffffffff8036930e

= a7i =
[35595.024715] Filesystem "sda2": XFS internal error xfs_trans_cancel at
line 1132 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff80372895
[35595.030585]
[35595.030586] Call Trace:
[35595.036749]  [<ffffffff803692f0>] xfs_trans_cancel+0x100/0x130
[35595.039804]  [<ffffffff80372895>] xfs_link+0x2b5/0x480
[35595.042774]  [<ffffffff80290b4a>] __link_path_walk+0x74a/0xe30
[35595.045834]  [<ffffffff8037dcbd>] xfs_vn_link+0x5d/0xd0
[35595.049002]  [<ffffffff80369e9b>] xfs_trans_unlocked_item+0x3b/0x60
[35595.052255]  [<ffffffff8036f5f5>] xfs_lookup+0xa5/0xb0
[35595.055554]  [<ffffffff8066fe81>] __mutex_lock_slowpath+0x121/0x260
[35595.059007]  [<ffffffff8037dc4a>] xfs_vn_lookup+0x6a/0x80
[35595.062576]  [<ffffffff8028ef72>] vfs_link+0xf2/0x140
[35595.066248]  [<ffffffff802922e1>] sys_linkat+0x151/0x180
[35595.070159]  [<ffffffff8028a1bd>] vfs_lstat_fd+0x4d/0x70
[35595.073942]  [<ffffffff8066e4ef>] thread_return+0x0/0x741
[35595.077652]  [<ffffffff80220a83>] sysenter_do_call+0x1b/0x67
[35595.081297]  [<ffffffff8037d600>] xfs_vn_getattr+0x0/0x110
[35595.085022]
[35595.088792] xfs_force_shutdown(sda2,0x8) called from line 1133 of
file fs/xfs/xfs_trans.c.  Return address = 0xffffffff8036930e

= a9i =
[  150.210765] Filesystem "sda2": XFS internal error xfs_trans_cancel at
line 1132 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff80372156
[  150.217907]
[  150.217908] Call Trace:
[  150.225265]  [<ffffffff803692f0>] xfs_trans_cancel+0x100/0x130
[  150.229091]  [<ffffffff80372156>] xfs_create+0x256/0x6e0
[  150.233118]  [<ffffffff80341e09>] xfs_dir2_isleaf+0x19/0x50
[  150.237054]  [<ffffffff8037e145>] xfs_vn_mknod+0x195/0x250
[  150.241055]  [<ffffffff8028f32c>] vfs_create+0xac/0xf0
[  150.245126]  [<ffffffff80292b3c>] open_namei+0x5dc/0x700
[  150.249259]  [<ffffffff8022a443>] __wake_up+0x43/0x70
[  150.253435]  [<ffffffff802851bc>] do_filp_open+0x1c/0x50
[  150.257694]  [<ffffffff8028524a>] do_sys_open+0x5a/0x100
[  150.261965]  [<ffffffff80220a83>] sysenter_do_call+0x1b/0x67
[  150.266326]
[  150.270729] xfs_force_shutdown(sda2,0x8) called from line 1133 of
file fs/xfs/xfs_trans.c.  Return address = 0xffffffff8036930e

= a2i =
[128951.705981] Filesystem "sda2": XFS internal error xfs_trans_cancel
at line 1132 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff80372895
[128951.709417]
[128951.709418] Call Trace:
[128951.712992]  [<ffffffff803692f0>] xfs_trans_cancel+0x100/0x130
[128951.714928]  [<ffffffff80372895>] xfs_link+0x2b5/0x480
[128951.716939]  [<ffffffff80290b4a>] __link_path_walk+0x74a/0xe30
[128951.719015]  [<ffffffff8037dcbd>] xfs_vn_link+0x5d/0xd0
[128951.721188]  [<ffffffff80369e9b>] xfs_trans_unlocked_item+0x3b/0x60
[128951.723493]  [<ffffffff8036f5f5>] xfs_lookup+0xa5/0xb0
[128951.725833]  [<ffffffff8066fe81>] __mutex_lock_slowpath+0x121/0x260
[128951.728113]  [<ffffffff8037dc4a>] xfs_vn_lookup+0x6a/0x80
[128951.730352]  [<ffffffff8028ef72>] vfs_link+0xf2/0x140
[128951.732637]  [<ffffffff802922e1>] sys_linkat+0x151/0x180
[128951.734982]  [<ffffffff8028a1bd>] vfs_lstat_fd+0x4d/0x70
[128951.737414]  [<ffffffff80220a83>] sysenter_do_call+0x1b/0x67
[128951.739932]  [<ffffffff8037d600>] xfs_vn_getattr+0x0/0x110
[128951.742416]
[128951.744790] xfs_force_shutdown(sda2,0x8) called from line 1133 of
file fs/xfs/xfs_trans.c.  Return address = 0xffffffff8036930e

... yes, not all of them were freshly booted, and not all of them had a
fresh xfs_repair, but I think this might help narrowing down on the
problem a bit ... all of them are running 2.6.22.16 right now.

any suggestions?

Br,

   Andreas

P.S: I've taken this off LKML, and will leave the systems largely
untouched until I hear from you ...

-- 
flatline IT services - Andreas Kotes - Tailored solutions for your IT needs
