Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1BMtm076927 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:11:23 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76DB51C7CEF8
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:13:03 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	W7WlAjmYb4gt8D5w for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:13:03 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	47946204-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 11:43:01 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMsIT-0000ac-Ju
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:12:49 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMsIE-0005Ui-7Y
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:12:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8] xfs: AIL lock contention reduction V2
Date: Mon, 29 Nov 2010 12:12:24 +1100
Message-Id: <1290993152-20999-1-git-send-email-david@fromorbit.com>
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

This series reduces AIL locking overhead by introducing bulk operations for
insert and delete. With delayed logging, we can be doing insert operations on
thousands of items at a time, so using a bulk operation to reduce AIL lock
traffic is a major win in terms of reducing contention on the lock.

Similarly, when we have inode buffer IO completion running on multiple CPUs at
once, the AIl lock contention from each individual AIL removal is significant.
By batching all the inodes on the buffer to be removed from the AIL in a single
bulk operation, contention on the AIL is reduced by an order of magnitude.

Finally, there is a modification to the xfsaild wakeup code to prevent too many
wakeups when the xfsaild is pausing waiting for some work to complete. This
prevents an excessive number of AIL scanning traversals by the xfsaild when
tail pushing is backing off and waiting for some IO to complete.

In combination, these modification reduce AIL lock contention sufficiently
to drop the AIL lock out of the "top 10" contended locks on 8-way fs_mark
and dbench workloads.

Version 2:

- split out stale inode AIL insertion bug fix
- split bulk AIL insertion into multiple patches
	- EFI/EFD handling changes
	- stale inode AIL insertion bug fix
	- simplify code calling xfs_ail_delete
	- bulk ail insertion modifications
- use atomic_inc_return for extent recording in xfs_trans_log_efi_extent()
- modified AIL sleep code to explicitly set task state as suggested by Christoph.
- split AIL bulk deletion into two patches
	- buffer iodone callback modifications
	- bulk AIL deletion and inode iodone callback mods.
- removed lip parameter from xfs_buf_do_callbacks() as the loop fetches
          it from the buffer anyway.
- fixed unused variable warning in xfs_buf_do_callbacks().
- added two new patches to reduce code duplication
        - use AIL bulk insertion function to implement single updates
        - use AIL bulk delete function to implement single deletes

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
