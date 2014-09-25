Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 25CD17FA6
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 07:34:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5653AC009
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 05:34:47 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	aD90h1U3RaxV9r4e for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 05:34:45 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XX8Fb-0006n8-Qs
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XX8Fb-0007gH-Pf
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/11 v2] xfs: clean up xfs_buf io interfaces
Date: Thu, 25 Sep 2014 22:34:10 +1000
Message-Id: <1411648461-29003-1-git-send-email-david@fromorbit.com>
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

This is an updated version of the patch set I first posted
here:

http://oss.sgi.com/archives/xfs/2014-08/msg00203.html

There are a few changes in the patchset as a result of review
comments and bugs that I found.

Version 2:
- change shutdown log force code so that the log IO is done before
  we mark both the filesystem and the log as being shut down.
  (prevents a godown regression in xfstests introduced by having
   xfs_buf_submit() check for shutdown)
- moved the delwri submission rework to the start of the patch set
- moved reference count fixups in error handling to the patch that
  introduced the new reference counting.
- dropped the xfs_trans_buf_read rework patch; it can be done at a
  later time after checking whether parts of the code are still
  needed or not.
- added Christoph's xfs_zero_remaining_bytes simplification
- reworked the error handling cleanups for xfs_buf_read_uncached
- updated several comments

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
