Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BED8D7F50
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:59:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9B23E8F8071
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 03:59:38 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SjeLAPcLaVYPqRpj for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 03:59:35 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YaMYY-0002sX-1U
	for xfs@oss.sgi.com; Tue, 24 Mar 2015 21:59:34 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YaMYY-00012z-0b
	for xfs@oss.sgi.com; Tue, 24 Mar 2015 21:59:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5 V2] xfs: RENAME_WHITEOUT support
Date: Tue, 24 Mar 2015 21:59:26 +1100
Message-Id: <1427194771-3105-1-git-send-email-david@fromorbit.com>
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

This is the second version of the RENAME_WHITEOUT patchset that I
originally posted here:

http://oss.sgi.com/pipermail/xfs/2015-February/040378.html

This is mainly the breakup and restructuring of the patchset I
mention that needed to be done, as well as addressing the comments
that were made at the time (e.g. wino -> wip).

The patchset has been split into 5 patches, the first four are
really cleanup and factoring patches to make the rename and inode
locking code a bit simpler and easier to understand. The last patch
then introduces the RENAME_WHITEOUT functionality, which ends up
being surprisingly little code....

The changes pass xfstests, but I have not run them on overlayfs at
all yet, so I don't know if that's going to result in smoke and
tears yet. Still, getting the patch set out for review now is more
important that waiting for testing because there is relatively
little time left before the 4.1 merge window opens up....

So, comments, thoughts and flames are more than welcome.

-Dave.

Diffstat:

fs/xfs/xfs_inode.c | 408 ++++++++++++++++++++++++++++++++-----------------------
fs/xfs/xfs_iops.c  |   2 +-
2 files changed, 239 insertions(+), 171 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
