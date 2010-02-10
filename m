Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1AK3i27075668 for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 14:03:45 -0600
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 104671CBE24F
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 12:04:57 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id UwOJzF23LgCMEmrW for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2010 12:04:57 -0800 (PST)
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 7C3C0D48015
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 21:04:53 +0100 (CET)
Received: from galadriel.home (pla78-1-82-235-234-79.fbx.proxad.net
	[82.235.234.79])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 81CA9D48147
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 21:04:51 +0100 (CET)
Date: Wed, 10 Feb 2010 21:04:48 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: [PATCH] enable inode64 by default when possible
Message-ID: <20100210210448.36f16aba@galadriel.home>
In-Reply-To: <4B7309D7.5090800@sandeen.net>
References: <4B7309D7.5090800@sandeen.net>
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
To: xfs@oss.sgi.com

Le Wed, 10 Feb 2010 13:32:39 -0600 vous =E9criviez:

> As such, this patch changes the default to inode64 whenever
> XFS_BIG_INUMS is set, which in turn depends on either
> CONFIG_LBDAF or 64-bit longs.

But doesn't it cause problems specially for NFS sharing ?

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
