Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A7F929E0D
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 03:32:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7976E8F8049
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 01:32:17 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	TxWGBhIeDYCJhLT0 for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 01:32:16 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UXSSV-000873-H5
	for xfs@oss.sgi.com; Wed, 01 May 2013 18:32:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UXSSL-0000fV-Cs
	for xfs@oss.sgi.com; Wed, 01 May 2013 18:32:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] xfstests: various fixes
Date: Wed,  1 May 2013 18:31:58 +1000
Message-Id: <1367397123-2530-1-git-send-email-david@fromorbit.com>
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

These are various fixes for xfstests.

The first patch is an infrastructure regression fix, resulting from
the patchset that split up the tests into subdirectories. It also
moves all the check.* output files to the result directory rather
than leaving them in the root directory of xfstests.

The second is a bunch of changes to generic/310 that should have
been done in the review cycle. It now works reliably for me.

The last 3 patches fix bugs in tests that result in files being left
in the root directory of xfstests.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
