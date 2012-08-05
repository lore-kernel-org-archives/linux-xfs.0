Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q75DnPH2217390 for <xfs@oss.sgi.com>; Sun, 5 Aug 2012 08:49:25 -0500
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 1HsLd443iQo2QHWu for
	<xfs@oss.sgi.com>; Sun, 05 Aug 2012 06:49:23 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfs_growfs / planned resize / performance impact
Date: Sun, 5 Aug 2012 15:49:22 +0200
References: <5017E426.2040709@profihost.ag>
	<201208051303.09337.Martin@lichtvoll.de>
	<501E6872.6000503@hardwarefreak.com>
	(sfid-20120805_153826_573731_00E594B5)
In-Reply-To: <501E6872.6000503@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201208051549.22830.Martin@lichtvoll.de>
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
To: stan@hardwarefreak.com
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Am Sonntag, 5. August 2012 schrieb Stan Hoeppner:
> On 8/5/2012 6:03 AM, Martin Steigerwald wrote:
> > Well the default was 16 AGs for volumes < 2 TiB AFAIR. And it has
> > been reduced to 4 for as I remember exactly performance reasons. Too
> > many AGs on a single device can incur too much parallelity. Thats at
> > least is what I have understood back then.
> =

> For striped md/RAID or LVM volumes mkfs.xfs will create 16 AGs by
> default because it reads the configuration and finds a striped volume.
> The theory here is that more AGs offers better performance in the
> average case on a striped volume.
> =

> With hardware RAID or a single drive, or any storage configuration for
> which mkfs.xfs is unable to query the parameters, mkfs.xfs creates 4
> AGs by default.  The 4 AG default has been with us for a very long
> time.  It was never reduced.

That does not match my memory, but I=B4d have to look it up. Maybe next =

week.

I am pretty sure mkfs.xfs on a single partition on a single harddisk upto =

2 TiB used 16 AGs for quite some time and now uses 4 AGs since quite some =

time already. I think I have noted the exact xfsprogs version where it was =

changed in my training slides.

-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
