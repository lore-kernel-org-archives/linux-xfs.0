Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 52E057F59
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 02:41:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3F3E58F811E
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 00:41:15 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9lC2LLGTN87o38gJ for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 00:41:13 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZMAMH-0000AQ-Kh
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:40:29 +1000
Received: from dave by disappointment with local (Exim 4.86_RC4)
	(envelope-from <dave@disappointment.disaster>) id 1ZMAMH-0008CU-Jl
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:40:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: sb_meta_uuid fixes
Date: Mon,  3 Aug 2015 17:40:21 +1000
Message-Id: <1438587625-31437-1-git-send-email-david@fromorbit.com>
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

These are fixes to problems I found int eh sb_meta_uuid changes I
recently pushed to for-next. They were all found by augmenting
_scratch_mkfs_xfs in xfstests with an extra command to change the
UUID after the filesystem had been created. I think we should
probably do that randomly in xfstests to get coverage of both
cases. No-one shoul dhave been exposed to these yet, because I
haven't released a userspace that can change the UUID yet on v5
filesystems.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
