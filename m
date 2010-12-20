Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBKB2WJO111840 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 05:02:33 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBA491CDF13E
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 03:04:27 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id uBAzjKcNzGOpPURW for
	<xfs@oss.sgi.com>; Mon, 20 Dec 2010 03:04:27 -0800 (PST)
Date: Mon, 20 Dec 2010 12:04:17 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Question regarding xfs_repair / memory requirement.
Message-ID: <20101220120417.1a0df133@galadriel.home>
In-Reply-To: <alpine.DEB.2.00.1012200519230.26485@p34.internal.lan>
References: <alpine.DEB.2.00.1012200519230.26485@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Le Mon, 20 Dec 2010 05:20:18 -0500 (EST) vous =E9criviez:

> I am looking at FS to use for a possible 43TB array.
> If there is a problem with a volume this large, how much ram will =

> xfs_repair need to fsck the volume?
> =


Nothing special, I have tens of such filesystems. With a < 3.0 xfs_progs
you should be able to run xfs_repair with 8 GB of RAM. With newer
versions the memory requirement are even lower.

I often needed at times to run older xfs_repair on big filesystems with
only 1 GB of RAM, and using lots of swap (3, 4 GB or more) did the
trick, though of course it was slow as a caterpillar swimming in
molasses.

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
