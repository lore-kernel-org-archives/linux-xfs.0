Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 832397F50
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 16:12:56 -0500 (CDT)
Message-ID: <5228F3D4.4090202@sgi.com>
Date: Thu, 05 Sep 2013 16:12:52 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 21/55] xfs: separate icreate log format definitions from
	xfs_icreate_item.h
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-22-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-22-git-send-email-david@fromorbit.com>
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

On 09/04/13 17:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The on disk log format definitions for the icreate log item are
> intertwined with the kernel-only in-memory log item definitions.
> Separate the log format definitions out into their own header file
> so they can easily be shared with userspace.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

This patch has not changed since the former post.

xfsprogs equivalent of the for 3.12 kernel patch 06/50.

move the shared xfs_icreate structure to xfs_log_format.h - varies from 
the kernel only by the XFS_MOUNT_QUOTA_ALL entry (added xfsprogs).

xfs_icreate_item.h is now kernel-only, remove from xfsprogs.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
