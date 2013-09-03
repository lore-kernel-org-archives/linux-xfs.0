Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 22A7A7F4E
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 06:47:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5592AC001
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 04:47:51 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	uh5FkGFVWUT2GYRA for <xfs@oss.sgi.com>;
	Tue, 03 Sep 2013 04:47:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGp5B-0003VY-0y
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 21:47:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGp5B-0005MN-03
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 21:47:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: more shutdown-related fixes
Date: Tue,  3 Sep 2013 21:47:36 +1000
Message-Id: <1378208858-20557-1-git-send-email-david@fromorbit.com>
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

More fixes as a result of forced shutdown testing. The first is
fixing yet another hole in the buf log item freein logic when a
transaction is aborted, and the other removes the asserts from the
inode buffer checking so that verifiers return errors rather than
crashing the system.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
