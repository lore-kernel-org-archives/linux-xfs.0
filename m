Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A3A0829E33
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 962288F8089
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:41 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Wrvr5oj3v66WaYD7 for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:37 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdraj-0003No-UV
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:29 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdraj-0008Tw-Ti
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/37 V4] xfsprogs: CRC write support for xfs_db + more
Date: Wed,  6 Nov 2013 12:06:46 +1100
Message-Id: <1383700043-32305-1-git-send-email-david@fromorbit.com>
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

Many thanks to Christoph for reviewing V3 of this patchset, which
was posted here:

V3: http://oss.sgi.com/archives/xfs/2013-10/msg00914.html

The series was described in the V2 posting here:

V2: http://oss.sgi.com/archives/xfs/2013-09/msg00805.html

Changes made since V3:
- moved LIBXFS_MOUNT_ROOTINOS removal patch to start of xfs_db
  series
- performance tested and reviewed Christoph's icache removal patch
  and added it before start of xfs_db series
- split several of the patches up into independent changes
- updated the commit message for the first step of the xfs_db libxfs
  conversion
- updated comments as requested by Christoph

Unrelated new patches at end of series:
- xfs_repair speedups that I wrote to speed up large filesystem
  testing. These reduce the default configuration repair time for a
  100TB filesystem with 50M inodes in it on my test rig by 70%.
- xfs_repair bug fix found while checking large directories.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
