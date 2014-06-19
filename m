Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 883B47F47
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2014 00:34:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 775328F8054
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 22:34:13 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	75FJDZuEwjGr3JCU for <xfs@oss.sgi.com>;
	Wed, 18 Jun 2014 22:34:11 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WxUyz-0001gh-4K
	for xfs@oss.sgi.com; Thu, 19 Jun 2014 15:33:57 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1WxUyz-0004xA-3K
	for xfs@oss.sgi.com; Thu, 19 Jun 2014 15:33:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfsprogs: fixes for CRC support
Date: Thu, 19 Jun 2014 15:33:50 +1000
Message-Id: <1403156032-18525-1-git-send-email-david@fromorbit.com>
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

These two patches correct a couple of oversights in the new CRC
support. Firstly, repair actually validates ACLs on disk (from a
consistency POV, not correctness) and so it needs to know that
v5 formats handle a lot more than 25 ACLs.

Secondly, we forgot all about documenting the "-m crc=1" option in
the mkfs.xfs(8) man page. So the second patch fixes that and also
adds the missing documentation for the free inode btree option as
well.

With these two fixes and all the other xfsprogs patches I've pulled
in and are currently testing, we're pretty much ready for a 3.2.1-rc
release. Is there anything that we know about that we don't have
patches for yet that needs to be done for 3.2.1?

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
