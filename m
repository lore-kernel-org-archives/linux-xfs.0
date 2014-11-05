Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 992A47FB4
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 18:05:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 46366AC005
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 16:05:56 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9eozotykxFJmrFvB for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 16:05:46 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Xlo6G-0001sa-8B
	for xfs@oss.sgi.com; Wed, 05 Nov 2014 11:05:24 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Xlo6G-0008D3-5S
	for xfs@oss.sgi.com; Wed, 05 Nov 2014 11:05:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6 v2] xfs: fix the bulkstat mess
Date: Wed,  5 Nov 2014 11:05:15 +1100
Message-Id: <1415145921-31507-1-git-send-email-david@fromorbit.com>
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

Hi folks, this is version 2 of the bulkstat fixup series first
posted here:

http://oss.sgi.com/archives/xfs/2014-11/msg00057.html

Version 2 fixes the issues Brian found during review:
- chunk formatter error leakage (patch 3)
- moved main loop chunk formatter error handling from patch 4 to
  patch 5
- reworks last_agino updating in patch 6 to do post-formatting
  updates and added comments.

Comeents and testing welcome.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
