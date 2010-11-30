Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAU788e5057200 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 01:08:08 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 455E81C79234
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 23:09:48 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	GbKHE2yXJzYvmzK3 for <xfs@oss.sgi.com>;
	Mon, 29 Nov 2010 23:09:48 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	48130226-1927428
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 17:39:47 +1030 (CDT)
Received: from dave by dastard with local (Exim 4.71)
	(envelope-from <david@fromorbit.com>) id 1PNKLR-0002qK-KY
	for xfs@oss.sgi.com; Tue, 30 Nov 2010 18:09:45 +1100
Date: Tue, 30 Nov 2010 18:09:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] xfs: fixes for 2.6.37-rcX
Message-ID: <20101130070945.GG3556@dastard>
References: <1290990024-15898-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290990024-15898-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Mon, Nov 29, 2010 at 11:20:19AM +1100, Dave Chinner wrote:
> Alex,
> 
> This is my curent set of fixes needed for 2.6.37-rcX. I've already posted the
> truncation fix and the stale buffer fixes, as well as the xfs_error_test
> optimisation. The other two fixes I have extracted from my current scalability
> patch set. They correct the invalid assumption that that ther eare no delayed
> allocation blocks left on a file after writeback and prevent stale inodes from
> being re-inserted into the AIL after the stale buffer behind them has been torn
> down.
> 
> Let me know how you want me to post the final versions for you to pull into the
> XFS tree. (i.e. do you want them in a git tree branch?)

Alex, the patches are now in the git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git xfs-for-2.6.37

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
