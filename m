Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 30C907F37
	for <xfs@oss.sgi.com>; Thu,  4 Sep 2014 20:24:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AFDC2AC001
	for <xfs@oss.sgi.com>; Thu,  4 Sep 2014 18:24:11 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	htIZOf7L21BC1k27 for <xfs@oss.sgi.com>;
	Thu, 04 Sep 2014 18:24:09 -0700 (PDT)
Date: Fri, 5 Sep 2014 11:24:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsrestore: use utimensat() to provide atime/mtime with
	ns resolution
Message-ID: <20140905012404.GV20518@dastard>
References: <1409848708-42666-1-git-send-email-bfoster@redhat.com>
	<20140905004501.GU20518@dastard> <54090C33.2060102@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54090C33.2060102@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, Sep 04, 2014 at 08:04:51PM -0500, Eric Sandeen wrote:
> On 9/4/14, 7:45 PM, Dave Chinner wrote:
> >On Thu, Sep 04, 2014 at 12:38:28PM -0400, Brian Foster wrote:
> >>xfsdump encodes and stores the full atime and mtime for each file with
> >>nanosecond resolution. xfsrestore uses utime() to set the times of each
> >>file that is restored. The latter supports resolution of 1 second, thus
> >>sub-second timestamp data is lost on restore.
> >
> >That doesn't seem like a big deal. What sort of problems does this
> >actually cause?
> >
> >FYI, many linux filesystems only have second resolution timestamps
> >and hence applications can't rely on sub-second timestamp resolution
> >to actually mean anything useful....
> 
> But why not restore the same resolution as is actually stored in the dump?
> Throwing it away seems odd, and restoring it looks easy enough.

Comes from a time when we couldn't restore what was in the dump. :/

> In any case, there was a user who noticed & complained.  Seems like a
> very reasonable thing to fix, to me.

Sure, but we don't make changes with the justification "just
because". xfsrestore has had this behaviour since dump/restore was
first introduced, so first we need to understand what the actual
problem is. Was the user complaining because they noticed they were
"different" in passing, or was it noticed because the difference is
the root cause of some other problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
