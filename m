Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A5947F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 03:56:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C2703040DA
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 01:56:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	NIABCzuBTWqV2glT for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 01:56:23 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wk8VV-0000JV-TV
	for xfs@oss.sgi.com; Tue, 13 May 2014 18:56:17 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wk8VV-0001kU-SG
	for xfs@oss.sgi.com; Tue, 13 May 2014 18:56:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/9] xfs: error sign fixes for 3.15-rc6
Date: Tue, 13 May 2014 18:56:04 +1000
Message-Id: <1399971373-6242-1-git-send-email-david@fromorbit.com>
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

I've been working through the mess that is the
error sign impedance mismatch between the core XFS code and the rest
of the kernel. I'm about half way through the codebase, and I've
found a bunch of incorrect error signs throughout the VFS interface
layers.

These were effectively all found by inspection, and is
further evidence that we need to convert all of XFS to negative
errors as quickly as possible. It is clear that we are missing these
on review, and changes made by developers adding functionality to
the VFS and hence just touching the outer layers of XFS are
simply not aware of these issues in the first place.

This patchset is based on v3.15-rc5 because some of the problems that
need to be fixed have merged into mainline via the ext4 tree
(COLLAPSE_RANGE changes). Hence I'll need to update the master
branch of the XFS tree to v3.15-rc5 before I merge these and push
them to Linus. I'm considering them as important fixes as things
like xfs_dir_fsync() and xfs_commit_metadata() returning incorrect
errnos mean data integrity operation failures may not be detected
correctly by applications.....

Comments, thoughts, testing all welcome!

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
