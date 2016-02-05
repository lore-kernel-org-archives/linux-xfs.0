Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 01E517CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 19:23:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AABB88F8040
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:23:35 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	VeF0wVqodsbjeYJg for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 17:23:32 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRV7T-0000Wo-16
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 12:23:31 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRV7S-0005tC-WF
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 12:23:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/9] xfs: configurable error behaviour
Date: Fri,  5 Feb 2016 12:23:18 +1100
Message-Id: <1454635407-22276-1-git-send-email-david@fromorbit.com>
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

I need to restart the discussion and review of this patch series.
There was some discussion of it last time, but nothing really came
from that. I'm posting what I have in my tree right now - treat it
as though it's an initial posting of the code because I can't recall
what I've changed since the first posting.

What I'd like to have to for the next merge window is all the IO
error bits sorted out. The final patch (kmem failure behaviour)
needs more infrastructure (passing mp to every allocation) so that's
a secondary concern right now and I've only included it to
demonstrate how to apply this code ot a different subsystem.

Things that need to be nailed down before I can commit the series:

	- sysfs layout
	- naming conventions for errors and subsystems in sysfs
	- how best to display/change default behaviour

Things that we can change/implement later:

	- default behaviour
	- additional error classes
	- additional error types
	- additional subsystems
	- subsystem error handling implementation
	- communication with other subsystems to dynamically change
	  error behaviour

IOWs, what is important right now is how we present this to
userspace, because we can't change that easily once we've decided on
a presentation structure.

Modifying the code to classify and handle all the different error
types is much less important, as we can change that to fix whatever
problems we have without impacting the presentation to userspace.

There is definite need for this (e.g. handling of ENOSPC on thin
provisioned devices), so I want to get quickly to a consensus on the
userspace facing aspects so that we can get this ball rolling.

The biggest unsolved issue is how to change the default behaviour
persistently. There is no infrastructure in this patch series to do
that, but it is someting that we have to consider so that we don't
require default behaviour to be changed after every mount of every
filesystem on a system. My thoughts on this is we store changes to
the defaults in xattrs on the root inode, but I'm open to ideas here
as there's no code written for it yet. Solving this problem,
however, is not necessary before commiting the initial code; it's
something we can add later once we've worked out all the details.

Discuss!

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
