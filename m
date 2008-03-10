Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 05:22:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2ACLocl024845
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 05:21:52 -0700
Date: Mon, 10 Mar 2008 13:22:16 +0100
From: Andreas Kotes <count-linux@flatline.de>
Subject: Re: XFS internal error
Message-ID: <20080310122216.GG14256@slop.flatline.de>
References: <470831E6.4030704@fastmail.co.uk> <20071008001452.GX995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008001452.GX995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hello,

* David Chinner <dgc@sgi.com> [20080310 13:18]:
> Yes, but those previous corruptions get left on disk as a landmine
> for you to trip over some time later, even on a kernel that has the
> bug fixed.
> 
> I suggest that you run xfs_check on the filesystem and if that
> shows up errors, run xfs_repair onteh filesystem to correct them.

I seem to be having similiar problems, and xfs_repair is not helping :(

I always run into:

[  137.099267] Filesystem "sda2": XFS internal error xfs_trans_cancel at line 1132 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff80372156
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
[  137.149014] xfs_force_shutdown(sda2,0x8) called from line 1133 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff8036930e
[  137.163485] Filesystem "sda2": Corruption of in-memory data detected.  Shutting down filesystem: sda2

directly after booting.

I'm using kernel 2.6.22.16 and xfs_repair version 2.9.7

How can I help finding the problem? I'd like xfs_repair to be able to
fix this.

Br,

   Andreas

-- 
flatline IT services - Andreas Kotes - Tailored solutions for your IT needs
