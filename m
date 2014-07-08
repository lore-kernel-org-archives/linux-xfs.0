Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 326027F5A
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 18:41:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 24A1C8F8054
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 16:41:46 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FlTNGqdW36zaOZNm for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 16:41:44 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1X4f14-0006T1-KN
	for xfs@oss.sgi.com; Wed, 09 Jul 2014 09:41:42 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1X4f14-0000t1-JA
	for xfs@oss.sgi.com; Wed, 09 Jul 2014 09:41:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] repair: more fixes for 3.2.1
Date: Wed,  9 Jul 2014 09:41:38 +1000
Message-Id: <1404862900-3369-1-git-send-email-david@fromorbit.com>
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

A couple more fixes for repair - the first being a change I missed
during review of the last patch series, and a new one that removes a
set of incorrect asserts when checking AG headers.

If nothing else pops up in the next couple of days, this is where I
want to draw the line for a 3.2.1 release, so having people run some
testing over the next couple of days woul dbe great....

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
