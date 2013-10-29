Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B9227F3F
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 06:12:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16207AC002
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 04:12:07 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	w7V8Cf4BWg1tLO5k for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 04:12:06 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vb7DM-0000PK-T0
	for xfs@oss.sgi.com; Tue, 29 Oct 2013 22:12:00 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vb7DM-000870-RO
	for xfs@oss.sgi.com; Tue, 29 Oct 2013 22:12:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/15] xfs: patches for 3.13
Date: Tue, 29 Oct 2013 22:11:43 +1100
Message-Id: <1383045118-31107-1-git-send-email-david@fromorbit.com>
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

Hi Ben,

This is a repost of the previous series with all the issues
your review found fixed up. It also has a few new patches, the first
of which is fixing the dir2/ftype offset issue you noticed.

The remaining new patches add a new validity check to the directory
block checking code to avoid a reference outside the directory
buffer, the patch to avoid stack overflows from the page cache which
has been updated to remove the AOP_FLAG_NOFS usage in XFS, and then
a final patch to clean up a bunch of new sparse warnings introduced
by the recent round of code movement.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
