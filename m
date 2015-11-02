Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 17BDF7F61
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 21:42:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E97178F8033
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 19:42:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ObaicWbNqaCmjGKz for <xfs@oss.sgi.com>;
	Sun, 01 Nov 2015 19:42:35 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Zt60k-00014j-7N
	for xfs@oss.sgi.com; Mon, 02 Nov 2015 14:42:22 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1Zt60k-0000S7-6O
	for xfs@oss.sgi.com; Mon, 02 Nov 2015 14:42:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/7] xfs: patches remaining for 4.4 merge window
Date: Mon,  2 Nov 2015 14:42:08 +1100
Message-Id: <1446435735-1526-1-git-send-email-david@fromorbit.com>
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

These are the outstanding patches I have for the 4.4 ,erge window.
It is effectively v3 of the DAX block zeroing patch set - this
version fixes the issues brian found, and marks all the unmodified
reviewed patches as such.

The final patch is also the fdatasync optimisation patch that Brain
noticed a race condition in. It has the fix I mentioned in the
review thread in it and it still works just fine.

I'll merge these into the for-next branch as soon as reviews come
through with an eye to sending Linus a pull request early next week.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
