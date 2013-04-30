Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 816DF7F52
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 06:39:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2201FAC004
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 04:39:42 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	LZCiQYHia95BhY13 for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 04:39:40 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UX8uI-0005sM-T7
	for xfs@oss.sgi.com; Tue, 30 Apr 2013 21:39:38 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UX8uI-0004lI-Ob
	for xfs@oss.sgi.com; Tue, 30 Apr 2013 21:39:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: fixes for 3.10 merge window.
Date: Tue, 30 Apr 2013 21:39:32 +1000
Message-Id: <1367321976-18268-1-git-send-email-david@fromorbit.com>
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

The following 4 patches are for the 3.10 merge window. The first is
a repost of the CONFIG_XFS_QUOTA build fix, the second is the
CONFIG_XFS_WARN functionality, and the remaining two are updates to
the CRC patchset in response to your review comments.

The first patch really needs to go in ASAP to fix the linux-next
build problems, the others aren't quite so critical.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
