Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAC2cKu9210316 for <xfs@oss.sgi.com>; Wed, 11 Nov 2009 20:38:20 -0600
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52BA2D12D71
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2009 18:38:38 -0800 (PST)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id fZTqOafCcctkSIkK for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2009 18:38:38 -0800 (PST)
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by Ishtar.sc.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAC2cZbQ002047 for <xfs@oss.sgi.com>; Wed, 11 Nov 2009 18:38:37 -0800
Message-ID: <4AFB752F.2080307@tlinx.org>
Date: Wed, 11 Nov 2009 18:38:39 -0800
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: xfsdump/restore?  Performance ...
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

Dunno if xfsdump/restore are considered that important with bacula being
adverted as being xfs-compat, but something I found that speeds up and
xfsdump/restore, or, especially, using xfsdump/restore to copy a file system --
I put 'mbuffer' in between them and gave it 1mb buffers, and used about 1024 of
them.  My fs->fs copy rate went up by 50%.

An equivalent amount of data took about 2700++ seconds with direction pipe from
xfsdump|xfsrestore, but with a buffer between them, that dropped to about
1800+.

Maybe xfsdump/restore need some larger buffers?  I was also thinking -- I'm not
sure how xfsrestore restores files, but does it take each file as it comes, and
then restores it, or does it cache the handles to the directories in the
previous path?  Usually wouldn't be noticeable, but if it has to walk through
directories that have lots of files, might save some lookup time.

If both were multithreaded -- with one thread for buffer management while the
other could do disk I/O -- or is that the infamous '-Y' option that has yet to
be implemented on linux? :-)

Don't know how much interest there is in these utils, but thought I'd mention
the benefit of a big buffer...  Same goes for restore and dump I presume,
separately.  I.e. if xfsdump always does output to mbuffer and mbuffer writes
to disk or to Xzip (X=g,bz,lz).  Maybe write's are sufficiently well buffered
by the kernel, that only restores would benefit -- with mbuffer reading a backup
file, but if those utils are used, there are some good possibilities for
performance improvements...

-linda


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
