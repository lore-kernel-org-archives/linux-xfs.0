Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1634E7F53
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 01:54:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3618304032
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 23:54:02 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	CpHdtG9jfVgHabpV for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 23:54:01 -0700 (PDT)
Date: Tue, 13 Aug 2013 16:53:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: call roundup_64() to calculate the min_logblks
Message-ID: <20130813065355.GB6023@dastard>
References: <5209C4D0.5050203@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5209C4D0.5050203@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: kbuild test robot <fengguang.wu@intel.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Aug 13, 2013 at 01:32:00PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Replace roundup() with roundup_64() as we calculate min_logblks
> with 64-bit divisions.  Hence, call roundup() will cause the
> following error while compiling a 32-bit kernel:
> 
> fs/built-in.o: In function `xfs_log_calc_minimum_size':
> fs/xfs/xfs_log_rlimit.c:140: undefined reference to `__udivdi3'
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

You beat me to it, Jeff. I got an email from Fengguang's build farm,
too. :)

Your fix looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
