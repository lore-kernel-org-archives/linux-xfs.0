Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E139929E06
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 01:38:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF9C6304039
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 23:38:48 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	gyTXbUxc0MomOvaD for <xfs@oss.sgi.com>;
	Sun, 26 May 2013 23:38:47 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ugr4p-0008FV-MH
	for xfs@oss.sgi.com; Mon, 27 May 2013 16:38:39 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ugr4f-0003x0-Hn
	for xfs@oss.sgi.com; Mon, 27 May 2013 16:38:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATH 0/9] xfs: fixes for 3.10-rc4
Date: Mon, 27 May 2013 16:38:18 +1000
Message-Id: <1369636707-15150-1-git-send-email-david@fromorbit.com>
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

Hi Ben,

This is an update for all the fixes I have for 3,10-rc4.

All the comments on the previous patches have been updated in this
series, and there are two new patches. The first patch adds support
for indicating that the filesystem has CRC enabled to userspace, and
the second fixes the missing CRC updates on the unlinked inode list
manipulations.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
