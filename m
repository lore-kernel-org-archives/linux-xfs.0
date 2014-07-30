Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C6EC7F6F
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 20:49:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2BC3AAC005
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 18:49:07 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	a3tfHUqFBnRjkqHx for <xfs@oss.sgi.com>;
	Tue, 29 Jul 2014 18:49:05 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XCJ0c-0001H9-Or
	for xfs@oss.sgi.com; Wed, 30 Jul 2014 11:48:50 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XCJ0c-0002uN-O5
	for xfs@oss.sgi.com; Wed, 30 Jul 2014 11:48:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: missing verifer fixes
Date: Wed, 30 Jul 2014 11:48:45 +1000
Message-Id: <1406684929-11133-1-git-send-email-david@fromorbit.com>
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

The following 4 patches catch and fix bugs associated with metadata
writes that occur without verifiers attached to the buffers. All
cached metadata writes should occur with verifiers attached, and the
lack of a verifier is indicative of a bug. The first problem was
found by Jan Kara w.r.t. to log recovery readahead, and the debug
patch I wrote to help track that down (the first patch in the
series) showed that there there were a bunch more problems in the
quota buffer handling, both at quotacheck and log recovery time.

Comments, testing welcome!

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
