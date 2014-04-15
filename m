Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E0677F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 03:25:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E1C15304059
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 01:25:08 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FE7CZjc4PfDV0ziG for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 01:25:06 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WZyfv-0003WL-6m
	for xfs@oss.sgi.com; Tue, 15 Apr 2014 18:25:03 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WZyfv-0008Ph-5h
	for xfs@oss.sgi.com; Tue, 15 Apr 2014 18:25:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/9] xfs_db, xfs_repair: improve CRC error detection
Date: Tue, 15 Apr 2014 18:24:52 +1000
Message-Id: <1397550301-31883-1-git-send-email-david@fromorbit.com>
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

After a conversion with a user on #IRC this morning, it was clear
that xfs_repair and xfs_db weren't handling metadata blocks with CRC
errors in them particularly well. xfs_metadump was reporting blocks
with errors, but xfs_db was reporting them as having a correct CRC,
which wasn't actually the case - they were unchecked, and the code
saw the absence of error flags as meaning they were good.

Repair had a similar problem - buffers that were prefetched never
had the verifier run on them when they were read by the checking
code as they were uptodate in the cache. Hence the prefetch code
needed to mark the buffers as unchecked so that the code that
checked the metadata ran the verifier and appropriately.

This then showed up the fact that there were many places where
repair was not catching the CRC error and rewriting the buffer to
correct the bad CRC.

This then showed up that we weren't actually handling remote
attribute properly for the CRC enabled format.

And so I fixed all of them. I've verified the code by manually
corrupting blocks with xfs_db by writing garabges into unused
regions of the blocks so that CRC errors are triggered. In each case
repair detected the CRC error and took appropriate action. The CRC
error was not found on a second run of xfs_repair. This really needs
to be turned into a xfstest, but I haven't had time to do that yet.
Any volunteers?

Anyway, these fixes mean we'll definitely need a 3.2.0-rc2 release
in the not too distant future. Comments, flames and testing all
welcome....

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
