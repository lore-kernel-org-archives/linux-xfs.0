Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBEIXe3A011464 for <xfs@oss.sgi.com>; Sun, 14 Dec 2008 12:33:40 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 236C31DF86
	for <xfs@oss.sgi.com>; Sun, 14 Dec 2008 10:33:38 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id DWE2DWsuDJegKMVk for
	<xfs@oss.sgi.com>; Sun, 14 Dec 2008 10:33:38 -0800 (PST)
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Content-Disposition: inline
From: Martin Steigerwald <Martin@lichtvoll.de>
Date: Sun, 14 Dec 2008 19:33:36 +0100
MIME-Version: 1.0
Message-Id: <200812141933.37398.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com
Cc: Linux RAID <linux-raid@vger.kernel.org>

Am Sonntag 14 Dezember 2008 schrieben Sie:
> Am Sonntag 14 Dezember 2008 schrieb Peter Grandi:

> > But talking about barriers in the context of metadata, and for a
> > "benchmark" which has a metadata barrier every 11KB, and without
> > knowing whether the storage subsystem can queue multiple barrier
> > operations seems to be pretty crass and meangingless, if not
> > misleading. A waste of time at best.
>
> Hmmm, as far as I understood it would be that the IO scheduler would
> handle barrier requests itself if the device was not capable for
> queuing and ordering requests.
>
> Only thing that occurs to me know, that with barriers off it has more
> freedom to order requests and that might matter for that metadata
> intensive workload. With barriers it can only order 11 KB of requests.
> Without it could order as much as it wants... but even then the
> filesystem would have to make sure that metadata changes land in the
> journal first and then in-place. And this would involve a sync, if no
> barrier request was possible.

No it hasn't. As I do not think XFS or any other filesystem would be keen 
to see the IO scheduler reorder a journal write after a corresponding 
meta data in-place write. So either the filesystem uses sync...

> So I still don't get why even that metadata intense workload of tar -xf
> linux-2.6.27.tar.bz2 - or may better bzip2 -d the tar before - should
> be slower with barriers + write cache on than with no barriers and
> write cache off.

... or it tells the scheduler that this journal write should come prior to 
the later writes. This is what a barrier would do - except for that it 
cannot utilize any additional in-hardware /  in-firmware support.

So why on earth can write cache off +  barrier off be faster than write 
cache on + barrier on in *any workload*? There must be some technical 
detail that I miss.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
