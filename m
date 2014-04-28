Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 13B0E29DF8
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 16:05:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8EEF0AC002
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 14:05:05 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jWNKj9w2ce5BvEvi for <xfs@oss.sgi.com>;
	Mon, 28 Apr 2014 14:05:03 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WesjV-00050t-Gz
	for xfs@oss.sgi.com; Tue, 29 Apr 2014 07:05:01 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WesjV-00050X-Fu
	for xfs@oss.sgi.com; Tue, 29 Apr 2014 07:05:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/9 v3] xfs_db, xfs_repair: improve CRC error detection
Date: Tue, 29 Apr 2014 07:04:50 +1000
Message-Id: <1398719099-19194-1-git-send-email-david@fromorbit.com>
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

This is the third version of the patchset originally posted here:

http://oss.sgi.com/archives/xfs/2014-04/msg00374.html

This version corrects the issues that Christoph commented on in the
second version.

Version 3:
- factored out libxfs_readbuf_verify()
- LIBXFS_B_UNCHECKED flag setting/clearing cleaned up
- cleaned up dirty checks on AG header scan
- cleaned up error path goto stack on AG header scan
- added no_modify check to remote symlink buffer bad CRC rewrite.

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
