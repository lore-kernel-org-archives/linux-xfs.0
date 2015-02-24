Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 484AE7F3F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 15:59:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3624A304032
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 13:59:15 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	AV84xW3N4M3lApCB for <xfs@oss.sgi.com>;
	Tue, 24 Feb 2015 13:59:09 -0800 (PST)
Date: Wed, 25 Feb 2015 08:59:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: trying to avoid a lengthy quotacheck by deleting all quota data
Message-ID: <20150224215907.GA18360@dastard>
References: <54EC958E.2000001@pythonanywhere.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54EC958E.2000001@pythonanywhere.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Harry <harry@pythonanywhere.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 24, 2015 at 03:15:26PM +0000, Harry wrote:
> Hi there,
> 
> We've got a moderately large disk (~2TB) into an inconsistent state,
> such that it's going to want a quotacheck the next time we mount it
> (it's currently mounted with quota accounting inactive).  Our tests
> suggest this is going to take several hours, and cause an outage we
> can't afford.

What tests are you performing to suggest a quotacheck of a small
filesystem will take hours? (yes, 2TB is a *small* filesystem).

(xfs_info, df -i, df -h, storage hardware, etc are all relevant
here).

> We're wondering whether there's a 'nuke the site from orbit' option
> that will let us avoid it.  The plan would be to:
> - switch off quotas and delete them completely, using the commands:
>   -- disable
>   -- off
>   -- remove
> - remount the drive with -o prjquota, hoping that there will not be
> a quotacheck, because we've deleted all the old quota data

Mounting with a quota enabled *forces* a quota check if quotas
aren't currently enabled. You cannot avoid it; it's the way quota
consistency is created.

> - run a script gradually restore all the quotas, one by one and in
> good time, from our own external backups (we've got the quotas in a
> database basically).

Can't be done - quotas need to be consistent with what is currently
on disk, not what you have in a backup somewhere.

> So the questions are:
> - is there a way to remove all quota information from a mounted drive?
> (the current mount status seems to be that it tried to mount it with

mount with quotas on and turn them off via xfs_quota,i or mount
without quota options at all. Then run the remove command in
xfs_quota.

> -o prjquota but that quota accounting is *not* active)

Not possible.

> - will it work and let us remount the drive with -o prjquota without
> causing a quotacheck?

No.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
