Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1E0F67F3F
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 16:35:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B540EAC003
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 14:35:51 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 5GoaOITkPW7XMp9Q
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 14:35:50 -0700 (PDT)
Message-ID: <53486031.5050503@hardwarefreak.com>
Date: Fri, 11 Apr 2014 16:35:45 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 10GB memorys occupied by XFS
References: <1396596386220-35015.post@n7.nabble.com>
	<1397184044761-35016.post@n7.nabble.com>
In-Reply-To: <1397184044761-35016.post@n7.nabble.com>
Reply-To: stan@hardwarefreak.com
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
To: daiguochao <dx-wl@163.com>, xfs@oss.sgi.com

On 4/10/2014 9:40 PM, daiguochao wrote:
> Dear Stan, I can't send email to you.So I leave a message here.I hope not to
> bother you.
> Thank you for your kind assistance.

I received all of the ones you sent to the list and that should always
be the case.  One that you sent directly to me was rejected but I think
I've fixed that now.  And I think my delayed reply made things seem
worse than they are.

Anyway, Dave replied while I was typing my last response.  He'll be much
more able to assist you.  Your problem seems beyond the edge of my
knowledge.

Cheers,

Stan



> In accordance with your suggestion, we executed "echo 3 >
> /proc/sysm/drop_caches" for trying to release vfs dentries and inodes.
> Really,
> our lost memory came back. But we learned that the memory of vfs dentries
> and inodes is distributed from slab. Please check our system "Slab:  509708
> kB" from /proc/meminfo, and it seems only be took up 500MB and xfs_buf take
> up 450MB among. And /proc/meminfo indicated that our system memory is
> anomalous, there is about 10GB out of the statistics. We want to know how
> the system could observe the usage amount of vfs dentries and iodes through
> the system interface. If the memory usage of system is not reflected in
> /proc/meminfo as we can not find the statistics, and we thought it as a bug
> of xfs.
> 
> My  vm.vfs_cache_pressure of linux system is 100. We think that the system
> will proactively take the memory back when the memory is not enough, rather
> than oom-killer kills our work process. Our datas of /proc/meminfo occurred
> during the system problem as below:
> 130> cat /proc/meminfo 
> MemTotal:       12173268 kB 
> MemFree:          223044 kB 
> Buffers:             244 kB 
> Cached:             4540 kB 
> SwapCached:            0 kB 
> Active:             1700 kB 
> Inactive:           5312 kB 
> Active(anon):       1616 kB 
> Inactive(anon):     1128 kB 
> Active(file):         84 kB 
> Inactive(file):     4184 kB 
> Unevictable:           0 kB 
> Mlocked:               0 kB 
> SwapTotal:             0 kB 
> SwapFree:              0 kB 
> Dirty:                 0 kB 
> Writeback:             0 kB 
> AnonPages:          2556 kB 
> Mapped:             1088 kB 
> Shmem:               196 kB 
> Slab:             509708 kB 
> SReclaimable:       7596 kB 
> SUnreclaim:       502112 kB 
> KernelStack:        1096 kB 
> PageTables:          748 kB 
> NFS_Unstable:          0 kB 
> Bounce:                0 kB 
> WritebackTmp:          0 kB 
> CommitLimit:     6086632 kB 
> Committed_AS:       9440 kB 
> VmallocTotal:   34359738367 kB 
> VmallocUsed:      303488 kB 
> VmallocChunk:   34359426132 kB 
> HardwareCorrupted:     0 kB 
> AnonHugePages:         0 kB 
> HugePages_Total:       0 
> HugePages_Free:        0 
> HugePages_Rsvd:        0 
> HugePages_Surp:        0 
> Hugepagesize:       2048 kB 
> DirectMap4k:        6152 kB 
> DirectMap2M:     2070528 kB 
> DirectMap1G:    10485760 kB
> 
> Best Regards,
> 
> Guochao
> 
> 
> 
> --
> View this message in context: http://xfs.9218.n7.nabble.com/10GB-memorys-occupied-by-XFS-tp35015p35016.html
> Sent from the Xfs - General mailing list archive at Nabble.com.
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
