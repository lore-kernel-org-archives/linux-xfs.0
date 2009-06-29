Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5TJdNej149543 for <xfs@oss.sgi.com>; Mon, 29 Jun 2009 14:39:23 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 227F3129160E
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2009 12:46:03 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 5lcfyc0eQx18Kws8 for
	<xfs@oss.sgi.com>; Mon, 29 Jun 2009 12:46:03 -0700 (PDT)
Message-ID: <4A491887.8050509@sandeen.net>
Date: Mon, 29 Jun 2009 14:39:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Correct usage of inode64/running out of inodes
References: <OF97A83ACB.604AE440-ON862575E4.00450F9F-862575E4.00475C94@genco.com>
In-Reply-To: <OF97A83ACB.604AE440-ON862575E4.00450F9F-862575E4.00475C94@genco.com>
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
To: Adam Donald <Adam.Donald@gencopharma.com>
Cc: xfs@oss.sgi.com

Adam Donald wrote:
> 
> Hello
> 
> In short, I believe that I have used the indode64 option correctly in
> mounting my XFS device on my Centos 5.2 system, however, I seem to only
> have 59 free inodes available and 7.5TB of free space.  I would
> appreciate any insight as to what the best approach would be to fix this
> situation.  In case it is helpful, I have included output from various
> commands/files below, the XFS device in question is
> /dev/mapper/VolGroup01-DATA01.  Thank you in advance for your assistance!

It all looks sane to me; what are the actual symptoms of the problem
You can create 59 files and then -ENOSPC?  Any kernel messages?

Maybe this is a bug in the old xfs code in the centos module... though I
don't remember such a bug right now.s

-Eric

> uname:
> Linux NAS01 2.6.18-92.1.6.el5 #1 SMP Wed Jun 25 13:45:47 EDT 2008 x86_64
> x86_64 x86_64 GNU/Linux
> 
> df -h:
> Filesystem                            Size  Used Avail Use% Mounted on
> /dev/mapper/VolGroup00-LogVol00        71G   12G   55G  18% /
> /dev/sda1                              99M   25M   70M  26% /boot
> tmpfs                                 3.9G     0  3.9G   0% /dev/shm
> /dev/mapper/VolGroup01-DATA01          18T  9.9T  7.5T  57% /DATA01
> 
> df -ih:
> Filesystem                          Inodes   IUsed   IFree IUse% Mounted on
> /dev/mapper/VolGroup00-LogVol00        19M    123K     19M    1% /
> /dev/sda1                              26K      44     26K    1% /boot
> tmpfs                                 999K       1    999K    1% /dev/shm
> /dev/mapper/VolGroup01-DATA01          18G    297K     18G    1% /DATA01
> 
> mount:
> ...
> /dev/mapper/VolGroup01-DATA01 on /DATA01 type xfs (rw,inode64)
> ...
> 
> fstab:
> ...
> /dev/VolGroup01/DATA01  /DATA01                 xfs    
> rw,suid,dev,exec,auto,nouser,async,inode64      1 0
> ...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
