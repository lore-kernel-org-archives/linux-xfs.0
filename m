Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6ULiQRE101393 for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 16:44:26 -0500
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D81883982CA
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 14:45:13 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id tzijxQxj4vcYcKor for
	<xfs@oss.sgi.com>; Thu, 30 Jul 2009 14:45:13 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1MWdR2-0003Ef-Qk
	for xfs@oss.sgi.com; Thu, 30 Jul 2009 14:45:12 -0700
Message-ID: <24747808.post@talk.nabble.com>
Date: Thu, 30 Jul 2009 14:45:12 -0700 (PDT)
From: rnb <neil.bell@gmail.com>
Subject: Re: xfs i/O error
In-Reply-To: <24742623.post@talk.nabble.com>
MIME-Version: 1.0
References: <24742623.post@talk.nabble.com>
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


[70273.864305] sd 8:0:0:0: [sdg] Sense Key : Medium Error [current] 
[70273.864314] Info fld=0x0
[70273.864318] sd 8:0:0:0: [sdg] Add. Sense: Unrecovered read error
[70273.864327] end_request: I/O error, dev sdg, sector 378206415
[70276.938405] sd 8:0:0:0: [sdg] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK

running a defrag that last few hours so there are tonnes of those. Like i
said it has no issues mounting, xfs_repair fails to see the problem. Bad
sectors I hope not the drives are a few months old and this is a storage
server to it isn't like it is getting a tonne of writing done to it. Being
external though I can't rule out hardware failure and smartctl doesn't run
over USB.

rnb wrote:
> 
> Running Ubuntu 9.04 kernel 2.26.28.14 generic
> Drive mounts fine.
> xfs_repair shows no errors
> sudo xfs_repair /dev/sdg1
>  Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> done
> 
> xfs_check did move a few things around but finished fine
> 
> sudo xfs_fsr -v /dev/sdg1 <== This is just so far it is still running.
> /media/Films start inode=0
> ino=140
> bad read of 0 bytes from ino=140: Input/output error
> ino=139
> extents before:66 after:8      ino=139
> ino=145
> extents before:42 after:7      ino=145
> ino=146
> extents before:40 after:8      ino=146
> ino=143
> bad read of 0 bytes from ino=143: Input/output error
> ino=144
> extents before:27 after:8      ino=144
> ino=8763008
> bad read of 0 bytes from ino=8763008: Input/output error
> ino=8763059
> bad read of 0 bytes from ino=8763059: Input/output error
> ino=8763057
> extents before:307 after:12      ino=8763057
> ino=8763058
> extents before:259 after:11      ino=8763058
> ino=8763024
> bad read of 0 bytes from ino=8763024: Input/output error
> ino=8763055
> kk
> extents before:125 after:10      ino=8763055
> ino=8763030
> bad read of 0 bytes from ino=8763030: Input/output error
> ino=8763060
> bad read of 0 bytes from ino=8763060: Input/output error
> ino=8763056
> extents before:62 after:13      ino=8763056
> ino=8763066
> 
> Now my issue is how do I fix it if xfs_repair doesn't see a problem.
> Anything getting copied to the drive works fine in place wasn't until i
> tried to move it off I noticed the issue. Some things copy fine from it
> several others fail. Then i get Input/output error. It is a full 1tb drive
> . WD mybook it lost power which I think is what caused this issue. How can
> I correct the issue. Everything I try takes a hell of a long time and
> doesn't yield a positive result
> 

-- 
View this message in context: http://www.nabble.com/xfs-i-O-error-tp24742623p24747808.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
