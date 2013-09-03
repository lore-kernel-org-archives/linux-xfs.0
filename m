Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 45A497F5E
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 19:15:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CAA93AC009
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 17:15:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TZLHiTOYCQtxoAS8 for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 17:15:00 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGeGn-0002J7-FO
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 10:14:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGeGn-0001z8-EK
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 10:14:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfstests: improvements for generic/204
Date: Tue,  3 Sep 2013 10:14:52 +1000
Message-Id: <1378167295-7566-1-git-send-email-david@fromorbit.com>
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

These patches are fixes and improvements for generic/204.

Firstly, it doesn't check the filesystem it works on, and so
corruptions can go undetected. Secondly, _scratch_mkfs_sized doesn't
handle different block sizes passed in on the command line via
MKFS_OPTIONS at all well (i.e they get ignored) and so it has never
run on small block size filesystems of any type.

Finally, make it run on filesystems with different block sizes and
inode sizes by scaling the file count appropriately. It detects
block and inode size from the output of mkfs, so scaling only occurs
if the underlying filesystem emits them.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
