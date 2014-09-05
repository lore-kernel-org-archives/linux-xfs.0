Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA0327F37
	for <xfs@oss.sgi.com>; Thu,  4 Sep 2014 19:45:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 617FFAC003
	for <xfs@oss.sgi.com>; Thu,  4 Sep 2014 17:45:12 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	VDGRG3O3zj19nlhw for <xfs@oss.sgi.com>;
	Thu, 04 Sep 2014 17:45:10 -0700 (PDT)
Date: Fri, 5 Sep 2014 10:45:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsrestore: use utimensat() to provide atime/mtime with
	ns resolution
Message-ID: <20140905004501.GU20518@dastard>
References: <1409848708-42666-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1409848708-42666-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 04, 2014 at 12:38:28PM -0400, Brian Foster wrote:
> xfsdump encodes and stores the full atime and mtime for each file with
> nanosecond resolution. xfsrestore uses utime() to set the times of each
> file that is restored. The latter supports resolution of 1 second, thus
> sub-second timestamp data is lost on restore.

That doesn't seem like a big deal. What sort of problems does this
actually cause?

FYI, many linux filesystems only have second resolution timestamps
and hence applications can't rely on sub-second timestamp resolution
to actually mean anything useful....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
