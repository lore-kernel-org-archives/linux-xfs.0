Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 42EB129DFA
	for <linux-xfs@oss.sgi.com>; Fri, 12 Apr 2013 08:19:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 30F8E8F8073
	for <linux-xfs@oss.sgi.com>; Fri, 12 Apr 2013 06:19:46 -0700 (PDT)
Received: from atlas.fiton.is (atlas.fiton.is [62.145.135.105]) by
	cuda.sgi.com with ESMTP id ISG6jS1xDnsLqnW9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Fri, 12 Apr 2013 06:19:45 -0700 (PDT)
Received: from localhost ([127.0.0.1]) by atlas.fiton.is
	for linux-xfs@oss.sgi.com; Fri, 12 Apr 2013 13:19:39 +0000
Mime-Version: 1.0 (Apple Message framework v1283)
Subject: Re: xfsaild causing load, and stuck in D state - Centos 6.4 x64
From: =?iso-8859-1?Q?Svavar_=D6rn_Eysteinsson?= <svavar@fiton.is>
In-Reply-To: <CC92A630-5658-4166-BA1F-8AA1F596461F@fiton.is>
Date: Fri, 12 Apr 2013 13:19:39 +0000
Message-Id: <F5375E92-41CB-4BFF-8DD9-4D314F5AAD9C@fiton.is>
References: <CC92A630-5658-4166-BA1F-8AA1F596461F@fiton.is>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

I installed the latest centosplus kernel, and it fixed it.

( <http://lists.centos.org/pipermail/centos/2013-March/132931.html> )

Looks like this problem will be fixed in kernel-2.6.32-358.5.1.el6

https://bugzilla.redhat.com/show_bug.cgi?id=3D921958


On 12.4.2013, at 10:38, Svavar =D6rn Eysteinsson wrote:

> PowerEdge 2850 with PERC SCSI RAID controller.
> 16GB RAM
> Dual Intel(R) Xeon(TM) CPU 3.00GHz
> Using megaraid driver and xfs on 3x 300GB SCSI disks as /dev/sdb (total 5=
72GB)  (RAID-5)
> =

> Stock Centos 6.4 x64, everything updated.
> Kernel : 2.6.32-358.2.1.el6.x86_64 #1 SMP
> =

> My Load always shows :
> =

> top - 10:30:21 up 23:09,  1 users,  load average: 0.99, 0.96, 0.79
> =

> yet there is no services what-so-ever doing anything.
> =

> Using PowerTOP I can see that xfsaild is causing second most wake-ups (af=
ter kernel core : hrtimer_start (tick_sched_timer) )
> =

> =

> < Detailed C-state information is not P-states (frequencies)
>                                        3.00 Ghz   100.0%
>                                        1500 Mhz     0.0%
>                                        1125 Mhz     0.0%
>                                         750 Mhz     0.0%
>                                         375 Mhz     0.0%
> =

> Wakeups-from-idle per second : 125.1    interval: 10.0s
> no ACPI power usage estimate available
> =

> Top causes for wake-ups:
>  47.7% (119.6)     <kernel core> : hrtimer_start (tick_sched_timer) =

>  39.9% (100.0)      xfsaild/sdb1 : xfsaild (process_timeout)
> =

> =

> Again, using TOP I can see that xfsaild is stuck in D state. It never cha=
nges.
> =

> =

> 10050 root      20   0     0    0    0 D  0.0  0.0   0:01.17 xfsaild/sdb1
> =

> =

> My only way to fix this, is either rebooting the machine, unmounting the =
volume
> and mounting it back online. I've been rsyncing data twice between this s=
erver and another
> one. The rsync process takes about 30m-1hour. After the rsync operation I=
 see that
> the xfsaild is stuck in D State and my Load is near 1.00.
> =

> =

> I'v had no problem what-so-ever on centos 6.3 or early versions on other =
servers.
> =

> Any thoughts ?
> Information, help would be much appreciated.
> =

> Thanks in advance.
> =

> Best regards,
> =

> Svavar
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
