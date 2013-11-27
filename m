Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 738CC7F63
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 22:15:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02EC7AC002
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 20:15:16 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	tm0ZF3t3BI6KIfpF for <xfs@oss.sgi.com>;
	Tue, 26 Nov 2013 20:15:15 -0800 (PST)
Date: Wed, 27 Nov 2013 15:14:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfstests,btrfs: add wrong compress type regression test
Message-ID: <20131127041449.GG10988@dastard>
References: <20131126064107.GN8803@dastard>
	<1385449223-28748-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385449223-28748-1-git-send-email-miaox@cn.fujitsu.com>
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
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Nov 26, 2013 at 03:00:23PM +0800, Miao Xie wrote:
> Btrfs would crash when the users wrote some data into a file with compress
> flag but the compression of the fs was disabled. This test case is to check
> this bug still happen or not.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
