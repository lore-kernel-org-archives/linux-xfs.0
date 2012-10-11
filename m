Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BIBigv193202 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 13:11:44 -0500
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id EeDFLKScBZdgLNSH for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 11:13:16 -0700 (PDT)
Received: from trent.utfs.org (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 943A83DF2D
	for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 20:13:14 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 7B6B33DC39
	for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 20:13:14 +0200 (CEST)
Date: Thu, 11 Oct 2012 11:13:14 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: possible memory allocation deadlock in xfs_buf_allocate_memory
Message-ID: <alpine.DEB.2.01.1210111048170.10880@trent.utfs.org>
MIME-Version: 1.0
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

Hi,

since Linux 3.5 I'm seeing these "inconsistent lock state" lockdep 
warnings [0]. They show up in 3.6 as well [1]. I was being told[2] that I 
may have run out of inode attributes. This may well be the case, but I 
cannot reformat the disk right now and will have to live with that warning 
a while longer.

I got the warning again today, but 8h later the system hung and eventually 
shutdown. The last message from the box was received via netconsole:

 XFS: possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x250)

This has been reported[3] for 3.2.1, but when the message was printed I 
was not around and could not watch /proc/slabinfo.

The last -MARK- message (some kind of heartbeat message from syslog, 
printing "MARK" every 5min) has been received 07:55 local time, the
netconsole message above was received 08:09, so two -MARK- messages were 
lost. sar(1) stopped recording at 08:05.

These two incidents (the lockdep warning and the final lockup) may be 
unrelated (and timestamp-wise, they seem to be), but I thought I'd 
better report it.

Full dmesg and .config: http://nerdbynature.de/bits/3.6.0/xfs/

Thanks,
Christian.

[0] http://oss.sgi.com/archives/xfs/2012-07/msg00113.html
[1] http://oss.sgi.com/archives/xfs/2012-09/msg00305.html
[2] http://oss.sgi.com/archives/xfs/2012-07/msg00116.html
[3] http://oss.sgi.com/archives/xfs/2012-06/msg00362.html
-- 
BOFH excuse #75:

There isn't any problem

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
