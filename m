Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B024A29DFB
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 11:07:14 -0500 (CDT)
Message-ID: <52011F2E.2040808@sgi.com>
Date: Tue, 06 Aug 2013 11:07:10 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 37/49] xfs: remove __KERNEL__ from debug code
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-38-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-38-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:45, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> There is no reason the remaining kernel-only debug code needs to
> remain kernel-only. Kill the __KERNEL__ part of the defines, and let
> userspace handle the debug code appropriately.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

user equivalent of the for Linux 3.12 kernel patch 30/49.

patches are the same, but at this point, the kernel and user 
xfs_rtalloc.c files are out of sync - doesn't appear they ever become 
synced.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
