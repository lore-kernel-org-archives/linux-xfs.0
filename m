Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA698sDB200042 for <xfs@oss.sgi.com>; Fri, 6 Nov 2009 03:08:54 -0600
Received: from mail.in-medias-res.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B937566FD4
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2009 01:09:09 -0800 (PST)
Received: from mail.in-medias-res.com (mail.in-medias-res.com [78.47.10.114])
	by cuda.sgi.com with ESMTP id 0PGEKOXcfznQI9Nm for
	<xfs@oss.sgi.com>; Fri, 06 Nov 2009 01:09:09 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by mail.in-medias-res.com (Postfix) with ESMTP id 471CC2071A1
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2009 10:09:08 +0100 (CET)
Received: from mail.in-medias-res.com ([127.0.0.1])
	by localhost (imr-web.in-medias-res.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id BGUSWpBUc+8u for <xfs@oss.sgi.com>;
	Fri,  6 Nov 2009 10:09:06 +0100 (CET)
Received: from imr-mail.services.in-medias-res.com
	(port-212-202-160-2.static.qsc.de [212.202.160.2])
	by mail.in-medias-res.com (Postfix) with ESMTP id 15C64164148
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2009 10:09:06 +0100 (CET)
Received: from mytux.intra.in-medias-res.com ([192.168.2.128])
	by imr-mail.services.in-medias-res.com with esmtp (Exim 4.69)
	(envelope-from <mill@in-medias-res.com>) id 1N6Koc-0000t1-03
	for xfs@oss.sgi.com; Fri, 06 Nov 2009 10:09:06 +0100
Date: Fri, 6 Nov 2009 10:09:05 +0100
From: mill / in-medias-res <mill@in-medias-res.com>
Subject: Re: xfs_repair breaks; xfs_metadump hangs
Message-ID: <20091106090905.GA4930@mytux.intra.in-medias-res.com>
References: <20091104152022.GA21347@mytux.intra.in-medias-res.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091104152022.GA21347@mytux.intra.in-medias-res.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I forgot to mention, that i actually have an metadump. But it is only written till xfs_db hangs.
It's filesize is 399M, is that enough to work with that?

Best Regards,
Max

* mill / in-medias-res <mill@in-medias-res.com> [091104 16:20]:
> Hello XFS-Community,
> 
> i have some real trouble with restoring/repairing my two XFS Partion's. These
> Partion's are on a RAID-5 Array which "was broken". The first xfs_repair run
> on /dev/sdc1 did restore 80 GB from ca. 300-400 GB. The Problem was that 99,9%
> of the million files are in lost+found.
> 
> Because i was more interested in restoring /dev/sdc2, i did forget about sdc1
> and run xfs_repair on the other Partion:
> 
> cmd: xfs_repair -t 1 -P /dev/sdc2
> [...]
> corrupt inode 3256930831 ((a)extents = 1).  This is a bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.
> cache_node_purge: refcount was 1, not zero (node=0x377d0008)
> fatal error -- couldn't map inode 3256930831, err = 117
> 
> time: 67,27s user 10,09s system 10% cpu 12:05,31 total
> 
> I tried to run xfs_metadump serveral times and it hangs everytime on this position:
> xfs_metadump  -g /dev/sdc2 metadump-sdc2-2
> Copied 1411840 of 4835520 inodes (0 of 3 AGs)
> 
> It runs till 2 days on the same inode and xfs_db consumes 99% of CPU.
> Should i wait here?
> 
> Versions:
> dpkg -l |grep xfs
> ii  xfsdump   3.0.2~bpo50+1       Administrative utilities for the XFS filesys
> ii  xfsprogs  3.0.4~bpo50+1       Utilities for managing the XFS filesystem
> Distribution: Debian lenny with xfsprogs, xfsdump backport from unstable.
> 
> The xfs_repair with stock Debian Lenny version also does crash at inode 3256930831.
> 
> Best Regards,
> Maximilian Mill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
