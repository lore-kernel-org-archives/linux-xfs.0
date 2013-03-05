Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7937D7FE6
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 12:43:44 -0600 (CST)
Message-ID: <51363CE6.1010807@sgi.com>
Date: Tue, 5 Mar 2013 12:43:50 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 276: fix error 'FIBMAP: Invalid argument'
References: <512DB284.1090806@gmail.com>
In-Reply-To: <512DB284.1090806@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: list.btrfs@jan-o-sch.net, linux-btrfs@vger.kernel.org, xfstests <xfs@oss.sgi.com>

This patch has been committed.

--Rich

commit eba3a5206cd7f8df73d6e6dbf2bb0afca677fca8
Author: Wang Sheng-Hui <shhuiw@gmail.com>
Date:   Thu Feb 28 02:05:56 2013 +0000

     xfstests 276: fix error 'FIBMAP: Invalid argument'

     Commit 05dadc0 ("Btrfs: add fiemap's flag check") added validity
     checks to the fiemap flags and hence invalid flags are now being
     rejected. Test 276 passes an invalid fiemap flag to btrfs, and so
     that test fails since this commit was added.

     Btrfs doesn't support FIEMAP_FLAG_XATTR, which is enabled by -x option
     of filefrag, and will fail with
         'FIBMAP: Invalid argument'
     for 'filefrag -vx'. 'filefrag -vx' fails on btrfs with
          'FIEMAP failed with unsupported flags 2'
     Remove the '-x' option.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
