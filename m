Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNIrvLZ225422 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 12:53:57 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 426E31CF505A
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 10:55:54 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id mfHU6a4AtR4dfky6 for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 10:55:54 -0800 (PST)
Date: Thu, 23 Dec 2010 19:55:44 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
Message-ID: <20101223195544.53d45f0b@galadriel.home>
In-Reply-To: <alpine.DEB.2.00.1012231304130.12482@p34.internal.lan>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222175611.1c7d5190@harpe.intellique.com>
	<4D124B71.9030401@sandeen.net>
	<20101223012655.2681c596@galadriel.home>
	<alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>
	<20101223005630.GJ4907@dastard>
	<alpine.DEB.2.00.1012230442150.7452@p34.internal.lan>
	<alpine.DEB.2.00.1012231304130.12482@p34.internal.lan>
Mime-Version: 1.0
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Le Thu, 23 Dec 2010 13:06:10 -0500 (EST) vous =E9criviez:

> http://home.comcast.net/~jpiszcz/20101223/final.html
> =


Something's wrong with the file create/stat/delete tests. Did you mount
with "nobarrier"? =

Which drives, controller firmware, raid level, stripe width? =


BTW don't run only one test, it's meaningless. I always run at least 8
cycles (and up to 30 or 40 cycles) and then calculate the average and
standard deviation, because one test among a cycle may vary wildly for
some reason. You don't need the "char" tests, that doesn't correspond
to any real-life usage pattern. Better run bonnie with the -f option,
and -x with some large enough value.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
