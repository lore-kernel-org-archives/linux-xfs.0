Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9C76B29E07
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 22:17:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 604D98F8039
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 20:17:05 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	OGgDHFr8VkMCszn1 for <xfs@oss.sgi.com>;
	Mon, 07 Mar 2016 20:17:02 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ad94S-0004A3-Tp
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:32 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ad94G-0007u0-Bl
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/16] xfs: first part of rmapbt functionality
Date: Tue,  8 Mar 2016 15:16:02 +1100
Message-Id: <1457410578-30233-1-git-send-email-david@fromorbit.com>
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

This is the first set of patches for reverse mapping support that
I've grabbed from Darrick's tree. They are are largely unchanged
from his tree, with minor cleanups to the commit messages and
formatting (e.g. de-shouting inline functions), some small bug fixes
and some code/patch rearrangement. Changes are noted in the commit
messages.

This isn't all of the rmap functionality. It's patches up to the
point where I've come across the first piece that needs to be
reworked (the rmap intent execution code), so there's no point
holding these back until I've sorted that out. This builds on top of
for-next and the patch set I posted yesterday.

Darrick, I've changed the authorship of the patches to reflect
the original series this has come from - can you check to see if
there's anything I got wrong when I did that?

Cheers,

Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
