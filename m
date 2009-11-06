Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA6MhAvx243570 for <xfs@oss.sgi.com>; Fri, 6 Nov 2009 16:43:10 -0600
Received: from x.digitalelves.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4EEA14CCF46
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2009 14:43:25 -0800 (PST)
Received: from x.digitalelves.com (v-209-98-77-55.ip.visi.com [209.98.77.55])
	by cuda.sgi.com with ESMTP id qxi8Fg3zjFnth42n for
	<xfs@oss.sgi.com>; Fri, 06 Nov 2009 14:43:25 -0800 (PST)
Message-ID: <4AF4A66B.8090906@digitalelves.com>
Date: Fri, 06 Nov 2009 16:42:51 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: xfs_repair breaks; xfs_metadump hangs
References: <20091104152022.GA21347@mytux.intra.in-medias-res.com>
In-Reply-To: <20091104152022.GA21347@mytux.intra.in-medias-res.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: mill / in-medias-res <mill@in-medias-res.com>
Cc: kirschbaum@in-medias-res.com, xfs@oss.sgi.com

mill / in-medias-res wrote:
> Hello XFS-Community,
>
> i have some real trouble with restoring/repairing my two XFS Partion's. These
> Partion's are on a RAID-5 Array which "was broken". The first xfs_repair run
> on /dev/sdc1 did restore 80 GB from ca. 300-400 GB. The Problem was that 99,9%
> of the million files are in lost+found.
>
> Because i was more interested in restoring /dev/sdc2, i did forget about sdc1
> and run xfs_repair on the other Partion:
>
> cmd: xfs_repair -t 1 -P /dev/sdc2
> [...]
> corrupt inode 3256930831 ((a)extents = 1).  This is a bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.
> cache_node_purge: refcount was 1, not zero (node=0x377d0008)
> fatal error -- couldn't map inode 3256930831, err = 117
>   
Hmm interesting.
Can you go into xfs_db and print out the bad inode? send it to us?
I'm guessing the extents are corrupted somehow.

One option to then flag the inode as deleted which will cause repair to
toss is hopefully clean up the mess.

Here is a write up how to do that.
http://jijo.free.net.ph/19

> time: 67,27s user 10,09s system 10% cpu 12:05,31 total
>
> I tried to run xfs_metadump serveral times and it hangs everytime on this position:
> xfs_metadump  -g /dev/sdc2 metadump-sdc2-2
> Copied 1411840 of 4835520 inodes (0 of 3 AGs)
>
> It runs till 2 days on the same inode and xfs_db consumes 99% of CPU.
> Should i wait here?
>
> Versions:
> dpkg -l |grep xfs
> ii  xfsdump   3.0.2~bpo50+1       Administrative utilities for the XFS filesys
> ii  xfsprogs  3.0.4~bpo50+1       Utilities for managing the XFS filesystem
> Distribution: Debian lenny with xfsprogs, xfsdump backport from unstable.
>
> The xfs_repair with stock Debian Lenny version also does crash at inode 3256930831.
>
> Best Regards,
> Maximilian Mill
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
>   

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
