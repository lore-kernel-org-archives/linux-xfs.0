Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNHXj9V211749 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:33:45 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2DCBC21C20E
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 09:35:42 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id 9qkFuW82ULyZEujP for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 09:35:42 -0800 (PST)
Date: Thu, 23 Dec 2010 18:35:31 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: able to mount a fs, unable to repair it
Message-ID: <20101223183531.19464601@galadriel.home>
In-Reply-To: <87r5d9uuez.fsf@ezri.u-picardie.fr>
References: <87r5d9uuez.fsf@ezri.u-picardie.fr>
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
To: laurent+xfs@u-picardie.fr
Cc: xfs@oss.sgi.com

Le Thu, 23 Dec 2010 02:53:08 +0100 vous =E9criviez:

> For a reason all my xfs FS got corrupted at the same time.
> My setup is: xen host using lvm on top of soft raid6 on top of jbod
> 3ware connected sata disks.
> Both the host and the VM fs got corrupted.

RAID-6 is extremely stable on the 3Ware, while software RAID-6 is
dubbed experimental in the kernel. Software RAID can provide seducely
high performance when running benchmarks, but IMO it doesn't fly when
you need your CPU to do some other jobs, like running NFS daemons or
even worse, VMs. Under high CPU loads concurrently coming from the
software RAID and virtualisation stack, so many things may go wrong...

My advice : software RAID stinks under high CPU load/ high IO. Use
hardware RAID whenever possible because it provides more predictable
performance and remove many weird software interactions from the
picture.

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
