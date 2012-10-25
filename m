Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9PFJrhw127810 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 10:19:53 -0500
Received: from smtp-tls.univ-nantes.fr (smtptls1-loi.cpub.univ-nantes.fr
	[193.52.103.112]) by cuda.sgi.com with ESMTP id
	9yymqAqXl2Quu4GM for <xfs@oss.sgi.com>;
	Thu, 25 Oct 2012 08:21:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTP id 16338401714
	for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 17:21:36 +0200 (CEST)
Received: from smtp-tls.univ-nantes.fr ([127.0.0.1])
	by localhost (smtptls1-loi.cpub.univ-nantes.fr [127.0.0.1])
	(amavisd-new, port 10024)
	with LMTP id CW8ScdqtB5qA for <xfs@oss.sgi.com>;
	Thu, 25 Oct 2012 17:21:36 +0200 (CEST)
Received: from [IPv6:2001:660:7220:0:ad47:bf7c:e044:a015] (unknown
	[IPv6:2001:660:7220:0:ad47:bf7c:e044:a015])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTPSA id E91394016E0
	for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 17:21:35 +0200 (CEST)
Message-ID: <508958FF.4000007@univ-nantes.fr>
Date: Thu, 25 Oct 2012 17:21:35 +0200
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: Problems with kernel 3.6.x (vm ?) (was : Is kernel 3.6.1 or
	filestreams option toxic ?)
References: <508554AF.5050005@univ-nantes.fr> <50865453.5080708@univ-nantes.fr>
In-Reply-To: <50865453.5080708@univ-nantes.fr>
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

Le 23/10/2012 10:24, Yann Dupont a =E9crit :
> Le 22/10/2012 16:14, Yann Dupont a =E9crit :
>
> Hello. This mail is a follow up of a message on XFS mailing list. I =

> had hang with 3.6.1, and then , damage on XFS filesystem.
>
> 3.6.1 is not alone. Tried 3.6.2, and had another hang with quite a =

> different trace this time , so not really sure the 2 problems are =

> related .
> Anyway the problem is maybe not XFS, but is just a consequence of what =

> seems more like kernel problems.
>
> cc: to linux-kernel
Hello.
There is definitively something wrong in 3.6.xx with XFS, in particular =

after an abrupt stop of the machine :

I now have corruption on a 3rd machine (not involved with ceph).
The machine was just rebooting from 3.6.2 kernel to 3.6.3 kernel.

This machine isn't under heavy load, but it's a machine we use for tests =

& compilations. We often crash it. For 2 years, we didn't have problems. =

XFS always was reliable, even in hard conditions (hard reset, loss of =

power, etc)

This time, after 3.6.3 boot, one of my xfs volume refuse to mount :

mount: /dev/mapper/LocalDisk-debug--git: can't read superblock

276596.189363] XFS (dm-1): Mounting Filesystem
[276596.270614] XFS (dm-1): Starting recovery (logdev: internal)
[276596.711295] XFS (dm-1): xlog_recover_process_data: bad clientid 0x0
[276596.711329] XFS (dm-1): log mount/recovery failed: error 5
[276596.711516] XFS (dm-1): log mount failed

I'm not even sure the reboot was after a crash or just a clean reboot. =

(I'm not the only one to use this machine). I have nothing suspect on my =

remote syslog.

Anyway, it's the 3rd XFS crashed volume in a row with 3.6 kernel. =

Different machines, different contexts. Looks suspicious.

This time the crashed volume was handled by a PERC (mptsas) card. The 2 =

others volumes previously reported were handled by emulex lightpulse =

fibre channel card (lpfc) and this time filestreams option wasn't used.


xfs_repair -n seems to show volume is quite broken :

Phase 1 - find and verify superblock...
Phase 2 - using internal log
         - scan filesystem freespace and inode maps...
block (1,6197-6197) multiply claimed by bno space tree, state - 2
bad magic # 0x7f454c46 in btbno block 3/2320
expected level 0 got 513 in btbno block 3/2320
bad btree nrecs (256, min=3D255, max=3D510) in btbno block 3/2320
invalid start block 16793088 in record 0 of bno btree block 3/2320
invalid start block 0 in record 1 of bno btree block 3/2320
invalid start block 0 in record 2 of bno btree block 3/2320
invalid start block 2282029056 in record 3 of bno btree block 3/2320
invalid start block 0 in record 4 of bno btree block 3/2320
invalid length 218106368 in record 5 of bno btree block 3/2320
invalid start block 1684369509 in record 6 of bno btree block 3/2320
invalid start block 6909556 in record 7 of bno btree block 3/2320
invalid start block 1493202533 in record 8 of bno btree block 3/2320
invalid start block 1768111411 in record 9 of bno btree block 3/2320
invalid start block 761557865 in record 10 of bno btree block 3/2320
invalid start block 842084400 in record 11 of bno btree block 3/2320
...
bad magic # 0x41425442 in btcnt block 2/14832
bad btree nrecs (436, min=3D255, max=3D510) in btcnt block 2/14832
out-of-order cnt btree record 2 (188545 1) block 2/14832
out-of-order cnt btree record 3 (188650 1) block 2/14832
out-of-order cnt btree record 4 (188658 1) block 2/14832
out-of-order cnt btree record 8 (189021 1) block 2/14832
out-of-order cnt btree record 9 (189104 1) block 2/14832
out-of-order cnt btree record 10 (189127 2) block 2/14832
out-of-order cnt btree record 11 (189193 2) block 2/14832
out-of-order cnt btree record 12 (189259 2) block 2/14832
out-of-order cnt btree record 13 (189268 1) block 2/14832
out-of-order cnt btree record 14 (189307 1) block 2/14832
out-of-order cnt btree record 15 (189330 1) block 2/14832
out-of-order cnt btree record 16 (189379 1) block 2/14832
out-of-order cnt btree record 18 (189477 1) block 2/14832


I won't try to repair this volume right now.

This time, volume is small enough to make an image (it's a 100 GB lvm =

volume). I'll try to image it before making anything else.

1st question : I saw there is ext4 corruption reported too with 3.6 =

kernel, but as far as I can see, problem seems to be jbd related, so it =

shouldn't affect xfs ?
2nd question : Am I the only one to see this ?? I saw problems reported =

with 2.6.37, but here, the kernel is 3.6.xx

3rd question : If you suspect the problem may be lying in XFS , what =

should I supply to help debugging the problem ?

Not CC:ing linux kernel list right now, as I'm really not sure where the =

problem is right now.

Cheers,

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
