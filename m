Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED78629DF9
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 11:48:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8858EAC002
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 09:48:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zfNgfGLRxizY8qHt for <xfs@oss.sgi.com>;
	Tue, 22 Jul 2014 09:48:05 -0700 (PDT)
Message-ID: <53CE95C5.8040702@sandeen.net>
Date: Tue, 22 Jul 2014 11:48:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Forced quotacheck after unclean unmount since 3.11, bisected
References: <53CE6415.8080607@excellency.fr>
In-Reply-To: <53CE6415.8080607@excellency.fr>
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
To: cbay@excellency.fr, xfs@oss.sgi.com

On 7/22/14, 8:16 AM, Cyril B. wrote:
> Hello,
> 
> I've noticed that since Linux 3.11, quotacheck always happen after
> unclean unmounts. Is this expected? It didn't happen on previous
> Linux versions.

I can reproduce this, I'll take a look - thanks for bisecting!

-Eric

> A bisect shows that this commit is responsible:
> xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD
> id: 83e782e1a1cc0159888e58e14dfc8f3289663338
> 
> Relevant dmesg:
> [    8.844063] XFS (md4): Mounting Filesystem
> [    9.054023] XFS (md4): Starting recovery (logdev: internal)
> [    9.331785] XFS (md4): Ending recovery (logdev: internal)
> [    9.383856] XFS (md4): Quotacheck needed: Please wait.
> [   48.427732] XFS (md4): Quotacheck: Done.
> 
> More details:
>   * vanilla kernel
>   * on top of mdadm (RAID1)
>   * xfsprogs 3.1.5
>   * mount options: noatime,nosuid,nodev,grpquota,inode64
>   * xfs_info:
> meta-data=/dev/md4               isize=256    agcount=4, agsize=119997280 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=479989120, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=234369, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Thanks,
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
