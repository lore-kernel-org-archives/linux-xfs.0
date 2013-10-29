Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C89CC7F3F
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 17:05:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B8D288F8040
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 15:05:45 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EZSYbahtLHGqdVuo for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 15:05:41 -0700 (PDT)
Date: Wed, 30 Oct 2013 09:05:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: linux-3.12 userspace Take 2
Message-ID: <20131029220537.GB6188@dastard>
References: <526A6FF9.8000506@sgi.com>
 <526EE7CF.7090603@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <526EE7CF.7090603@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Oct 28, 2013 at 05:40:15PM -0500, Rich Johnston wrote:
> Hey Folks,
> 
> Sorry for any confusion, let me try again.
> 
> In preparation for the new userspace release, are there any outstanding
> userspace patches that should be marked as critical and hold up the new
> userspace release?

If you are talking about 3.2.0, then we are not yet even ready for a
beta release as xfs_repair is not yet fully complete. There's still
a siginificant amount of work needed to complete that. e.g:

	- dirent ftype check/repair/rebuild
	- repair throws CORRUPTION_ERROR output from verifiers on
	  broken filesystems instead of detecting and handling it
	- repair doesn't check for CRC errors and consider them an
	  error that needs fixing at all
	- log zeroing invalidates all the metadata LSNs in the
	  filesystem, so we need to track the maximum LSN in
	  filesystem metadata and write a dummy record into the
	  log with that in it if we've zeroed the log

There's a few other bits of new metadata that aren't fully
validated/repaired, either, so there's still a bunch of
infrastructure and repair work to be done before we can release a
3.2.0 package. I'd say there's at least 50-100 patches in the above
work still to be done....

> Code shared by userspace and kernelspace are committed by different
> maintainers, I propose we discuss how to make it clear which patch
> series are tied together.

Yes, I do that already.

> This would aid reviewers and testers also.
> 
> 	One thought is to state in the kernel [PATCH 0/XX] email body
> 	something like:
> 		This kernel series shares the same headers as the
> 		userspace series "NAME OF USERSPACE SERIES"
> 
> 	and a similar email for the userspace series.

e.g. from the last xfs_db write series I posted:

"The first part of the patch series fixes a couple of minor bugs,
followed by syncing up with the kernel code to match the series I
just posted for 3.13. This is necessary for CRC support in xfs_db."

http://oss.sgi.com/archives/xfs/2013-09/msg00805.html

> 	The second commit should contain the first series commit id to
> 	tie them together.

Extracting commit ids from a different repository and then
matching and adding them to patch headers individually is a painful,
painful process. If the reviewers can't run a "git log" command
themselves to check that the patch is in the kernel code, then I'd
say they simply aren't qualified to review the code in the patch....

> Userspace patch series will be committed when the entire patch
> series has been reviewed.  Partial series commits will happen only
> with the authors approval (confirmation posted to the list).

Use your discretion. If a patch series is made up of "sync to kernel
code" and "add new functionality", then the first "sync to kernel
code" part can be committed before the "add new functionality" part
has been fully reviewed.  If you are not sure, ask on the list.  It
doesn't matter if the author doesn't respond - someone else can say
"yes, makes sense to commit that portion"...

However, this does not address the root cause of the problems that
have lead to this discussion. It's the same problem we've had for
the past year - patches sitting around for weeks or months before
anyone other than me looks at them.

That's the real problem here - it's now 8 weeks since code that is a
blocker for a 3.2.0 release was first posted, and not a single
comment has been made about it. All this talk about kernel/userspace
syncing is just a side show - it's never been a major issue before
and it's not a major issue now. What is a major issue is that code
is going unreviewed for weeks/months on end and we've been having
this problem for at least a year now.

So let's try to address the real problem that needs solving here -
getting patches reviewed and committed *promptly*. We don't need
more process overhead to accomplish that - we need people to
actually put time into reviewing code quickly and we need
maintainers that commit reviewed patch series just as quickly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
