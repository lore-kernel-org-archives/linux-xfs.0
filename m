Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAPM2RwY010825 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 16:02:28 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C4E615F6478
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 14:02:26 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id iovGw9HGjfoL37q1 for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 14:02:26 -0800 (PST)
Message-ID: <492C6C9B.3060000@sandeen.net>
Date: Tue, 25 Nov 2008 15:22:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
References: <1226760254.5089.11.camel@chevrolet>	<430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>	<1227476908.32357.5.camel@chevrolet>	<alpine.DEB.1.10.0811231721350.22594@p34.internal.lan>	<1227485956.5145.10.camel@chevrolet>	<alpine.DEB.1.10.0811240448570.25866@p34.internal.lan>	<1227569808.5039.6.camel@chevrolet>	<alpine.DEB.2.00.0811250057510.27010@aurora.sdinet.de>
	<1227645887.7992.10.camel@chevrolet>
In-Reply-To: <1227645887.7992.10.camel@chevrolet>
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
Cc: Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Stian Jordet wrote:
> ti., 25.11.2008 kl. 01.09 +0100, skrev Sven-Haegar Koch:
>> I had the same problem when I tried it on my laptop (T60) - using it on 
>> the unencrypted root filesystem (with /usr/src) took ages, using it on 
>> the LUKS encrypted /home was blasing fast - on the same disk.
>>
>> This test was some time ago with something like 2.6.20 or 2.6.24 - I 
>> gave up and reformatted / with ext3 as I needed the machine.
>>
>> I think barriers were the problem, they seem to cost performance like 
>> hell, especially for operations with many small files. My laptop used 
>> barriers for xfs on the direct partition, but not on crypto drivermapper 
>> mounts.
>>
>> So perhaps try mounting with nobarrier and see if the speed problem goes 
>> away - but know that you sacrifice some crash-resilience when doing so.
> 
> Barriers were the problem indeed. My old system had no problems with
> barriers, but here it did an incredible difference.

Depending on the old system, perhaps its storage did not allow the
barriers to be honored, so after xfs saw a test barrier write fail at
mount time, it disabled them ... you'd see a message if that were the
case, FWIW.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
