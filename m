Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5IBWNK3221535 for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 06:32:23 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E6E514A69F5
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 04:38:48 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id W0yrAExCewCRX7AG for
	<xfs@oss.sgi.com>; Fri, 18 Jun 2010 04:38:48 -0700 (PDT)
Date: Fri, 18 Jun 2010 13:34:58 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Help with XFS
Message-ID: <20100618133458.6640ce96@harpe.intellique.com>
In-Reply-To: <OF450B8187.BD5256B0-ONC1257746.003E79FF-C1257746.003EE62C@bergenofs.no>
References: <OF4967B99D.609CC213-ONC1257745.0048E646-C1257745.004919A3@bergenofs.no>
	<20100618132108.790921cf@harpe.intellique.com>
	<OF450B8187.BD5256B0-ONC1257746.003E79FF-C1257746.003EE62C@bergenofs.no>
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

Le Fri, 18 Jun 2010 13:27:01 +0200
Thomas F=F8rde <thomas.forde@bergenofs.no> =E9crivait:

> both the xfs_check and xfs_Reapir was done from a unmounted system,
> the system has not been mounted or used since.

That's good. Did you run xfs_repair -n first ? Did you run =

xfs_repair -L afterwards?

> its a IBM x3650 with stadnard 2x73GB disk.

But what about the RAID array? =

 =

> [root@strmng04 ~]# cat /etc/issue
> CentOS release 4.7 (Final)
> Kernel \r on an \m
> =

> [root@strmng04 ~]# uname -a
> Linux strmng04 2.6.9-78.0.5.ELsmp #1 SMP Wed Oct 8 07:06:30 EDT 2008 =

> x86_64 x86_64 x86_64 GNU/Linux
> =

> =

> there is no backup no, as how to backup 8 TB of data,very expensive
> tape wise.

You could have a disk backup on cheaper drives. And current tapes are
800 GB (LTO-3) or 1.5 TB (LTO-4), and libraries are cheaper nowadays.

> xfs_irecover ias been mentioned to me, so my fingers are crossed.
> =


If your data is a huge bunch of media files or similar, photorec really
can help you as a very last resort, though you'll have to manually sort
through all this data...

good luck,
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
