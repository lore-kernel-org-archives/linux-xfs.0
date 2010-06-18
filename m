Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5ICjHfR224358 for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 07:45:18 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFB5814FD752
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 05:47:55 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id 2OUJA94jgudBfvE5 for
	<xfs@oss.sgi.com>; Fri, 18 Jun 2010 05:47:55 -0700 (PDT)
Subject: Re: Help with XFS
From: Andi Kleen <andi@firstfloor.org>
References: <OF4967B99D.609CC213-ONC1257745.0048E646-C1257745.004919A3@bergenofs.no>
	<20100618132108.790921cf@harpe.intellique.com>
	<OF450B8187.BD5256B0-ONC1257746.003E79FF-C1257746.003EE62C@bergenofs.no>
	<20100618133458.6640ce96@harpe.intellique.com>
	<OF0E234D8E.F048FF4D-ONC1257746.003FC10E-C1257746.00407333@bergenofs.no>
Date: Fri, 18 Jun 2010 14:47:52 +0200
In-Reply-To: <OF0E234D8E.F048FF4D-ONC1257746.003FC10E-C1257746.00407333@bergenofs.no>
	("Thomas =?iso-8859-1?Q?F=F8rde=22's?= message of "Fri\, 18 Jun 2010
	13\:43\:57 +0200")
Message-ID: <87iq5gv75z.fsf@basil.nowhere.org>
MIME-Version: 1.0
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
To: Thomas =?iso-8859-1?Q?F=F8rde?= <thomas.forde@bergenofs.no>
Cc: xfs@oss.sgi.com

Thomas F=F8rde <thomas.forde@bergenofs.no> writes:

> the raid array is a FC SAN array consisting of DS4700 unit with EXP810
> expansion system
>
> xfs_check first, xfs_repair -n, and xfs_repair
>
> xfs_Repair -L has not been used.
>
> its seismisc processed data, large text files.

I've seen people get text files (source files) back with strings
/dev/...

If you're lucky it's mostly continous and large =

and not too hard to sort out.

But definitely backups are a good idea next time. RAID is no replacement
for backups.

-Andi

-- =

ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
