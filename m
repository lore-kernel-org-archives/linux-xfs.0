Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1E5W2tP068645 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 23:32:02 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id g9ecVxfoAFZAp27L
	for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 21:32:01 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 0ACD66C161
	for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 23:32:01 -0600 (CST)
Message-ID: <4F39F1CB.3060806@hardwarefreak.com>
Date: Mon, 13 Feb 2012 23:31:55 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
References: <20120213170825.GA7197@infradead.org>
	<4F394442.9020307@cape-horn-eng.com>
	<20120213171556.GA13449@infradead.org>
	<4F3947D6.5060402@cape-horn-eng.com>
	<20120213172937.GA25248@infradead.org>
	<4F394E10.9000804@cape-horn-eng.com>
	<20120213180220.GA24163@infradead.org>
	<4F395134.8030202@cape-horn-eng.com>
	<20120213181012.GA27962@infradead.org>
	<4F395B1A.7010709@cape-horn-eng.com>
	<20120213211654.GA20192@infradead.org>
In-Reply-To: <20120213211654.GA20192@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 2/13/2012 3:16 PM, Christoph Hellwig wrote:

> I'd have to look into it in more detail.  IIRC you said you're using
> RAID6 which can be fairly nasty for small reads.  Did you use the
> inode64 mount option on the filesystem?

On 2/13/2012 10:57 AM, Richard Ems wrote:

> # mount | grep xfs
> /dev/sda1 on /backup/IFT type xfs
>
(rw,noatime,nodiratime,attr2,delaylog,nobarrier,logbufs=8,logbsize=256k,sunit=256,swidth=5376,noquota,_netdev)

With a 16TB+ XFS, 20TB here, isn't inode64 the default allocator?

[...]

> 20 TB XFS
> partition is 100% full

Does the fact the FS is 100% full make any difference here?


> The case is connected through SCSI.

Do you mean iSCSI?  Does the host on which you're running your "find
dir" command have a 1GbE or 10GbE connection to the InforTrend unit?
More than one connection using bonding or multipath?  Direct connected
or through a switch(es)?  What brand is the switch(es)?  Switch(es)
under heavy load?

If it's a single direct 1GbE connection it's possible you're running out
of host pipe bandwidth which is only ~100MB/s in each direction.  Check
iotop/iostat while running your command to see if you're peaking the
interface with either read or write bytes.  If either are at or above
100MB/s then your host pipe is full, thus this is a significant part of
your high run time problem.

Also check the performance data in the management interface on the
InforTrend unit to see if you're hitting any limits there (if it has
such a feature).  RAID6 is numerically intensive and that particular
controller may not have the ASIC horsepower to keep up with the IOPS
workload you're throwing at it.

Lastly, please paste the exact command or script you refer to as "find
dir" which is generating the workload in question.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
