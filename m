Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C1FAE7F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 02:52:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9D169304043
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 00:52:15 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vfNwIJDTZqBSFRv1 for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 00:52:13 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKl4w-0006HT-Jq
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKl4w-0006y5-Iz
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/13] xfsprogs: initial EFSBADCRC support
Date: Tue,  4 Mar 2014 19:51:44 +1100
Message-Id: <1393923117-9559-1-git-send-email-david@fromorbit.com>
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

Hi Folks,

This series is a userspace port of Eric's EFSBADCRC verifier error
discrimination patch set. It brings across all the relevant pathes
form the kernel code and shoe-horns them into the libxfs codebase.
There are two extra patches on the end of the series - one to make
xfs_db use EFSBADCRC for it's CRC validity indication, and the other
to make xfs_repair detect and handle primary superblock CRC failures
and recalculation when the primary superblock is rebuilt and
rewritten.

This is the first step in bring full awareness of CRC errors into
xfs_repair. More patches will follow as I make more repair code
aware that EFSBADCRC means that the object that was just read
needs repair.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
