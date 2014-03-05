Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 486437F58
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 19:12:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D8FABAC006
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 17:12:04 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	cEUpzYWapyoBzXbe for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 17:11:57 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WL0My-0000ea-6R
	for xfs@oss.sgi.com; Wed, 05 Mar 2014 12:11:36 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WL0My-0000S9-5H
	for xfs@oss.sgi.com; Wed, 05 Mar 2014 12:11:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: more bug fixes
Date: Wed,  5 Mar 2014 12:11:31 +1100
Message-Id: <1393981893-2497-1-git-send-email-david@fromorbit.com>
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

The first patch here fixes the issue that Brian first reported and
posted a candidate fix for here:

http://oss.sgi.com/pipermail/xfs/2014-February/034667.html

It fixes the problems with xfs_check_page_type() and
xfs_convert_page() as well.

The second is a fix for a transaction overrun problem that has been
showing up on RHEL7 kernels quite frequently of late. It has been
reproduced on upstream kernels as well, and the patch should address
the oversight made in previous fixes to the inode reservation size
calculation.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
