Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MJMkUg079887 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 14:22:47 -0500
Received: from pirx.askja.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E908B92EA7
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 12:23:40 -0700 (PDT)
Received: from pirx.askja.de (pirx.askja.de [83.137.103.148]) by cuda.sgi.com
	with ESMTP id mCaht5BrLH6ZpCUm for <xfs@oss.sgi.com>;
	Wed, 22 Sep 2010 12:23:40 -0700 (PDT)
Date: Wed, 22 Sep 2010 21:23:28 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: XFS internal error xfs_da_do_buf(2)
Message-ID: <20100922192328.GC23326@pirx.askja.de>
References: <20100922072653.GA23326@pirx.askja.de>
	<20100922103134.4e652651@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100922103134.4e652651@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Emmanuel Florac schrieb:
> Le Wed, 22 Sep 2010 09:26:53 +0200 vous =E9criviez:
> =

> > Infortrend RAID with BBU -> DRBD -> LVM -> XFS
> =

> I'm not sure to understand; DRBD is used to mirror devices, are you
> using 2 Infortrend arrays, or one split into two volumes? =


yes, 2 drbd/heartbeat nodes, 2 Infortrend systems

 =

> In any case, battery protected write cache shouldn't create any
> corruption (OTOH it will enhance performance dramatically). AFAIK all
> RAID arrays mirror the drives cache in the array cache until it hits
> platters. There may be some "cheating" hard drives (I heard that WD
> isn't always totally clear about cache policies) but Seagate and Hitachi
> professional grade drives definitely are OK. Hint: don't use desktop
> hard drives in any case because they probably cheat about cache
> synchronisation.

The drives are 15000 RPM SAS drives, so no desktops drives. As far as
I understand the documentation, when the "Delayed Drive Write" RAID
option is enabled, there is the possibility of data loss.
 =

> I see that you may have been running rsync at the time of failure; there
> are quite a lot of quite unclear (to me at least) cases of XFS failures
> when running rsync to copy large amount of data. I it a fully 64 bits
> system?

There were many more lines with this error in the logs. Triggered by
smbd, rsync, bacula...

Ralf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
