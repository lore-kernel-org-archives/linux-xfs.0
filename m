Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBO0xJjI029432 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 18:59:20 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 130D1147EEEF
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 17:01:18 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Mcq9riURJ3wKeiBu
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 17:01:18 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 2395B6C14F
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 19:01:18 -0600 (CST)
Message-ID: <4D13F0DE.50306@hardwarefreak.com>
Date: Thu, 23 Dec 2010 19:01:18 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>	<20101222175611.1c7d5190@harpe.intellique.com>	<4D124B71.9030401@sandeen.net>	<20101223012655.2681c596@galadriel.home>	<alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>	<20101223005630.GJ4907@dastard>	<alpine.DEB.2.00.1012230442150.7452@p34.internal.lan>	<alpine.DEB.2.00.1012231304130.12482@p34.internal.lan>	<20101223195544.53d45f0b@galadriel.home>
	<alpine.DEB.2.00.1012231427430.6569@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1012231427430.6569@p34.internal.lan>
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

Justin Piszcz put forth on 12/23/2010 1:29 PM:

> Please check the updated page:
> http://home.comcast.net/~jpiszcz/20101223/final.html
> 
> Using a partition shows a slight degredation in the re-write speed but
> an increase in performance for sequential output and input with the mode
> set to perform.  Looks like this is what I will be using as it is the
> fastest
> speeds overall except for the rewrite.

If your primary workloads for this array are mostly single user/thread
streaming writes/reads then this may be fine.  If they are multi-user or
multi-threaded random re-write server loads, re-write is the most
important metric and you should optimize for that scenario alone, as its
performance is most dramatically impacted by parity RAID schemes such as
RAID 6.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
