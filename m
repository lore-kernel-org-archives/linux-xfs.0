Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o290sFiI088063 for <xfs@oss.sgi.com>; Mon, 8 Mar 2010 18:54:15 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 541F222611B
	for <xfs@oss.sgi.com>; Mon,  8 Mar 2010 16:55:46 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id MR3ZyNdZdxEqsLl4 for
	<xfs@oss.sgi.com>; Mon, 08 Mar 2010 16:55:46 -0800 (PST)
Message-ID: <4B959C91.70506@sandeen.net>
Date: Mon, 08 Mar 2010 18:55:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: What are the correct mkfs.xfs parameters for a lying WD-EARS HDD?
References: <20100308221044.GA17830@citd.de> <4B957E03.9090000@sandeen.net>
	<yq1vdd68j1w.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1vdd68j1w.fsf@sermon.lab.mkp.net>
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
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: xfs@oss.sgi.com

Martin K. Petersen wrote:
>>>>>> "Eric" == Eric Sandeen <sandeen@sandeen.net> writes:
> 
> Eric> Make sure your partitions, if any, are on 4k boundaries.(*) older
> Eric> fdisk at least won't do this by default, not sure about parted.
> 
> You can use the expert mode in fdisk to ensure that the partition begins
> on a 4KB boundary.

and use -u to give it sector units ...

> 
> Eric> (*)unless the drive has an offset to make 512-sector 63 line up on
> Eric> a nice boundary... in which case I guess you could experiment with
> Eric> perf both ways to be sure...
> 
> EARS is the one that's lying about the physical block size.  It's
> zero-aligned unless somebody messed with the jumper.

Ok, that's good.

Thanks Martin!

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
