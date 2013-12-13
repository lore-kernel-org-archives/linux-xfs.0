Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E3FC7F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 16:44:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EFA8E304051
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 14:44:49 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Eu6PjCwjviETbshD for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 14:44:32 -0800 (PST)
Date: Sat, 14 Dec 2013 09:44:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Handling of reviewed patch series
Message-ID: <20131213224421.GY10988@dastard>
References: <20131213053611.GQ10988@dastard>
 <52AB0EC1.4000500@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52AB0EC1.4000500@redhat.com>
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

On Fri, Dec 13, 2013 at 08:42:25AM -0500, Brian Foster wrote:
> On 12/13/2013 12:36 AM, Dave Chinner wrote:
> > Hi folks,
> > 
> ...
> > What I'd like to do is publish each of the reviewed branch in the
> > XFS git repos on oss.sgi.com as completed and ready-to-go code. This
> > is a bit different to what we do now - normally Ben would come along
> > and merge the series straight into the master branch, then update
> > the for-next branch to point at it.
> > 
> > The issue with this is that it then makes our lives more difficult
> > when we get a bug fix that has to go into the master branch and be
> > sent to linus for an -rc kernel before all the development code that
> > is already checked into the master branch.
> > 
> > What I propose is that the xfs-oss/master branch tracks the Linus
> > -rc1 releases, and we never check code directly into the master
> > branch except in exceptional circumstances. i.e.  we try to only
> > ever pull back down from Linus into it. Exceptional circumstances
> > would be work that causes widespread rebasing, like all of the
> > structural rework that we've done recently. The structural work
> > would go into the master branch immediately after a -rc1 update, and
> > the next cycle's work and topic branches then based on top of that.
> > 
> > What this means is that the "for-next" branch is no longer based
> > on the master branch - it becomes the development branch we work on,
> > and is effectively a merge of all the topic branches. i.e like the
> > -next tree, it is a branch that can be rebased without impacting the
> > history of the code in the topic branches because it's just a merge
> > target.
> > 
> 
> Is the merge of a topic branch into the for-next branch a maintainer
> duty formality here, or another "phase" we're introducing into the
> development process? IOW, a developer submits patches and said patches
> are reviewed and merged into a topic branch. What/when/how is said topic
> branch merged into the for-next for impending upstream merge?

It's purely a maintainer thing. Instead of committing the reviewed
series to the master branch, it gets pushed to a topic branch, and
then the topic branch is merged into the for-next branch soon after.

So, really, you don't even need to know that the topic branch exists
;)

> I don't see the existence of such branches as a big issue. In fact, it
> would be nice to see a sort of a high/feature level index of what kind
> of things are outstanding for a release, or to be able to narrow down a
> regression into a particular set, etc. A more granular workflow doesn't
> necessarily hurt if the maintainer(s) see it as worth the extra steps.

Quite a few maintainers use this workflow as it means we don't have
to fix the order of the code that is to be send to Linus weeks
before the merge window. The code is in the repository and so when
it was committed is recorded and that is maintained across merges.
Hence Linus can see that the code has been in the repo well before
the merge window and hence been subject to -next testing.

The win from the maintainer POV is that we can send bug fixes to
Linus in the -rc window without having to cherry pick bug fix
patches out of a fixed history in the master branch - we just get
linus to pull the fix directly, and then rebase the for-next branch
by merging those bug fix topic branches first..

> On the flipside, topic branches alone make it harder for a
> non-maintainer to actually test the whole of a release. Is it up to the
> developer to merge all of the topic branches to actually test everything
> and actively maintain that relationship as things change on the
> maintainer end? Or are these patches pulled into a topic branch and
> merged onto for-next at the same time?

No, what it means is that if you want the current dev tree, you work
from the for-next branch rather than from the master branch.

Ideally, developers work against and send patches against the master
branch rather than the for-next branch, but test against the
for-next branch. To demonstrate, here's my typical workflow (the way
I use guilt to manage individual feature branchs is ommitted here):

# add XFS repo as a remote to a cloned Linus tree
$ git remote add xfs-oss git://oss.sgi.com/xfs/xfs
$ git remote update
....

# create permanent test branch
$ git checkout -b testing xfs-oss/for-next
....

# create a new feature branch
$ git checkout -b feature1 xfs-oss/master
....
$ git commit
$ <build for feature test cycle>

# Integration testing:
$ git checkout testing
$ git reset --hard xfs-oss/for-next
$ git merge feature1
$ git merge feature2
....
$ git merge featureN
$ <build and test>

# bug fixes needed
$ git checkout feature1
<do work, build, test>
$
# Integration testing, need to reset branch to remove previous state
$ git checkout testing
$ git reset --hard xfs-oss/for-next
$ git merge feature1
$ git merge feature2
....

And so the cycle goes. This is how I keep several different lines of
development separate at the same time, yet I'm easily able to test
them all together. You can also see how quickly and easily
integrating 3rd party patches from the mailing list is when they are
based on the master branch:

$ git checkout -b tmp xfs-oss/master
$ git am hch-log-format
....
$ git checkout -b tip-log-format xfs-oss/master
$ guilt init
$ guilt import-commit xfs-oss/master..tmp
$ git branch -d tmp
$ <use guilt to walk patches, build test each, add s-o-b and commit>

# now I have a complete 3rd party branch, test:

# Integration testing:
$ git checkout testing
$ git reset --hard xfs-oss/for-next
$ git merge guilt/tip-log-format
$ git merge feature1
....
$ <build, test>

3rd party patchset good, so the only extra thing I need to do now to
make it available for everyone else is this:

$ git checkout -b for-next xfs-oss/for-next
$ git merge guilt/tip-log-format
$ <build, smoke test>
$ git push .... guilt/tip-log-format:tip-log-format
$ git push .... for-next:for-next
$ guilt branch -d for-next

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
