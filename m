Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5IBIaSg221015 for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 06:18:36 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B77313E44B4
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 04:21:12 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id SswQBzOpNLVYzHb1 for
	<xfs@oss.sgi.com>; Fri, 18 Jun 2010 04:21:12 -0700 (PDT)
Date: Fri, 18 Jun 2010 13:21:08 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Help with XFS
Message-ID: <20100618132108.790921cf@harpe.intellique.com>
In-Reply-To: <OF4967B99D.609CC213-ONC1257745.0048E646-C1257745.004919A3@bergenofs.no>
References: <OF4967B99D.609CC213-ONC1257745.0048E646-C1257745.004919A3@bergenofs.no>
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
To: Thomas =?ISO-8859-1?Q?F=F8rde?= <thomas.forde@bergenofs.no>
Cc: xfs@oss.sgi.com

Le Thu, 17 Jun 2010 15:18:26 +0200
Thomas F=F8rde <thomas.forde@bergenofs.no> =E9crivait:

> i have run xfs_check without any verbos information given
> i have run xfs_repair without any information errors fixed.

That's unfortunate that you didn't post here before doing irreparable =

damage. Any activity to the filesystem may delete permanently data, so
you should stop using it completely until done with the rescue
operations and unmount it.

> =

> when i try to mount the XFS filesystem of 10TB, my 7.8 TB of data is
> now gone.
> =

> before:         /dev/sdf1            10527858560 8801101708
> 1726756852 84% /D5
> after:          /dev/sdf1            10527858560       528
> 10527858032 1% /D5
> =


Some old versions of xfs_repair may fail on big FS. You didn't mention
which version you're using, which distribution and which kernel. The
hardware setup may be important, too.

> help, where did my data go, and how can i get it back.

Apparently xfs_repair deleted it because it was corrupt (alas, happen
sometimes with xfs_repair before 2.8). The best thing to do is to get it
back from backups. I suppose that you have no backup (people don't do
any backup until they lose important data, which always occurs).

If you have no backups, your last hope is to use a tool like photorec
to find your data on the raw device; however it won't reconstruct the
metadata (no names, no folders, no hierarchy, no user rights). BTW you
need some other place to store the newly discovered files with at least
as much space (7.8 TB).

My condolences. I once lost 13TB and see, I'm not dead. You'll get over
it somehow.
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
