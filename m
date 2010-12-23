Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNM30eL257686 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 16:03:00 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 604E41CF583D
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 14:04:58 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id W43wuv7HoZeFIvC7 for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 14:04:58 -0800 (PST)
Date: Thu, 23 Dec 2010 17:04:58 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
In-Reply-To: <20101223225036.4bef756e@galadriel.home>
Message-ID: <alpine.DEB.2.00.1012231703380.17269@p34.internal.lan>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222175611.1c7d5190@harpe.intellique.com>
	<4D124B71.9030401@sandeen.net>
	<20101223012655.2681c596@galadriel.home>
	<alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>
	<20101223005630.GJ4907@dastard>
	<alpine.DEB.2.00.1012230442150.7452@p34.internal.lan>
	<alpine.DEB.2.00.1012231304130.12482@p34.internal.lan>
	<20101223195544.53d45f0b@galadriel.home>
	<alpine.DEB.2.00.1012231403440.5924@p34.internal.lan>
	<20101223225036.4bef756e@galadriel.home>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-1092608683-1293141898=:17269"
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

--655872-1092608683-1293141898=:17269
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,

I had not tested with 64KB or 16KB stripes:

I used optimal (default I believe) in newer 2.2+ parted:

        -a alignment-type, --align alignment-type
               Set  alignment  for  newly  created  partitions, valid align=
ment
               types are:

               none   Use the minimum alignment allowed by the disk type.

               cylinder
                      Align partitions to cylinders.

               minimal
                      Use minimum alignment  as  given  by  the  disk  topo=
logy
                      information.  This  and  the  opt  value  will use la=
yout
                      information provided by the disk  to  align  the  log=
ical
                      partition  table  addresses  to actual physical block=
s on
                      the disks.  The min value is the minimum aligment  ne=
eded
                      to align the partition properly to physical blocks, w=
hich
                      avoids performance degradation.

               optimal
                      Use optimum alignment  as  given  by  the  disk  topo=
logy
                      information.  This  aligns  to a multiple of the phys=
ical
                      block size in a way that guarantees optimal performan=
ce.

I'm happy with the performance now.. I get 16GB ram tomorrow so hopefully=
=20
that'll be enough if I need to xfs_repair.

Justin.


On Thu, 23 Dec 2010, Emmanuel Florac wrote:

> Le Thu, 23 Dec 2010 14:07:13 -0500 (EST) vous =E9criviez:
>
>> Main wonder I have is why when the partition is aligned to 1MiB,
>> which is the default in parted 2.2+ I believe, is it slower than with
>> no partitions?
>
> 1MiB possibly can't round well on the stripe boundaries. I suppose you
> could get better results with 64KB or 16KB stripes. Did you try with an
> LVM in between?
>
> --=20
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                    |   Intellique
>                    |=09<eflorac@intellique.com>
>                    |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
>
--655872-1092608683-1293141898=:17269
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--655872-1092608683-1293141898=:17269--
