Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 947A77FBD
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 15:04:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 377C3AC002
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 13:04:48 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DxEWIceWHCbWz2m3 for <xfs@oss.sgi.com>;
	Wed, 04 Feb 2015 13:04:41 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YJ77c-0003G4-5X
	for xfs@oss.sgi.com; Thu, 05 Feb 2015 08:04:28 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YJ77c-0007XM-4L
	for xfs@oss.sgi.com; Thu, 05 Feb 2015 08:04:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6 V2] xfs: introduce mmap/truncate lock
Date: Thu,  5 Feb 2015 08:04:13 +1100
Message-Id: <1423083859-28439-1-git-send-email-david@fromorbit.com>
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

This is the second version of the mmap/truncate lock patchset I
first posted here:

http://oss.sgi.com/archives/xfs/2015-01/msg00129.html

The concensus was that this problem should initially be fixed in the
filesystem rather than the VFS due to the limited support of
hole punching in filesystems, so the patch is mostly unchanged from
the first version. The only changes have been to address the issues
that Brain pointed out during review.

The patchset has been used in all my testing since the first version
was posted, and most of that has been with lockdep enabled. I have
not had lockdep trip over anything other than already known issues
in xfstests and various stress loads that I've run, so I think this
is good to go.

Comments, thoughts?

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
