Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 468507F54
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 14:39:28 -0500 (CDT)
Message-ID: <522A2F6C.2030103@sgi.com>
Date: Fri, 06 Sep 2013 14:39:24 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: aborted buf items can be in the AIL.
References: <1378208858-20557-1-git-send-email-david@fromorbit.com>
	<1378208858-20557-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1378208858-20557-2-git-send-email-david@fromorbit.com>
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

On 09/03/13 06:47, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Saw this on generic/270 after a DQALLOC transaction overrun
> shutdown:
>
> XFS: Assertion failed: !(bip->bli_item.li_flags&  XFS_LI_IN_AIL), file: fs/xfs/xfs_buf_item.c, line: 952
> .....
>   xfs_buf_item_relse+0x4f/0xd0
>   xfs_buf_item_unlock+0x1b4/0x1e0
>   xfs_trans_free_items+0x7d/0xb0
>   xfs_trans_cancel+0x13c/0x1b0
>   xfs_symlink+0x37e/0xa60
> ....
>
> When a transaction abort occured.
>
> If we are aborting a transaction and trigger this code path, then
> the item may be dirty. If the item is dirty, then it may be in the
> AIL. Hence if we are aborting, we need to check if the item is in
> the AIL and remove it before freeing it.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

This is fine for Linux 3.12. Christoph's reference counting reorg sounds 
interesting.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
