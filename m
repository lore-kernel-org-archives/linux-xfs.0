Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 649D07FA9
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 11:06:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5153B304032
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 09:06:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HHI436VbCmrUuGh0 for <xfs@oss.sgi.com>;
	Mon, 14 Jul 2014 09:06:05 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 55C5C63BE4E5
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 11:06:05 -0500 (CDT)
Message-ID: <53C3FFED.5080301@sandeen.net>
Date: Mon, 14 Jul 2014 11:06:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: time for an xfsdump release?
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

There aren't a lot of changes since v3.1.3, but with the rate of change of xfsdump (slow), I wonder if it's worth cutting a point release to get these bugfixes out there:

b1d6979 remove ancient sys_getdents code paths
9ed517b xfsdump: getdents.c: clean up ifdef-hell around sys_getdents
c3a4db1 xfsdump: Fix memory and fd leak in invutil/stobj.c
a88c490 restore: don't trash file capabilities
0ece1a1 xfsdump: handle large, wholly-sparse files
151858e xfsdump: fix DEBUGPARTIALS build
1162bdb xfsdump: avoid segfault in partial_reg() in error case

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
