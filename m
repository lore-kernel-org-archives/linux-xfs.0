Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o736M9jC228094 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 01:22:10 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04DAB1D6B5AF
	for <xfs@oss.sgi.com>; Mon,  2 Aug 2010 23:22:28 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	l7z6cvo6qxyNDYIw for <xfs@oss.sgi.com>;
	Mon, 02 Aug 2010 23:22:28 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	33712022-1927428
	for <xfs@oss.sgi.com>; Tue, 03 Aug 2010 15:52:27 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OgAtN-00079F-U3
	for xfs@oss.sgi.com; Tue, 03 Aug 2010 16:22:25 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OgAtH-0007q7-Sa
	for xfs@oss.sgi.com; Tue, 03 Aug 2010 16:22:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: Fast zeroing of allocated space
Date: Tue,  3 Aug 2010 16:22:04 +1000
Message-Id: <1280816526-30100-1-git-send-email-david@fromorbit.com>
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

These two patches allow conversion of a written range of a file into
back into unwritten state. The first patch converts page cache
helper functions to use the correct range primitives as we need to
be able to toss (invalidate) pages only within the range specified,
not to to the end of the file as it currently uses.

The actual conversion also preallocates any holes in the range, so
it turns the entire range requested into allocated, unwritten
extents.

Version 2:
o removed stray debugging printks
o truncate_inode_pages_range doesn't handle partial tail pages, so
  the range needs to be tossed appropriately.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
