Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0L4BQxb049059 for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 22:11:26 -0600
Received: from mail-yx0-f173.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 131961786F46
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 20:12:26 -0800 (PST)
Received: from mail-yx0-f173.google.com (mail-yx0-f173.google.com
	[209.85.210.173]) by cuda.sgi.com with ESMTP id
	GOFdPxNW99svIivh for <xfs@oss.sgi.com>;
	Wed, 20 Jan 2010 20:12:26 -0800 (PST)
Received: by yxe3 with SMTP id 3so895548yxe.20
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 20:12:26 -0800 (PST)
MIME-Version: 1.0
From: "Guk-Bong, Kwon" <gbkwon@gmail.com>
Date: Thu, 21 Jan 2010 13:12:06 +0900
Message-ID: <77cc6e171001202012y9472a42m849bcea8910ca290@mail.gmail.com>
Subject: [help] project quota information incorrect over nfs ...
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

hi all

i tested xfs project quota over nfs...

exported directory(/test/111) df size, df used is correct. but df avail is
incorrect...

=====================================================================
linux nfs server
=====================================================================

#uname -a
Linux 2.6.27.23 #2 SMP Wed May 20 15:35:13 KST 2009 x86_64 Intel(R) Xeon(R)
CPU E5405 @ 2.00GHz GenuineIntel GNU/Linux

#xfs_repair  -V
xfs_repair version 2.9.8

#df
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda1             5.0G  2.2G  2.6G  47% /
/dev/sda2             5.0G  180M  4.5G   4% /var
none                  250M   44K  249M   1% /dev/shm
/dev/mapper/LD-test  1014M  500M  500M  50% /test

#cat /proc/mounts
rootfs / rootfs rw 0 0
/proc /proc proc rw 0 0
/dev/root / ext3 rw,noatime,nodiratime,errors=continue,data=journal 0 0
/proc /proc proc rw 0 0
/sys /sys sysfs rw 0 0
/dev/shm /dev/shm tmpfs rw 0 0
none /dev/pts devpts rw,gid=5,mode=620 0 0
nfsd /proc/fs/nfsd nfsd rw 0 0
/dev/sda2 /var ext3 rw,noatime,nodiratime,errors=continue,data=journal 0 0
/dev/LD/test /test xfs rw,noatime,attr2,nobarrier,prjquota,grpquota 0 0

#cat /etc/projid
1:1

#cat /etc/projects
1:/test/111

# xfs_quota -x -c 'report -p -b -h' /test
Project quota on /test (/dev/LD/test)
                        Blocks
Project ID   Used   Soft   Hard Warn/Grace
---------- ---------------------------------
1               0      0   100M  00 [------]

#ls -al /test/111/
total 0
drwxrwxrwx 2 root root   6 Jan 19 06:42 ./
drwxr-xr-x 3 root root 116 Jan 19 11:08 ../

#exportfs  -v
/test/111 0.0.0.0/0.0.0.0(rw,async,wdelay,no_root_squash,no_subtree_check)

=====================================================================
linux nfs client
=====================================================================
$ uname -a
Linux 2.6.32.2 #2 Mon Jan 11 16:32:50 KST 2010 x86_64 AMD Athlon(tm) 64
Processor 3000+ AuthenticAMD GNU/Linux

$ mount -t nfs nfs_server:/test/111 /mnt/nfs

$ cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / ext3 rw,noatime,errors=continue,data=writeback 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
udev /dev tmpfs rw,nosuid,relatime,size=10240k,mode=755 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620 0 0
none /dev/shm tmpfs rw,relatime 0 0
nfsd /proc/fs/nfsd nfsd rw,nosuid,nodev,noexec,relatime 0 0
nfs_server:/test/111 /mnt/nfs nfs
rw,relatime,vers=3,rsize=65536,wsize=65536,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.0.160,mountvers=3,mountproto=tcp,addr=192.168.0.160
0 0

$ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/hda2             9.4G  5.4G  3.7G  60% /
udev                   10M  196K  9.9M   2% /dev
none                  250M     0  250M   0% /dev/shm
nfs_server:/test/111
                      100M     0  500M   0% /mnt/nfs

$ ls -al /mnt/nfs/
total 4.0K
drwxrwxrwx  2 root root    6 2010-01-19 06:42 ./
drwxr-xr-x 73 root root 4.0K 2009-03-03 19:34 ../

=====================================================================

nfs client "nfs_server:/test/111" Size is correct..(100M)

but nfs client "nfs_server:/test/111" Avail is incorrect.. (500M)

"Avail" is big than "Size" ...

this stat is normal??

--

thanks

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
