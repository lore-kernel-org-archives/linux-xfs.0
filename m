Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p14LPOGp036692 for <xfs@oss.sgi.com>; Fri, 4 Feb 2011 15:25:24 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6829918D41
	for <xfs@oss.sgi.com>; Fri,  4 Feb 2011 13:27:53 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ctR4SSu0QwWMAeWh for <xfs@oss.sgi.com>;
	Fri, 04 Feb 2011 13:27:53 -0800 (PST)
Date: Sat, 5 Feb 2011 08:27:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: project quota: df/reservations
Message-ID: <20110204212750.GA11040@dastard>
References: <4D4BF051.9000608@ncac.torun.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D4BF051.9000608@ncac.torun.pl>
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
To: Jerzy Borkowski <jubork@ncac.torun.pl>
Cc: xfs@oss.sgi.com

On Fri, Feb 04, 2011 at 01:25:53PM +0100, Jerzy Borkowski wrote:
> Hello,
> 
> 1) Fancy a project with quota set to 10GB, and filled
> with 5GB of data. When I type
> 
>   df /path/to/project/tree
> 
> it shows 5GB free space. Now, the root user
> fills up the disk (outside project tree), so the
> XFS filesystem is really 100% full. The df command
> still shows 5GB free space. I guess, this is
> intentional. I propose to add some switch/flag
> (either during mount or project creation),
> which would tell XFS to report in statfs() calls
> the free space as: min(project_free_space, filesystem_free_space).

If you just run "df" or "df /path/to/mtpt" rather than asking
specifically for the project tree path, you should see the real
filesystem usage.

Think of project quotas like thin provisioned filesystems - they can
still have space available when the underlying storage runs out and
it is up to the admin to manage this situation.

> 2) is there any way to have space reservations for projects (like in ZFS) ?
> For instance, a project with 10GB quota and 7GB of preallocated
> space, so even root, writing outside the project tree, cannot
> completely fill up the disk.

No. Quotas can only be used to limit space usage, not reserve it.
It could probably be done, but it's not a simple retrofit...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
