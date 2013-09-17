Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF7897F4E
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 20:44:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CDFB0304048
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 18:44:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	33mfnALEHZEBHnj7 for <xfs@oss.sgi.com>;
	Mon, 16 Sep 2013 18:44:36 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VLkLB-00069i-MW
	for xfs@oss.sgi.com; Tue, 17 Sep 2013 11:44:33 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VLkLB-0007p3-Le
	for xfs@oss.sgi.com; Tue, 17 Sep 2013 11:44:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: fixes for 3.12-rc2
Date: Tue, 17 Sep 2013 11:44:28 +1000
Message-Id: <1379382271-29907-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

Three patches for 3.12-rc2. The first has been posted previously,
and prevents an assert failure during a shutdown while zeroing space
with an uncached buffer.

The second patch is to fix a regression introduced in the 3.12 merge
by commit 46f9d2e ("xfs: aborted buf items can be in the AIL").

The third is fixing a thinko made a long time ago when adding RCU
freeing to the struct xfs_inode, but has only been exposed by the
recent merge of the per-node LRUs and shrinkers allowing concurrent
reclaim and lookup races to be hit easily. The RCU traversals of the
inode radix trees take the lock on the inode to determine if it is
being freed or not, and so that can race with freeing of the inode.
Hence we can't assert that the lock is not held when freeing the
inode.

These all fix regressions triggered by xfstests....

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
