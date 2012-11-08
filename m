Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8MLa0j027309 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 16:21:36 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A6B038F8033
	for <xfs@oss.sgi.com>; Thu,  8 Nov 2012 14:23:35 -0800 (PST)
Received: from cxfsxe19.americas.sgi.com (cxfsxe19.americas.sgi.com
	[128.162.240.35])
	by estes.americas.sgi.com (Postfix) with ESMTP id 86C20700263D
	for <xfs@oss.sgi.com>; Thu,  8 Nov 2012 16:23:35 -0600 (CST)
Received: by cxfsxe19.americas.sgi.com (Postfix, from userid 0)
	id 76BAEBA0C2; Thu,  8 Nov 2012 16:23:35 -0600 (CST)
Message-Id: <20121108222315.505370321@sgi.com>
Date: Thu, 08 Nov 2012 16:23:15 -0600
From: adahl@sgi.com
Subject: [patch 0/2] xfs: xfs_tosspages() bug
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

Hi everyone,

This patch set fixes a bug in xfs with the xfs_tosspages() function and adds a tosspages test to xfstests.

xfs_tosspages() tries to avoid tossing a partial tail page, but it gets the calculation wrong.  As a result, if we pass in an interval [0, PAGE-SIZE-1] we end up tossing all pages.  This patch set resolves this issue.

Thanks,

Andrew 



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
