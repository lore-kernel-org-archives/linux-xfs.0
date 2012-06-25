Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5P5wGpD188142 for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 00:58:17 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id pAnfbYl9yv1Pd1ZL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 24 Jun 2012 22:58:15 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	q5P5wCDf028711 for <xfs@oss.sgi.com>; Sun, 24 Jun 2012 22:58:14 -0700
Message-ID: <4FE7FDF4.6080506@tlinx.org>
Date: Sun, 24 Jun 2012 22:58:12 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Strange case of deleting lots of files and "df" not recognizing
	it....(unless I umount/mount) the disk...
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This isn't that big of a deal, as I'm not close to the limit,
but I pruned a backup disk that was at 87% full (1.5T free), down
by 3.8T.  Indeed, doing a 'du' of the disk shows space is ~6-7T (/11T)
but df still shows 9.5T usage.

I've done sync a few times, but the files were deleted almost a half an hour
ago.

So when does it actually synchronize w/o me forcing it?  (I.e. umount/mount)?

Have seen this before, and that's what brought it into 'sync'....

none of the xfs_centitimes are greater than 3000 or 30 seconds.  Not a big
problem that I know of, hardly a problem at all, cept that it is weird.

Curious?
-linda

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
