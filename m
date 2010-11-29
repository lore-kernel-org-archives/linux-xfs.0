Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT11BfW075619 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:01:12 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69CAA1AF7B8
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 16:59:20 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	E6nCRdqZ36paELwb for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 16:59:20 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	47772514-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 11:29:19 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMs5O-0000Yy-08
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 11:59:18 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMs58-0005Re-Lj
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 11:59:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: buffer cache shrinker overhaul V2
Date: Mon, 29 Nov 2010 11:58:56 +1100
Message-Id: <1290992339-20849-1-git-send-email-david@fromorbit.com>
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

This series adds a per-filesystem LRU to the buffer cache. When
combined with a shrinker per filesystem, this enables us to
prioritise reclaim of buffers under memory pressure. This solves the
current problem of page cache reclaim having no concept of what the
pages actually contain in deciding which pages to reclaim.

The LRU is lazily updated, meaning that we only access the LRU
lists and locks when the last reference to a buffer goes away. As a
result, there is no impact to the hot buffer lookup path and we are
not constantly moving buffers around in the LRU.

This series effectively means that the buffer cache can now be made
independent of the page cache as we now have our own optimised
buffer cache reclaim mechanisms.

Version 2:

- removed buffer lru addition during xfs_buf_find() as it is done
  lazily on the last reference going away.
- removed buffer type additions and used the existing macro to just
  set the reference value.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
