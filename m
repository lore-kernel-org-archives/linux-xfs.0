Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 966037F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:52:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2C1B3AC001
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 03:52:56 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7aYWtRJA6XV0SAy5 for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 03:52:55 -0700 (PDT)
Date: Fri, 17 May 2013 20:52:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: code sync up for log space reservation
Message-ID: <20130517105253.GU24635@dastard>
References: <5195F67F.5070101@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5195F67F.5070101@oracle.com>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, May 17, 2013 at 05:21:03PM +0800, Jeff Liu wrote:
> Hello,
> 
> Here is a patch to sync up the kernel code changes regarding log space reservation
> to the xfsprogs.
> 
> There have a couple of differences between the kernel and the user space.
> 1) A few transaction reservation item related to dquot are not synced because they
>    are not being used in xfsprogs.
> 2) In xfs_log_rlimit.c, the xfs_log_validate_logspace() is not copied and the xfs_mkfs.c
>    still use the default validate_log_space() to check the given log size.

Hi Jeff,

Just as a heads up, this is going to have conflicts with the CRC
patchset that I'm planning on posting in a few minutes. How do you
want to resolve them?

>From my perspective it's easier if we rebase your patch on top of my
patchset. If we go the other way around, I'll have to rebase 10-20
patches that your patch has conflicts with....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
