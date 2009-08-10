Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7AET1Gg063162 for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 09:29:01 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CDB93B8527
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 07:29:46 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id pBQwNTNhmbqYFGEd for
	<xfs@oss.sgi.com>; Mon, 10 Aug 2009 07:29:46 -0700 (PDT)
Message-ID: <4A802EDC.1080706@sandeen.net>
Date: Mon, 10 Aug 2009 09:29:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem shutting down on linux 2.6.28.10 (xfs_rename)
References: <1367391532.793061249444829356.JavaMail.root@mail.vpac.org>
In-Reply-To: <1367391532.793061249444829356.JavaMail.root@mail.vpac.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chris Samuel <csamuel@vpac.org>
Cc: xfs@oss.sgi.com

Chris Samuel wrote:
> Hi folks,
> 
> I believe we've been hitting the same issue that
> Gabriel Barazer reported in 2.6.28.9 on the 22nd
> of July on our NFS server for our HPC Linux clusters.
> 
> Here is the backtrace we got this morning:
> 
> Aug  5 11:44:27 stg7 kernel: [680506.864506] Pid: 5271, comm: nfsd Not tainted 2.6.28.10-vpac-1 #1
> Aug  5 11:44:27 stg7 kernel: [680506.864508] Call Trace:
> Aug  5 11:44:27 stg7 kernel: [680506.864541]  [<ffffffffa032c8d5>] xfs_rename+0x5ac/0x5af [xfs]
> Aug  5 11:44:27 stg7 kernel: [680506.864567]  [<ffffffffa032d793>] xfs_trans_cancel+0x56/0xee [xfs]
> Aug  5 11:44:27 stg7 kernel: [680506.864589]  [<ffffffffa032c8d5>] xfs_rename+0x5ac/0x5af [xfs]
> Aug  5 11:44:27 stg7 kernel: [680506.864609]  [<ffffffffa033b8d0>] xfs_vn_rename+0x61/0x69 [xfs]
> Aug  5 11:44:27 stg7 kernel: [680506.864615]  [<ffffffff8029a798>] vfs_rename+0x28a/0x404
> Aug  5 11:44:27 stg7 kernel: [680506.864642]  [<ffffffffa045322c>] nfsd_rename+0x2ba/0x35f [nfsd]
> Aug  5 11:44:27 stg7 kernel: [680506.864654]  [<ffffffffa045a898>] nfsd3_proc_rename+0x120/0x131 [nfsd]
> Aug  5 11:44:27 stg7 kernel: [680506.864681]  [<ffffffffa044f23b>] nfsd_dispatch+0xdd/0x1b9 [nfsd]
> Aug  5 11:44:27 stg7 kernel: [680506.864706]  [<ffffffffa03b3cdd>] svc_process+0x3e6/0x70e [sunrpc]
> Aug  5 11:44:27 stg7 kernel: [680506.864711]  [<ffffffff8022f9f2>] default_wake_function+0x0/0xe
> Aug  5 11:44:27 stg7 kernel: [680506.864717]  [<ffffffff8040dfac>] __down_read+0x15/0x99
> Aug  5 11:44:27 stg7 kernel: [680506.864740]  [<ffffffffa044f7d1>] nfsd+0x1a0/0x26c [nfsd]
> Aug  5 11:44:27 stg7 kernel: [680506.864750]  [<ffffffffa044f631>] nfsd+0x0/0x26c [nfsd]
> Aug  5 11:44:27 stg7 kernel: [680506.864754]  [<ffffffff802470de>] kthread+0x47/0x73
> Aug  5 11:44:27 stg7 kernel: [680506.864757]  [<ffffffff80232f9a>] schedule_tail+0x27/0x60
> Aug  5 11:44:27 stg7 kernel: [680506.864761]  [<ffffffff8020ccd9>] child_rip+0xa/0x11
> Aug  5 11:44:27 stg7 kernel: [680506.864764]  [<ffffffff80247097>] kthread+0x0/0x73
> Aug  5 11:44:27 stg7 kernel: [680506.864766]  [<ffffffff8020cccf>] child_rip+0x0/0x11
> Aug  5 11:44:27 stg7 kernel: [680506.864770] xfs_force_shutdown(md25,0x8) called from line 1165 of file fs/xfs/xfs
> _trans.c.  Return address = 0xffffffffa032d7ac

...

Just for the record, Chris let me know offline that he tried ext4 and
got an error:

> EXT4-fs: mounted filesystem sde1 with ordered data mode
> end_request: I/O error, dev sde, sector 1430524111
> Aborting journal on device sde1:8.
> ext4_abort called.
> EXT4-fs error (device sde1): ext4_journal_start_sb: Detected aborted journal
> Remounting filesystem read-only
> <snip>
> ext4_abort called.
> EXT4-fs error (device sde1): ext4_put_super: Couldn't clean up the journal
> end_request: I/O error, dev sde, sector 63

so he got IO errors to sector 1430524111 and sector 63 (!)

the question may now be whether xfs got an IO error causing the dirty
transaction cancellation but didn't report it as such.

Also interesting that no other layers complained about the IO error ...

What's your storage stack look like?

-Eric

> This kernel is built with XFS as a kernel module so I've
> been able to attach the objdump output that Eric Sandeen
> had originally requested from Gabriel.
> 
> Like Gabriel we're stuck on 2.6.28.x as the last working
> NFS exporting XFS kernel due to kernel bug #13375 (the
> radix bug), so I hope this helps!
> 
> cheers,
> Chris
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
