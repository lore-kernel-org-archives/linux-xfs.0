Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:31:04 -0800 (PST)
Received: from itchy (itchy.melbourne.sgi.com [134.14.55.96])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M4UuBG010309
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:31:01 -0800
Subject: PARTIAL TAKE 971186 
Message-Id: <20080222043011.2AFB0C98F@itchy>
Date: Fri, 22 Feb 2008 15:30:11 +1100 (EST)
From: xaiki@sgi.com (Niv Sardi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.ptools@sgi.com
Cc: xfs@oss.sgi.com

The forward declarations for the xfs_ioctl() helpers and
the associated comment about gcc behavior really aren't
needed; all of these functions are marked STATIC which
includes noinline, and the stack usage won't be a problem.

This effectively just removes the forward declarations and
moves xfs_ioctl() back to the end of the file.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Niv Sardi <xaiki@sgi.com>
