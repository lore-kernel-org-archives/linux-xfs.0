Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6761B7F60
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 23:49:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2E6CAC006
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 21:49:15 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	54wEgMeC6Ki82jvV for <xfs@oss.sgi.com>;
	Sun, 13 Jul 2014 21:49:08 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1X6YCE-0006Jc-9z
	for xfs@oss.sgi.com; Mon, 14 Jul 2014 14:49:02 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1X6YCE-0007ae-8y
	for xfs@oss.sgi.com; Mon, 14 Jul 2014 14:49:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3, V2] xfs; fixes for 3.16-rc5
Date: Mon, 14 Jul 2014 14:48:56 +1000
Message-Id: <1405313339-29110-1-git-send-email-david@fromorbit.com>
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

This is an updated series of fixes for 3.16-rc5, first posted here:

http://oss.sgi.com/pipermail/xfs/2014-July/037159.html

The first patch is unchanged, the other two have been modified as a
result of review feedback (thanks Brian and Arkadiusz!).

Please review and test.

-Dave.

Version 2
- get rid of unused flags in struct xfs_bmalloca
- get rid of XFS_BMAPI_STACK_SWITCH
- fix gquotino being NULLed incorrectly when group quota was enabled
  on filesystems with a shared group/project quota inode.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
