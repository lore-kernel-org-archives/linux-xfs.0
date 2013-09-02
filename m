Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 946D929DFB
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 12:03:41 -0500 (CDT)
Message-ID: <5224C4E9.8080604@sgi.com>
Date: Mon, 02 Sep 2013 12:03:37 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfs: fix some new memory allocation failures
References: <1378119180-31380-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1378119180-31380-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/02/13 05:52, Dave Chinner wrote:
> Hi folks,
>
> These failures are a result of order-4 allocations being done on v5
> filesystems to support the large ACL count xattrs. The first patch
> puts out usual falbback to vmalloc workaround in place. The second
> patch factors all the places we now have this fallback-to-vmalloc
> and makes it transparent to the callers.
>
> Cheers,
>
> Dave.

Thanks for clean up. Broken record time: Do we really need order 
allocation in the filesystem? Esp in xfs_ioctl.c.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
