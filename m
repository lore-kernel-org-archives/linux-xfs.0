Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 84B677F47
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 11:08:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4E01230407A
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 09:08:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id SLj1TkFjpvN7ihUf for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 09:08:53 -0700 (PDT)
Message-ID: <53A9A295.8030302@sandeen.net>
Date: Tue, 24 Jun 2014 11:08:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Metadata CRC error upon unclean unmount
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
In-Reply-To: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Fanael Linithien <fanael4@gmail.com>, xfs@oss.sgi.com

On 6/24/14, 11:01 AM, Fanael Linithien wrote:
> XFS V5 can become unmountable after an unclean unmount. Zeroing the
> log and running xfs_repair fixes the filesystem.
> 
> The following kernel messages are from Linux 3.14.4, but the same
> thing happens in 3.15.1.

Do you have any kind of reproducer for this?  Any chance you created
an xfs_metadump before the xfs_repair?

What constitutes an "unclean unmount" in your case; a VM reset?  A host
crash?

(This is a VM, right?)  What sort of block device configuration does it have?

-Eric

> SGI XFS with ACLs, security attributes, realtime, large block/inode
> numbers, no debug enabled
> XFS (sda2): Version 5 superblock detected. This kernel has
> EXPERIMENTAL support enabled!
> Use of these features in this kernel is at your own risk!
> XFS (sda2): Using inode cluster size of 16384 bytes
> XFS (sda2): Mounting Filesystem
> XFS (sda2): Starting recovery (logdev: internal)
> XFS (sda2): Version 5 superblock detected. This kernel has
> EXPERIMENTAL support enabled!
> Use of these features in this kernel is at your own risk!
> ffff880063e85000: 41 42 33 42 00 00 00 2b ff ff ff ff ff ff ff ff
> AB3B...+........
> ffff880063e85010: 00 00 00 00 01 f3 6a 00 00 00 00 01 00 00 06 c9
> ......j.........
> ffff880063e85020: 30 c1 4d f1 3a e2 44 7d a7 bb 25 1f a5 65 5a 7f
> 0.M.:.D}..%..eZ.
> ffff880063e85030: 00 00 00 01 4d 5f 10 db 00 00 00 01 00 00 00 07
> ....M_..........
> XFS (sda2): Internal error xfs_allocbt_read_verify at line 362 of file
> fs/xfs/xfs_alloc_btree.c.  Caller 0xffffffffa0527be5
> CPU: 0 PID: 93 Comm: kworker/0:1H Not tainted 3.14.4-1-ARCH #1
> Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> Workqueue: xfslogd xfs_buf_iodone_work [xfs]
>  0000000000000000 00000000cebb8ca3 ffff88006e927d90 ffffffff8150996e
>  ffff880067064800 ffff88006e927dd0 ffffffffa052ae00 ffffffffa0527be5
>  ffffffffa05ab718 ffff8800672132a0 ffff880067213200 ffffffffa0527be5
> Call Trace:
>  [<ffffffff8150996e>] dump_stack+0x4d/0x6f
>  [<ffffffffa052ae00>] xfs_corruption_error+0x90/0xa0 [xfs]
>  [<ffffffffa0527be5>] ? xfs_buf_iodone_work+0x75/0xa0 [xfs]
>  [<ffffffffa0527be5>] ? xfs_buf_iodone_work+0x75/0xa0 [xfs]
>  [<ffffffffa0546ed9>] xfs_allocbt_read_verify+0x69/0xe0 [xfs]
>  [<ffffffffa0527be5>] ? xfs_buf_iodone_work+0x75/0xa0 [xfs]
>  [<ffffffffa0527be5>] xfs_buf_iodone_work+0x75/0xa0 [xfs]
>  [<ffffffff81088068>] process_one_work+0x168/0x450
>  [<ffffffff81088ac2>] worker_thread+0x132/0x3e0
>  [<ffffffff81088990>] ? manage_workers.isra.23+0x2d0/0x2d0
>  [<ffffffff8108f2ea>] kthread+0xea/0x100
>  [<ffffffff811b0000>] ? __mem_cgroup_try_charge+0x6a0/0x8a0
>  [<ffffffff8108f200>] ? kthread_create_on_node+0x1a0/0x1a0
>  [<ffffffff815176bc>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8108f200>] ? kthread_create_on_node+0x1a0/0x1a0
> XFS (sda2): Corruption detected. Unmount and run xfs_repair
> XFS (sda2): metadata I/O error: block 0x1f36a00
> ("xfs_trans_read_buf_map") error 117 numblks 8
> XFS (sda2): Failed to recover EFIs
> XFS (sda2): log mount finish failed
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
