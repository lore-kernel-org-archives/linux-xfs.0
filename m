Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB1BB29E0E
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 01:04:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9B44F8F8037
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 23:04:34 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	f8AbN4UAwpFvqwBV for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 23:04:32 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UZxUL-0000pI-Hc
	for xfs@oss.sgi.com; Wed, 08 May 2013 16:04:29 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UZxUL-0002R4-DK
	for xfs@oss.sgi.com; Wed, 08 May 2013 16:04:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfstests: more simple fixes...
Date: Wed,  8 May 2013 16:04:24 +1000
Message-Id: <1367993066-9313-1-git-send-email-david@fromorbit.com>
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

A couple of simple fixes - another redirection issue that I missed
on the last sweep (thanks Michael!), and a patch that disables quota
tests on relatime filesystems as realtime filesystems don't support
quotas.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
