Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q478LHqV239886 for <xfs@oss.sgi.com>; Mon, 7 May 2012 03:21:17 -0500
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id x0eXGNTyGBZEiAtu for
	<xfs@oss.sgi.com>; Mon, 07 May 2012 01:21:15 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: suddenly slow writes on XFS Filesystem
Date: Mon, 7 May 2012 10:21:14 +0200
References: <4FA63DDA.9070707@profihost.ag> <20120507013456.GW5091@dastard>
	<4FA76E11.1070708@profihost.ag>
	(sfid-20120507_095413_656560_122EB192)
In-Reply-To: <4FA76E11.1070708@profihost.ag>
MIME-Version: 1.0
Message-Id: <201205071021.14478.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: xfs@oss.sgi.com
Cc: stan@hardwarefreak.com, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

Am Montag, 7. Mai 2012 schrieb Stefan Priebe - Profihost AG:
> Hi,
> 
> after deleting 400GB it was faster. Now there are still 300GB free but
> it is slow as hell again ;-(

Well, before you had 200 GB free, now you have 300 GB free. Thats not that 
much more. You have 5 AGs, so if distributed evenly it would be 40 to 60 
GB free space per AG.

The 10% Dave recommended of 4,6 TB would be 460 GB.

Are other volumes of similar size are similarily full but faster?

Would be interesting to see whether you are able to sustain faster speeds 
by keeping the volume above 500 GB free or so.

> >> It is a raid 10 of 20 SATA Disks and i can only write to them with
> >> about 700kb/s while doing random i/o.
> > 
> > What sort of random IO? size, read, write, direct or buffered, data
> > or metadata, etc?
> 
> There are 4 rsync processes running and doing backups of other severs.

Which rsync version is involved? I strongly suggest to use rsync version 3 
or above.

> > Your filesystem is near full - the allocation algorithms definitely
> > slow down as you approach ENOSPC, and IO efficiency goes to hell
> > because of a lack of contiguous free space to allocate from.
> 
> I've now 94% used but it is still slow. It seems it was just getting
> fast with more than 450GB free space.
> 
> /dev/sdb1             4,6T  4,3T  310G  94% /mnt

Then: Will it stay fast if you keep it above 450 GB free space?

And is it as fast then as it used to be before you faced performance 
issues?

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
