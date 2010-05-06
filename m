Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o46DOphc095183 for <xfs@oss.sgi.com>; Thu, 6 May 2010 08:24:51 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1434B315364
	for <xfs@oss.sgi.com>; Thu,  6 May 2010 06:26:45 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	2xShjUvp74Qve0e2 for <xfs@oss.sgi.com>;
	Thu, 06 May 2010 06:26:45 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	23594965-1927428
	for <xfs@oss.sgi.com>; Thu, 06 May 2010 22:56:43 +0930 (CST)
Received: from dave by dastard with local (Exim 4.71)
	(envelope-from <david@fromorbit.com>) id 1OA169-0005qI-VT
	for xfs@oss.sgi.com; Thu, 06 May 2010 23:26:42 +1000
Date: Thu, 6 May 2010 23:26:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/11] xfs: delayed logging
Message-ID: <20100506132641.GC19579@dastard>
References: <1273110351-2333-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1273110351-2333-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Thu, May 06, 2010 at 11:45:40AM +1000, Dave Chinner wrote:
> 
> Hi Folks,
> 
> This is version 4 of the delayed logging series.
> 
> I won't repeat everything about what it is, just point you
> here:
> 
> http://marc.info/?l=linux-xfs&m=126862777118946&w=2
> 
> for the description, and here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git delayed-logging
> 
> for the current code. Note that this is a rebased branch, so you'll
> need to pull it again into a new branch to review.
> 
> This version includes a number of fixes and cleanups related to the
> busy extent tracking. This includes fixing a long standing
> off-by-one that was causing assert failures when inserting busy
> extents that overlapped with existing busy extents.

Ok, so I'm still getting assert failures, but they are much harder
to hit. However, here's the fragment of a trace that points out why
delayed logging is now tripping over this problem:

$ grep _busy: t.t |tail -20|cut -d ":" -f 2-
xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0xa9a1ac8d agno 1 agbno 133 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0xa9a1ac8d agno 1 agbno 24 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0xa9a1ac8d agno 1 agbno 91909 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0xa9a1ac8d agno 1 agbno 75 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0xfe95d7e3 agno 1 agbno 100504 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0xfe95d7e3 agno 1 agbno 100505 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0xfe95d7e3 agno 1 agbno 100506 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0xfe95d7e3 agno 1 agbno 100507 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0xfe95d7e3 agno 1 agbno 100508 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0xfe95d7e3 agno 1 agbno 100509 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff880067c42da0 tid 0xbe3d9ca6 agno 0 agbno 37809 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff880067c42da0 tid 0x4575b77f agno 2 agbno 133387 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff880067c42da0 tid 0xeb882f7e agno 2 agbno 151935 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff880067c42da0 tid 0x362c7c31 agno 2 agbno 133386 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff880067c42da0 tid 0x4dda728f agno 2 agbno 151936 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff880067c42da0 tid 0xc1ca9675 agno 3 agbno 49832 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff880067c42da0 tid 0x8a3e0a41 agno 3 agbno 49833 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff880067c42da0 tid 0x3fe9fb72 agno 1 agbno 109637 len 1 async
xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0x69f15b1c agno 1 agbno 91909 len 1 async

First thing to note is that there are only two different addresses
for transaction structures here, but there are 11 different
transaction IDs. That's a bit of a problem, really. The assert fail
was triggered by the last line:

xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0x69f15b1c agno 1 agbno 91909 len 1 async

Which appears to have already been marked busy by a different
transaction earlier on:

xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0xa9a1ac8d agno 1 agbno 91909 len 1 async

If I just pull out the last operations on that block:

$ grep "agno 1 agbno 919" t.t |tail -5
         fs_mark-2741  [007] 795063.752648: xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0xa9a1ac8d agno 1 agbno 91909 len 1 async
         fs_mark-2742  [005] 795063.754591: xfs_alloc_busysearch: dev 253:16 agno 1 agbno 91909 len 1 found
         fs_mark-2745  [007] 795063.775012: xfs_alloc_busy: dev 253:16 trans 0xffff8801067eada0 tid 0x69f15b1c agno 1 agbno 91909 len 1 async
       xfslogd/4-497   [004] 795063.775540: xfs_alloc_unbusy: dev 253:16 agno 1 agbno 91909 len 1
       xfslogd/4-497   [004] 795063.775542: xfs_alloc_busysearch: dev 253:16 agno 1 agbno 91909 len 1 found

We can see that there are two separate processes marking the same
extent busy, using the same transaction structure address. But they
have to be two different transactions, because a transaction is
always done in the context of a single kernel thread.  i.e:

	fs_mark-2741	fs_mark-2742	fs_mark-2743	xfslogd
	xact alloc
	free 1:91909
	mark busy
	commit xact
	free xact
			xact alloc
			alloc 1:91909
			busy search
			mark xact sync
			commit xact
			free xact
			force log
			checkpoint starts
			....
					xact alloc
					free 1:91909
					mark busy
					finds match, not sync
					*** KABOOM! ***
					....
							log IO completes
							unbusy 1:91909
			checkpoint completes

So, now I think I can explain the causes of that assert failure.
Firstly, the off-by one I found this morning in the search code
which would trigger for both delayed and normal logging modes.  This
had nothing to do with transaction commits and lifecycles, just a
search failing to set the transaction synchronous when it should
have.

Secondly, for delayed logging only, matching by transaction
structure address triggers the failure because busy extents
have a much longer life than the transaction structure. It is clear
why the transaction ID matching didn't trip over - it would have
triggered a log force in this situation, and hence blocked until
the checkpoint that fs_mark-2742 had triggered was complete before
redoing the rbtree insert.

Right now I'm simply going to go back to using the transaction ID
for matching transactions, even though the above analysis points out
that even that is not as efficient as it could be for delayed
logging. That is, we don't even need to force the log or have a
synchronous transaction if the extent was first freed in the current
checkpoint seqeunce. Doing that, however, requires pinning the
checkpoint sequence (i.e. preventing a flush) until the current
transaction commits. While that is in the plan for delayed logging,
it is future functionality and hence I'm not going to attempt to
design and implement it this close to 2.6.35-rc cycle. [*]

Christoph - does this answer all your concerns with the busy extent
tracking modifications, or is there still something that are left
unexplained?

Cheers,

Dave.

[*] Checkpoint pinning is needed to implement atomic
multi-transaction operations such as "create with attribute".
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
