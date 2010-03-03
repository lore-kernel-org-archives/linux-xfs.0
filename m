Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o236IHr3048445 for <xfs@oss.sgi.com>; Wed, 3 Mar 2010 00:18:17 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F014F13ED2BC
	for <xfs@oss.sgi.com>; Tue,  2 Mar 2010 22:19:43 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	LxH9nLzIT9PnxiAX for <xfs@oss.sgi.com>;
	Tue, 02 Mar 2010 22:19:43 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	15685376-1927428
	for <xfs@oss.sgi.com>; Wed, 03 Mar 2010 16:49:42 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1Nmhvi-0003N4-4a
	for xfs@oss.sgi.com; Wed, 03 Mar 2010 17:19:34 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nmhva-00039j-QN
	for xfs@oss.sgi.com; Wed, 03 Mar 2010 17:19:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfsqa: new tests and fixes
Date: Wed,  3 Mar 2010 17:19:19 +1100
Message-Id: <1267597162-12092-1-git-send-email-david@fromorbit.com>
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

Two new tests - an enospc exerciser for delalloc writes and a repost of the
fiemap exerciser that Josef and Eric put together in July last year.

One fix - small scratch filesystems were not being correctly specified so
they weren't being made small at all.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
