Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 670AB7CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 04:23:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B13D4AC001
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 02:23:38 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	zLOmLPzp1O3LUina for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 02:23:33 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1anjgP-0004C2-1b
	for xfs@oss.sgi.com; Wed, 06 Apr 2016 19:23:29 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1anjft-0006id-Ua
	for xfs@oss.sgi.com; Wed, 06 Apr 2016 19:22:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] xfs; xfs_iflush_cluster vs xfs_reclaim_inode
Date: Wed,  6 Apr 2016 19:22:49 +1000
Message-Id: <1459934574-25543-1-git-send-email-david@fromorbit.com>
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

There is a problem that RHEL QE tripped over on a long-running
fsstress test on a RHEL 6.6. Brian did all the hard work of working
out the initial cause of the GPF that was being tripped, but
had not yet got past how to fix the issues around xfs_free_inode.
The code is the same as the current upstream code, so the problem
still exists....

The first patch fixes an obvious (now!) bug in xfs_iflush_cluster
where it checks the wrong inode after lookup for validity. It still
kind-of works, because the correct inode number is used for the "are
we still in the right cluster" check, so it's not quite a hole the
size of a truck. Still something that should not have slipped
through 6 years ago and not been discovered until now...

The most important patch (#4) address the use-after-free issues that the
xfs inode has w.r.t. RCU freeing and the lookup that
xfs_iflush_cluster is doing under the rcu_read_lock. All the
structures accessed under the RCU context need to be freed after the
current RCU grace period expires, as RCU lookups may attempt to
access them at any time during the grace period. hence we have to
move them into the RCU callback so that we don't free them
prematurely.

The rest of the patches are defensive in that they make
xfs_iflush_cluster only act on relevant inodes and be able to
guarantee detection inodes that are in the process of being freed.
While these aren't absolutely necessary, it seems silly to ignore
these obvious issues while I'm fixing up other issues with the same
code.

There's some more detail on the fixes in the commit descriptions.

Brian, I've only run this through xfstests, so I have no real idea
if it fixes the problem fsstress has uncovered. AIUI it takes 3 or 4
days to reproduce the issue so this is kind of a pre-emptive strike
on what I think is the underlying issue based on your description
and commentary. I figured having code to explain the problems would
save some time while you sleep....

Comments, thoughts, testing and flames all welcome...

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
