Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q585d48u173157 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 00:39:05 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	tFfmyIsLHjRcaolB for <xfs@oss.sgi.com>;
	Thu, 07 Jun 2012 22:39:02 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1ScruA-0004h7-Ng
	for xfs@oss.sgi.com; Fri, 08 Jun 2012 15:38:38 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1ScruA-0002vS-JW
	for xfs@oss.sgi.com; Fri, 08 Jun 2012 15:38:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/9] xfs: discontiguous directory buffer support
Date: Fri,  8 Jun 2012 15:38:25 +1000
Message-Id: <1339133914-11148-1-git-send-email-david@fromorbit.com>
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
buffer support series. It has been rebased on 3.5-rc1 and Jan Kara's
buffer initialisation/allocation fix ("Fix overallocation in
xfs_buf_allocate_memory()").

The series introduces Dateh concept of buffer block maps, then
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
