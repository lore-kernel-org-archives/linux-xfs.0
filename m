Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R5qXu8168299 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 00:52:33 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C535C12BB615
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 23:02:55 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	yvySKWymfjiOhcL6 for <xfs@oss.sgi.com>;
	Mon, 26 Jul 2010 23:02:55 -0700 (PDT)
Received: from dastard (unverified [121.44.18.238])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	33036802-1927428
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 15:25:35 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Odd8Y-0004Hu-8f
	for xfs@oss.sgi.com; Tue, 27 Jul 2010 15:55:34 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Odd8V-0002rE-CR
	for xfs@oss.sgi.com; Tue, 27 Jul 2010 15:55:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 0/2] xfs: Fast zeroing of allocated space
Date: Tue, 27 Jul 2010 15:55:27 +1000
Message-Id: <1280210129-10925-1-git-send-email-david@fromorbit.com>
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

These two patches allow conversion of a written range of a file into
back into unwritten state. The first patch converts page cache
helper functions to use the correct range primitives as we need to
be able to toss (invalidate) pages only within the range specified,
not to to the end of the file as it currently uses.

The actual conversion also preallocates any holes in the range, so
it turns the entire range requested into allocated, unwritten
extents.

I also have a patch that adds this functionality to fallocate(). I
haven't tested that at all, but if this is something we want to
support, I'd suggest that we want fallocate to be able to do it...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
