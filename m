Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A91887F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:34:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 959E48F8035
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 21:34:43 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	zCkxJPZtiP9tzi1E for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 21:34:42 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vqyv2-0000bk-8y
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 16:34:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vqyv2-0003cG-7m
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 16:34:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] xfs: fixes for 3.13-rc4
Date: Thu, 12 Dec 2013 16:34:32 +1100
Message-Id: <1386826478-13846-1-git-send-email-david@fromorbit.com>
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

Theses are all the kernel fixes I've accumulated over the past
few weeks. There are a couple of IO error handling fixes, log grant
head accounting fixes to avod spurious warnings, a swalloc alignment
fix, and a patch to fix all the leaks in
xlog_recover_process_data().

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
