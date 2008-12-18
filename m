Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBIIJpjn007856 for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 12:19:52 -0600
Received: from ngcobalt07.manitu.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7183175C74D
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 10:19:25 -0800 (PST)
Received: from ngcobalt07.manitu.net (ngcobalt07.manitu.net [217.11.48.107])
	by cuda.sgi.com with ESMTP id cUPf41uR3u24XkH5 for
	<xfs@oss.sgi.com>; Thu, 18 Dec 2008 10:19:25 -0800 (PST)
From: Roland Eggner <edvx1@systemanalysen.net>
Subject: XFS ignores all atime related mount options,
	noatime is always in effect, documentation misses this information
Date: Thu, 18 Dec 2008 19:15:13 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812181915.13962.edvx1@systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
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
To: SGI Project XFS mailing list <xfs@oss.sgi.com>

On my linux box I tried to achieve regular atime behaviour, tried mount with
no atime related option at all, tried mount options atime, sync,
osyncisosync, .. XFS on plain partitions, on loop devices .. I tried another
kernel (sidux image with kernel 2.6.25-9) ..

My result:
It seems impossible to switch off "noatime" mount option.
atime updates happen only in core, never on disk unless coinciding with other
inode modifications, regardless of specified mount options.

$  uname -a
Linux roland 2.6.23.12roland2 #2 Tue Apr 15 17:10:52 CEST 2008 i686 GNU/Linux

$  zgrep XFS /proc/config.gz
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_SECURITY=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_VXFS_FS is not set

In mailing list archive I found
http://oss.sgi.com/archives/xfs/2007-10/msg00168.html
It seems, that 3 years ago an unconditional noatime enforcement has been
introduced.

(1)  If this is true, please update documentation accordingly.
Users, who need a filesystem with regular atime behaviour, will no more waste
their time to try XFS, when in fact it is unusable for their particular
requirements.

(2)  If I missed a possibility to achieve regular atime behaviour, please
document it in Documentation/filesystems/xfs.txt and in man 8 mount.

Thanks!

-- 
Roland Eggner

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
