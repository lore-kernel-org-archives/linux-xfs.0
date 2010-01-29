Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0TIEuha135503
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 12:14:56 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62E8D19C009
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 10:16:01 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id w5FBOV4PEkoCBxDY for
	<linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 10:16:01 -0800 (PST)
Message-ID: <4B6325E2.2040703@sandeen.net>
Date: Fri, 29 Jan 2010 12:16:02 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Filesystem corrupted: "Sorry, could not find valid secondary
	superblock"
References: <hjus58$6oi$1@ger.gmane.org>	<4B63010D.1080608@sandeen.net>	<hjv12n$r2o$1@ger.gmane.org>	<4B631704.8080902@sandeen.net>
	<hjv6l0$j2g$1@ger.gmane.org>
In-Reply-To: <hjv6l0$j2g$1@ger.gmane.org>
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
To: Nicolas Stransky <nico@stransky.cx>
Cc: linux-xfs@oss.sgi.com

Nicolas Stransky wrote:
> OK here is a bunch of new stuff:
> 
> # xfs_repair /dev/sda1
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
> ERROR: The filesystem has valuable metadata changes in a log which needs
> to be replayed.  Mount the filesystem to replay the log, and unmount it
> before re-running xfs_repair.  If you are unable to mount the
> filesystem, then use the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a
> mount of the filesystem before doing this.
> 
> # mount/ dev/sda1
> mount: Structure needs cleaning

dmesg at this point would be good

> 
> Is the use of -L the only way to go? I wonder, since it will cause data
> loss...

if you can't mount it, yeah

> 
> Also here is the output of xfs_db:
> 
> # xfs_db /dev/sda1
> xfs_db> sb 0
> xfs_db> p
> magicnum = 0x58465342

ok, odd; you got:

>> # xfs_repair /dev/sda
>> Phase 1 - find and verify superblock...
>> bad primary superblock - bad magic number !!!

but this magic number is fine ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
