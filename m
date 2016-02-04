Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A6B87CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:03:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE71A8F8033
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 15:02:57 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	QHNicwrIC98MPr7n for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 15:02:48 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRStY-0000D6-Qn
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 10:01:00 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRStY-0004vU-Pz
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 10:01:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3 v2] metadump/restore: fix up zeroing and accounting
Date: Fri,  5 Feb 2016 10:00:55 +1100
Message-Id: <1454626858-17823-1-git-send-email-david@fromorbit.com>
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

These are my pending metadump fixes - the second patch in the series
still needs review - the only changes there are to fix up the
leaf/node max record count indexes that Brian noticed were wrong.

First posted here:

http://oss.sgi.com/archives/xfs/2015-12/msg00557.html

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
