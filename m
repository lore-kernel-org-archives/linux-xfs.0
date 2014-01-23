Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E9F0B7F9C
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 17:21:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C80A6304048
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 15:21:37 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EJVc7xD92tbQf9CW for <xfs@oss.sgi.com>;
	Thu, 23 Jan 2014 15:21:35 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W6TaT-0006Ps-J4
	for xfs@oss.sgi.com; Fri, 24 Jan 2014 10:21:29 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W6TaT-0008Bs-I5
	for xfs@oss.sgi.com; Fri, 24 Jan 2014 10:21:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3 V2] repair: discontiguous directory block support
Date: Fri, 24 Jan 2014 10:21:21 +1100
Message-Id: <1390519284-31440-1-git-send-email-david@fromorbit.com>
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

This is version 2 of the patchset first posted here:

http://oss.sgi.com/archives/xfs/2014-01/msg00341.html

Version 2 changes:
- rework extent tracking logic in discontiguous block support
  as requested by Brain. (patch 3/3)

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
