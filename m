Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ED45C7F6C
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 01:09:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D66408F8068
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 23:09:51 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rGgsRnzHmeOxSWN3 for <xfs@oss.sgi.com>;
	Mon, 09 Jun 2014 23:09:49 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WuFFg-0005zY-H6
	for xfs@oss.sgi.com; Tue, 10 Jun 2014 16:09:44 +1000
Date: Tue, 10 Jun 2014 16:09:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [DISCUSS] Planning for new dev cycle (3.17)
Message-ID: <20140610060944.GG9508@dastard>
References: <20140609223320.GE9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140609223320.GE9508@dastard>
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
To: xfs@oss.sgi.com

On Tue, Jun 10, 2014 at 08:33:20AM +1000, Dave Chinner wrote:
> Hi everyone,
> 
> Now that the 3.16 dev cycle has drawn to a close (one more
> linux-next build and I'll tag for-next and send a pull request),
> it's time to look ahead for the next couple of months. I think the
> current major pieces of work that are currently outstanding are
> these:
> 
> 	- Jeff's bulkstat rework
> 	- Brian's EOF prealloc scanning
> 	- Namjae's FALLOC_FL_INSERT_RANGE work
> 	- Eric's XFS_ERROR() macro removal and return () cleanup.
> 
> There's also two major pieces of infrastructure work I'd like to get
> done:
> 
> 	- convert XFS to negative error returns
> 	- restructure code to have a fs/xfs/libxfs structure similar
> 	  to userspace
> 
> Because Eric's XFS_ERROR removal touches the entire codebase, as
> does the negative error return and the libxfs restructuring, I'd
> like to get these done first and base the rest of the dev cycle work
> on top of that. Eric's patches just need a minor rebase and the
> libxfs restructure needs some makefile rework and review and they
> should be good to go.

There is a new version of this work (Eric's patches and the base
libxfs restructure) here:

	git://oss.sgi.com/xfs/xfs.git xfs-libxfs-restructure

It's based on 3.15 with the current for-next branch merged into it
and then the changes done over the top, so it's about as up-to-date
as it can be. Comments welcome...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
