Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB23qhp9201432
	for <linux-xfs@oss.sgi.com>; Tue, 1 Dec 2009 21:52:43 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0F5F19071BD
	for <linux-xfs@oss.sgi.com>; Tue,  1 Dec 2009 19:53:13 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id uyAk2uSUFAJjX3OS for
	<linux-xfs@oss.sgi.com>; Tue, 01 Dec 2009 19:53:13 -0800 (PST)
Message-ID: <4B15E48E.7080900@sandeen.net>
Date: Tue, 01 Dec 2009 21:52:46 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: can xfs_repair guarantee a complete clean filesystem?
References: <389deec70911301805j37df7397l1c3ddbbad7e91768@mail.gmail.com>	
	<4B14936F.7040401@sandeen.net>	
	<389deec70911302037v19764c2cr7686b353c5e933fa@mail.gmail.com>	
	<4B14B077.5090500@sandeen.net>	
	<389deec70911302234v2fc792ddt54bf88f5200500be@mail.gmail.com>	
	<4B152BAD.1000004@sandeen.net>	
	<389deec70912010732o72edd3c4q196088a1c01b801e@mail.gmail.com>	
	<4B1539C6.90000@sandeen.net>	
	<389deec70912011646y682a2cc2rd5d4ea8cfe78d2f5@mail.gmail.com>	
	<4B15BE1C.2030209@sandeen.net>
	<389deec70912011839y57cf5d84y2a50f8d2ea39ca29@mail.gmail.com>
In-Reply-To: <389deec70912011839y57cf5d84y2a50f8d2ea39ca29@mail.gmail.com>
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
To: hank peng <pengxihan@gmail.com>
Cc: linux-xfs@oss.sgi.com

hank peng wrote:
> Hi, Eric:
> I think I have reproduced the problem.
> 
> # uname -a
> Linux 1234dahua 2.6.23 #747 Mon Nov 16 10:52:58 CST 2009 ppc unknown
> #mdadm -C /dev/md1 -l5 -n3 /dev/sd{h,c,b}
> # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
> [raid4] [multipath]
> md1 : active raid5 sdb[3] sdc[1] sdh[0]
>       976772992 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]
>       [==>..................]  recovery = 13.0% (63884032/488386496)
> finish=103.8min speed=68124K/sec
> 
> unused devices: <none>
> #pvcreate /dev/md1
> #vgcreate Pool_md1 /dev/md1
> #lvcreate -L 931G -n testlv Pool_md1
> #lvdisplay
> # lvdisplay
>   --- Logical volume ---
>   LV Name                /dev/Pool_md1/testlv
>   VG Name                Pool_md1
>   LV UUID                jWTgk5-Q6tf-jSEU-m9VZ-K2Kb-1oRW-R7oP94
>   LV Write Access        read/write
>   LV Status              available
>   # open                 1
>   LV Size                931.00 GB
>   Current LE             238336
>   Segments               1
>   Allocation             inherit
>   Read ahead sectors     auto
>   - currently set to     256
>   Block device           253:0
> 
> #mkfs.xfs -f -ssize=4k /dev/Pool_md1/testlv
> #mount /dev/Pool_md1/testlv /mnt/Pool_md1/testlv
> All is OK and mount the filesystem and began to write files into it
> through our application software. For a short while, problem occured.
> # cd /mnt/Pool_md1/testlv
> cd: error retrieving current directory: getcwd: cannot access parent
> directories: Input/output error
> #dmesg | tail -n 30
> --- rd:3 wd:2
>  disk 0, o:1, dev:sdh
>  disk 1, o:1, dev:sdc
> RAID5 conf printout:
>  --- rd:3 wd:2
>  disk 0, o:1, dev:sdh
>  disk 1, o:1, dev:sdc
>  disk 2, o:1, dev:sdb
> md: recovery of RAID array md1
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than
> 200000 KB/sec) for recovery.
> md: using 128k window, over a total of 488386496 blocks.
> Filesystem "dm-0": Disabling barriers, not supported by the underlying device
> XFS mounting filesystem dm-0
> Ending clean XFS mount for filesystem: dm-0
> Filesystem "dm-0": XFS internal error xfs_trans_cancel at line 1169 of
> file fs/xfs/xfs_trans.c.  Caller 0xc019fbf0
> Call Trace:
> [e8e6dcb0] [c00091ec] show_stack+0x3c/0x1a0 (unreliable)
> [e8e6dce0] [c017559c] xfs_error_report+0x50/0x60
> [e8e6dcf0] [c0197058] xfs_trans_cancel+0x124/0x140
> [e8e6dd10] [c019fbf0] xfs_create+0x1fc/0x63c
> [e8e6dd90] [c01ad690] xfs_vn_mknod+0x1ac/0x20c
> [e8e6de40] [c007ded4] vfs_create+0xa8/0xe4
> [e8e6de60] [c0081370] open_namei+0x5f0/0x688
> [e8e6deb0] [c00729b8] do_filp_open+0x2c/0x6c
> [e8e6df20] [c0072a54] do_sys_open+0x5c/0xf8
> [e8e6df40] [c0002320] ret_from_syscall+0x0/0x3c
> xfs_force_shutdown(dm-0,0x8) called from line 1170 of file
> fs/xfs/xfs_trans.c.  Return address = 0xc01b0b74
> Filesystem "dm-0": Corruption of in-memory data detected.  Shutting
> down filesystem: dm-0
> Please umount the filesystem, and rectify the problem(s)
> 
> What shoul I do now? use xfs_repair or use newer kernel ? Please let
> me know if you need other information.

Test upstream; if it passes, test kernels in between to see if you can find
out when it got fixed, and maybe you can backport it.

If it fails upstream, we have an unfixed bug and we'll try to help you find it.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
