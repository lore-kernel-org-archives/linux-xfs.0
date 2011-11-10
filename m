Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAKZbaZ126966 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:35:37 -0600
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 0/8] xfsprogs: new resvsp db command, plus some fixes
Date: Thu, 10 Nov 2011 14:35:10 -0600
Message-Id: <1320957318-16269-1-git-send-email-aelder@sgi.com>
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

The original purpose for this series was to add a new
"resvsp" command to xfs_db, to provide access to the
xfsctl(3) XFS_IOC_RESVSP64 operation.  Kevan Rehm did
this work, and along the way he found and fixed a few
cases where things weren't getting flushed to disk
properly.  I also looked things over and came up with
a few other small fixes.

I'm submitting the resulting series on Kevan's behalf.
I think we'll want to follow this up with at least one
test in the xfstests suite to exercise this new command.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
