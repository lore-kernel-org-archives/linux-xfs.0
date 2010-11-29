Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1bEMu082059 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:37:14 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EB481AE773
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:38:54 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	Cy7MkNYWtQAiBLxI for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:38:54 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	48055158-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 12:08:53 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMshf-0000dH-Br
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:51 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMshP-0005cG-Sh
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/14] xfs: grant lock scaling and removal V2
Date: Mon, 29 Nov 2010 12:38:18 +1100
Message-Id: <1290994712-21376-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This series addresses the log grant lock contention seen by 8-way fs_mark
workloads. The log grant lock protects:

	- reserve grant head and wait queue
	- write grant head and wait queue
	- tail lsn
	- last sync lsn

While they are all currently protected by a single lock, ther eis no reason
that they need to all be under the same lock. As a result, one option for
scaling was simply to split the grant lock into three locks - one for each of
the above groups. However, this would mean that we'd need to nest locks inside
each other and it ignores the fact that we really only use the lock on the
tail and last sync lsn variables to protect against concurrent updates.

Hence we can make the tail and last sync LSN variables independent of the grant
lock by making them atomic variables. This means that when we are moving the
tail of the log, we can avoid all locking except when there are waiters queued
on the grant heads.

Making the grant heads scale better is a bit more of a chanllenge. Just
replacing the grant lock with reserve and write grant locks doesn't really help
improve scalability because we'd still need to take both locks in the hot
xfs_log_reserve() path. To improve scalability, we really need to make this
path lock free.

The first step to acheiving this is to encode the grant heads as a 64 bit
variable and then convert it to an atomic variable. This means we can read
the grant heads without holding locks and that allows (in combination with the
above tail/last sync atomics) tail pushing calculations and available log space
calculations to operate lock free.

The second step is to introduce a lock per grant queue that is used exclusively
to protect queue manpulations. With the use of list_empty_careful() we can
check whether the queue has waiters without holding the queue lock. Hence
in the case where the queues are empty we do not need to take the queue locks
in the fast path.

Finally, we need to make the grant head space calculations lockless. With the
grant heads already being atomic variables, we can change the calculation
algorithm to a lockless cmpxchg algorithm. This means we no longer need any
spinlocks in the transaction reserve fast path and hence the scalability of
this path should be significantly improved. There is one down side to this
change - the xlog_verify_head() debug code can no longer be reliably used to
detect accounting problems in the grant space allocations as it requires an
atomic sample of both grant heads. However, the tail verification and the
xlog_space_left() verification still works without problems, so we still have
some debug checking on the grant head locations.

After all this, having converted the ticket queues to use generic wait queues
directly during the series, it seemed like a good idea to remove all the other
users of sv_t types in the log code. Hence there is three patches at the end to
do the conversion and remove the sv_t wrapper from the codebase completely.

Version 2:
- split into lots of patches
- clean up the code and comments
- add patches to clean up sv_t usage at the end of the series

Finally, there's a patch to split up the log grant lock. This needs splitting
into 4 or 5 smaller patches (as you can see it was originally from the commit
log). It splits the grant lock into two list locks (reserve and write queues),
and converts all the other variables that the grant lock protected into atomic
variables. Grant head calculations are made atomic by converting them into 64
bit "LSNs" and the use of cmpxchg loops on atomic 64 bit variables. All log
tail and sync LSNs updates are made atomic via conversion to atomic variables.
With this, the grant lock goes away completely, and the transaction reserve
fast path now only has two cmpxchg loops instead of a heavily contended spin
lock.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
