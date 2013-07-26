Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B4D2F29E30
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 16:16:56 -0500 (CDT)
Message-ID: <51F2E747.8070105@sgi.com>
Date: Fri, 26 Jul 2013 16:16:55 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 27/49] xfs: consolidate extent swap code
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-28-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-28-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:24, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> So we don't need xfs_dfrag.h in userspace anymore, move the
> extent swap ioctl structure definition to xfs_fs.h
> where most of the other ioctl structure definitions are.
>
> Now that we don't need separate files for extent swapping,
> separate the basic file descriptor checking code to xfs_ioctl.c,
> and the code that does the extent swap operation to xfs_bmap_util.c.
> This cleanly separates the user interface code from the physical
> mechanism used to do the extent swap.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good. Only change is xfs_swapext() is rename xfs_ioc_swapext() 
when moved to xfs_ioctl.c.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
