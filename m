Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBJD2HJG024994 for <xfs@oss.sgi.com>; Fri, 19 Dec 2008 07:02:18 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D931D358FC
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2008 05:02:15 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id Nl3NhgL1tKB9urnl for
	<xfs@oss.sgi.com>; Fri, 19 Dec 2008 05:02:15 -0800 (PST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS ignores all atime related mount options,
	noatime is always in effect, documentation misses this information
Date: Fri, 19 Dec 2008 14:01:38 +0100
References: <200812181915.13962.edvx1@systemanalysen.net>
	(sfid-20081218_195913_535609_9F401C50)
In-Reply-To: <200812181915.13962.edvx1@systemanalysen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812191401.38733.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Roland Eggner <edvx1@systemanalysen.net>
Cc: SGI Project XFS mailing list <xfs@oss.sgi.com>

Am Donnerstag 18 Dezember 2008 schrieb Roland Eggner:
> On my linux box I tried to achieve regular atime behaviour, tried mount
> with no atime related option at all, tried mount options atime, sync,
> osyncisosync, .. XFS on plain partitions, on loop devices .. I tried
> another kernel (sidux image with kernel 2.6.25-9) ..
>
> My result:
> It seems impossible to switch off "noatime" mount option.
> atime updates happen only in core, never on disk unless coinciding with
> other inode modifications, regardless of specified mount options.
>
> $  uname -a
> Linux roland 2.6.23.12roland2 #2 Tue Apr 15 17:10:52 CEST 2008 i686
> GNU/Linux

I can't reproduce this on 2.6.27.7:

martin@shambhala:~/Zeit> grep /home /proc/mounts
/dev/sda5 /home xfs 
rw,relatime,attr2,nobarrier,logbufs=8,logbsize=256k,noquota 0 0
martin@shambhala:~/Zeit> echo "hallo" >hallo.txt
martin@shambhala:~/Zeit> ls -l --time=atime hallo.txt
-rw-r--r-- 1 martin martin 6 19. Dez 13:56 hallo.txt
martin@shambhala:~/Zeit> cat hallo.txt ; ls -l --time=atime hallo.txt
hallo
-rw-r--r-- 1 martin martin 6 19. Dez 13:57 hallo.txt

How did you test it? A reproducable test case would be fine.

> $  zgrep XFS /proc/config.gz
> CONFIG_XFS_FS=m
> # CONFIG_XFS_QUOTA is not set
> CONFIG_XFS_SECURITY=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> # CONFIG_VXFS_FS is not set

martin@shambhala:~> zgrep XFS /proc/config.gz
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_VXFS_FS is not set

> In mailing list archive I found
> http://oss.sgi.com/archives/xfs/2007-10/msg00168.html
> It seems, that 3 years ago an unconditional noatime enforcement has
> been introduced.

Did you look within the same mount or did you unmount and remount first? I 
remember there has been some issue with inode updates and unmounting, but 
I do not remember the details.

> (2)  If I missed a possibility to achieve regular atime behaviour,
> please document it in Documentation/filesystems/xfs.txt and in man 8
> mount.

Its either atime, relatime or noatime as mount option.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
