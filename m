Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN0QWnX055537 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 18:26:32 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83B56219A1B
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 16:28:30 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id bijORHcX1h5Jc8jF for
	<xfs@oss.sgi.com>; Wed, 22 Dec 2010 16:28:30 -0800 (PST)
Date: Wed, 22 Dec 2010 19:28:29 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
In-Reply-To: <20101223012655.2681c596@galadriel.home>
Message-ID: <alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222175611.1c7d5190@harpe.intellique.com>
	<4D124B71.9030401@sandeen.net>
	<20101223012655.2681c596@galadriel.home>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-2018785734-1293064109=:7452"
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-2018785734-1293064109=:7452
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 23 Dec 2010, Emmanuel Florac wrote:

> Le Wed, 22 Dec 2010 13:03:13 -0600 vous =E9criviez:
>
>> http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_fo=
r_.3Csomething.3E
>>
>> which mentions getting your geometry right if it's hardware raid
>> that can't be detected automatically.
>
> Just as a side note : I tried several times to manually set the
> filesystem layout to precisely match the underlying hardware RAID
> with sunit and swidth but didn't find that it made a noticeable
> difference. On my 39.9 TB systems, the default agcount is 39, while the
> optimum would be (theorically at least)  42.
>
> --=20
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                    |   Intellique
>                    |=09<eflorac@intellique.com>
>                    |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
>

Hi, I concur, for hardware raid (at least on 3ware cards) I have found it=
=20
makes no difference, thanks for confirming.

Which RAID cards did you use?

Justin.
--655872-2018785734-1293064109=:7452
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--655872-2018785734-1293064109=:7452--
