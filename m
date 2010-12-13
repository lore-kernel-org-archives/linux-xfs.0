Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD4tJKI160432 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 22:55:19 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67ABB1CB786B
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 20:46:26 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	ciGzRQi1xHZpYbX7 for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 20:46:26 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	49641077-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 15:16:25 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PS0Ip-00022N-6B
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:46:23 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PS0HL-0004mD-0g
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:44:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: xfs: grant lock scaling and removal V3
Date: Mon, 13 Dec 2010 15:44:31 +1100
Message-Id: <1292215483-18224-1-git-send-email-david@fromorbit.com>
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

This series addresses the log grant lock contention seen by 8-way
fs_mark workloads. The log grant lock protects:

        - reserve grant head and wait queue
        - write grant head and wait queue
        - tail lsn
        - last sync lsn

While they are all currently protected by a single lock, there is no
reason that they need to all be under the same lock. As a result,
one option for scaling was simply to split the grant lock into three
locks - one for each of the above groups. However, this would mean
that we'd need to nest locks inside each other and it ignores the
fact that we really only use the lock on the tail and last sync lsn
variables to protect against concurrent updates.

Hence we can make the tail and last sync LSN variables independent
of the grant lock by making them atomic variables. This means that
when we are moving the tail of the log, we can avoid all locking
except when there are waiters queued on the grant heads.

Making the grant heads scale better is a bit more of a challenge.
Just replacing the grant lock with reserve and write grant locks
doesn't really help improve scalability because we'd still need to
take both locks in the hot xfs_log_reserve() path. To improve
scalability, we really need to make this path lock free.

The first steps aree to clean up some of the code. We convert the
ticket queues to use the common list_head infrastructure, factor out
some common debug code, refactor and rearrange the grant head
calculations code and convert all the users of the sv_t wait
mechanisms to use wait queues directly.

The second step to acheiving this is to encode the grant heads as a
64 bit variable and then convert it to an atomic variable. The
tail/last sync LSNs also get converted to atomic variables, and this
means we can read the grant heads without holding locks and that
allows tail pushing calculations and available log space
calculations to operate lock free.

The next step is to introduce a lock per grant queue that is used
exclusively to protect queue manpulations. With the use of
list_empty_careful() we can check whether the queue has waiters
without holding the queue lock. Hence in the case where the queues
are empty we do not need to take the queue locks in the fast path.

Finally, we need to make the grant head space calculations lockless.
With the grant heads already being atomic variables, we can change
the calculation algorithm to a lockless cmpxchg algorithm. This
means we no longer need any spinlocks in the transaction reserve
fast path and hence the scalability of this path should be
significantly improved.

There is one down side to this change - the xlog_verify_head() debug
code can no longer be reliably used to detect accounting problems in
the grant space allocations as it requires an atomic sample of both
grant heads. However, the tail verification and the
xlog_space_left() verification still works without problems, so we
still have some debug checking on the grant head locations.

Version 3:
- dropped cleanup of xlog_grant_log_space() and
  xlog_regrant_log_write_space().
- split grant head aggregation into multiple patches
	- split out xlog_verify_tail() function
	- factor grant head calculations and drop wrappers
	- combine grant heads and add wrappers to crack/combine
	  grant heads.
- removed intermediate grant head "_lsn" suffix name.
- folded all sv_t removal patches into one.
- don't pass tail and last sync lsn into xlog_grant_push_ail().
- ensure that shutdown checks in ticket queue processing are done
  consistently before sleeping.
- removed xlog_grant_verify_head()
- folded grant lock removal into patch that converts grant head
  manipulations to lockless algorithms.
- added a couple of tracepoints for when the log tail is moved and
  queued tickets are woken to aid debugging.

Version 2:
- split into lots of patches
- clean up the code and comments
- add patches to clean up sv_t usage at the end of the series

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
