Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3SHRINV014181 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 12:27:18 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79D8541CC99
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 10:30:49 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id 1QRvFei1LB0GLMDs for
	<xfs@oss.sgi.com>; Thu, 28 Apr 2011 10:30:49 -0700 (PDT)
Date: Thu, 28 Apr 2011 10:30:47 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110427102824.GI12436@dastard>
Message-ID: <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
	<alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
	<20110427022655.GE12436@dastard>
	<alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
	<20110427102824.GI12436@dastard>
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

Hi David,

sorry for the late response:

On Wed, 27 Apr 2011 at 20:28, Dave Chinner wrote:
> hmmmm. Speaking of which - have you changed any of the XFS tunables
> in /proc/sys/fs/xfs/ on your machine (specifically
> xfssyncd_centisecs)?

No, I did not change anything underneath /proc/sys/fs/xfs.
 
> Not easy because there are tree-wide changes that need to be
> preserved (e.g. block layer plugging changes) while others around it
> would need to be reverted....

Yeah, I noticed. I wanted to do something like this:

  $ for c in `git log --pretty=oneline --no-merges v2.6.38..v2.6.39-rc2 fs/xfs | awk '{print $1}'`; do
       git revert $c
    done

...but this broke on the 1st or 2nd commit because of unresolved changes.

Now I'm in the middle of another bisect attempt, trying to reproduce but 
Im getting (probably totally unrelated) warnings here:

BUG: sleeping function called from invalid context at /usr/local/src/linux-2.6-git/drivers/ide/ide-io.c:447
in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper
INFO: lockdep is turned off.
[...]
 
> Can you check if there are any blocked tasks nearing OOM (i.e. "echo
> w > /proc/sysrq-trigger") so we can see if XFS inode reclaim is
> stuck somewhere?

In one instance when I mounted with "noatime", no log messages made it to 
the disk, but I could see "hung tasks":

   http://nerdbynature.de/bits/2.6.39-rc4/oom/oom-6.JPG

I will try sysrq-w later on.

FWIW, a regression bug has been opened:

  https://bugzilla.kernel.org/show_bug.cgi?id=34012

Thanks,
Christian.
-- 
BOFH excuse #284:

Electrons on a bender

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
