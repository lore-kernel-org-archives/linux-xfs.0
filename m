Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E2C57F52
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 03:11:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 79DE4304053
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 01:11:13 -0800 (PST)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id YJyR0bZ39Bj3uvjQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Feb 2013 01:11:12 -0800 (PST)
Message-ID: <510F7B2D.908@tlinx.org>
Date: Mon, 04 Feb 2013 01:11:09 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: Looking for Linux XFS file system performance tuning tips for
	LSI	9271-8i + 8 SSD's RAID0
References: <courier.510ECA60.00003A99@softhome.net>
In-Reply-To: <courier.510ECA60.00003A99@softhome.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: rkj@softhome.net
Cc: xfs-oss <xfs@oss.sgi.com>



rkj@softhome.net wrote:
> 
> I am working with hardware RAID0 using LSI 9271-8i + 8 SSD's...
>... With Direct IO, the sequential writes are around 
> 3.5 GB/s but I noticed a drop-off in sequential reads for smaller record 
> sizes.
----
1) Are you using the realtime partitions?
2) are you using an empty file space with max log size
3) what are you using to do write's with, "dd"?
4) have you tried pre-allocating the space, running xfs_fsr on the
file, to get it to 1 extent in size,
then run dd with the conv=nocreat,notrunc option?

Those are some things to try for maximums.
I notice ~30% hit if I go through the linux buffer system as well.
Have you tried different write sizes?

i.e. 32M, 64M, 128 256... i.e. I notice optimal sizes after
which things fall off...

do you run 'time' on "dd" as well and see how much cpu it is using?

If you use bash, I find setting TIMEFORMAT to:

"%2Rsec %2Uusr %2Ssys (%P%% cpu)"

to be a useful format (1 line, and shows cpu % usage)...

just some random thoughts...


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
