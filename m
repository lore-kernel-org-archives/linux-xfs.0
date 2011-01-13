Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0DDDjhr137008 for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 07:13:45 -0600
Received: from mail-px0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56481260AB8
	for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 05:15:58 -0800 (PST)
Received: from mail-px0-f181.google.com (mail-px0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	Htt0QWllcMcDwqPo for <xfs@oss.sgi.com>;
	Thu, 13 Jan 2011 05:15:58 -0800 (PST)
Received: by pxi2 with SMTP id 2so375818pxi.26
	for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 05:15:58 -0800 (PST)
Message-ID: <4D2EFB08.90502@philkarn.net>
Date: Thu, 13 Jan 2011 05:15:52 -0800
From: Phil Karn <karn@philkarn.net>
MIME-Version: 1.0
Subject: Extreme fragmentation when backing up via NFS
References: <4D0C9A4F.4040108@pzystorm.de>	<20101220001024.GH5193@dastard>	<4D0EC5C5.2070407@pzystorm.de>	<20101220045126.GK5193@dastard>	<20101220105547.4f9e7218@galadriel.home>
	<4D2E3B38.6010506@pzystorm.de>
In-Reply-To: <4D2E3B38.6010506@pzystorm.de>
Reply-To: karn@ka9q.net
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

I have been backing up my main Linux server onto a secondary machine via
NFS. I use xfsdump like this:

xfsdump -l 9 -f /machine/backups/fs.9.xfsdump /

Over on the server machine, xfs_bmap shows an *extreme* amount of
fragmentation in the backup file. 20,000+ extents are not uncommon, with
many extents consisting of a single allocation block (8x 512B sectors or
4KB).

I do notice while the backup file is being written that holes often
appear in the extent map towards the end of the file. I theorize that
somehow the individual writes are going to the file system out of order,
and this causes both the temporary holes and the extreme fragmentation.

I'm able to work around the fragmentation manually by looking at the
estimate from xfsdump of the size of the backup and then using the
fallocate command locally on the file server to allocate more than that
amount of space to the backup file. When the backup is done, I look at
xfsdump's report of the actual size of the backup file and use the
truncate command locally on the server to trim off the excess.

Is fragmentation on XFS via NFS a known problem?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
