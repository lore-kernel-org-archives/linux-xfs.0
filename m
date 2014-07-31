Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 256297F99
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 20:02:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 131458F8074
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 18:01:58 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kllbVf113RmEFwJe for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 18:01:56 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XCeki-0004nF-8C
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 11:01:52 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XCeki-0000A5-71
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 11:01:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4 V2] xfs: missing verifier fixes
Date: Thu, 31 Jul 2014 11:01:45 +1000
Message-Id: <1406768509-32556-1-git-send-email-david@fromorbit.com>
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

Updated version of the patchset posted yesterday here:

http://oss.sgi.com/archives/xfs/2014-07/msg00430.html

Version 2:
- use XFS_BUF_DADDR_NULL
- print buffer addr/length pair, not two addrs
- remove extraneous xfs_sb_version_hascrc() checks
- fix m_qflags check issue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
