Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4L9wYjU116999 for <xfs@oss.sgi.com>; Mon, 21 May 2012 04:58:34 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id kJTdZomc0M5ZgXG1 for
	<xfs@oss.sgi.com>; Mon, 21 May 2012 02:58:32 -0700 (PDT)
Date: Mon, 21 May 2012 10:58:30 +0100
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Storage server, hung tasks and tracebacks
Message-ID: <20120521095830.GC8283@nsrc.org>
References: <20120502184450.GA2557@nsrc.org>
	<4FA27EF8.6040002@hardwarefreak.com> <20120503204157.GC4387@nsrc.org>
	<4FA3047D.8060908@hardwarefreak.com> <20120504163237.GA6128@nsrc.org>
	<4FA4C321.2070105@hardwarefreak.com> <20120515140237.GA3630@nsrc.org>
	<20120520235903.GB25351@dastard>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20120520235903.GB25351@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 21, 2012 at 09:59:03AM +1000, Dave Chinner wrote:
> You need to provide the output of sysrq-W at this point ('echo w >
> /proc/sysrq-trigger') so we can see where these are hung. the entire
> dmesg would also be useful....

Thank you for this advice Dave.

Attached is the full dmesg output after another hang. The sysrq output is
near the end, at timestamp 250695.

For this test, I built a fresh XFS filesystem (you can see this at timestamp
246909) - I forgot to mount with "inode64" this time, but it doesn't seem to
have made a difference.  I also did "swapoff" before starting the test, to
ensure that swapping to sda was not part of the problem.

A quick status summary from the hung system:

    root@storage3:~# free
                 total       used       free     shared    buffers     cached
    Mem:       8156224    8052824     103400          0       4808    7399112
    -/+ buffers/cache:     648904    7507320
    Swap:            0          0          0
    root@storage3:~# uptime
     10:46:47 up 2 days, 21:43,  1 user,  load average: 10.00, 9.81, 8.16
    root@storage3:~# ps auxwww | grep -v ' S'
    root        34  2.9  0.0      0     0 ?        D    May18 122:14 [kswapd0]
    root      1387  0.0  0.0  15976   504 ?        Ds   May18   0:18 /usr/sbin/irqbalance
    root      5242  0.0  0.0      0     0 ?        D    09:39   0:02 [xfsaild/md127]
    tomi      6249  4.2  0.0 378860  3844 pts/1    D+   09:40   2:48 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
    tomi      6251  4.1  0.0 378860  3836 pts/2    D+   09:40   2:44 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
    tomi      6253  4.1  0.0 378860  3848 pts/3    D+   09:40   2:46 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
    tomi      6255  4.0  0.0 378860  3840 pts/4    D+   09:40   2:40 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
    root      7795  0.1  0.0      0     0 ?        D    10:27   0:02 [kworker/0:3]
    root      8517  0.0  0.0  16876  1272 pts/0    R+   10:46   0:00 ps auxwww
    root     24420  0.0  0.0      0     0 ?        D    00:50   0:00 [kworker/3:0]
    root@storage3:~# cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4]
    [raid10] 
    md127 : active raid0 sds[17] sdx[22] sdj[8] sdt[18] sdk[9] sdc[1] sdb[0]
    sdh[6] sdu[19] sdi[7] sdn[12] sdo[13] sdv[20] sdm[11] sdq[15] sdp[14]
    sdl[10] sdw[21] sdg[5] sdr[16] sde[3] sdy[23] sdd[2] sdf[4]
          70326362112 blocks super 1.2 1024k chunks
          
    unused devices: <none>
    root@storage3:~# mount
    /dev/sda1 on / type ext4 (rw,errors=remount-ro)
    proc on /proc type proc (rw,noexec,nosuid,nodev)
    sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
    none on /sys/fs/fuse/connections type fusectl (rw)
    none on /sys/kernel/debug type debugfs (rw)
    none on /sys/kernel/security type securityfs (rw)
    udev on /dev type devtmpfs (rw,mode=0755)
    devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=0620)
    tmpfs on /run type tmpfs (rw,noexec,nosuid,size=10%,mode=0755)
    none on /run/lock type tmpfs (rw,noexec,nosuid,nodev,size=5242880)
    none on /run/shm type tmpfs (rw,nosuid,nodev)
    rpc_pipefs on /run/rpc_pipefs type rpc_pipefs (rw)
    /dev/md127 on /disk/scratch type xfs (rw)
    root@storage3:~# df
    Filesystem       1K-blocks      Used   Available Use% Mounted on
    /dev/sda1        967415188  16754388   902241696   2% /
    udev               4069104         4     4069100   1% /dev
    tmpfs              1631248       380     1630868   1% /run
    none                  5120         0        5120   0% /run/lock
    none               4078112         0     4078112   0% /run/shm
    /dev/md127     70324275200 258902416 70065372784   1% /disk/scratch
    root@storage3:~# 

(Aside: when the test started the load average was just above 4, for the
four bonnie++ processes)

"iostat 5" shows zero activity to the MD RAID.

    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
               0.00    0.00    0.00    0.05    0.00   99.95

    Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
    sda               0.20         1.60         0.00          8          0
    sdf               0.00         0.00         0.00          0          0
    sde               0.00         0.00         0.00          0          0
    sdd               0.00         0.00         0.00          0          0
    sdc               0.00         0.00         0.00          0          0
    sdg               0.00         0.00         0.00          0          0
    sdh               0.00         0.00         0.00          0          0
    sdp               0.00         0.00         0.00          0          0
    sdj               0.00         0.00         0.00          0          0
    sdq               0.00         0.00         0.00          0          0
    sdk               0.00         0.00         0.00          0          0
    sdb               0.00         0.00         0.00          0          0
    sdl               0.00         0.00         0.00          0          0
    sdo               0.00         0.00         0.00          0          0
    sdm               0.00         0.00         0.00          0          0
    sdn               0.00         0.00         0.00          0          0
    sdi               0.00         0.00         0.00          0          0
    sdr               0.00         0.00         0.00          0          0
    sdu               0.00         0.00         0.00          0          0
    sdv               0.00         0.00         0.00          0          0
    sdw               0.00         0.00         0.00          0          0
    sdy               0.00         0.00         0.00          0          0
    sdx               0.00         0.00         0.00          0          0
    sds               0.00         0.00         0.00          0          0
    sdt               0.00         0.00         0.00          0          0
    md127             0.00         0.00         0.00          0          0

Anything you can determine from this info much appreciated!

Regards,

Brian.

--MGYHOYXEY6WxJCY8
Content-Type: application/x-gunzip
Content-Disposition: attachment; filename="storage3-dmesg.txt.gz"
Content-Transfer-Encoding: base64

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

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--MGYHOYXEY6WxJCY8--
