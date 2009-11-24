Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAOD7h4t133090 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 07:07:43 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B746114E58D5
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 05:08:07 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id hybzywc0sSxGjVDA for
	<xfs@oss.sgi.com>; Tue, 24 Nov 2009 05:08:07 -0800 (PST)
Date: Tue, 24 Nov 2009 08:08:07 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Which kernel options should be enabled to find the root cause of
	this bug?
In-Reply-To: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0911240805490.25676@p34.internal.lan>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
MIME-Version: 1.0
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
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Cc: Alan Piszcz <ap@solarrain.com>



On Sat, 17 Oct 2009, Justin Piszcz wrote:

> Hello,
>
> I have a system I recently upgraded from 2.6.30.x and after approximately 
> 24-48 hours--sometimes longer, the system cannot write any more files to disk 
> (luckily though I can still write to /dev/shm) -- to which I have
> saved the sysrq-t and sysrq-w output:
>
> http://home.comcast.net/~jpiszcz/20091017/sysrq-w.txt
> http://home.comcast.net/~jpiszcz/20091017/sysrq-t.txt
>
> Configuration:
>
> $ cat /proc/mdstat Personalities : [raid1] [raid6] [raid5] [raid4] md1 : 
> active raid1 sdb2[1] sda2[0]
>      136448 blocks [2/2] [UU]
>
> md2 : active raid1 sdb3[1] sda3[0]
>      129596288 blocks [2/2] [UU]
>
> md3 : active raid5 sdj1[7] sdi1[6] sdh1[5] sdf1[3] sdg1[4] sde1[2] sdd1[1] 
> sdc1[0]
>      5128001536 blocks level 5, 1024k chunk, algorithm 2 [8/8] [UUUUUUUU]
>
> md0 : active raid1 sdb1[1] sda1[0]
>      16787776 blocks [2/2] [UU]
>
> $ mount
> /dev/md2 on / type xfs (rw,noatime,nobarrier,logbufs=8,logbsize=262144)
> tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
> proc on /proc type proc (rw,noexec,nosuid,nodev)
> sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
> udev on /dev type tmpfs (rw,mode=0755)
> tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
> devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
> /dev/md1 on /boot type ext3 (rw,noatime)
> /dev/md3 on /r/1 type xfs (rw,noatime,nobarrier,logbufs=8,logbsize=262144)
> rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
> nfsd on /proc/fs/nfsd type nfsd (rw)
>
> Distribution: Debian Testing
> Arch: x86_64
>
> The problem occurs with 2.6.31 and I upgraded to 2.6.31.4 and the problem
> persists.
>
> Here is a snippet of two processes in D-state, the first was not doing 
> anything, the second was mrtg.
>
> [121444.684000] pickup        D 0000000000000003     0 18407   4521 
> 0x00000000
> [121444.684000]  ffff880231dd2290 0000000000000086 0000000000000000 
> 0000000000000000
> [121444.684000]  000000000000ff40 000000000000c8c8 ffff880176794d10 
> ffff880176794f90
> [121444.684000]  000000032266dd08 ffff8801407a87f0 ffff8800280878d8 
> ffff880176794f90
> [121444.684000] Call Trace:
> [121444.684000]  [<ffffffff810a742d>] ? free_pages_and_swap_cache+0x9d/0xc0
> [121444.684000]  [<ffffffff81454866>] ? __mutex_lock_slowpath+0xd6/0x160
> [121444.684000]  [<ffffffff814546ba>] ? mutex_lock+0x1a/0x40
> [121444.684000]  [<ffffffff810b26ef>] ? generic_file_llseek+0x2f/0x70
> [121444.684000]  [<ffffffff810b119e>] ? sys_lseek+0x7e/0x90
> [121444.684000]  [<ffffffff8109ffd2>] ? sys_munmap+0x52/0x80
> [121444.684000]  [<ffffffff8102c52b>] ? system_call_fastpath+0x16/0x1b
>
> [121444.684000] rateup        D 0000000000000000     0 18538  18465 
> 0x00000000
> [121444.684000]  ffff88023f8a8c10 0000000000000082 0000000000000000 
> ffff88023ea09ec8
> [121444.684000]  000000000000ff40 000000000000c8c8 ffff88023faace50 
> ffff88023faad0d0
> [121444.684000]  0000000300003e00 000000010720cc78 0000000000003e00 
> ffff88023faad0d0
> [121444.684000] Call Trace:
> [121444.684000]  [<ffffffff811f42e2>] ? xfs_buf_iorequest+0x42/0x90
> [121444.684000]  [<ffffffff811dd66d>] ? xlog_bdstrat_cb+0x3d/0x50
> [121444.684000]  [<ffffffff811db05b>] ? xlog_sync+0x20b/0x4e0
> [121444.684000]  [<ffffffff811dc44c>] ? xlog_state_sync+0x26c/0x2a0
> [121444.684000]  [<ffffffff810513e0>] ? default_wake_function+0x0/0x10
> [121444.684000]  [<ffffffff811dc4d1>] ? _xfs_log_force+0x51/0x80
> [121444.684000]  [<ffffffff811dc50b>] ? xfs_log_force+0xb/0x40
> [121444.684000]  [<ffffffff811a7223>] ? xfs_alloc_ag_vextent+0x123/0x130
> [121444.684000]  [<ffffffff811a7aa8>] ? xfs_alloc_vextent+0x368/0x4b0
> [121444.684000]  [<ffffffff811b41e8>] ? xfs_bmap_btalloc+0x598/0xa40
> [121444.684000]  [<ffffffff811b6a42>] ? xfs_bmapi+0x9e2/0x11a0
> [121444.684000]  [<ffffffff811dd7f0>] ? xlog_grant_push_ail+0x30/0xf0
> [121444.684000]  [<ffffffff811e8fd8>] ? xfs_trans_reserve+0xa8/0x220
> [121444.684000]  [<ffffffff811d805e>] ? xfs_iomap_write_allocate+0x23e/0x3b0
> [121444.684000]  [<ffffffff811f0daf>] ? __xfs_get_blocks+0x8f/0x220
> [121444.684000]  [<ffffffff811d8c00>] ? xfs_iomap+0x2c0/0x300
> [121444.684000]  [<ffffffff810d5b76>] ? __set_page_dirty+0x66/0xd0
> [121444.684000]  [<ffffffff811f0d15>] ? xfs_map_blocks+0x25/0x30
> [121444.684000]  [<ffffffff811f1e04>] ? xfs_page_state_convert+0x414/0x6c0
> [121444.684000]  [<ffffffff811f23b7>] ? xfs_vm_writepage+0x77/0x130
> [121444.684000]  [<ffffffff8108b21a>] ? __writepage+0xa/0x40
> [121444.684000]  [<ffffffff8108baff>] ? write_cache_pages+0x1df/0x3c0
> [121444.684000]  [<ffffffff8108b210>] ? __writepage+0x0/0x40
> [121444.684000]  [<ffffffff810b1533>] ? do_sync_write+0xe3/0x130
> [121444.684000]  [<ffffffff8108bd30>] ? do_writepages+0x20/0x40
> [121444.684000]  [<ffffffff81085abd>] ? __filemap_fdatawrite_range+0x4d/0x60
> [121444.684000]  [<ffffffff811f54dd>] ? xfs_flush_pages+0xad/0xc0
> [121444.684000]  [<ffffffff811ee907>] ? xfs_release+0x167/0x1d0
> [121444.684000]  [<ffffffff811f52b0>] ? xfs_file_release+0x10/0x20
> [121444.684000]  [<ffffffff810b2c0d>] ? __fput+0xcd/0x1e0
> [121444.684000]  [<ffffffff810af556>] ? filp_close+0x56/0x90
> [121444.684000]  [<ffffffff810af636>] ? sys_close+0xa6/0x100
> [121444.684000]  [<ffffffff8102c52b>] ? system_call_fastpath+0x16/0x1b
>
> Anyone know what is going on here?
>
> Justin.
>

In addition to using netconsole, which kernel options should be enabled
to better diagnose this issue?

Should I enable these to help track down this bug?

[ ]   XFS Debugging support (EXPERIMENTAL)
[ ] Compile the kernel with frame pointers

Are there any other options that will help determine the root cause of this
bug that are recommended?

Justin.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
