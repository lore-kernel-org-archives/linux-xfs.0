Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 838577F54
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 23:47:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 342FAAC003
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 21:47:44 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	C2murwOpL3xpNyfB for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 21:47:40 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1WBHoF-0007Cr-Rk
	for xfs@oss.sgi.com; Thu, 06 Feb 2014 16:47:35 +1100
Date: Thu, 6 Feb 2014 16:47:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests updated to 9d00bf8
Message-ID: <20140206054735.GK13997@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
just been updated. Patches often get missed, so please check if your
outstanding patches were in this update. If they have not been in
this update, please resubmit them to xfs@oss.sgi.com so they can be
picked up in the next update.

The new head of the master branch is commit:

9d00bf8 xfs/008: initialize "valid" bitmap in randholes.c

New Commits:

Dave Chinner (2):
      [6442726] xfs/296: fix golden output
      [7c9748f] xfs/066: stat the test file, not the directory

Eric Sandeen (1):
      [9d00bf8] xfs/008: initialize "valid" bitmap in randholes.c

Code Diffstat:

 src/randholes.c   | 1 +
 tests/xfs/066     | 6 ++++--
 tests/xfs/066.out | 6 ++++--
 tests/xfs/296.out | 3 ++-
 4 files changed, 11 insertions(+), 5 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
