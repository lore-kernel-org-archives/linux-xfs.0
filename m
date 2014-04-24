Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E9C6D7F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 00:02:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D71A28F8052
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 22:02:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	KgdaDUaW1myTotNf for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 22:02:46 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WdBnQ-0006xr-OJ
	for xfs@oss.sgi.com; Thu, 24 Apr 2014 15:02:04 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WdBnQ-0005fu-NS
	for xfs@oss.sgi.com; Thu, 24 Apr 2014 15:02:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/9 V2] xfs_db, xfs_repair: improve CRC error detection
Date: Thu, 24 Apr 2014 15:01:53 +1000
Message-Id: <1398315722-20870-1-git-send-email-david@fromorbit.com>
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

This is version 2 of the patchset first posted here:

http://oss.sgi.com/archives/xfs/2014-04/msg00374.html

The version corrects all the issues mentioned in the first review.
It doesn't try to rework the directory buffer read issue that
Christoph was concerned about - API changes are necessary so we'll
do that through the kernel first in a separate patchset.

Version 2:
- move LIBXFS_B_UNCHECKED to the correct patch (patch 1)
- set_cur_iotype assumes a valid type (patch 2)
- comments added to explain the way LIBXFS_B_UNCHECKED and dirty
  buffers are supposed to interact (patch 3)
- fixed comment flow and added separate "crc_error" return variable
  to dir_read_buf() (patch 4)
- reworked CRC error handling of AG headers (patch 5)
- readded missing dirty/no_modify assert (patch 6)
- fixed typos (patch 8)
- fixed "repair" variable initialisation flow (patch 9)
- fixed dirty buffer accounting on the cursor to dirty the correct
  buffer on CRC errors, added some clarifying comments (patch 9)

Comments and testing welcome!

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
