Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9RA5F5s156380 for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 05:05:15 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7AFB1363F28
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 03:22:08 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id WyYaK8zqq2RQmOUg for
	<xfs@oss.sgi.com>; Wed, 27 Oct 2010 03:22:08 -0700 (PDT)
Date: Wed, 27 Oct 2010 12:06:28 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
Message-ID: <20101027120628.7b4b2e20@harpe.intellique.com>
In-Reply-To: <4CC7CDF6.3080405@profihost.ag>
References: <4CC67450.9020602@profihost.ag> <4CC6B56B.7020007@profihost.ag>
	<20101026132505.6af29d5d@harpe.intellique.com>
	<201010270124.44846@zmi.at>
	<20101027080454.31a59a3c@galadriel.home>
	<4CC7CDF6.3080405@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

Le Wed, 27 Oct 2010 09:00:06 +0200
Stefan Priebe - Profihost AG <s.priebe@profihost.ag> =E9crivait:

> So what values do you recommand in general for iSCSI on Serverside
> and which values on iSCSI client side?
> =


Depends upon the hardware. nr_requests should be 512 for 3Ware cards,
256 to 1024 for other controllers (always more than the default 128
anyway). =


Same rule goes for read-ahead; however many RAID controllers (Areca,
Adaptec) "cheat" and do read-ahead optimisation by themselves (which
may harm random access). The default read-ahead value (256) was OK for
obsolete ATA drives with a few KB of cache; nowadays all drives have 32
or 64 MB, and controllers 512 MB to several GB, so more read-ahead can
do no harm but fill the cache up. I often go up to 65536 or 131072
sectors (for 24 or 48 drives arrays). Keep in mind that this is
sequentail-raid optimisation; random access (such as VM work) may give
better result with lower read-ahead values. Benchmarking your
application is king here.

Just for information : I currently run some servers with kernel
2.6.22.18 (march 2008) and 3Ware firmware 4.10.0.7, so upgrading your
2.6.23 system should be perfectly safe from a driver compatibility
point of view.

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
