Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB90Q3oR154028 for <xfs@oss.sgi.com>; Wed, 8 Dec 2010 18:26:03 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5A421CA8667
	for <xfs@oss.sgi.com>; Wed,  8 Dec 2010 16:27:51 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id hDXytBuwkkwogvAh
	for <xfs@oss.sgi.com>; Wed, 08 Dec 2010 16:27:51 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id C2B386C173
	for <xfs@oss.sgi.com>; Wed,  8 Dec 2010 18:27:50 -0600 (CST)
Message-ID: <4D002286.2080204@hardwarefreak.com>
Date: Wed, 08 Dec 2010 18:27:50 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs tuning for a 830 GB partition (mkfs.xfs options)
References: <AANLkTimkZB20eqywSPvwh00gcXWcr4_Eqm5u40P6RqaJ@mail.gmail.com>	<4D00032D.4040000@hardwarefreak.com>
	<AANLkTi=qkM9c5ukdJj7Hqhj8XMWSOGNENLEG9_Uz_DBT@mail.gmail.com>
In-Reply-To: <AANLkTi=qkM9c5ukdJj7Hqhj8XMWSOGNENLEG9_Uz_DBT@mail.gmail.com>
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

Abel Coto put forth on 12/8/2010 5:29 PM:

> By the moment i will use one hard disk for / (on ext3) and /home , and
> the data partition for saving 3d projects working on in another hard
> disk (1,5 tb one , with the 350 GB partition and one of 1 TB for
> backups of /home mostly)
> 
> so agcount should be in both cases 4, as i haven't got a raid (the 1,5
> tb disk won't be in the LVM neither).
> 
> I have read that in xfsprogs 3.1.2, i think, -l lazy-count=1,version=2
> and -i attr=2 is the default option like agcount=4. So  i should only
> specify the -l size=128m if i want a log size of 128m for improve
> deleting performance and improving system in general.

With a single disk filesystem, you can tweak these things forever, and
you will gain almost no performance benefit over the mkfs.xfs defaults,
though you may decrease performance if you don't know exactly what
you're doing, such as with your previous misunderstanding of agcount.

The one thing you can tweak beyond defaults to get improved performance
is using delayed logging, which will increase metadata write performance
substantially.  For example, deletes of large groups (thousands) of
small files will be "massively" faster using delayed logging.  IIRC this
requires kernel 2.6.36 or later.  Simply add "delaylog" to you
/etc/fstab mount options.

> I think in /home the most important thing is read/write seqential
> performance , and in /data (the 350 GB partition) the same.
> 
> I don't think /data would have to handle too many ramdon reads/ writes
> when Maya saves and read data from it, i think would be mostly
> seqential and then allocated in memory.

Again, with a single disk, there's not much you can tweak to increase
general XFS performance, except for metadata writes using delaylog.  For
sequential file reads/writes and random reads/writes, you're at the
mercy of the drive's spindle speed.

XFS options can't improve upon the poor physics of a single spinning
drive.  If you need improved file performance (not metadata), your
options are to add spindles and stripe the data (RAID card or mdadm,
RAID 0/5/6/10), or use a good quality SSD.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
