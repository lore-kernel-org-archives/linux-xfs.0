Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAPM7kA4011692 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 16:07:46 -0600
Received: from pmx2.sophos.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0E9415F5795
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 14:07:45 -0800 (PST)
Received: from pmx2.sophos.com (pmx2.sophos.com [213.31.172.17]) by
	cuda.sgi.com with ESMTP id bThXQbtic0Mctguc for
	<xfs@oss.sgi.com>; Tue, 25 Nov 2008 14:07:45 -0800 (PST)
Message-ID: <492C75E2.1080701@ca.sophos.com>
Date: Tue, 25 Nov 2008 14:02:10 -0800
From: David Sparks <dave@ca.sophos.com>
MIME-Version: 1.0
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
References: <1226760254.5089.11.camel@chevrolet>	<430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>	<1227476908.32357.5.camel@chevrolet>	<alpine.DEB.1.10.0811231721350.22594@p34.internal.lan>	<1227485956.5145.10.camel@chevrolet>	<alpine.DEB.1.10.0811240448570.25866@p34.internal.lan>	<1227569808.5039.6.camel@chevrolet>	<alpine.DEB.2.00.0811250057510.27010@aurora.sdinet.de>	<1227645887.7992.10.camel@chevrolet>
	<492C6C9B.3060000@sandeen.net>
	<1227649893.6557.10.camel@oldsmobile>
In-Reply-To: <1227649893.6557.10.camel@oldsmobile>
Reply-To: David Sparks <dave@ca.sophos.com>
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
To: Stian Jordet <liste@jordet.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> With no barriers, it's 22s faster than my workstation. That can't be the
> way it's supposed to be?

What IO elevator are you using?  Did you try the 'noop' or 'deadline' schedulers?

cat /sys/block/sda/queue/scheduler
echo noop > /sys/block/sda/queue/scheduler

ds

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
