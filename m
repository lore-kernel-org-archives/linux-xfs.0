Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 50D0B7F9D
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 00:01:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 306CA30405F
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 22:01:15 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bUH9roQLo2J3pabs for <xfs@oss.sgi.com>;
	Wed, 09 Apr 2014 22:01:11 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WY76e-0004c7-MG
	for xfs@oss.sgi.com; Thu, 10 Apr 2014 15:00:56 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WY76e-0002C9-LH
	for xfs@oss.sgi.com; Thu, 10 Apr 2014 15:00:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6 v2] xfs: delalloc, dio and corruption...
Date: Thu, 10 Apr 2014 15:00:47 +1000
Message-Id: <1397106053-7489-1-git-send-email-david@fromorbit.com>
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

This is version 2 of the DIO vs delalloc patchset I posted here:

http://oss.sgi.com/archives/xfs/2014-03/msg00313.html

The changes to this version are:

	- the bug fix to patch 2 that Brain noticed,
	- I dropped the delalloc extent splittting patch because
	  with the fix to patch 2 I can't trigger that bug anymore,
	  and that patch was causing transaction overruns in
	  xfs/297. Hence without an existing reproducer, I won't try
	  to fix that problem.
	- the last patch is new, and is a bug in the collapse range
	  code where it fails to shift the last N extents correctly
	  if there are N delalloc extents before the shifted range.

With these 6 patches, all of the xfstests fsx/fsstress tests pass
on 1k, 2k and 4k block size filesystems, with and without CRCs
enabled, on 1, 2 and 16p test VMs.

I'm much happier with these patches now - I don't think that there
are more problems lurking, but only time will tell. I'd like to get
these fixes to Linus for 3.15 (probably for -rc2), so eyeballs and
testing would be appreciated.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
