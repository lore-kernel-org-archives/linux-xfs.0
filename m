Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1OEr2l0055478 for <xfs@OSS.SGI.com>; Fri, 24 Feb 2012 08:53:03 -0600
Received: from anakin.london.02.net (anakin.london.02.net [87.194.255.134]) by
	cuda.sgi.com with ESMTP id OzKDxqzVpSHG3sCO for
	<xfs@OSS.SGI.com>; Fri, 24 Feb 2012 06:52:59 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by anakin.london.02.net (8.5.140)
	id 4EEB63D20135AF02 for xfs@OSS.SGI.com;
	Fri, 24 Feb 2012 14:52:57 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1S0wVs-00088l-0R
	for <xfs@OSS.SGI.com>; Fri, 24 Feb 2012 14:52:48 +0000
MIME-Version: 1.0
Message-ID: <20295.42047.874856.157404@tree.ty.sabi.co.UK>
Date: Fri, 24 Feb 2012 14:52:47 +0000
Subject: Re: creating a new 80 TB XFS
In-Reply-To: <4F478818.4050803@cape-horn-eng.com>
References: <4F478818.4050803@cape-horn-eng.com>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

> We are getting now 32 x 3 TB Hitachi SATA HDDs. I plan to
> configure them in a single RAID 6 set with one or two
> hot-standby discs. The raw storage space will then be 28 x 3
> TB = 84 TB.  On this one RAID set I will create only one
> volume.  Any thoughts on this?

Well, many storage experts would be impressed by and support
such an audacious plan...

But I think that wide RAID6 sets and large RAID6 stripes are a
phenomenally bad idea, and large filetrees also strikingly bad,
and the two combined seems to me almost the most terrible setup.
It is also remarkably brave to use 32 identical drives in a RAID
set. But all this is very popular because in the beginning "it
works" and is really cheap.

The proposed setup has only 7% redundancy, RMW issues with large
stripe sizes, and 'fsck' time and space issues with large trees.

Consider this series of blog notes:

  http://www.sabi.co.uk/blog/12-two.html#120218
  http://www.sabi.co.uk/blog/12-two.html#120127
  http://www.sabi.co.uk/blog/1104Apr.html#110401
  http://groups.google.com/group/linux.debian.ports.x86-64/msg/fd2b4d46a4c294b5

> This storage will be used as secondary storage for backups. We
> use dirvish (www.dirvish.org, which uses rsync) to run our
> daily backups.

So it will be lots and lots of metadata (mostly directory)
updates. Not a very good match there. Especially considering
that almost always you will be only writing to it even for data,
and presumably from multiple hosts concurrently. You may benefit
considerably from putting the XFS log on a separate disk, and if
you use Linux MD for RAID the bitmaps on a separate disk.

> *MKFS* We also heavily use ACLs for almost all of our files.

That's a daring choice.

> [ ... ] "-i size=512" on XFS creation, so my mkfs.xfs would look
> something like: mkfs.xfs -i size=512 -d su=stripe_size,sw=28
> -L Backup_2 /dev/sdX1

As a rule I specify a sector size of 4096, and in your case
perhaps an inode size of 2048 might be appropriate to raise the
chance of ACLs and directories fully stored in inode tails,
which seem particularly important in your case. Something like:

  -s size=4096 -b size=4096 -i size=2048,attr=2

> mount -o noatime,nobarrier,nofail,logbufs=8,logbsize=256k,inode64
> /dev/sdX1 /mount_point

'nobarrier' seems rather optimistic unless you are very very
sure there won't be failures.

There are many others details to looks into, from readhead to
flusher frequency.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
