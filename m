Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o07AmaCW168063 for <xfs@oss.sgi.com>; Thu, 7 Jan 2010 04:48:36 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B257150F9CD
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2010 02:49:26 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	pckkSS1jELQc0Hgn for <xfs@oss.sgi.com>;
	Thu, 07 Jan 2010 02:49:26 -0800 (PST)
Received: from discord (unverified [121.44.238.220])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11302954-1927428
	for <xfs@oss.sgi.com>; Thu, 07 Jan 2010 21:19:25 +1030 (CDT)
Received: from dave by discord with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>) id 1NSpvf-0001RI-HQ
	for xfs@oss.sgi.com; Thu, 07 Jan 2010 21:49:23 +1100
Date: Thu, 7 Jan 2010 21:49:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] Fix inode reclaim problems (hopefully)
Message-ID: <20100107104923.GZ13802@discord.disaster>
References: <1262819125-27083-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1262819125-27083-1-git-send-email-david@fromorbit.com>
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

On Thu, Jan 07, 2010 at 10:05:23AM +1100, Dave Chinner wrote:
> These two patches seem to fix the inode reclaim issues I've been
> able to reproduce lately. The changes are still running xfsqa in a
> loop to confirm this, but the directory/small file stress test I've
> been running to trigger the problem has run for 10 hours with these
> fixes instead of dying after 20-30 minutes.

Still running xfsqa 11 hours later without any problem, so it looks
like this series fixes the problem I was seeing. Score another win
for the new tracing code :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
