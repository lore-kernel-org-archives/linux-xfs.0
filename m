Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 Mar 2007 06:08:51 -0700 (PDT)
Received: from mail.gatrixx.com (mail.gatrixx.com [217.111.11.44])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2SD8j6p021066
	for <xfs@oss.sgi.com>; Wed, 28 Mar 2007 06:08:46 -0700
Message-ID: <460A6298.4040702@j-o-a.de>
Date: Wed, 28 Mar 2007 14:42:00 +0200
From: Oliver Joa <oliver@j-o-a.de>
MIME-Version: 1.0
Subject: Re: Corrupt XFS -Filesystems on new Hardware and Kernel
References: <46094344.4090007@j-o-a.de> <20070328113141.GQ32597093@melbourne.sgi.com>
In-Reply-To: <20070328113141.GQ32597093@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

Hi,

David Chinner wrote:

[...]

> What is the corruption message in the log from XFS?
> Can you please post that? Without it we really can't help you.
> 
> Also, please check to see if there are any I/O errors
> in the log around the time the corruption message appears.

Ok, here is a test:

test:/# find / -xdev | cpio -padm /test/
cpio: /usr/src/linux-2.6.20.2/Documentation/networking/NAPI_HOWTO.txt: 
Structure needs cleaning
3648371 blocks
test:/#

test:/home/olli# uname -a
Linux test 2.6.20.4-majestix-1 #1 SMP PREEMPT Tue Mar 27 12:15:41 CEST 
2007 i686 GNU/Linux

dmesg gives the following:
[15442.935941] Filesystem "sda3": XFS internal error xfs_iformat(6) at 
line 492 of file fs/xfs/xfs_inode.c.  Caller 0xc0211f94
[15442.936003]  [<c0216dba>] xfs_iread+0x4ee/0x6e8
[15442.936039]  [<c0211f94>] xfs_iget+0x2e4/0x714
[15442.936071]  [<c0211f94>] xfs_iget+0x2e4/0x714
[15442.936101]  [<c02293be>] xfs_dir_lookup_int+0x7d/0xd4
[15442.936135]  [<c022cc6b>] xfs_lookup+0x52/0x78
[15442.936167]  [<c0238a22>] xfs_vn_lookup+0x3b/0x70
[15442.936201]  [<c0153e6d>] do_lookup+0xa3/0x140
[15442.936234]  [<c015578e>] __link_path_walk+0x73d/0xb5e
[15442.936278]  [<c0211655>] xfs_iunlock+0x51/0x6d
[15442.936309]  [<c0155bf3>] link_path_walk+0x44/0xb3
[15442.936342]  [<c0155efe>] do_path_lookup+0x176/0x191
[15442.936373]  [<c0154ef8>] getname+0x59/0x8f
[15442.936402]  [<c01566b8>] __user_walk_fd+0x2f/0x45
[15442.936431]  [<c0150a09>] vfs_lstat_fd+0x16/0x3d
[15442.936461]  [<c0150a75>] sys_lstat64+0xf/0x23
[15442.936490]  [<c0102bd8>] syscall_call+0x7/0xb
[15442.936519]  =======================

And after this command:

test:/# rm /usr/src/linux-2.6.20.2/Documentation/networking/NAPI_HOWTO.txt
rm: cannot remove 
`/usr/src/linux-2.6.20.2/Documentation/networking/NAPI_HOWTO.txt': 
Structure needs cleaning
test:/#

I got:

[18359.750604] Filesystem "sda3": XFS internal error xfs_iformat(6) at 
line 492 of file fs/xfs/xfs_inode.c.  Caller 0xc0211f94
[18359.750701]  [<c0216dba>] xfs_iread+0x4ee/0x6e8
[18359.750755]  [<c0211f94>] xfs_iget+0x2e4/0x714
[18359.750802]  [<c0211f94>] xfs_iget+0x2e4/0x714
[18359.750849]  [<c02293be>] xfs_dir_lookup_int+0x7d/0xd4
[18359.750897]  [<c022cc6b>] xfs_lookup+0x52/0x78
[18359.750943]  [<c0238a22>] xfs_vn_lookup+0x3b/0x70
[18359.750990]  [<c0153e6d>] do_lookup+0xa3/0x140
[18359.751036]  [<c015578e>] __link_path_walk+0x73d/0xb5e
[18359.751086]  [<c0155bf3>] link_path_walk+0x44/0xb3
[18359.751133]  [<c0252afc>] rb_insert_color+0x4c/0xad
[18359.751180]  [<c0142044>] vma_link+0x54/0xcd
[18359.751226]  [<c0155efe>] do_path_lookup+0x176/0x191
[18359.751273]  [<c0154ef8>] getname+0x59/0x8f
[18359.751318]  [<c01566b8>] __user_walk_fd+0x2f/0x45
[18359.751364]  [<c0150a09>] vfs_lstat_fd+0x16/0x3d
[18359.751410]  [<c0252afc>] rb_insert_color+0x4c/0xad
[18359.751457]  [<c0142044>] vma_link+0x54/0xcd
[18359.751501]  [<c0150a75>] sys_lstat64+0xf/0x23
[18359.751546]  [<c0110545>] do_page_fault+0x277/0x526
[18359.751595]  [<c01102ce>] do_page_fault+0x0/0x526
[18359.751640]  [<c0102bd8>] syscall_call+0x7/0xb
[18359.751686]  [<c0360033>] rsc_parse+0x6f/0x37f
[18359.751732]  =======================
[18359.751784] Filesystem "sda3": XFS internal error xfs_iformat(6) at 
line 492 of file fs/xfs/xfs_inode.c.  Caller 0xc0211f94
[18359.751859]  [<c0216dba>] xfs_iread+0x4ee/0x6e8
[18359.751906]  [<c0211f94>] xfs_iget+0x2e4/0x714
[18359.751952]  [<c0211f94>] xfs_iget+0x2e4/0x714
[18359.751998]  [<c02293be>] xfs_dir_lookup_int+0x7d/0xd4
[18359.752047]  [<c022cc6b>] xfs_lookup+0x52/0x78
[18359.752094]  [<c0238a22>] xfs_vn_lookup+0x3b/0x70
[18359.752140]  [<c0154bcf>] __lookup_hash+0xb1/0xe1
[18359.752191]  [<c0156241>] do_unlinkat+0x5f/0x126
[18359.752237]  [<c0110545>] do_page_fault+0x277/0x526
[18359.752285]  [<c0102bd8>] syscall_call+0x7/0xb
[18359.752331]  [<c0360033>] rsc_parse+0x6f/0x37f
[18359.752376]  =======================



Thanks a Lot

Oliver
