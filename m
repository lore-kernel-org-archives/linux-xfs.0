Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BGhxAW140971 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 10:43:59 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D1C8191A6CD
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 08:43:23 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id Kvd7IN3sl7klEITg for
	<xfs@oss.sgi.com>; Wed, 11 Feb 2009 08:43:23 -0800 (PST)
Date: Wed, 11 Feb 2009 11:42:51 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: sunit & swidth on RAID-1?
In-Reply-To: <20090211155638.GA3864@dentifrice>
Message-ID: <alpine.DEB.1.10.0902111141560.18885@p34.internal.lan>
References: <20090211155638.GA3864@dentifrice>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463747160-891558874-1234370571=:18885"
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
To: mike dentifrice <fluor@poivron.org>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-891558874-1234370571=:18885
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 11 Feb 2009, mike dentifrice wrote:

> Hello,
>
> I would like to know if it makes any sense to specify sunit & swidth
> parameters as mount options to XFS filesystems sitting on a Linux
> software RAID-1 array, as advertised here [1] or there [2].
>
> I'm asking, because it seems that chunk_size does not matter in a RAID-1
> context, nor do stripe units; or do they?
>
> Any tip would be appreciated,
>
> [1]=C2=A0http://www.socalsysadmin.com/2008/10/15/optimizing-xfs-on-raid-a=
rrays/
> [2] http://feedblog.org/2008/06/18/howto-configure-raid-strides-in-xfs/
>
> --=20
> mike dentifrice <fluor@poivron.org>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

mkfs.xfs will auto-optimize for software-raid arrays for the most part,=20
with HW raid on a 3ware controller, tweaking mkfs.xfs does not help very=20
much.  with SW raid, at least for raid1 - I use the defaults.

Justin.
---1463747160-891558874-1234370571=:18885
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463747160-891558874-1234370571=:18885--
