Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA1617CA0
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 09:03:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35788AC005
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 07:03:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GEt6wMnh1EoYhNAk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 29 Jul 2016 07:03:33 -0700 (PDT)
Date: Fri, 29 Jul 2016 10:03:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: partition 100% full No space left on device. looks like xfs is
	corrupted or a bug
Message-ID: <20160729140330.GA27744@bfoster.bfoster>
References: <4278AB9734C1445A8E48635B155149F8@dinulap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4278AB9734C1445A8E48635B155149F8@dinulap>
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
To: Lista Unx <lista.unx@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 29, 2016 at 12:01:42PM +0300, Lista Unx wrote:
> Hello xfs experts,
> 
> I am crawling in the dark from few days and I have no idea how to fix the following problem. On a centos 7 system:
> 
> # uname -a
> Linux 1a 3.10.0-327.el7.x86_64 #1 SMP Thu Nov 19 22:10:57 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> 
> df is reporting 100% full of / and du is reporting only 1.7G usage from 50GB available (less than 4%). I want to mention that / is xfs. See below:
> 

First and foremost, have you run 'xfs_repair -n' to see if the fs is
healthy? If so, the next thing I would probably try is mount from a
single user mode of some sort (or boot a livecd) and recheck from there
to rule out any OS runtime weirdness going on (open but unlinked files,
files hidden under mount points, etc.).

Brian

