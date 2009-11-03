Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA3BJcG0149290 for <xfs@oss.sgi.com>; Tue, 3 Nov 2009 05:19:38 -0600
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF0F7180DDD5
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2009 03:19:24 -0800 (PST)
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2]) by
	cuda.sgi.com with ESMTP id mwa7DFtc5k4EPpTW for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2009 03:19:24 -0800 (PST)
Date: Tue, 3 Nov 2009 12:19:20 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS and DPX files
Message-ID: <20091103121920.7e6b6d07@harpe.intellique.com>
In-Reply-To: <200911022258.35164@zmi.at>
References: <4AEC2CF4.8040703@aol.com> <200911021205.28006@zmi.at>
	<20091102185249.0da8e388@harpe.intellique.com>
	<200911022258.35164@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Le Mon, 2 Nov 2009 22:58:35 +0100
Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:

> Hence my suggestion for turning on the disk write cache just to see
> if it makes a difference.

Unfortunately there isn't any way in the 3Ware controllers to manage
that. Worse, I couldn't get a clear answer from 3Ware support about the
controller policy about drives caches. However from the tests I've done
(pulling the plug on a server while writing) it looks like the 3Ware
uses the disks caches in write-thru mode, however (fortunately now that
many drives come with 32 or 64 MB caches). =


Some other SATA/SAS RAID controllers (Areca, LSI and Adaptec) allows to
activate drive write-back cache separately from the controller cache,
though.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Intellique
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
