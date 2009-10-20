Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9KM2XN0176342 for <xfs@oss.sgi.com>; Tue, 20 Oct 2009 17:02:33 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5762317AA396
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2009 15:04:06 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id ieVBzVzj8uKGNfx8 for
	<xfs@oss.sgi.com>; Tue, 20 Oct 2009 15:04:06 -0700 (PDT)
Message-ID: <4ADE33D5.6080907@sandeen.net>
Date: Tue, 20 Oct 2009 17:04:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr: XFS_IOC_SWAPEXT failed : busy?m
References: <4ADD4D9B.9090808@tlinx.org>
In-Reply-To: <4ADD4D9B.9090808@tlinx.org>
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Linda A. Walsh wrote:
> I noticed a weird message from my daily fsr run -- looks like it is on the
> root partition. 
> Does this mean the file was busy? (hopefully? :-))
> 
> (all 10 passes...but they were only about 2 seconds apart...disks are
> apparently not very frag'ed... :-))...
> 
> tnx,
> -linda
> 

What kernel?  and what file is inode 16781994?  (find / -inum 16781994)

EINVAL can come from many places; trying to defrag a swapfile is one of 
them ...

-Eric

> 
> Oct 19 02:05:33 Ishtar fsr[20913]: / start inode=0
> Oct 19 02:05:33 Ishtar fsr[20906]: XFS_IOC_SWAPEXT failed: ino=16781994: 
> Invalid argument
> Oct 19 02:05:33 Ishtar fsr[20907]: /var start inode=0
> ...
> Oct 19 02:05:35 Ishtar fsr[20913]: / start inode=0
> Oct 19 02:05:35 Ishtar fsr[20913]: XFS_IOC_SWAPEXT failed: ino=16781994: 
> Invalid argument
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
