Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5M8oVaj257042 for <xfs@oss.sgi.com>; Fri, 22 Jun 2012 03:50:31 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	lMzp4NDNv0Kx6nVS for <xfs@oss.sgi.com>;
	Fri, 22 Jun 2012 01:50:29 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1ShzZU-0005Rm-92
	for xfs@oss.sgi.com; Fri, 22 Jun 2012 18:50:28 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1ShzZK-0006q5-6q
	for xfs@oss.sgi.com; Fri, 22 Jun 2012 18:50:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/9, V2] xfs; discontiguous buffer support
Date: Fri, 22 Jun 2012 18:50:06 +1000
Message-Id: <1340355015-26250-1-git-send-email-david@fromorbit.com>
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

This is the latest version of the native xfs_buf discontiguous
buffer support series.

The series introduces the concept of buffer block maps, then
adds APIs for using them, converts the internal xfs_buf method
implementation to use them exclusively, adds support for
discontiguous buffer log items in transactions, converts
the directory code to use them and finally removes the xfs_dabuf
from the picture.

This greatly simplifies the directory buffer code and avoids
copy-up/copy-down for discontiguous buffers. It also avoids needing
to create and destroy a xfs-dabuf for every directory block that is
read or written, greatly reducing buffer setup and teardown
overhead and memory footprint.

Version 2:
- addressed Christoph's comments
- reordered to bring the xfs_buf_log_format changes up front
- rebased on a current 3.5-rc + xfs-oss/master tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
