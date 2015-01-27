Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 728CC7F74
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2015 10:31:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F96A8F8039
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2015 08:31:32 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YilQ5PcyC2wXAXoT for <xfs@oss.sgi.com>;
	Tue, 27 Jan 2015 08:31:30 -0800 (PST)
Message-ID: <54C7BD60.5000104@sandeen.net>
Date: Tue, 27 Jan 2015 10:31:28 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: maxpct option for small xfs filesystems
References: <54C667F3.8040303@oracle.com> <20150126223715.GA7621@dastard>
	<54C7BB78.4060203@oracle.com>
In-Reply-To: <54C7BB78.4060203@oracle.com>
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
To: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 1/27/15 10:23 AM, Alexander Tsvetkov wrote:

...

> I have not the same results,  just installed 3.19-rc6 and repeated the test.,
> df -i reports 640 inodes for filesystem, but actually created 40512 files:
> 
> [root@fedora ~]# mkfs.xfs -f -d size=16m -i maxpct=1 /dev/sdb2
> meta-data=/dev/sdb2              isize=256    agcount=1, agsize=4096 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=4096, imaxpct=1
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal log           bsize=4096   blocks=853, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> [root@fedora ~]# mount /dev/sdb2 /mnt/scratch/
> fill with files until enospc...
> [root@fedora ~]# df -i /mnt/scratch/
> Filesystem     Inodes IUsed IFree IUse% Mounted on
> /dev/sdb2         640   640     0  100% /mnt/scratch
> [root@fedora ~]# df -Th /mnt/scratch/
> Filesystem     Type  Size  Used Avail Use% Mounted on
> /dev/sdb2      xfs    13M   13M  156K  99% /mnt/scratch
> [root@fedora ~]# umount /mnt/scratch
> [root@fedora ~]# xfs_db -c "blockget -n" -c "ncheck" /dev/sdb2 | wc -l
> 40512

and what does df -i say after remount?

This is actually a problem with the lazy superblock counters I've run into before,
but haven't yet fixed.  This kind of workload is such that it never trips the
runtime rebalancing.


> Looking into ncheck output there are 40512 pairs reported in the output each with own unique
> inode number. ncheck doesn't report inodes count by definition, but what does these
> 40512 reported inode numbers mean if only actually 640 inodes were allocated? From another hand
> each new file should have associated meta-data in the corresponding allocated inode structure, so for
> 40512 newly created files I expect the same count of allocated inodes, is it correct?

Recheck df -i after remount, I think you will see many more than 640.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
