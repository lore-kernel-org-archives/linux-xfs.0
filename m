Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D5A37CBF
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 19:01:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4830AC008
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 17:01:33 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AfmMBlLHsC5lLUof for <xfs@oss.sgi.com>;
	Sun, 13 Dec 2015 17:01:31 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1a8HVt-0006ow-ND
	for xfs@oss.sgi.com; Mon, 14 Dec 2015 12:01:17 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1a8HVt-0000J1-MC
	for xfs@oss.sgi.com; Mon, 14 Dec 2015 12:01:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfsprogs: metadump/restore fixes
Date: Mon, 14 Dec 2015 12:01:04 +1100
Message-Id: <1450054866-32720-1-git-send-email-david@fromorbit.com>
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

A couple of patches from trying to process a rather large, badly
broken filesystem from Arkadiusz Miskiewicz. The first patch
prevents a crash when zeroing unused regions of corrupt btree
blocks. The second patch makes mdrestore report progress correctly,
which is kind of important when you've got a 35+GB metadump image
being restored.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
