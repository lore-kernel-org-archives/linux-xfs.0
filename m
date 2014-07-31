Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6CAC37F98
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 01:12:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4C12C30404E
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 23:12:19 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	bHvCz101nq7fqZBr for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 23:12:14 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XCjaz-0005TM-UU
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 16:12:09 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XCjaz-00036a-TR
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 16:12:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: extent swap fixes
Date: Thu, 31 Jul 2014 16:12:06 +1000
Message-Id: <1406787128-11897-1-git-send-email-david@fromorbit.com>
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

The extent swap code is not symmetrical, so correct behaviour is
dependent on userspace doing the right thing. If we try to swap
extents with the temporary inode in the wrong state we can have
interesting failures. These two patches fix those issues and treat
the two files identically in terms of the state of the data
contained in the files being swapped. Failure to write or remove all
cached data from either file will now cause the swap extents
operation to fail.

Comments, thoughts?

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
