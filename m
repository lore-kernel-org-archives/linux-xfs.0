Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNJuLfw236704 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:56:21 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D15C1CF54DC
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:58:19 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id BFaBViFgJrC5ysQG
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:58:19 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 906C36C0B8
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:58:19 -0600 (CST)
Message-ID: <4D13A9DB.1010700@hardwarefreak.com>
Date: Thu, 23 Dec 2010 13:58:19 -0600
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

> Using a partition shows a slight degredation in the re-write speed but
> an increase in performance for sequential output and input with the mode
> set to perform.  Looks like this is what I will be using as it is the
> fastest
> speeds overall except for the rewrite.

As Dave mentioned earlier, performance may degrade significantly over
time as the FS grows and ages, compared to running benchies against an
empty filesystem today, especially if your mkfs.xfs parms were off the
mark when creating.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
