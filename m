Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 130FF29E11
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 08:51:20 -0500 (CDT)
Message-ID: <51F27ED7.9040009@sgi.com>
Date: Fri, 26 Jul 2013 08:51:19 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 33/49] xfs: move kernel specific type definitions to xfs.h
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-34-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-34-git-send-email-david@fromorbit.com>
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
> xfs_types.h is shared with userspace, so having kernel specific
> types defined in it is problematic. Move all the kernel specific
> defines to xfs_linux.h so we can remove the __KERNEL__ guards from
> xfs_types.h
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
