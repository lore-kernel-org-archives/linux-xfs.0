Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p13Eel61186678
	for <linux-xfs@oss.sgi.com>; Thu, 3 Feb 2011 08:40:47 -0600
Received: from mout.perfora.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 549884FDDD8
	for <linux-xfs@oss.sgi.com>; Thu,  3 Feb 2011 06:43:17 -0800 (PST)
Received: from mout.perfora.net (mout.perfora.net [74.208.4.194]) by
	cuda.sgi.com with ESMTP id ye7tjEn8gVfhVBl3 for
	<linux-xfs@oss.sgi.com>; Thu, 03 Feb 2011 06:43:17 -0800 (PST)
Message-ID: <4D4ABEF7.7000400@lueckdatasystems.com>
Date: Thu, 03 Feb 2011 09:43:03 -0500
From: Michael Lueck <mlueck@lueckdatasystems.com>
MIME-Version: 1.0
Subject: Re: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug get
	into	Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
References: <iibmah$dlp$1@dough.gmane.org> <4D49A35B.6030009@sgi.com>
	<20110203045836.GV11040@dastard>
In-Reply-To: <20110203045836.GV11040@dastard>
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

Dave Chinner wrote:
> So bulkstat got EINVAL returned for and inode that it was looking
> up. That implies that it was racing with an unlink, which is
> what the above commits catch and prevent. Can you run xfsdump with
> full debug output (-v 5) so we can see what inode is being operated
> on when this failure occurs?

Thank you so much Dave!

Please find the trace output here in zipped format:

http://www.lueckdatasystems.com/pub/ldsbackup.trace.log.zip

I chose to trace the "data" backup that actually had some size to it.

Sincerely,

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
