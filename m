Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1D3G9JJ103070 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 21:16:14 -0600
Received: from web51408.mail.re2.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id EFC8C192ABD7
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 19:15:31 -0800 (PST)
Received: from web51408.mail.re2.yahoo.com (web51408.mail.re2.yahoo.com
	[206.190.38.187]) by cuda.sgi.com with SMTP id 3bPkvCfAVgfP9N4S
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 19:15:31 -0800 (PST)
Message-ID: <283651.13069.qm@web51408.mail.re2.yahoo.com>
Date: Thu, 12 Feb 2009 19:15:31 -0800 (PST)
From: Richard Troxell <knavewave@yahoo.com>
Subject: xfs_fsr not defragmenting: 'could not open tmp file'
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


I am trying out the xfs_fsr utility, but am not having much luck getting it to actually do anything. Running with -vd, I see a flood of 'no such file messages' like the following.

ino=570425612
ino=570425612 extents=12 can_save=11 tmp=/disk08-01/.fsr/ag329/tmp22898
could not open tmp file: /disk08-01/.fsr/ag329/tmp22898: No such file or directory

Just for the fun of it, I tried creating some of these directories, only to find the operation bails in the ioctl.
ino=570425630
ino=570425630 extents=13 can_save=12 tmp=/disk08-01/.fsr/ag328/tmp22898
DEBUG: fsize=445760 blsz_dio=445440 d_min=512 d_max=2147483136 pgsz=4096
Temporary file has 1 extents (13 in original)
XFS_IOC_SWAPEXT failed: ino=570425630: Invalid argument


xfs_fsr is coming from xfsprogs 3.0.0
Linux kernel is 2.6.23.9
Architecture is x86_64, but xfs_fsr is 32bit.


I did some searching for through past post for any similiar cases, but could not find any. Here are some other useful outputs that I found from somewhat related posts.

# xfs_db -c frag -f /dev/sdp2
actual 38348, ideal 1318, fragmentation factor 96.56%

Most of the files appear to have single extent layouts, but there are a few exceptions.

# xfs_db -c "frag -v" -f /dev/sdp2 
...
inode 570425622 actual 957 ideal 1
...

I did a quick check of the 'bmap' of the inode listed above and the file looks non-sparse (all 'flag 0')


Thanks!



      

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
