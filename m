Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E8E67F5D
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 18:52:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6E853304032
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 16:52:44 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gOae1LHGHhx4zsA5 for <xfs@oss.sgi.com>;
	Tue, 12 May 2015 16:52:39 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2 v2] percpu_counter: xfs requires custom compare batch size
Date: Wed, 13 May 2015 09:52:32 +1000
Message-Id: <1431474754-15764-1-git-send-email-david@fromorbit.com>
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
Cc: peterz@infradead.org, tj@kernel.org, linux-kernel@vger.kernel.org

Hi folks,

This is v2 of the regression fix for the new generic per-cpu
superblock counter code in XFS. The problems fixed arise from using
custom batch sizes for addition and decrement exceeding the
"accurate compare" bounds in percpu_counter_compare() and hence
resulting in incorrect comparisons being made.

This regression was introduced in 4.1-rc1 and it requires a small
tweak to the percpu counter infrastructure to fix, hence the two
patches.

Comments welcome!

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
