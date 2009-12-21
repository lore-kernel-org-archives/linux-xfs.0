Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBLAmYlb027117 for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 04:48:34 -0600
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42768134DC52
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 02:49:13 -0800 (PST)
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2]) by
	cuda.sgi.com with ESMTP id sRvGnIUMQSS6EqNS for
	<xfs@oss.sgi.com>; Mon, 21 Dec 2009 02:49:13 -0800 (PST)
Date: Mon, 21 Dec 2009 11:48:36 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: please help me
Message-ID: <20091221114836.1554ced4@harpe.intellique.com>
In-Reply-To: <4B2F3CC5.1000507@storageindia.com>
References: <4B2F3CC5.1000507@storageindia.com>
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
To: rajkumar <rajkumar@storageindia.com>
Cc: xfs@oss.sgi.com

Le Mon, 21 Dec 2009 14:45:49 +0530
rajkumar <rajkumar@storageindia.com> =E9crivait:

> i have scientific linux 4.7 server with kernel 2.6.9.-78.ELsmp and =

> installed the xfs rpms for supporting xfs filesystem.Now created  a =

> volume of 300TB plz tell me how to format.please give commands how to =

> format 300TB using xfs filesystem.

Are you running a 64 bits kernel? A 32 bits kernel won't be able to use
a filesystem bigger than 16 TB.

You need to install the xfs-progs too, to have mkfs.xfs.

To format a 300TB xfs, basically just do

mkfs.xfs /dev/whatever

However you'd better configure your filesystem to match the underlying
device. You must be using some sort of RAID array; you should do it
this way:

mkfs.xfs -d su=3D<value>,sw=3D<numberofdataDisks> /dev/whatever

Where <value> is the RAID array stripe size (in bytes, or append a k or
m accordingly) and <sw> the number of data disks (removing parity and
spare drives from the total).

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
