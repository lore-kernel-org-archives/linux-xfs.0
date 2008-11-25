Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAPKitCO005119 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 14:44:56 -0600
Received: from buick.jordet.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72EB715F5367
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 12:44:55 -0800 (PST)
Received: from buick.jordet.net (buick.jordet.net [193.91.240.190]) by
	cuda.sgi.com with ESMTP id 7o2FRZob4oPKV0jw for
	<xfs@oss.sgi.com>; Tue, 25 Nov 2008 12:44:55 -0800 (PST)
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
From: Stian Jordet <liste@jordet.net>
In-Reply-To: <alpine.DEB.2.00.0811250057510.27010@aurora.sdinet.de>
References: <1226760254.5089.11.camel@chevrolet>
	<430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>
	<1227476908.32357.5.camel@chevrolet>
	<alpine.DEB.1.10.0811231721350.22594@p34.internal.lan>
	<1227485956.5145.10.camel@chevrolet>
	<alpine.DEB.1.10.0811240448570.25866@p34.internal.lan>
	<1227569808.5039.6.camel@chevrolet>
	<alpine.DEB.2.00.0811250057510.27010@aurora.sdinet.de>
Date: Tue, 25 Nov 2008 21:44:47 +0100
Message-Id: <1227645887.7992.10.camel@chevrolet>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

ti., 25.11.2008 kl. 01.09 +0100, skrev Sven-Haegar Koch:
> I had the same problem when I tried it on my laptop (T60) - using it on 
> the unencrypted root filesystem (with /usr/src) took ages, using it on 
> the LUKS encrypted /home was blasing fast - on the same disk.
> 
> This test was some time ago with something like 2.6.20 or 2.6.24 - I 
> gave up and reformatted / with ext3 as I needed the machine.
> 
> I think barriers were the problem, they seem to cost performance like 
> hell, especially for operations with many small files. My laptop used 
> barriers for xfs on the direct partition, but not on crypto drivermapper 
> mounts.
> 
> So perhaps try mounting with nobarrier and see if the speed problem goes 
> away - but know that you sacrifice some crash-resilience when doing so.

Barriers were the problem indeed. My old system had no problems with
barriers, but here it did an incredible difference.

Thanks!
-Stian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
