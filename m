Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F1247F50
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 03:46:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0E01B304081
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 01:46:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	MhxDOLE1vdzS1oWB for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 01:46:21 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WIxXH-0007at-6R
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:45:47 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WIxXH-0007pX-4N
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:45:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfsprogs: mkfs fixes
Date: Thu, 27 Feb 2014 20:45:42 +1100
Message-Id: <1393494344-30056-1-git-send-email-david@fromorbit.com>
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

The first patch is an update to the patch I sent a while back to
reduce the default log size of small filesystems back to new to the
3.1.x sizes. I've incorporated the changes Brian an I discussed, and
it makes all the xfstets that expect specific log sizes for certain
sized filesystems pass again.

The second patch fixes an oversight when adding dirent ftype support
to mkfs - the protofile code that creates files in the filesystem at
mkfs time does nto set the ftype value in the directory structures,
so xfs_repair complains on a freshly made filesystem that the ftypes
aren't correct.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
