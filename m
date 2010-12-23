Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNJ5FDS227823 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:05:16 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99C451CF50F7
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:07:14 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id 3RfRCnXqNg1bRrqm for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:07:14 -0800 (PST)
Date: Thu, 23 Dec 2010 14:07:13 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
In-Reply-To: <20101223195544.53d45f0b@galadriel.home>
Message-ID: <alpine.DEB.2.00.1012231403440.5924@p34.internal.lan>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222175611.1c7d5190@harpe.intellique.com>
	<4D124B71.9030401@sandeen.net>
	<20101223012655.2681c596@galadriel.home>
	<alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>
	<20101223005630.GJ4907@dastard>
	<alpine.DEB.2.00.1012230442150.7452@p34.internal.lan>
	<alpine.DEB.2.00.1012231304130.12482@p34.internal.lan>
	<20101223195544.53d45f0b@galadriel.home>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-897510591-1293131233=:5924"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-897510591-1293131233=:5924
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 23 Dec 2010, Emmanuel Florac wrote:

> Le Thu, 23 Dec 2010 13:06:10 -0500 (EST) vous =E9criviez:
>
>> http://home.comcast.net/~jpiszcz/20101223/final.html
>>
>
> Something's wrong with the file create/stat/delete tests. Did you mount
> with "nobarrier"?
No, default mount options..
Also I just changed it will update the page in a bit, the raid was on
balance mode, with performance, the raid-rewrite went to ~420-430MiB/s, muc=
h
faster.

> Which drives, controller firmware, raid level, stripe width?
Hitachi 7K3000 7200RPM 3TB Drives
Latest firmware, 10.2 I think for the 9750-24ie
Raid Level =3D 6
Stripe width =3D 256k (default)
>
> BTW don't run only one test, it's meaningless. I always run at least 8
> cycles (and up to 30 or 40 cycles) and then calculate the average and
> standard deviation, because one test among a cycle may vary wildly for
> some reason. You don't need the "char" tests, that doesn't correspond
> to any real-life usage pattern. Better run bonnie with the -f option,
> and -x with some large enough value.

I ran 3 tests and took the average of the 3 runs per each unit test.=20
I use this test because I have been using it for 3-4+ years so I can compar=
e=20
apples to apples.

If its +++ or blank in the HTML that means it ran too fast for it to measur=
e
I believe.

Main wonder I have is why when the partition is aligned to 1MiB, which is
the default in parted 2.2+ I believe, is it slower than with no partitions?

I will try again with mode=3Dperformance on the RAID controller..


>
> --=20
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                    |   Intellique
>                    |=09<eflorac@intellique.com>
>                    |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
>
--655872-897510591-1293131233=:5924
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--655872-897510591-1293131233=:5924--
