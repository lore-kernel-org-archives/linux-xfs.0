Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 420667CA0
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2016 17:55:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC9308F8033
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2016 15:55:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	sMVm6rgEa9ggZsNO for <xfs@oss.sgi.com>;
	Sun, 28 Aug 2016 15:55:03 -0700 (PDT)
Date: Mon, 29 Aug 2016 08:55:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Make __xfs_xattr_put_listen preperly report errors.
Message-ID: <20160828225501.GJ19025@dastard>
References: <1471967653-2561-1-git-send-email-asavkov@redhat.com>
	<20160824015551.GB19025@dastard>
	<20160824080833.GA11104@shodan.usersys.redhat.com>
	<20160825002408.GC19025@dastard>
	<20160825082109.GB11104@shodan.usersys.redhat.com>
	<20160825224215.GF19025@dastard>
	<20160826085928.GA15715@shodan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160826085928.GA15715@shodan.usersys.redhat.com>
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
To: Artem Savkov <asavkov@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Aug 26, 2016 at 10:59:28AM +0200, Artem Savkov wrote:
> On Fri, Aug 26, 2016 at 08:42:15AM +1000, Dave Chinner wrote:
> > So when I look at the fix, and see that it doesn't reproduce on my
> > systems, it's clear that it's either not yet fully understood or
> > hasn't been fully explained by the person who understands the issue.
> > These are some of the questions I've asked myself to understand why
> > we are seeing what we've been seeing:
> > 
> > 	- what condition in the unfixed code leads to the ASSERT
> > 	  being tripped?
> > 	- how does the patch prevent that from occurring?
> > 	- at what threshold does the problem trigger (i.e. n=0, n=1,
> > 	  n=2 .... ?)
> > 	- how do the environmental initial conditions affect the
> > 	  test being run?
> > 	- what do security layers automatically store in the inode
> > 	  at creation time?
> > 	- how can we modify the test to always trigger the assert?
> > 
> > I know the answer, and it would take much less time to tell everyone
> > that it does to write an email like this.  But that means I'll just
> > have to do the same thing next time, and the next time, and so on.
> > The more people we have that can think through issues like this and
> > come to the right conclusion without needing my help, the better off
> > we'll all be...
> 
> Fair enough.
> 
> The problem only shows itself with a minimum of 2 xattrs and only when
> the buffer gets depleted before the last one.

This sentence needs to be in the commit description. :P

> LTP's llistxattr02 test
> only sets one xattr, but on my testsystem "security.selinux" attribute
> is automatically added on file creation which allows this bug to be
> reproduced. So I would assume that on your systems there are no
> automatically created xattrs and thats why you can't reproduce this.

On /some/ of my systems. I have a mix of selinux enabled/disabled
test machines, precisely because of the way always having an
attribute fork in the inode can perturb test results. I happened to
try to reproduce this on a machine that doesn't have selinux
enabled....

> Furthermore if buffersize is such that it is enough to hold the last
> xattr's name, but not enough to hold the sum of preceeding xattrs
> listxattr won't fail with ERANGE, but will suceed returning that xattr's
> name without the first character. The first character end's up
> overwriting whatever is stored at (context->alist - 1).

That should probably also be in the commit description - that
way when we have an idea of what problems it fixes when trying to
match upstream fixes to problems with older kernels (e.g. for distro
kernel backports).

Yes, I know it's a lot to put in a commit message, but in a couple
of years time nobody will remember these details. We regularly have
to work out why something was done 10-15 years ago in the code base,
and having good commit messages makes this a much easier job.
Someone like me will thank you in future for writing a comprehensive
commit message for a relatively simple bug fix....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
