Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9QCwvZR073619 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 07:58:57 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7D0D1E85BA6
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 06:00:12 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id gVdbigXH5DlDjPv9 for
	<xfs@oss.sgi.com>; Tue, 26 Oct 2010 06:00:12 -0700 (PDT)
Date: Tue, 26 Oct 2010 15:00:12 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
Message-ID: <20101026150012.07b43f4c@harpe.intellique.com>
In-Reply-To: <4CC6C4E8.6010409@profihost.ag>
References: <4CC67450.9020602@profihost.ag>
	<20101026092205.086c0d89@galadriel.home>
	<4CC68249.7050409@profihost.ag>
	<20101026094111.48670eb7@galadriel.home>
	<4CC688FE.7010206@profihost.ag>
	<20101026130103.7cc43aec@harpe.intellique.com>
	<4CC6B56B.7020007@profihost.ag>
	<20101026132505.6af29d5d@harpe.intellique.com>
	<4CC6C4E8.6010409@profihost.ag>
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
Cc: xfs@oss.sgi.com

Le Tue, 26 Oct 2010 14:09:12 +0200
Stefan Priebe - Profihost AG <s.priebe@profihost.ag> =E9crivait:

>  > echo "noop">  /sys/block/sdc/queue/scheduler
>  > echo 512>  /sys/block/sdc/queue/nr_requests  =

> =

> Is there a way to make this static to this disk?
> [snip]
>  > blockdev --setra 4096 /dev/sdc  =

> Is there also a way to make this static?

The easiest way is to add these commands to /etc/rc.local.

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
