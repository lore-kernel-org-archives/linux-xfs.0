Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Oct 2008 15:39:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9QMdjX0013947
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 15:39:45 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09C55549293
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 15:39:45 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id SzLGpvIKDdKzqGwe for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 15:39:45 -0700 (PDT)
Date: Mon, 27 Oct 2008 09:39:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlock with latest xfs
Message-ID: <20081026223940.GN18495@disturbed>
References: <4900412A.2050802@sgi.com> <20081023205727.GA28490@infradead.org> <49013C47.4090601@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49013C47.4090601@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 24, 2008 at 01:08:55PM +1000, Lachlan McIlroy wrote:
> Christoph Hellwig wrote:
>> On Thu, Oct 23, 2008 at 07:17:30PM +1000, Lachlan McIlroy wrote:
>>> another problem with latest xfs
>>
>> Is this with the 2.6.27-based ptools/cvs tree or with the 2.6.28 based
>> git tree?  It does looks more like a VM issue than a XFS issue to me.
>>
>
> It's with the 2.6.27-rc8 based ptools tree.  Prior to checking
> in these patches:
>
> Can't lock inodes in radix tree preload region
> stop using xfs_itobp in xfs_bulkstat
> free partially initialized inodes using destroy_inode
>
> I was able to stress a system for about 4 hours before it ran out
> of memory.  Now I hit the deadlock within a few minutes.  I need
> to roll back to find which patch changed the behaviour.

Ok, I think I've found the regression - it's introduced by the AIL
cursor modifications. The patch below has been running for 15
minutes now on my UML box that would have hung in a couple of
minutes otherwise.

FYI, the way I found this was:

	- put a breakpoint on xfs_create() once the fs hung
	- `touch /mnt/xfs2/fred` to trigger the break point.
	- look at:
		- mp->m_ail->xa_target
		- mp->m_ail->xa_ail.next->li_lsn
		- mp->m_log->l_tail_lsn
	  which indicated the push target was way ahead the
	  tail of the log, so AIL pushing was obviously not
	  happening otherwise we'd be making progress.
	- added breakpoint on xfsaild_push() and continued
	- xfsaild_push() bp triggered, looked at *last_lsn
	  and found it way behind the tail of the log (like
	  3 cycle behind), which meant that would return
	  NULL instead of the first object and AIL pushing
	  would abort. Confirmed with single stepping.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

XFS: correctly select first log item to push

Under heavy metadata load we are seeing log hangs. The
AIL has items in it ready to be pushed, and they are within
the push target window. However, we are not pushing them
when the last pushed LSN is less than the LSN of the
first log item on the AIL. This is a regression introduced
by the AIL push cursor modifications.
---
 fs/xfs/xfs_trans_ail.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 67ee466..2d47f10 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -228,7 +228,7 @@ xfs_trans_ail_cursor_first(
 
 	list_for_each_entry(lip, &ailp->xa_ail, li_ail) {
 		if (XFS_LSN_CMP(lip->li_lsn, lsn) >= 0)
-			break;
+			goto out;
 	}
 	lip = NULL;
 out:
