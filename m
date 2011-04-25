Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3P7G1nu104746 for <xfs@oss.sgi.com>; Mon, 25 Apr 2011 02:16:02 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E01A61643B6E
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2011 00:19:31 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id F6jk1m2QbdVrJVtl for
	<xfs@oss.sgi.com>; Mon, 25 Apr 2011 00:19:31 -0700 (PDT)
Date: Mon, 25 Apr 2011 00:19:24 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
	<alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
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

Please see http://nerdbynature.de/bits/2.6.39-rc4/oom/

 - slabinfo-4.txt.bz2, contains /proc/sys/fs/{dentry,inode}-state and
   /proc/fs/xfs/stat (is this interesting at all?) and a few other
   /proc outputs
 - messages-4.txt, contains the syslog from this run.

Should I enable a few more DEBUG_* options in the kernel? Which options 
would be helpful?

Thanks for looking into it,
Christian.
-- 
BOFH excuse #194:

We only support a 1200 bps connection.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
