Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4F25F7F59
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 02:42:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DFDC8AC046
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 00:42:47 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hRnvpNZwBzyxzTGe for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 00:42:46 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZMAOG-0000Az-EF
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:42:32 +1000
Received: from dave by disappointment with local (Exim 4.86_RC4)
	(envelope-from <dave@disappointment.disaster>) id 1ZMAOG-0008Eb-DL
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:42:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfsprogs: sb_meta_uuid fixes
Date: Mon,  3 Aug 2015 17:42:27 +1000
Message-Id: <1438587749-31597-1-git-send-email-david@fromorbit.com>
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

THis is the userspace side fixes that I've needed to make to get
xfstests to pass without regressions with a modified sb_meta_uuid.
Same circumstances as the kernel side patches I just sent....

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
