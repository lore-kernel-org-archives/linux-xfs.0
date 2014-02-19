Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B3ABE800C
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 22:17:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 46702AC004
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 20:17:19 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IiHsQGOGrMDXqZtE for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 20:17:17 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WFyaT-00022i-7R
	for xfs@oss.sgi.com; Wed, 19 Feb 2014 15:16:45 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WFyaT-0001FR-3x
	for xfs@oss.sgi.com; Wed, 19 Feb 2014 15:16:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: lockdep and stack reduction fixes
Date: Wed, 19 Feb 2014 15:16:39 +1100
Message-Id: <1392783402-4726-1-git-send-email-david@fromorbit.com>
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

The following patches fix the lockdep regression caused by adding
the inode ilock to the readdir code and reduce the stack of XFS in a
couple of critical paths. The log force change is the critical one,
as it can happen a leaf functions in the code paths and hence
greatly increase the maximum stack depth of any path that needs to
unpin an object or lock a buffer.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
