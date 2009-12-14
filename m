Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBEGHsJ3159428
	for <linux-xfs@oss.sgi.com>; Mon, 14 Dec 2009 10:17:55 -0600
Received: from quickstep.mgras.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C617514F76BD
	for <linux-xfs@oss.sgi.com>; Mon, 14 Dec 2009 08:18:29 -0800 (PST)
Received: from quickstep.mgras.net (quickstep.mgras.net [84.245.154.74]) by
	cuda.sgi.com with ESMTP id E7Vi762nCzHWTngW for
	<linux-xfs@oss.sgi.com>; Mon, 14 Dec 2009 08:18:29 -0800 (PST)
Received: from osprey.mgras.de (osprey.mgras.de [192.168.48.3])
	by quickstep.mgras.net (8.13.1/8.13.0) with ESMTP id nBEGHSBq010103
	for <linux-xfs@oss.sgi.com>; Mon, 14 Dec 2009 17:17:29 +0100 (CET)
Received: (from news@localhost) by osprey.mgras.de (AIX5.1/8.11.6p2/8.11.0) id
	nBEGHSq24832 for linux-xfs@oss.sgi.com;
	Mon, 14 Dec 2009 17:17:28 +0100
From: Martin Spott <Martin.Spott@mgras.net>
Subject: Re: XFS and DPX files
Date: Mon, 14 Dec 2009 16:17:28 +0000 (UTC)
Message-ID: <hg5oeo$bh2$1@osprey.mgras.de>
References: <4AEC2CF4.8040703@aol.com> <200911021205.28006@zmi.at>
	<200911022258.35164@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Michael Monnerie wrote:

> Don't mix up the controller write cache vs. disk write cache. The 
> controller write cache should be on whenever you have a BBM installed, 
> because this brings real performance, while the disk write cache should 
> always be off in a production environment, because you will loose data 
> on power fail, which nobody can recognize (the controller believes the 
> sectors to be written already...)

I've been under the impression that "modern disks" (TM), at minimum the
server-type products, are supposed to re-use the remaining spin-energy
for generating the required power and thus writing the content of their
on-disk write cache to the disks.

Cheers,
	Martin.
-- 
 Unix _IS_ user friendly - it's just selective about who its friends are !
--------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
