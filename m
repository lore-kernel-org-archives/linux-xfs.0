Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CCBCA7F6B
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 18:37:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AA0E08F8033
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 16:37:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	i7hiyylQx1ASrz7Z for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 16:37:47 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XWw81-0004yD-JJ
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 09:37:45 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XWw81-00056g-ID
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 09:37:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: sparse fixes
Date: Thu, 25 Sep 2014 09:37:39 +1000
Message-Id: <1411601863-19594-1-git-send-email-david@fromorbit.com>
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

In gathering up the outstanding sparse warning fixes, these are
the ones that went unnoticed or didn't have patches for them. The
first patch fixes an actual bug, though one with almost no impact
on performance and no impact on correctness. The others are just
cleanups to remove warnings from correctly functioning code.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
