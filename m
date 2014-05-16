Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7376B7F3F
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 18:01:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 478B18F8054
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 16:01:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XxD2OdJwTKnw6D2u for <xfs@oss.sgi.com>;
	Fri, 16 May 2014 16:01:00 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WlR7Z-0004wq-GH
	for xfs@oss.sgi.com; Sat, 17 May 2014 09:00:57 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WlR7Z-0007ww-F9
	for xfs@oss.sgi.com; Sat, 17 May 2014 09:00:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5 V2] xfs: sanitise superblock feature bit support
Date: Sat, 17 May 2014 09:00:47 +1000
Message-Id: <1400281252-29638-1-git-send-email-david@fromorbit.com>
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

This is a followup series that addresses the review comments made
for this version:

http://oss.sgi.com/pipermail/xfs/2014-May/036025.html

The main change is to the NLINK/inode version handling (patch 3)
where xfs_iread() now unconditionally converts inodes to v2 format
in memory, so that if they are logged and written back they always
get converted to v2 format. This means there is no more bumping of
inode versions when link counts change, and xfs_iflush_int() no
longer writes v1 inodes at all.

Comments, testing, etc all welcome.

Version 2:
- rework inode version handling
- remove fetaure bit template comment in xfs_sb.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
