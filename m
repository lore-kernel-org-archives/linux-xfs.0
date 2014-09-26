Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6B54A7FF7
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 21:19:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17B57AC001
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 19:19:24 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	cqhKsawIuzmlyazF for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 19:19:17 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XXL7q-0000Ri-PW
	for xfs@oss.sgi.com; Fri, 26 Sep 2014 12:19:14 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XXL7q-0006Rv-Og
	for xfs@oss.sgi.com; Fri, 26 Sep 2014 12:19:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5 v2] xfs: clean up xlog_recover_process_data
Date: Fri, 26 Sep 2014 12:19:07 +1000
Message-Id: <1411697952-24741-1-git-send-email-david@fromorbit.com>
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

This is a new version of the log recovery transaction processing
cleanup I first posted here:

http://oss.sgi.com/archives/xfs/2014-08/msg00367.html

It's largely the same, but there's been a couple of but fixes and
rework done to it.

Version 2
- use sizeof(variable) consistently
- reworked transaction lookup factoring to encapsulate start ophdr
  processing completely.
- re-ordered checks for opheader length validity to so we do all the
  ophdr validity checks before we try to process it.
- added patch to re-integrate simple use-once functions to look up
  and allocate recovery transaction structures.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
