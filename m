Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7A39829E03
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 20:21:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F7F18F8049
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 18:21:47 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Vzoz8oIY0ZUYDyTW for <xfs@oss.sgi.com>;
	Wed, 08 May 2013 18:21:45 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UaFYF-00039N-QV
	for xfs@oss.sgi.com; Thu, 09 May 2013 11:21:43 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UaFYF-0003vQ-Mj
	for xfs@oss.sgi.com; Thu, 09 May 2013 11:21:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3, V2] xfstests: more fixes... 
Date: Thu,  9 May 2013 11:21:38 +1000
Message-Id: <1368062501-15046-1-git-send-email-david@fromorbit.com>
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

A couple of simple fixes:

	- another redirection issue that I missed on the last sweep
	   (thanks Michael!),

	- disables quota tests on relatime filesystems as realtime
	  filesystems don't support quotas. V2 also disables the xfs
	  specific quota tests.

And a new patch to fix the random xfs/189 failures I've been seeing
for the past few months. I'm questioning whether I'm still sane
after dealing with this one. The commit message adequately explains
the problem, I think...

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
