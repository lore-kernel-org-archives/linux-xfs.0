Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNJqGCm235906 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:52:17 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CD48147DFF4
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:54:14 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id bv5Je8ZSyxlag2UX
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:54:14 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 491C26C0B8
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:54:14 -0600 (CST)
Message-ID: <4D13A8E6.7090606@hardwarefreak.com>
Date: Thu, 23 Dec 2010 13:54:14 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>	<20101222175611.1c7d5190@harpe.intellique.com>	<4D124B71.9030401@sandeen.net>	<20101223012655.2681c596@galadriel.home>	<alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>	<20101223005630.GJ4907@dastard>	<alpine.DEB.2.00.1012230442150.7452@p34.internal.lan>	<alpine.DEB.2.00.1012231304130.12482@p34.internal.lan>	<20101223195544.53d45f0b@galadriel.home>
	<alpine.DEB.2.00.1012231403440.5924@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1012231403440.5924@p34.internal.lan>
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

Justin Piszcz put forth on 12/23/2010 1:07 PM:

> Main wonder I have is why when the partition is aligned to 1MiB, which is
> the default in parted 2.2+ I believe, is it slower than with no partitions?

Best guess?  Those 3TB Hitachi drives use 512 byte translated native 4KB
sectors.  The 9750-24 ie card doesn't know how to properly align
partitions on such drives, and/or you're using something other than
fdisk or parted to create your partitions.  Currently these are the only
two partitioners that can align partitions properly on 512 byte
translated/native 4KB sector drives.  Thus you're taking a performance
hit, same as with the WD "Advanced Format" drives which have 512 byte
translated/native 4KB sectors.

If you want maximum performance with least configuration headaches,
avoid 512B/4KB sector hybrid drives.  If you _need_ maximum drive
capacity, live with the warts, or jump through hoops to get the
partitions aligned, or, live without partitions if you can.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
