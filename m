Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 81F427F4E
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 08:06:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 10222AC00C
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 06:06:47 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	z9M5aQGQyWM7dpp0 for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 06:06:45 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkwNN-0005a4-5w
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 23:06:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkwNN-0003oj-1h
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 23:06:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] xfstests: various fixes
Date: Fri,  7 Jun 2013 23:06:32 +1000
Message-Id: <1370610398-14630-1-git-send-email-david@fromorbit.com>
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

I figured that sending 77 patches to the list in one day wasn't
enough, so here's another 6 for xfstests. These patches fix the suid
tests in generic/193 to run on the target filesystem, test suid/sgid
behaviour for truncate, stop the experimatal warnings from CRC
enabled xfsprogs from making tests fail, fix a missing $seq to
$seqres conversion, convert an ENOSPC test to work with arbitrary
block sizes, avoid tests that currently won't run or are not
relevant for CRC enabled filesystems, and add a multithreaded test
mode to the bstat test program....

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
