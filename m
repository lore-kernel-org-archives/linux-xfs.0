Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D3887F51
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 02:27:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38D19AC003
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 00:26:58 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	KmIASRdMdWt5IGHU for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 00:26:55 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YhvFE-0000qY-S2
	for xfs@oss.sgi.com; Tue, 14 Apr 2015 17:26:52 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YhvFE-0000VR-R4
	for xfs@oss.sgi.com; Tue, 14 Apr 2015 17:26:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8 v2] xfs: fix direct IO completion issues
Date: Tue, 14 Apr 2015 17:26:43 +1000
Message-Id: <1428996411-1507-1-git-send-email-david@fromorbit.com>
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

This is the second version of the series I first posted here:

http://oss.sgi.com/archives/xfs/2015-04/msg00097.html

I've reworked and refactored the first two patches in the series,
breaking them out into simpler, more self contained patches.

The main change from the previous version is that I dropped the
pre-allocation of the append transaction to avoid the nesting
problems it could cause.

The only other major change is that the ioend is only allocated when
a mapping is either for an unwritten region or spans EOF. hence if the
mapping is an overwrite within EOF we do not allocate an ioend, we
do not defer completion to the DIO workqueue and we do nothing in
the completion function as there is nothing to do.

Comments, thoughts?

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
