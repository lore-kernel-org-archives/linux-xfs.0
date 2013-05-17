Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7A4387F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:45:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 13FA3AC002
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 03:45:35 -0700 (PDT)
Received: from mail-ea0-f176.google.com (mail-ea0-f176.google.com
	[209.85.215.176]) by cuda.sgi.com with ESMTP id
	qjGyFoGaHWxawFgr (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 03:45:34 -0700 (PDT)
Received: by mail-ea0-f176.google.com with SMTP id k11so2312128eaj.21
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 03:45:33 -0700 (PDT)
Received: from gmail.com (2-230-238-136.ip204.fastwebnet.it. [2.230.238.136])
	by mx.google.com with ESMTPSA id
	x41sm17812777eey.17.2013.05.17.03.45.31 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=RC4-SHA bits=128/128);
	Fri, 17 May 2013 03:45:31 -0700 (PDT)
Date: Fri, 17 May 2013 12:45:29 +0200
From: Paolo Pisati <p.pisati@gmail.com>
Subject: 3.5+, xfs and 32bit armhf - xfs_buf_get: failed to map pages
Message-ID: <20130517104529.GA12490@luxor.wired.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

While exercising swift on a single node 32bit armhf system running a 3.5 kernel,
i got this when i hit ~25% of fs space usage:

dmesg:
...
[ 3037.399406] vmap allocation for size 2097152 failed: use vmalloc=<size> to increase size.
[ 3037.399442] vmap allocation for size 2097152 failed: use vmalloc=<size> to increase size.
[ 3037.399469] vmap allocation for size 2097152 failed: use vmalloc=<size> to increase size.
[ 3037.399485] XFS (sda5): xfs_buf_get: failed to map pages
[ 3037.399485]
[ 3037.399501] XFS (sda5): Internal error xfs_trans_cancel at line 1466 of file /build/buildd/linux-3.5.0/fs/xfs/xfs_trans.c. Caller 0xbf0235e0
[ 3037.399501]
[ 3037.413789] [<c00164cc>] (unwind_backtrace+0x0/0x104) from [<c04ed624>] (dump_stack+0x20/0x24)
[ 3037.413985] [<c04ed624>] (dump_stack+0x20/0x24) from [<bf01091c>] (xfs_error_report+0x60/0x6c [xfs])
[ 3037.414321] [<bf01091c>] (xfs_error_report+0x60/0x6c [xfs]) from [<bf0633f8>] (xfs_trans_cancel+0xfc/0x11c [xfs])
[ 3037.414654] [<bf0633f8>] (xfs_trans_cancel+0xfc/0x11c [xfs]) from [<bf0235e0>] (xfs_create+0x228/0x558 [xfs])
[ 3037.414953] [<bf0235e0>] (xfs_create+0x228/0x558 [xfs]) from [<bf01a7cc>] (xfs_vn_mknod+0x9c/0x180 [xfs])
[ 3037.415239] [<bf01a7cc>] (xfs_vn_mknod+0x9c/0x180 [xfs]) from [<bf01a8d0>] (xfs_vn_mkdir+0x20/0x24 [xfs])
[ 3037.415393] [<bf01a8d0>] (xfs_vn_mkdir+0x20/0x24 [xfs]) from [<c0135758>] (vfs_mkdir+0xc4/0x13c)
[ 3037.415410] [<c0135758>] (vfs_mkdir+0xc4/0x13c) from [<c013884c>] (sys_mkdirat+0xdc/0xe4)
[ 3037.415422] [<c013884c>] (sys_mkdirat+0xdc/0xe4) from [<c0138878>] (sys_mkdir+0x24/0x28)
[ 3037.415437] [<c0138878>] (sys_mkdir+0x24/0x28) from [<c000e320>] (ret_fast_syscall+0x0/0x30)
[ 3037.415452] XFS (sda5): xfs_do_force_shutdown(0x8) called from line 1467 of file /build/buildd/linux-3.5.0/fs/xfs/xfs_trans.c. Return address = 0xbf06340c
[ 3037.416892] XFS (sda5): Corruption of in-memory data detected. Shutting down filesystem
[ 3037.425008] XFS (sda5): Please umount the filesystem and rectify the problem(s)
[ 3047.912480] XFS (sda5): xfs_log_force: error 5 returned.

flag@c13:~$ df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda2 225G 2.1G 212G 1% /
none 4.0K 0 4.0K 0% /sys/fs/cgroup
udev 2.0G 4.0K 2.0G 1% /dev
tmpfs 405M 260K 404M 1% /run
none 5.0M 0 5.0M 0% /run/lock
none 2.0G 0 2.0G 0% /run/shm
none 100M 0 100M 0% /run/user
/dev/sda1 228M 30M 186M 14% /boot
/dev/sda5 2.0G 569M 1.5G 28% /mnt/sdb1

flag@c13:~$ df -i
Filesystem Inodes IUsed IFree IUse% Mounted on
/dev/sda2 14958592 74462 14884130 1% /
none 182027 1 182026 1% /sys/fs/cgroup
udev 177378 1361 176017 1% /dev
tmpfs 182027 807 181220 1% /run
none 182027 3 182024 1% /run/lock
none 182027 1 182026 1% /run/shm
none 182027 1 182026 1% /run/user
/dev/sda1 124496 35 124461 1% /boot
/dev/sda5 524288 237184 287104 46% /mnt/sdb1

the vmalloc space is ~256M usually on this box, so i enlarged it:

flag@c13:~$ dmesg | grep vmalloc                                                                                                                                                          
Kernel command line: console=ttyAMA0 nosplash vmalloc=512M                                                                                                                                
    vmalloc : 0xdf800000 - 0xff000000   ( 504 MB)

and while i didn't hit the warning above, still after ~25% of usage, the storage
node died with:

May 17 06:26:00 c13 container-server ERROR __call__ error with PUT /sdb1/123172/AUTH_test/3b3d078015304a41b76b0ab083b7863a_5 : [Errno 28] No space
left on device: '/srv/1/node/sdb1/containers/123172' (txn: tx8ea3ce392ee94df096b16-00519605b0)


flag@c13:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2       225G  3.9G  210G   2% /
none            4.0K     0  4.0K   0% /sys/fs/cgroup
udev            2.0G  4.0K  2.0G   1% /dev
tmpfs           405M  260K  404M   1% /run
none            5.0M     0  5.0M   0% /run/lock
none            2.0G     0  2.0G   0% /run/shm
none            100M     0  100M   0% /run/user
/dev/sda1       228M   25M  192M  12% /boot
/dev/sda5       2.0G  564M  1.5G  28% /mnt/sdb1

flag@c13:~$ df -i
Filesystem       Inodes  IUsed    IFree IUse% Mounted on
/dev/sda2      14958592 124409 14834183    1% /
none             114542      1   114541    1% /sys/fs/cgroup
udev             103895   1361   102534    2% /dev
tmpfs            114542    806   113736    1% /run
none             114542      3   114539    1% /run/lock
none             114542      1   114541    1% /run/shm
none             114542      1   114541    1% /run/user
/dev/sda1        124496     33   124463    1% /boot
/dev/sda5        524288 234880   289408   45% /mnt/sdb1


any idea what else shall i tune to workaround this? or is it a know problem that
involves 32bit arch and xfs?
-- 
bye,
p.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
