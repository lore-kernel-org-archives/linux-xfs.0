Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9PKrMXg163298 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 15:53:22 -0500
Received: from smtp-tls.univ-nantes.fr (smtptls1-loi.cpub.univ-nantes.fr
	[193.52.103.112]) by cuda.sgi.com with ESMTP id
	5ov53dxQxaNmAm4V for <xfs@oss.sgi.com>;
	Thu, 25 Oct 2012 13:55:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTP id 6122D4016EC
	for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 22:55:06 +0200 (CEST)
Received: from smtp-tls.univ-nantes.fr ([127.0.0.1])
	by localhost (smtptls1-loi.cpub.univ-nantes.fr [127.0.0.1])
	(amavisd-new, port 10024)
	with LMTP id xITnfNJ+veKZ for <xfs@oss.sgi.com>;
	Thu, 25 Oct 2012 22:55:06 +0200 (CEST)
Received: from [IPv6:2001:660:7220:0:ad47:bf7c:e044:a015] (unknown
	[IPv6:2001:660:7220:0:ad47:bf7c:e044:a015])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTPSA id 3FC084016E0
	for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 22:55:06 +0200 (CEST)
Message-ID: <5089A729.8030207@univ-nantes.fr>
Date: Thu, 25 Oct 2012 22:55:05 +0200
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: Problems with kernel 3.6.x (vm ?) (was : Is kernel 3.6.1 or
	filestreams option toxic ?)
References: <508554AF.5050005@univ-nantes.fr> <50865453.5080708@univ-nantes.fr>
	<508958FF.4000007@univ-nantes.fr>
In-Reply-To: <508958FF.4000007@univ-nantes.fr>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Le 25/10/2012 17:21, Yann Dupont a =E9crit :
> Hello.
> There is definitively something wrong in 3.6.xx with XFS, in =

> particular after an abrupt stop of the machine :
>
> I now have corruption on a 3rd machine (not involved with ceph).
> The machine was just rebooting from 3.6.2 kernel to 3.6.3 kernel.
>
> This machine isn't under heavy load, but it's a machine we use for =

> tests & compilations. We often crash it. For 2 years, we didn't have =

> problems. XFS always was reliable, even in hard conditions (hard =

> reset, loss of power, etc)
>
> This time, after 3.6.3 boot, one of my xfs volume refuse to mount :
>
> mount: /dev/mapper/LocalDisk-debug--git: can't read superblock
>
> 276596.189363] XFS (dm-1): Mounting Filesystem
> [276596.270614] XFS (dm-1): Starting recovery (logdev: internal)
> [276596.711295] XFS (dm-1): xlog_recover_process_data: bad clientid 0x0
> [276596.711329] XFS (dm-1): log mount/recovery failed: error 5
> [276596.711516] XFS (dm-1): log mount failed
>

Just found something interesting :

I was rebooting with 3.4.15 to make a backup of this volume. As I said =

in previous message, I didn't did xfs_repair on it.
Before reboot, I forgot to edit fstab to prevent the mount.
To my surprise, under 3.4.15 the volume mounts like a charm !!!

[   37.958374] XFS (dm-1): Mounting Filesystem
[   38.050374] XFS (dm-1): Starting recovery (logdev: internal)
[   69.596892] XFS (dm-1): Ending recovery (logdev: internal)

As far as I can say, there is no corruption, no problems, all my files =

are here !!!

So far here is the scenario :

You have to hard reset your machine with 3.6 (maybe kernel version isn't =

important here). As I encoutered others 3.6 Bugs (exit_mm and =

rwsem_down_failed_common) , I had to do that.

So XFS is not clean.

2) boot with 3.6.xx
Mounting volume fails, bacause log replay fails for an unkwown reason

3) You think your FS is broken, so you start an xfs_repair, which is =

somehow fooled and definitively broke your filesystem

I hope it's reproductible. Will try tomorrow morning.

Cheers,

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
