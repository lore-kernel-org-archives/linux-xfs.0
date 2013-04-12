Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DED7E29DFA
	for <linux-xfs@oss.sgi.com>; Fri, 12 Apr 2013 05:38:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC2078F8040
	for <linux-xfs@oss.sgi.com>; Fri, 12 Apr 2013 03:38:52 -0700 (PDT)
Received: from atlas.fiton.is (atlas.fiton.is [62.145.135.105]) by
	cuda.sgi.com with ESMTP id KUdiW5qKiL1Drawm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Fri, 12 Apr 2013 03:38:51 -0700 (PDT)
Received: from localhost ([127.0.0.1]) by atlas.fiton.is
	for linux-xfs@oss.sgi.com; Fri, 12 Apr 2013 10:38:49 +0000
From: =?iso-8859-1?Q?Svavar_=D6rn_Eysteinsson?= <svavar@fiton.is>
Subject: xfsaild causing load, and stuck in D state - Centos 6.4 x64
Date: Fri, 12 Apr 2013 10:38:49 +0000
Message-Id: <CC92A630-5658-4166-BA1F-8AA1F596461F@fiton.is>
Mime-Version: 1.0 (Apple Message framework v1283)
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
To: linux-xfs@oss.sgi.com

PowerEdge 2850 with PERC SCSI RAID controller.
16GB RAM
Dual Intel(R) Xeon(TM) CPU 3.00GHz
Using megaraid driver and xfs on 3x 300GB SCSI disks as /dev/sdb (total 572GB)  (RAID-5)

Stock Centos 6.4 x64, everything updated.
Kernel : 2.6.32-358.2.1.el6.x86_64 #1 SMP

My Load always shows :

top - 10:30:21 up 23:09,  1 users,  load average: 0.99, 0.96, 0.79

yet there is no services what-so-ever doing anything.

Using PowerTOP I can see that xfsaild is causing second most wake-ups (after kernel core : hrtimer_start (tick_sched_timer) )


< Detailed C-state information is not P-states (frequencies)
                                        3.00 Ghz   100.0%
                                        1500 Mhz     0.0%
                                        1125 Mhz     0.0%
                                         750 Mhz     0.0%
                                         375 Mhz     0.0%

Wakeups-from-idle per second : 125.1    interval: 10.0s
no ACPI power usage estimate available

Top causes for wake-ups:
  47.7% (119.6)     <kernel core> : hrtimer_start (tick_sched_timer) 
  39.9% (100.0)      xfsaild/sdb1 : xfsaild (process_timeout)


Again, using TOP I can see that xfsaild is stuck in D state. It never changes.


10050 root      20   0     0    0    0 D  0.0  0.0   0:01.17 xfsaild/sdb1


My only way to fix this, is either rebooting the machine, unmounting the volume
and mounting it back online. I've been rsyncing data twice between this server and another
one. The rsync process takes about 30m-1hour. After the rsync operation I see that
the xfsaild is stuck in D State and my Load is near 1.00.


I'v had no problem what-so-ever on centos 6.3 or early versions on other servers.

Any thoughts ?
Information, help would be much appreciated.

Thanks in advance.

Best regards,

Svavar
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
