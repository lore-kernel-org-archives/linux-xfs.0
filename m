Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6RNOIL5216094 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 18:24:19 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E8881638B66
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 16:27:22 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	LpKQ2mWsLwtNrsaT for <xfs@oss.sgi.com>;
	Tue, 27 Jul 2010 16:27:22 -0700 (PDT)
Date: Wed, 28 Jul 2010 09:27:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Master Branch Rebase
Message-ID: <20100727232719.GR7362@dastard>
References: <1280247366.2002.111.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280247366.2002.111.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 27, 2010 at 11:16:06AM -0500, Alex Elder wrote:
> Some recent commits have resulted in changes to
> the XFS master branch that result in non-trivial
> merges, which are not something we want to have in
> our git history.  (I didn't realize this when I
> pushed my last set of updates out, unfortunately.)
> 
> To remedy this, I'm have re-based the XFS master
> branch on oss.sgi.com against v2.6.35-rc6.

<groan>

Alex, this is a bit annoying. Rebases are a real pain for anyone
downstream that is using git in non-trivial ways. I'll give you an
idea of what this means to me - for the xfs tree directly:

	- bare repository on kernel.org I have to fix
	- local bare repo pulled from kernel.org I have to fix
	- local working repo I have to fix with about 10 separate
	  working branches that I have now have to rebase
	- run garbage collection on all repos

And for the for-2.6.36 branch of my xfsdev.git tree on kernel.org
(which I've been careful not to require rebasing as the OSS tree has
gained more commits):

	- all the commits in that branch are stale, so the branch
	  has to be destroyed (in 3 repos)
	- remove any branch based on for-2.6.36 in 2 bare repos
	- recreate a new branch and pull the new xfs tree commits
	  into it and push it back out to bare repos
	- rebase another ~10 local working branches based on the
	  for-2.6.36 branch and push them back out
	- restage all the pending commits that I hadn't pushed out
	  on that branch yet.
	- run garbage collection on all repos

And to top that all off - I know that people have pulled branches
from this tree that are based on for-2.6.36, so they are going to
get problems when trying to update them again. i.e. an upstream
rebase triggers problems for users downstream of my repo, not just
the direct downstream of the OSS repo....

....

> If you have a different branch checked out, you
> can do this instead to force the re-based commits
> to land in your "xfs-master" branch:
>     git pull git://oss.sgi.com/xfs/xfs.git +master:xfs-master

You don't want to do this - the forced merge causes a branch in
history in the local repository and hence it's no longer an
identical copy of the upstream repository any more. I got caught by
this on a previous rebase when I started pushing commits back out
and people tried to pull them...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
