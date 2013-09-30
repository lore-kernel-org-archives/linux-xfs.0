Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 67A0F7F4E
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:07:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B1E9304032
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:07:25 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	WN4swi2KdsZ2ulfx for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:07:23 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTpO-0006LQ-I5
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTpO-0002BU-H9
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/16] xfs: patches for 3.13
Date: Mon, 30 Sep 2013 13:06:57 +1000
Message-Id: <1380510433-8353-1-git-send-email-david@fromorbit.com>
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

This patch series sits on top of the series I sent earlier this
morning for 3.12-rc4. It is made up of two main parts - the first 6
patches continues the process of sanitising the code to make
user/kernel space code merges easier. That's all pretty straight
forward, simple code movement.

The series is the next 9 patches, and they vectorise the differences
in encoding and decoding the directory on disk formats. This gets
rid of repeated "xfs_sb_version_has..." checks from the paths, and
als o removes the other conditional behaviours triggered by magic
number matching. Instead, each different directory format we need to
support has an ops vector that holds the exact set of functions
needed to encode/decode the format appropriately. The patch seis
currently introduces v4, v4+dtype and v5 vectors.

The last patch in the series is increasing the inode cluster size
for v5 filesystems.

Comments, testing, and flames all welcome....

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
