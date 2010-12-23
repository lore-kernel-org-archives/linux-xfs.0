Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNNJ7Nb010291 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 17:19:07 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA5D321CB9A
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 15:21:06 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id NCy022x1DondhYeH
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 15:21:06 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 25F496C14F
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 17:21:06 -0600 (CST)
Message-ID: <4D13D962.5060809@hardwarefreak.com>
Date: Thu, 23 Dec 2010 17:21:06 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>	<20101222175611.1c7d5190@harpe.intellique.com>	<4D124B71.9030401@sandeen.net>	<20101223012655.2681c596@galadriel.home>	<alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>	<20101223005630.GJ4907@dastard>	<alpine.DEB.2.00.1012230442150.7452@p34.internal.lan>	<alpine.DEB.2.00.1012231304130.12482@p34.internal.lan>	<20101223195544.53d45f0b@galadriel.home>	<alpine.DEB.2.00.1012231403440.5924@p34.internal.lan>	<4D13A8E6.7090606@hardwarefreak.com>
	<20101223224832.1abb3cb8@galadriel.home>
In-Reply-To: <20101223224832.1abb3cb8@galadriel.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Emmanuel Florac put forth on 12/23/2010 3:48 PM:
> Le Thu, 23 Dec 2010 13:54:14 -0600 vous =E9criviez:
> =

>> Best guess?  Those 3TB Hitachi drives use 512 byte translated native
>> 4KB sectors. =

> =

> Yes, I'm sure that no new drive model comes with true 512B sectors
> anymore...

I believe most/all shipping drives of 1TB and smaller still have native
512 byte sectors, dependent on specific vendor/model line of course.
It's mainly the 1.5TB and up drives with the hybrid 512/4096 byte sector
abomination.

It would be far more optimal if they'd just ship native 4K sector drives
wouldn't it?  Isn't most of Linux already patched for pure 4k sector
drives?  Is XFS ready for such native 4k sector drives?  Are the various
RAID cards/SAN array controllers?

-- =

Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
