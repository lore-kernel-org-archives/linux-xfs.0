Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8EB137F3F
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 06:23:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6FFC6304039
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 04:22:57 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	QHgWASQEVi2U65nU for <xfs@oss.sgi.com>;
	Wed, 28 Aug 2013 04:22:52 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VEdpp-0004xY-Db
	for xfs@oss.sgi.com; Wed, 28 Aug 2013 21:22:49 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VEdpp-0001i1-CU
	for xfs@oss.sgi.com; Wed, 28 Aug 2013 21:22:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: prevent transient corrupt states during log recovery
Date: Wed, 28 Aug 2013 21:22:45 +1000
Message-Id: <1377688967-6480-1-git-send-email-david@fromorbit.com>
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

The following two patches prvent log recovery from recovering old
changes over a newer object on disk, preventing transient corrupt
states in memory causing verifier failures when recovery tries to
write the objects back to disk.

This only works for v5 filesystems as it relies on the LSN that is
contained in all v5 metadata and stamped with the current LSN when
ever the metadata is written to doisk.

The first patch fixes a problem with LSN fields being unitialised
and logged in that state, and then having recovery restore that
uninitialised state and confuse any further attempts by recovery
to determine the age of the object by LSN.

The second patch does the work of determining the age of an object
being recovered based on the magic number in the object. The reasons
for doing this are described in that patch.

By skipping recovery of objects that are newer on disk than in the
checkpoint being recovered, we ensure that log recovery never
creates a transient corrupt state during recovery in memory, and
hence we never attempt to write them to disk and so recovery won't
abort due to corruption being detected due to this issue.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
