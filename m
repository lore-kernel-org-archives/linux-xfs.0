Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3P5lo6S100622 for <xfs@oss.sgi.com>; Mon, 25 Apr 2011 00:47:51 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AE7B1521E52
	for <xfs@oss.sgi.com>; Sun, 24 Apr 2011 22:51:20 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id CoW0W2HjoeCwGwJV for
	<xfs@oss.sgi.com>; Sun, 24 Apr 2011 22:51:20 -0700 (PDT)
Date: Sun, 24 Apr 2011 22:51:17 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110424234655.GC12436@dastard>
Message-ID: <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, 25 Apr 2011 at 09:46, Dave Chinner wrote:
> I'd say they are not being reclaimmmed because the VFS hasn't let go
> of them yet. Can you also dump /proc/sys/fs/{dentry,inode}-state so
> we can see if the VFS has released the inodes such that they can be
> reclaimed by XFS?

Will do that.

> BTW, what are your mount options? If it is the problem I suspect it
> is, then using noatime with stop it from occurring....

# grep xfs /proc/mounts 
/dev/mapper/wdc1 /mnt/backup xfs rw,nosuid,nodev,noexec,relatime,attr2,delaylog,noquota 0 0
/dev/mapper/wdc1 /data xfs ro,relatime,attr2,delaylog,noquota 0 0

The "/dev/mapper/wdc1" is a dm-crypt device on a ~1TB external disk 
(via FireWire). The 2nd line in the output above is a bind-mount from 
somewhere below "/mnt/backup".

I'm currently trying to reproduce the problem again and see if the 
{dentry,inode}-state output reveals any more information. After that, I'll 
try with noatime.

Thanks,
Christian.
-- 
BOFH excuse #115:

your keyboard's space bar is generating spurious keycodes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
