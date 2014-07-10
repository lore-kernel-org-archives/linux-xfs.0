Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 109E87F3F
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 18:26:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02EE9304032
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 16:26:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZGnDfgbKMcmRxfRX for <xfs@oss.sgi.com>;
	Thu, 10 Jul 2014 16:26:24 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1X5NjK-0005M8-8w
	for xfs@oss.sgi.com; Fri, 11 Jul 2014 09:26:22 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1X5NjK-0000dl-87
	for xfs@oss.sgi.com; Fri, 11 Jul 2014 09:26:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: regression fixes for 3.16-rc5
Date: Fri, 11 Jul 2014 09:26:16 +1000
Message-Id: <1405034779-2028-1-git-send-email-david@fromorbit.com>
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

These three patches are fixes for recent regressions. The first two
are fixing up the mess that making the allocation workqueue kswapd
aware. The first reverts the original patch, and the second moves
the stack switch to the problematic double btree split path rather
than being done for all writeback allocation. This allows the stack
split to be done unconditionally for all allocations due to the
relative rarity of it occurring now, and allows the kswapd awareness
to be passed because we aren't going to swamp memory reclaim with
hundreds of concurrent allocation requests from "kswapd" context.

The last patch is for an older regression, and one that was tripped
over recently when fixing up v3.2.0 of repair. It only affects
people who are switching from newer kernels to older kernels and
have only user quotas enabled. That combination shouldn't be too
frequent - the fact the bug has been there since 3.12 indicates that
this, indeed, isn't a frequent occurrence. Still, it needs to be
fixed.

Comments, thoughts, and testing all welcome...

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
