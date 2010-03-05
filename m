Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2593Xuc236809 for <xfs@oss.sgi.com>; Fri, 5 Mar 2010 03:03:34 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 981A521C37E
	for <xfs@oss.sgi.com>; Fri,  5 Mar 2010 01:05:01 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id 2GO0K4q51yyQrmFb
	for <xfs@oss.sgi.com>; Fri, 05 Mar 2010 01:05:01 -0800 (PST)
Message-ID: <4B90C935.4070008@dermichi.com>
Date: Fri, 05 Mar 2010 10:04:53 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: XFS hang during xfs_fsr run
References: <4B8F871C.60802@dermichi.com>	<20100304112018.GG14317@discord.disaster>	<4B8FA2CD.6010904@dermichi.com>	<20100304131511.GH14317@discord.disaster>	<20100304134641.GA26871@infradead.org>	<4B8FC1B7.3070505@dermichi.com>
	<20100304222611.GK14317@discord.disaster>
In-Reply-To: <20100304222611.GK14317@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> If you've got the inode numbers, then your running with the verbose
> flag set? Do you still have the logs for those inodes that it hung
> on?
Yes I am running xfs_fsr with the -v flag. But I'm not 100% sure if the 
log was truncated since it resides in /var which locked up. Here are the 
last log entries before the oopses:
ino=134269708  (this inode was /var/log/xfs_fsr.log)
(hang)
...
ino=277040401  (this inode was /var/spool/imap/x/user/xxxx/cyrus.cache)
(hang)

I can pin down those things at the moment:
- Both times it was a "hot" file - in one case a logfile, in the other 
case a database file.
- Usually it should say "file busy" and continue but sometimes it 
doesn't and just hangs the filesystem + oopses the kernel.
- It happens randomly, if i rerun xfs_fsr after the hang it usually goes 
over the "problem" file without a hickup.
- On /var/log/xfs_fsr.log it hung even though the (+f) chattr was set.

> xfs_fsr doesn't do directory traversals to find files for defrag -
> it uses more efficient bulkstat+open-by-handle method to visit every
> inode in the filesystem once. As a result, it will still open inodes
> that have the nodefrag flag set on them, but will then ignore them once
> it finds the flag is set.
Yes, usually it says "marked as don't defrag, ignoring" but this one 
time it hung.

> A trace would tell us which one it was....
Will see that i can get another one.

cheers,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
