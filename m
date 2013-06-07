Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E2AC57F37
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7F4B3AC007
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:21 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	CaoPGUBOdBThFOHv for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:20 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVR-0003tn-O2
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:13 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVR-0001JP-Jm
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/48] xfsprogs: CRC support
Date: Fri,  7 Jun 2013 10:25:23 +1000
Message-Id: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

This is the latest update of the series of patches tht introduces
CRC support into xfsprogs. Of note, for CRC enabled filesystems;

	- write support for xfs-db is disabled
	- obfuscation for metadump is disabled
	- xfs_check does nothing ("always succeed") so that xfstests
	  can run without needing this
	- all structures shoul dbe supported for printing in xfs_db
	- xfs_repair should be able to fully validate the structure
	  of a CRC enabled filesystem.
	- xfs_repair still ignores CRC validation errors when
	  reading metadata
	- mkfs.xfs enforces limitations on the format of CRC enabled
	  filesystems (inode size, attr format, projid32bit, etc).
	- whenever a v5 superblock is parsed on read by any utility,
	  it outputs a wanring about it being an experimental
	  format.

Bug reports, patches, comments, reviews, etc all welcome.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
