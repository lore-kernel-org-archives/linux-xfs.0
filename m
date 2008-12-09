Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB97rnOq006242
	for <linux-xfs@oss.sgi.com>; Tue, 9 Dec 2008 01:53:49 -0600
Received: from smtp5-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7085024CE
	for <linux-xfs@oss.sgi.com>; Mon,  8 Dec 2008 23:53:47 -0800 (PST)
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35]) by
	cuda.sgi.com with ESMTP id IvVHahTvCg3pkMJs for
	<linux-xfs@oss.sgi.com>; Mon, 08 Dec 2008 23:53:47 -0800 (PST)
Date: Tue, 9 Dec 2008 08:53:28 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS over SSD
Message-ID: <20081209085328.001d483d@galadriel.home>
In-Reply-To: <5d96567b0812080442r131d9fc8t4019c99ffbffa290@mail.gmail.com>
References: <5d96567b0812080442r131d9fc8t4019c99ffbffa290@mail.gmail.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com

Le Mon, 8 Dec 2008 14:42:34 +0200 vous =E9criviez:

> I am thinking of using XFS over a SSD disk.
> 1. Can I separate xfs meta data ( not just the logging) from the SSD ?
> can I put the meta on a different disk ?
> 2. When does a file's meta ( its block maps ) is being flushed to disk
> ? can I control it ?

I've made some testing on a bunch of MTRON SSDs. Actually, the best bet
is to use one SSD to store the XFS log for an array of SATA or SAS
drives, that's the highest performance gain ; it offers tremendous IO
performance.


-- =

--------------------------------------------------
Emmanuel Florac               www.intellique.com   =

--------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
