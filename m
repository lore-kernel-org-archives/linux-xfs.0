Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 165687F51
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 00:22:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02CC9304039
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 22:22:45 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	cgdc1yAQXjYjijGm for <xfs@oss.sgi.com>;
	Sun, 19 Jan 2014 22:22:44 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W58Fs-0004Kk-JT
	for xfs@oss.sgi.com; Mon, 20 Jan 2014 17:22:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W58Fs-0004Tr-IR
	for xfs@oss.sgi.com; Mon, 20 Jan 2014 17:22:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/7] xfstests: various fixes and additions for XFS
Date: Mon, 20 Jan 2014 17:22:30 +1100
Message-Id: <1390198957-17184-1-git-send-email-david@fromorbit.com>
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

The following series cleans up some of the infrastructure for
handling XFS filesystems, and fixes a few failures that have
resulted from recent changes to mkfs defaults. There is also a new
log recovery test that uses fsstress to generate load and log
traffic. This was causing failures and hangs on recent kernels.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
