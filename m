Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 66CD67F54
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 17:02:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F27A8AC002
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 15:02:23 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vjyJvF2uTekK9aJk for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 15:02:22 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: fix inode count underrun
Date: Wed,  6 May 2015 08:01:37 +1000
Message-Id: <1430863299-9341-1-git-send-email-david@fromorbit.com>
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
Cc: linux-kernel@vger.kernel.org

Hi folks,

With the conversion of XFS to use the generic per-cpu superblocks, I
overlooked the fact that the update batch size is important to the
accuracy of the comparison function. Using different batch sizes
means percpu_counter_compare() doesn't detect when it should fall
back to percpu_counter_sum() for accuracy correctly, resulting in
counter comparisons being inaccurate. This leads to problems with
zero threshold detection in XFS.

To fix, add __percpu_counter_compare() to take a caller supplied
batch size. This fixes the XFS regression introduced in 4.1-rc1.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
