Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0CB3B7F50
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 12:13:49 -0500 (CDT)
Message-ID: <522A0D4C.6010608@sgi.com>
Date: Fri, 06 Sep 2013 12:13:48 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 35/55] xfs: move swap extent code to xfs_extent_ops
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-36-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-36-git-send-email-david@fromorbit.com>
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
> Swapping extents is clearly an extent operaiton, and it is not
> shared with userspace. Move the code to xfs_extent_ops.[ch], and
> the userspace ioctl structure definition to xfs_fs.h where most of
> the other ioctl structure definitions are. The means xfs_dfrag.h is
> no longer needed in userspace.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

user equivalent of the for Linux 3.12 kernel patch 27/50.

same as the previous post. looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
