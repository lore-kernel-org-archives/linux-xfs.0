Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 983F47F72
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 20:26:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7925330405F
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 18:26:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	60cy6xT8Ws8bbYm7 for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 18:26:42 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WYQEI-0007Wp-W0
	for xfs@oss.sgi.com; Fri, 11 Apr 2014 11:26:07 +1000
Date: Fri, 11 Apr 2014 11:26:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsdump: master branch updated to b1d6979
Message-ID: <20140411012606.GF15995@dastard>
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

The xfsdump repository at git://oss.sgi.com/xfs/cmds/xfsdump has
just been updated.

The new head of the master branch is commit:

b1d6979 remove ancient sys_getdents code paths

New Commits:

Boris Ranto (1):
      [c3a4db1] xfsdump: Fix memory and fd leak in invutil/stobj.c

Kyle McMartin (2):
      [9ed517b] xfsdump: getdents.c: clean up ifdef-hell around sys_getdents
      [b1d6979] remove ancient sys_getdents code paths


Code Diffstat:

 common/getdents.c | 282 +++++++++++++-----------------------------------------
 invutil/stobj.c   |  13 +--
 2 files changed, 76 insertions(+), 219 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
