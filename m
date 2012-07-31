Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6VGwKo5200664 for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 11:58:21 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id oTnBkdZ6mOsZyVkH for <xfs@oss.sgi.com>;
	Tue, 31 Jul 2012 09:58:19 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 660D34963292
	for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 11:58:19 -0500 (CDT)
Message-ID: <50180EAB.8030008@sandeen.net>
Date: Tue, 31 Jul 2012 11:58:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: xfstests git trees are drifting a little
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

kernel.org & oss.sgi.com have gotten a bit out of sync, I think.

Are there plans to address this soon, on either side?

xfstests vs. xfstests-dev:

 016                    |    9 
 030                    |    3 
 030.out.linux          |    1 
 273                    |   10 
 274                    |   70 ++---
 285                    |   58 ----
 285.full               |  116 --------
 285.out                |    1 
 286                    |  114 --------
 286.full               |   70 -----
 286.out                |    1 
 README                 |    4 
 common.attr            |    4 
 common.dump            |    2 
 group                  |    2 
 src/Makefile           |    3 
 src/seek_copy_test.c   |  249 -----------------
 src/seek_sanity_test.c |  683 -------------------------------------------------


-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
