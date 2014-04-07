Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5FC5F8004
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 18:29:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F0ED2AC012
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 16:29:01 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	MgfFZNFMMMbuyWTs for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 16:28:49 -0700 (PDT)
Date: Tue, 8 Apr 2014 09:28:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/19] xfs: remove a bunch of unused function args
Message-ID: <20140407232846.GE27017@dastard>
References: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 07, 2014 at 02:58:47PM -0500, Eric Sandeen wrote:
> I did some mindless work during a plane ride.  ;)
> 
> If the granularity of these patches is just too much, I could certainly
> collapse them into fewer, bigger patches, but I figured that this would
> make them super-trivial to review.
> 
> Most have no interesting commit messages aside from the subject, because
> the subject says it all.
> 
> Compile-tested only, TBH.

Looks good, except for the patch I specifically commented on.

FWIW, this sort of cleanup will help reduce some of the register
pressure these code paths have, and that in turn will help reduce
stack usage, so if you can find more...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
