Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n14CkMoc152320 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 06:46:22 -0600
Received: from smtp6-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A96A7E5D1A
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 04:45:41 -0800 (PST)
Received: from smtp6-g21.free.fr (smtp6-g21.free.fr [212.27.42.6]) by
	cuda.sgi.com with ESMTP id eSaLgmBsAMbBDNR6 for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 04:45:41 -0800 (PST)
Date: Wed, 4 Feb 2009 13:45:38 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_force_shutdown after Raid crash
Message-ID: <20090204134538.24c2b4ac@harpe.intellique.com>
In-Reply-To: <20090204122241.GL24173@disturbed>
References: <498376CF.8020806@renderforce.de> <200902031140.08576@zmi.at>
	<20090203154907.GA21278@infradead.org> <200902040952.45440@zmi.at>
	<20090204122241.GL24173@disturbed>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

Le Wed, 4 Feb 2009 23:22:41 +1100
Dave Chinner <david@fromorbit.com> =E9crivait:

>  Please consult your RAID
> controller documentation to determine how to change these settings."

I have some controllers at hand, and I had a quick glance :

- Adaptec : allows setting individual drives cache
	 arcconf setcache <disk> wb|wt
<disk
- 3ware : no information

- Xyratex : no information

- Areca : Allows setting individual cache for passthru disks, needs
actual testing for drives part of an array.



-- =

----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
