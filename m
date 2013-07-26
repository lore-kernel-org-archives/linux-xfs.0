Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AF76429E03
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 08:32:09 -0500 (CDT)
Message-ID: <51F27A59.6060809@sgi.com>
Date: Fri, 26 Jul 2013 08:32:09 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 34/49] xfs: make struct xfs_perag kernel only
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-35-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-35-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:25, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The struct xfs_perag has many kernel-only definitions in it,
> requiring a __KERNEL__ guard so userspace can use it to. Move it to
> xfs_mount.h so that it it kernel-only, and let userspace redefine
> it's own version of the structure containing only what it needs.
> This gets rid of another __KERNEL__ check in the XFS header files.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

moves the xfs_perag structure and adds a comment to why it is moved.

looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
