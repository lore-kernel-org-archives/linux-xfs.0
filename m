Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p18HbNw7133413
	for <linux-xfs@oss.sgi.com>; Tue, 8 Feb 2011 11:37:23 -0600
Received: from mout.perfora.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AF261EAD9B0
	for <linux-xfs@oss.sgi.com>; Tue,  8 Feb 2011 09:39:57 -0800 (PST)
Received: from mout.perfora.net (mout.perfora.net [74.208.4.195]) by
	cuda.sgi.com with ESMTP id UyheKt2pZaF5juqA for
	<linux-xfs@oss.sgi.com>; Tue, 08 Feb 2011 09:39:57 -0800 (PST)
Message-ID: <4D517FDB.1080402@lueckdatasystems.com>
Date: Tue, 08 Feb 2011 12:39:39 -0500
From: Michael Lueck <mlueck@lueckdatasystems.com>
MIME-Version: 1.0
Subject: Re: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug get
	into Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
References: <iibmah$dlp$1@dough.gmane.org> <4D49A35B.6030009@sgi.com>
	<20110203045836.GV11040@dastard>
	<4D4ABEF7.7000400@lueckdatasystems.com>
	<20110204000823.GW11040@dastard>
In-Reply-To: <20110204000823.GW11040@dastard>
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
Cc: linux-xfs@oss.sgi.com, Dann Frazier <dannf@debian.org>

Greetings Dave,

I am just finally getting back to this. Rebooted to the latest 10.04 kernel.

$ uname -a
Linux ldslnx01 2.6.32-28-generic-pae #55-Ubuntu SMP Mon Jan 10 22:34:08 UTC 2011 i686 GNU/Linux

Dave Chinner wrote:
> Can you firstly post the output of:
>
> # xfs_db -c "inode 80508397" -c p<dev>

Command seems grumpy...

$ sudo xfs_db -c "inode 80508397" -c p <dev>
-bash: syntax error near unexpected token `newline'

I even tried unmounting the /srv partition. I am having difficulty finding docs about the usage of xfs_db / xfs_repair.

rrrrrr?????

> And can you also run 'xfs_repair -n<dev>' on the filesystem and
> post the output as well so we can see what state the filesytem is
> in?

This one as well...

/srv$ sudo xfs_repair -n<dev>
-bash: syntax error near unexpected token `newline'

Sincerely,

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
