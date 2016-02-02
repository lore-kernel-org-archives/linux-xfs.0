Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B72747CB1
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 18:39:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3FB88AC002
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 16:39:34 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UIm7ym82Cj0EqrFj for <xfs@oss.sgi.com>;
	Mon, 01 Feb 2016 16:39:32 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aQOzw-0007po-IY
	for xfs@oss.sgi.com; Tue, 02 Feb 2016 11:39:12 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aQOzw-0000pY-HF
	for xfs@oss.sgi.com; Tue, 02 Feb 2016 11:39:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: fix realtime device assert failures
Date: Tue,  2 Feb 2016 11:39:07 +1100
Message-Id: <1454373550-3102-1-git-send-email-david@fromorbit.com>
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

This is a followup to Eric's patch that attempted to fix the assert
failure that Ross reported. I'd mentioned I'd looked at this
recently, because xfs/090 was triggering the same failure when
configured with a RT device. This series fixes the original locking
based assert failures, followed by the issues that fixing the
original assert uncovered. This now results in xfs/090 failing
because of xfs_db check problem (repair is clean) but it (and other
tests) no longer assert fail.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
