Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0CBEdlV009020 for <xfs@oss.sgi.com>; Mon, 12 Jan 2009 05:14:39 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 497C217D95E5
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2009 03:14:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id 6DjCeB9h7Dyop5hJ for <xfs@oss.sgi.com>;
	Mon, 12 Jan 2009 03:14:36 -0800 (PST)
Date: Mon, 12 Jan 2009 06:14:36 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: spurious -ENOSPC on XFS
Message-ID: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

Hi

I discovered a bug in XFS in delayed allocation.

When you take a small partition (52MB in my case) and copy many small 
files on it (source code) that barely fits there, you get -ENOSPC. Then 
sync the partition, some free space pops up, click "retry" in MC an the 
copy continues. They you get again -ENOSPC, you must sync, click "retry" 
and go on. And so on few times until the source code finally fits on the 
XFS partition.

This misbehavior is apparently caused by delayed allocation, delayed 
allocation does not exactly know how much space will be occupied by data, 
so it makes some upper bound guess. Because free space count is only a 
guess, not the actual data being consumed, XFS should not return -ENOSPC 
on behalf of it. When the free space overflows, XFS should sync itself, 
retry allocation and only return -ENOSPC if it fails the second time, 
after the sync.

Mikulas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
