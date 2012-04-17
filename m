Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3H9K2e5036927 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 04:20:03 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id HdFEuZilLdiNrk0G (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Apr 2012 02:20:00 -0700 (PDT)
Message-ID: <4F8D35B8.4090507@profihost.ag>
Date: Tue, 17 Apr 2012 11:19:52 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: XFS blocked task in xlog_cil_force_lsn
References: <4F8BC0B9.90604@profihost.ag> <20120416235647.GA6734@dastard>
	<4F8D27A1.2090809@profihost.ag> <20120417083210.GI6734@dastard>
In-Reply-To: <20120417083210.GI6734@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Philipp Herz - Profihost AG <p.herz@profihost.ag>, stable@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 17.04.2012 10:32, schrieb Dave Chinner:
>>> What's your storage hardware, application, workload, etc?
>> It a Raid 10 of 1TB SATA Drives in front of a 3Ware Controller doing
>> heavy rsync backups.
> 
> Hmmm. It sounds like it is just taking a long time for the IO to
> complete, not that there is any other problem. If the IO is realy,
> really slow, the a log force is definitely a place it coul dstall
> for some time.
OK as i've seen this just once it just might be that the controller /
disks were too slow in this case.

> Does the RAID controller have a BBWC?
No but doesn't matter ;-) If it crashes i can just repair the FS and
restart the backup again.

> What IO scheduler are you using?
[root@backup1 ~]# cat /sys/block/sdc/queue/scheduler
[noop] deadline cfq

> Does mounting with nobarriers reduce the stall time?
It is already mounted with nobarrier:
/dev/sdc3 on /sdc3 type xfs (rw,noatime,nodiratime,nobarrier,prjquota)

> Can you reduce the IO load so that it doesn't end up in this state?
Can try that by just doing less backups per time period.

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
