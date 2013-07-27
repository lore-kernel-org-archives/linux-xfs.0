Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 48B037F59
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 14:48:24 -0500 (CDT)
Message-ID: <51F42407.8060709@sgi.com>
Date: Sat, 27 Jul 2013 14:48:23 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 19/49] xfs: split out the remote symlink handling
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-20-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-20-git-send-email-david@fromorbit.com>
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
> The remote symlink format definition and manipulation needs to be
> shared with userspace, but the in-kernel interfaces do not. Split
> the remote symlink format handling out into xfs_symlink_remote.[ch]
> fo it can easily be shared with userspace.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Does exactly as commit message says. Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
