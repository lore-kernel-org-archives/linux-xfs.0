Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AAC427F7E
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 15:44:18 -0500 (CDT)
Date: Tue, 13 Aug 2013 15:44:18 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: call roundup_64() to calculate the min_logblks
Message-ID: <20130813204418.GB12719@sgi.com>
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

Applied.  Thanks Jeff.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
