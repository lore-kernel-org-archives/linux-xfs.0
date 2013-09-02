Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 13CFB29E04
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 19:32:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0102730404E
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 17:32:17 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EI392kkTQckCJwRq for <xfs@oss.sgi.com>;
	Sun, 01 Sep 2013 17:32:16 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGI3p-00088m-8v
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 10:32:05 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGI3p-0004qC-7y
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 10:32:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: log recovery buffer fixes
Date: Mon,  2 Sep 2013 10:31:59 +1000
Message-Id: <1378081921-18570-1-git-send-email-david@fromorbit.com>
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

Folks, these two patches make sure log recovery correctly identifies
the type of buffer being recovered. The buffer log format type field
is not always being set correctly, and that leads to invalid remote
symlink and directory blocks after recovery as they hav enot had the
CRC recalculated after being recovered.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
