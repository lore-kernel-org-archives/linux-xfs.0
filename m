Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p18JoRqn145083
	for <linux-xfs@oss.sgi.com>; Tue, 8 Feb 2011 13:50:28 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B82F1559523
	for <linux-xfs@oss.sgi.com>; Tue,  8 Feb 2011 11:52:59 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	rdW2md0A8HNDXQAA for <linux-xfs@oss.sgi.com>;
	Tue, 08 Feb 2011 11:52:59 -0800 (PST)
Date: Wed, 9 Feb 2011 06:52:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug
	get into	Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
Message-ID: <20110208195256.GA25601@dastard>
References: <iibmah$dlp$1@dough.gmane.org> <4D49A35B.6030009@sgi.com>
	<20110203045836.GV11040@dastard>
	<4D4ABEF7.7000400@lueckdatasystems.com>
	<20110204000823.GW11040@dastard>
	<4D517FD2.5040509@lueckdatasystems.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D517FD2.5040509@lueckdatasystems.com>
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
To: Michael Lueck <mlueck@lueckdatasystems.com>
Cc: linux-xfs@oss.sgi.com, Dann Frazier <dannf@debian.org>

On Tue, Feb 08, 2011 at 12:39:30PM -0500, Michael Lueck wrote:
> Greetings Dave,
> 
> I am just finally getting back to this. Rebooted to the latest 10.04 kernel.
> 
> $ uname -a
> Linux ldslnx01 2.6.32-28-generic-pae #55-Ubuntu SMP Mon Jan 10 22:34:08 UTC 2011 i686 GNU/Linux
> 
> Dave Chinner wrote:
> >Can you firstly post the output of:
> >
> ># xfs_db -c "inode 80508397" -c p<dev>
> 
> Command seems grumpy...
> 
> $ sudo xfs_db -c "inode 80508397" -c p <dev>
> -bash: syntax error near unexpected token `newline'
> 
> I even tried unmounting the /srv partition. I am having difficulty finding docs about the usage of xfs_db / xfs_repair.

The man pages, perhaps? i.e. 'man xfs_db' and 'man xfs_repair'

> >And can you also run 'xfs_repair -n<dev>' on the filesystem and
> >post the output as well so we can see what state the filesytem is
> >in?
> 
> This one as well...
> 
> /srv$ sudo xfs_repair -n<dev>
> -bash: syntax error near unexpected token `newline'

Substitute /dev/sda, /dev/sdb or whatever your filesystem is on for
"<dev>" in the above commands.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
