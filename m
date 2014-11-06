Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 21FE07F57
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 07:15:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F25328F8033
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 05:15:06 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	sYr6sD7LH0Bx1gNy for <xfs@oss.sgi.com>;
	Thu, 06 Nov 2014 05:15:04 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XmMty-0007Es-Au
	for xfs@oss.sgi.com; Fri, 07 Nov 2014 00:15:02 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XmMty-0002ZI-9Z
	for xfs@oss.sgi.com; Fri, 07 Nov 2014 00:15:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6 v3] xfs: fix the bulkstat mess
Date: Fri,  7 Nov 2014 00:14:53 +1100
Message-Id: <1415279699-8739-1-git-send-email-david@fromorbit.com>
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

HI folks,

This is the third version of the bulkstat fixup series. This version
fixes the end-of-ag, end-of-user-buffer bug that was causing inodes
to be skipped.

This passes all my ad hoc tests and xfstests, so please review and
test so I can push this up to Linus ASAP.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
