Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E38A07CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 18:41:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 69080AC001
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 16:41:19 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Npc42wR235VUPdPR for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 16:41:16 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRUPV-0000Rh-8u
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 11:38:05 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRUPV-0005MP-7s
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 11:38:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] xfs: clean up buffer flag macros
Date: Fri,  5 Feb 2016 11:37:57 +1100
Message-Id: <1454632683-20543-1-git-send-email-david@fromorbit.com>
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

This series gets rid of the remaining XFS_BUF flag macros. We've
removed most of them over the past few years as we've made changes,
with only a few now remaining. May as well get rid of them for
good...

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
