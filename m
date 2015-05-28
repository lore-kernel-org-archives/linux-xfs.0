Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3C2627F51
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 18:46:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 296848F8052
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 16:46:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jkH8cirzXzObmcuv for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 16:46:07 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Yy7Uy-0006cn-80
	for xfs@oss.sgi.com; Fri, 29 May 2015 09:46:04 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Yy7Uy-00024D-6m
	for xfs@oss.sgi.com; Fri, 29 May 2015 09:46:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8 v3] xfs: DAX support
Date: Fri, 29 May 2015 09:45:47 +1000
Message-Id: <1432856755-7859-1-git-send-email-david@fromorbit.com>
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

v3 of the patch set, with the review fixes to patches 4 and 5 having
been made and tested. I've only posted this to the XFS list, as all
the other patches have been acked/reviewed and only the two XFS
patches still need review.

The patch passes xfstests on my ramdisk based test machines, as well
as quite a lot of fsstress and fsx testing.

V3 changes:
- swapped order of patches 4 and 5, as block zeroing has a
  dependency on the unwritten extent conversion infrastructure
  introduced in the file operations patch.
- added comments to xfs_iozero to indicate requirements for block
  allocation w.r.t. DAX.
- reworked file operations to use the new direct IO ioend completion
  infrastructure. This results in a mcuh cleaner patch as the DAX IO
  completion is now just a variant of the existing DIO completion
  code rather than being a unique snowflake.

Comments welcome.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
