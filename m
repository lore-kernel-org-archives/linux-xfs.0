Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q769ojWr103651 for <xfs@oss.sgi.com>; Mon, 6 Aug 2012 04:50:45 -0500
Received: from mail-gh0-f181.google.com (mail-gh0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	7W9U2ZtyXjDIoupB (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Aug 2012 02:50:44 -0700 (PDT)
Received: by ghz3 with SMTP id 3so559253ghz.26
	for <xfs@oss.sgi.com>; Mon, 06 Aug 2012 02:50:43 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 Aug 2012 10:50:43 +0100
Message-ID: <CAP5prOivS=0PowpcEkmOWPRVo0V8HJQdDV+ZamM5bP5B_nZ5ew@mail.gmail.com>
Subject: XFS_WANT_CORRUPTED_GOTO error
From: Adam Huffman <adam.huffman@gmail.com>
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
To: xfs@oss.sgi.com

Hello

We suffered a power 'blip' yesterday morning and it caused some
corruption on our of our storage servers.  I had to run xfs_repair and
xfs_repair -L on several filesystems, after which I was able to mount
everything normally.

However, when I restart the storage software on the server immediately
messages like this appear:

 kernel: XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 4135 of
file fs/xfs/xfs_bmap.c.  Caller 0xffffffffa0229886
 kernel:
 kernel: Pid: 28552, comm: java Not tainted 2.6.32-279.2.1.el6.x86_64 #1
 kernel: Call Trace:
 kernel: [<ffffffffa021ff1f>] ? xfs_error_report+0x3f/0x50 [xfs]
 kernel: [<ffffffffa0229886>] ? xfs_iread_extents+0x86/0x110 [xfs]
 kernel: [<ffffffffa0201a74>] ? xfs_bmap_read_extents+0x154/0x350 [xfs]
 kernel: [<ffffffffa0229616>] ? xfs_iext_add+0x156/0x260 [xfs]
 kernel: [<ffffffffa0229886>] ? xfs_iread_extents+0x86/0x110 [xfs]
 kernel: [<ffffffffa0209008>] ? xfs_bmapi+0x198/0x1090 [xfs]
 kernel: [<ffffffff814ff506>] ? down_write+0x16/0x40
 kernel: [<ffffffffa022478e>] ? xfs_ilock+0x7e/0xd0 [xfs]
 kernel: [<ffffffffa02458ef>] ? __xfs_get_blocks+0x14f/0x440 [xfs]
 kernel: [<ffffffffa0245c11>] ? xfs_get_blocks+0x11/0x20 [xfs]
 kernel: [<ffffffff811af508>] ? block_read_full_page+0x198/0x3d0
 kernel: [<ffffffffa0245c00>] ? xfs_get_blocks+0x0/0x20 [xfs]
 kernel: [<ffffffff811b72ef>] ? do_mpage_readpage+0x3cf/0x5f0
 kernel: [<ffffffff8121a8d1>] ? avc_has_perm+0x71/0x90
 kernel: [<ffffffff811b755f>] ? mpage_readpage+0x4f/0x70
 kernel: [<ffffffffa0245c00>] ? xfs_get_blocks+0x0/0x20 [xfs]
 kernel: [<ffffffff8121a8d1>] ? avc_has_perm+0x71/0x90
 kernel: [<ffffffffa0246208>] ? xfs_vm_readpage+0x18/0x20 [xfs]
 kernel: [<ffffffff81115c3c>] ? generic_file_aio_read+0x1fc/0x700
 kernel: [<ffffffffa024b6df>] ? xfs_file_aio_read+0x17f/0x2d0 [xfs]
 kernel: [<ffffffff8117afda>] ? do_sync_read+0xfa/0x140
 kernel: [<ffffffff810920d0>] ? autoremove_wake_function+0x0/0x40
 kernel: [<ffffffff811803b4>] ? cp_new_stat+0xe4/0x100
 kernel: [<ffffffff8121febb>] ? selinux_file_permission+0xfb/0x150
 kernel: [<ffffffff81213266>] ? security_file_permission+0x16/0x20
 kernel: [<ffffffff8117b9e5>] ? vfs_read+0xb5/0x1a0
 kernel: [<ffffffff810d6b12>] ? audit_syscall_entry+0x272/0x2a0
 kernel: [<ffffffff8117bb21>] ? sys_read+0x51/0x90
 kernel: [<ffffffff8100b0f2>] ? system_call_fastpath+0x16/0x1b

The server is running CentOS 6.3, kernel 2.6.32-279.2.1.el6.x86_64.

The RAID controller is an Adaptec 5805ZQ, with 2 x 16-disk RAID6 logical drives.

Is there any way I can find out where this error is occurring i.e. on
which LVM logical volume?
Can it be fixed or is the filesystem irretrievably corrupted?

Best Wishes,
Adam

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
