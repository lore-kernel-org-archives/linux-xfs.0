Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ8v0at029406 for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 02:57:00 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B3CD160345A
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 00:56:59 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id mQfUeC2KyptTIjED for
	<xfs@oss.sgi.com>; Wed, 26 Nov 2008 00:56:59 -0800 (PST)
Received: from shambala.of.teamix.net (blackhole.teamix.net [194.150.191.251])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 0E23B5AE36
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 09:51:59 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Badness in key lookup (length)
Date: Wed, 26 Nov 2008 09:51:58 +0100
References: <200811252302.55944.Martin@Lichtvoll.de> <492C9D65.2080302@sgi.com>
	(sfid-20081126_093700_023988_A1E7DD35)
In-Reply-To: <492C9D65.2080302@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811260951.58472.Martin@lichtvoll.de>
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

Am Mittwoch 26 November 2008 schrieb Timothy Shimmin:
> Martin Steigerwald wrote:
> > Hi!
> >
> > I also checked my / XFS filesystem after that failed attempt to
> > hibernate via TuxOnIce (see my mail "truncated files"). Well BTW this
> > happened on a ThinkPad T42.
> >
> > While /home was fine, / had some rather minor - it seems - issues.
> > Whether they have been from today or from whenever - I do not know.
> >
> > xfs_check had stuff like
> >
> > agi unlinked bucket 0 is 8620800 in ag 0 (inode=8620800)
> > agi unlinked bucket 1 is 1181377 in ag 0 (inode=1181377)
> > agi unlinked bucket 2 is 8628866 in ag 0 (inode=8628866)
> > agi unlinked bucket 3 is 8620611 in ag 0 (inode=8620611)
> > agi unlinked bucket 4 is 1181380 in ag 0 (inode=1181380)
> > agi unlinked bucket 5 is 7711173 in ag 0 (inode=7711173)
> > agi unlinked bucket 6 is 7711174 in ag 0 (inode=7711174)
> > [...]
> > allocated inode 207025 has 0 link count
> > allocated inode 207029 has 0 link count
> > allocated inode 207118 has 0 link count
> > allocated inode 7711173 has 0 link count
> > allocated inode 7711174 has 0 link count
> > allocated inode 7711197 has 0 link count
> >
> > Which are due to references to deleted files AFAIK.
>
> Yep, inodes which were unlinked but still had references to them
> when the filesystem was taken down without cleanly unmounting.
> There is a hash table of buckets which point to linked lists of
> unlinked inodes. These are then supposed to be cleaned up during the
> log-replay stage on mount.
> I presume (sorry for asking but just checking :-) that you mounted the
> filesystem first - you would have gotten an error message if there was
> a dirty log anyway. And if you didn't mount first, did you get the
> error message? Just curious.

I did mount first ;-). I know its better to avoid xfs_repair -L ;-)

Indeed it was not unmounted cleanly:

Nov 25 13:16:39 shambhala kernel: XFS mounting filesystem sda5
Nov 25 13:16:39 shambhala kernel: Starting XFS recovery on filesystem: 
sda5 (logdev: internal)
Nov 25 13:16:39 shambhala kernel: Ending XFS recovery on filesystem: sda5 
(logdev: internal)

I wonder about those "Badness in key lookup (length)" messages of 
xfs_repair 2.9.8 touch.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
