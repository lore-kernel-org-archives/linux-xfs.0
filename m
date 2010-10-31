Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9VE8mJ7127186 for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 09:08:48 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57EB91379459
	for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 07:26:07 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id bnce4Z0MYR6Gzq2B for
	<xfs@oss.sgi.com>; Sun, 31 Oct 2010 07:26:07 -0700 (PDT)
Date: Sun, 31 Oct 2010 15:10:00 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_repair of critical volume
Message-ID: <20101031151000.70dcd6b9@galadriel.home>
In-Reply-To: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
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
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com

Le Sun, 31 Oct 2010 00:54:13 -0700 vous =E9criviez:

> I have a large XFS filesystem (60 TB) that is composed of 5 hardware
> RAID 6 volumes. One of those volumes had several drives fail in a
> very short time and we lost that volume.

You may still have a slight chance to repair the broken RAID volume.
What is the type and model of RAID controller? What is the model of the
drives? Did you aggregate the RAID arrays with LVM?


Most drives failures (particularly on late 2009 Seagate SATA drives) are
both relatively frequent and transitory, i. e. may randomly recover
after a while.

What did you try? Can you power down the faulty RAID array
entirely and power it up after a while? Did you try to actually freeze
the failed drives (it may revive them for a while)? Did you try to run
SpinRite or another utility on the broken drives, individually ?

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
