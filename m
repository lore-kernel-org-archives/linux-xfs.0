Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DFED87F61
	for <xfs@oss.sgi.com>; Sun, 30 Nov 2014 22:21:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7D9EAAC002
	for <xfs@oss.sgi.com>; Sun, 30 Nov 2014 20:21:03 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	c3nmGtv2NvTIodPE for <xfs@oss.sgi.com>;
	Sun, 30 Nov 2014 20:21:01 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XvIT5-0001d7-19
	for xfs@oss.sgi.com; Mon, 01 Dec 2014 15:20:11 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XvIT4-00026r-WB
	for xfs@oss.sgi.com; Mon, 01 Dec 2014 15:20:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: more return cleanups
Date: Mon,  1 Dec 2014 15:20:06 +1100
Message-Id: <1417407608-8016-1-git-send-email-david@fromorbit.com>
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

I noticed a bit of inconsistency when reviewing the shift extent
return cleanups that coccinelle flagged. The first was that the
out_error labels were basically meaningless - it jsut returns the
error, and we have much neater ways of doing that. Also, the logic
flow through xfs_bmse_shift_one() jumped around all over the place -
it can be done lots neater without any gotos at all, and is easier
to read as a result.

These patches apply on top of the for-next branch (the
xfs-coccinelle-cleanups branch to be precise).

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