> # df -a|grep ^/
> /dev/mapper/centos-root  52403200 52400396      2804 100% /
>                                      ^^^^^^^^^^   ^^^^^^^^^^
> /dev/sda1                  503040   131876    371164  27% /boot
> /dev/mapper/centos-home 210529792    35204 210494588   1% /home
> 
> du is estimating just 1.7G usage of /
> # du -sch /* --exclude=home --exclude=boot
> 0       /bin
> 0       /dev
> 25M     /etc
> 0       /lib
> 0       /lib64
> 744K    /luarocks-2.3.0
> 0       /media
> 0       /mnt
> 125M    /openresty-1.9.7.4
> 0       /opt
> 420K    /root
> 49M     /run
> 0       /sbin
> 0       /srv
> 0       /sys
> 0       /tmp
> 1.3G    /usr
> 227M    /var
> 1.7G    total
> [root@localhost ~]#
> 
> df is also reporting 80% of inode usage:
> 
> # df -i
> Filesystem                 Inodes IUsed     IFree IUse% Mounted on
> /dev/mapper/centos-root     78160 66218     11942   85% /
>                                        ^^^^^^^^
> devtmpfs                  8218272   519   8217753    1% /dev
> tmpfs                     8221010     1   8221009    1% /dev/shm
> tmpfs                     8221010   648   8220362    1% /run
> tmpfs                     8221010    13   8220997    1% /sys/fs/cgroup
> /dev/sda1                  509952   330    509622    1% /boot
> /dev/mapper/centos-home 210632704    99 210632605    1% /home
> tmpfs                     8221010     1   8221009    1% /run/user/0
> #
> 
> / partition is created on top of a LVM having also 50GB size.
> 
> # lvdisplay /dev/centos/root
>   --- Logical volume ---
>   LV Path                /dev/centos/root
>   LV Name                root
>   VG Name                centos
> 
>   LV Status              available
>   # open                 1
>   LV Size                50.00 GiB
>   Current LE             12800
>   Segments               1
>   Allocation             inherit
>   Read ahead sectors     auto
>   - currently set to     256
>   Block device           253:0
> 
> I've already checked against rootkit without finding anything wrong!
> 
> I have another system, identical with this one which is healthy. The only difference I found between those systems is regarding max number of inodes available on / (which has the same size, 50GB on booth servers). On the second one (healthy), max number of inodes are ~52 milions and not only just ~85.000 as are reported on "seek" server.
> 
> # df -i|grep ^/
> /dev/mapper/centos-root  52424704 66137  52358567    1% /
>                                    ^^^^^^^^^^^^^
> /dev/sda1                                  509952   330    509622    1% /boot
> /dev/mapper/centos-home 210632704    26 210632678    1% /home
> [root@localhost ~]#
> 
> Suspected also large number of files on /. Counted total number of files and or booth servers are the same: ~180K. So no difference here.
> 
> Look to find also files larger than 100M and on booth servers and found just 1 (104M size):
> 
> find / -type f -size +100000k -exec ls -lh {} \;
> #
> /usr/lib/locale/locale-archive
> #
> 
> Looking to find files larger than 10M, I found just ~20 on booth servers.
> 
> # find / -type f -size +10000k -exec ls -lh {} \; |wc -l
> 16
> #
> 
> So for sure, there are NO files exhausting free space.
> 
> On booth servers, number of used inodes are identical: ~66K. Also xfs_info report is identical for booth. What is different is number of AVAILABLE inodes: 85K (on seek node) vs 52 milion (on healthy node)!!! How is possible that!!! Booth servers has the same size (50GB) for /!
> 
> #lsof -nP |grep -i delete|wc -l
> 0
> #find /proc/*/fd -ls | grep -i dele|wc -l
> 0
> 
> so lsof and find does not report anything wrong (any file deleted and still open)!
> 
> reboot does not fix the problem, / remain 100% full
> 
> After reboot, on 25th July:
> 
> # df -ah|grep centos-root
> /dev/mapper/centos-root   50G   50G  4.0M 100% /
> #
> 
> Also max number of inodes = 67k:
> # df -i
> Filesystem                 Inodes IUsed     IFree IUse% Mounted on
> /dev/mapper/centos-root     66960 66165       795   99% /
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> devtmpfs                  8218272   519   8217753    1% /dev
> tmpfs                     8221010     1   8221009    1% /dev/shm
> tmpfs                     8221010   630   8220380    1% /run
> tmpfs                     8221010    13   8220997    1% /sys/fs/cgroup
> /dev/sda1                  509952   330    509622    1% /boot
> /dev/mapper/centos-home 210632704    28 210632676    1% /home
> tmpfs                     8221010     1   8221009    1% /run/user/0
> #
> 
> Lets try to run intentionally xfs_grow (which normally should not produce any change)
> 
> # xfs_growfs /dev/mapper/centos-root
> meta-data=/dev/mapper/centos-root isize=256    agcount=16, agsize=819136 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=13106176, imaxpct=25
>          =                       sunit=64     swidth=64 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal               bsize=4096   blocks=6400, version=2
>          =                       sectsz=512   sunit=64 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> data blocks changed from 13106176 to 13107200
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> #
> 
> Partition remain the same, 50GB size:
> [root@nl-hvs-ov001a ~]# df -ah|grep centos-root
> /dev/mapper/centos-root   50G   50G  4.0M 100% /
> 
> But number of inodes INCREASED with more tha 20%!!!
> # df -i
> Filesystem                 Inodes IUsed     IFree IUse% Mounted on
> /dev/mapper/centos-root     83200 66165     17035   80% /
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> devtmpfs                  8218272   519   8217753    1% /dev
> tmpfs                     8221010     1   8221009    1% /dev/shm
> tmpfs                     8221010   630   8220380    1% /run
> tmpfs                     8221010    13   8220997    1% /sys/fs/cgroup
> /dev/sda1                  509952   330    509622    1% /boot
> /dev/mapper/centos-home 210632704    28 210632676    1% /home
> tmpfs                     8221010     1   8221009    1% /run/user/0
> #
> 
> On 27July without changing anything there, max number inodes available for / decreased to ~67k (the same size like 2 days ago, before xfs_grow)!
> 
> # df -i
> Filesystem                 Inodes IUsed     IFree IUse% Mounted on
> /dev/mapper/centos-root     67024 66225       799   99% /
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> devtmpfs                  8218272   519   8217753    1% /dev
> tmpfs                     8221010     1   8221009    1% /dev/shm
> tmpfs                     8221010   632   8220378    1% /run
> tmpfs                     8221010    13   8220997    1% /sys/fs/cgroup
> /dev/mapper/centos-home 210632704    99 210632605    1% /home
> /dev/sda1                  509952   330    509622    1% /boot
> tmpfs                     8221010     1   8221009    1% /run/user/0
> #
> 
> Please note that all that time, number of files remain unchanged ~180K, the same for inodes used, the number remain constant ~66K. Just max number of inodes available decreased which is an abnormal behavior.
> 
> How can be fixed? Looks like xfs is crrupted or like a bug.
> 
> Thanks in advance for help.
> Alex

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
