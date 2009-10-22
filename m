Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9MEPNTD102171 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 09:25:24 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 123B7C36A61
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 07:26:56 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 68wo24Xkplu1bQ3E for
	<xfs@oss.sgi.com>; Thu, 22 Oct 2009 07:26:56 -0700 (PDT)
Message-ID: <4AE06BAE.8090706@sandeen.net>
Date: Thu, 22 Oct 2009 09:26:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 1992 of file
	fs/xfs/xfs_da_btree.c
References: <c2dcdfa40910202307m77a9d7c5lf18e278a9ebae08e@mail.gmail.com>	<4ADF2EE8.6010700@sandeen.net>	<c2dcdfa40910211032y5b1d2cd8l418491327d24b87b@mail.gmail.com>	<4ADF4882.70106@sandeen.net>
	<c2dcdfa40910220209v781f6a76u31e349ea461bc10a@mail.gmail.com>
In-Reply-To: <c2dcdfa40910220209v781f6a76u31e349ea461bc10a@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com

Amit Sahrawat wrote:
> Hi Eric,
> 
> This seems related with the directory Inodes.
> 
> I tried the changes mentioned in the patch, they didn't work for me.
> As mine seems to be ARM with EABI.

The other one you might check on is:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=94a3f78566ef98a48814d82892f28bb741624cb8

Other than that, if you can try a newer kernel that'd be great, and if 
the problem remains, let me know what the testcase is and I can try it out.

-Eric

> When files are created at the Root . It reports Root Inode :128 at the 
> crash with bno:2
> 
> While suppose if another directory is created and Inode is 137
> And then, rm -rf * in that directory
> Crash would report error With this inode
> 
> xfs_da_do_buf: bno 8388631
> dir: inode 137
> Filesystem "sda4": XFS internal error xfs_da_do_buf(1) at line 1992 of 
> file fs/x
> fs/xfs_da_btree.c.  Caller 0xc0118eb8
> ry
> rm: unable [<c0022618>] (dump_stack+0x0/0x14) from [<c0125700>] 
> (xfs_error_repor
> t+0x54/0x64)
> [<c01256ac>] (xfs_error_report+0x0/0x64) from [<c0118a74>] 
> (xfs_da_do_buf+0x334/
> 0x6ec)
> [<c0118740>] (xfs_da_do_buf+0x0/0x6ec) from [<c0118eb8>] 
> (xfs_da_read_buf+0x34/0
> x3c)
> [<c0118e84>] (xfs_da_read_buf+0x0/0x3c) from [<c011b5c8>] 
> (xfs_da_node_lookup_in
> t+0x70/0x318)
> [<c011b558>] (xfs_da_node_lookup_int+0x0/0x318) from [<c01219d4>] 
> (xfs_dir2_node
> _removename+0x48/0x500)
> [<c012198c>] (xfs_dir2_node_removename+0x0/0x500) from [<c011c334>] 
> (xfs_dir_rem
> ovename+0x100/0x10c)
> [<c011c234>] (xfs_dir_removename+0x0/0x10c) from [<c014cde4>] 
> (xfs_remove+0x280/
> 0x424)
>  r6 = 00000000  r5 = 00000000  r4 = 00003951
> [<c014cb64>] (xfs_remove+0x0/0x424) from [<c0157044>] 
> (xfs_vn_unlink+0x30/0x60)
> [<c0157014>] (xfs_vn_unlink+0x0/0x60) from [<c009175c>] 
> (vfs_unlink+0x70/0xac)
>  r7 = C471C000  r6 = C43BF598  r5 = C395B3B8  r4 = 00000000
> [<c00916ec>] (vfs_unlink+0x0/0xac) from [<c0093ac0>] 
> (do_unlinkat+0xcc/0x14c)
>  r6 = C3968AD8  r5 = C395B3B8  r4 = 00000000
> [<c00939f4>] (do_unlinkat+0x0/0x14c) from [<c0093b58>] 
> (sys_unlink+0x18/0x1c)
>  r7 = 0000000A  r6 = 0000000C  r5 = 00000008  r4 = BEDCBC19
> [<c0093b40>] (sys_unlink+0x0/0x1c) from [<c001de40>] 
> (ret_fast_syscall+0x0/0x2c)
> to remove `5826'xfs_da_do_buf: bno 8388631
> dir: inode 137
> 
> Checking this through xfs_check will show:
> ]# xfs_check /dev/sdb4
> dir 128 block 8388609 extra leaf entry d5830 402
> dir 128 block 8388609 extra leaf entry d5831 404
> dir 128 block 8388609 extra leaf entry d5832 406
> dir 128 block 8388609 extra leaf entry d5833 408
> dir 128 block 8388609 extra leaf entry d5834 40a
> dir 128 block 8388609 extra leaf entry d5835 40c
> dir 128 block 8388609 extra leaf entry d5836 40e
> dir 128 block 8388609 extra leaf entry d5837 410
> ...
> ...
> dir 128 block 8388609 extra leaf entry ddab2 5fa
> dir 128 block 8388609 extra leaf entry ddab3 5fc
> dir 128 block 8388609 extra leaf entry ddab4 5fe
> bad free block ent 1 is 65535 should be 0 for dir ino 128 block 16777216
> bad free block ent 2 is 0 should be 65535 for dir ino 128 block 16777216
> dir ino 128 missing leaf entry for d5a37/260
> dir ino 128 missing leaf entry for d5a38/262
> dir ino 128 missing leaf entry for d5a39/264
> ...
> ...
> 
> I tried checking the inode before and after corruption using xfs_db and 
> xfs_check
> When I create files and check using xfs_check, no corruption is showed 
> and also xfs_db shows correct results for the inode.
> While after the crash is observed, xfs_check show the errors I mentioned 
> above.
> Also, the values for Inode using xfs_db differ from the ones I get after 
> i do xfs_repair -L on the device.
> 
> 
> Can u get anything from the above mentioned log.
> 
> Thanks & Regards,
> Amit Sahrawat
> 
> 
> On Wed, Oct 21, 2009 at 11:14 PM, Eric Sandeen <sandeen@sandeen.net 
> <mailto:sandeen@sandeen.net>> wrote:
> 
>     Amit Sahrawat wrote:
>      > Thanks Eric,
>      >
>      > Yes, I am able to get this for the same Inode and Block number.
>      >
>      > xfs_check reports error for dir inode 128 missing leaf
>     entries..(exact
>      > string I m missing), will provide you the details.
>      >
>      > Using xfs_repair fixes the problem. But again the same operation
>     leads
>      > to the crash.
>      > Even on a freshly formatted disk, I get this error.
>      >
>      > Please let me know from where I can get this patch to try whether it
>      > fixes for me or not.
> 
> 
>     http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=ae23a5e87dbbf4657a82e1ff8ebc52ab50361c14
> 
>     -Eric
> 
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
