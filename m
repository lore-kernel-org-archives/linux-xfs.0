Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0J4TAYZ179232 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 22:29:11 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 278E91621761
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 20:31:27 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DiDnjInqGwHjISZ6 for <xfs@oss.sgi.com>;
	Tue, 18 Jan 2011 20:31:27 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PfPhc-0007Em-Ce
	for xfs@oss.sgi.com; Wed, 19 Jan 2011 15:31:24 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PfPgJ-00044t-2X
	for xfs@oss.sgi.com; Wed, 19 Jan 2011 15:30:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] xfs: various 2.6.38 candidate bug fixes
Date: Wed, 19 Jan 2011 15:29:55 +1100
Message-Id: <1295411400-15614-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

There's the fix for the specualtive allocation regression that arekm
and hch reported different symptoms of. Some extsize tweaks to
prevent assert failures and btree corruptions. An allocation size
fix to prevent wildly inefficient handling of nullfb allocation
group scanning (demonstrated by low space scanning or single large
preallocation that spans hundreds/thousands of AGs).  Finally,
another a fix for another delayed logging commit path error handling
problem that I noticed by inspection.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
