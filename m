Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 18A5E7FB9
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 05:17:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D84A5304051
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 03:17:30 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	SgMS4Ex9m58RpO6Q for <xfs@oss.sgi.com>;
	Fri, 01 Mar 2013 03:17:29 -0800 (PST)
Date: Fri, 1 Mar 2013 22:17:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair segfaults
Message-ID: <20130301111701.GB23616@dastard>
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
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
To: Ole Tange <tange@binf.ku.dk>
Cc: xfs@oss.sgi.com

On Thu, Feb 28, 2013 at 04:22:08PM +0100, Ole Tange wrote:
> I forced a RAID online. I have done that before and xfs_repair
> normally removes the last hour of data or so, but saves everything
> else.

Why did you need to force it online?

> Today that did not work:
> 
> /usr/local/src/xfsprogs-3.1.10/repair# ./xfs_repair -n /dev/md5p1
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
> flfirst 232 in agf 91 too large (max = 128)

Can you run:

# xfs_db -c "agf 91" -c p /dev/md5p1

And post the output?

> # cat /proc/partitions |grep md5
>    9        5 125024550912 md5
>  259        0 107521114112 md5p1
>  259        1 17503434752 md5p2

Ouch.

> # cat /proc/mdstat
> Personalities : [raid0] [raid6] [raid5] [raid4]
> md5 : active raid0 md1[0] md4[3] md3[2] md2[1]
>       125024550912 blocks super 1.2 512k chunks
> 
> md1 : active raid6 sdd[1] sdi[9] sdq[13] sdau[7] sdt[10] sdg[5] sdf[4] sde[2]
>       31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
> [10/8] [_UU_UUUUUU]
>       bitmap: 2/2 pages [8KB], 1048576KB chunk

There are 2 failed devices in this RAID6 lun - i.e. no redundancy -
and no rebuild in progress. Is this related to why you had to force
the RAID online?

> md4 : active raid6 sdo[13] sdu[9] sdad[8] sdh[7] sdc[6] sds[11]
> sdap[3] sdao[2] sdk[1]
>       31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
> [10/8] [_UUUU_UUUU]
>       [>....................]  recovery =  2.1% (84781876/3907017344)
> finish=2196.4min speed=29003K/sec
>       bitmap: 2/2 pages [8KB], 1048576KB chunk

and 2 failed devices here, too, with a rebuild underway that will
take the best part of 2 days to complete...

So, before even trying to diagnose the xfs_repair problem, can you
tell us what actually went wrong with your md devices?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
