Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2BC6F7F4E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 20:21:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF210AC002
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 18:21:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5McUWAQnYbeEExAm for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2014 18:21:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XM5SC-0000K9-53
	for xfs@oss.sgi.com; Tue, 26 Aug 2014 11:21:44 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XM5SC-0002U9-4J
	for xfs@oss.sgi.com; Tue, 26 Aug 2014 11:21:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 0/4] xfs: clean up xlog_recover_process_data
Date: Tue, 26 Aug 2014 11:21:37 +1000
Message-Id: <1409016101-9511-1-git-send-email-david@fromorbit.com>
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

The log recovery use-after-free that Brian posted a patch for has
had several previous attempts sent and none have completed review.
So let's put this one to bed for good.

This patch set addresses the previous review feedback for fixing
this problem. It factors xlog_recover_process_data() to make it
cleaner and isolate the context of the transaction recvoery
structure that is causing problems. It fixes a leak of the structure
in an error condition that I noticed while factoring, as well as the
double free that Brian and others have identified and tried to fix
in the past. It then re-arranges the recovery item management code
to put it all in one place, rather than in 3 separate parts of the
file separated by several hundred lines of unrelated code.

Comments?

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
