Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7A61C7F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 09:37:43 -0500 (CDT)
Message-ID: <51C859B6.5050800@sgi.com>
Date: Mon, 24 Jun 2013 09:37:42 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 11/60] xfs: Inode create item recovery
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-12-git-send-email-david@fromorbit.com>
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

On 06/18/13 23:50, Dave Chinner wrote:
> When we find a icreate transaction, we need to get and initialise
> the buffers in the range that has been passed. Extract and verify
> the information in the item record, then loop over the range
> initialising and issuing the buffer writes delayed.
>
> Support an arbitrary size range to initialise so that in
> future when we allocate inodes in much larger chunks all kernels
> that understand this transaction can still recover them.
>
> Signed-off-by: Dave Chinner<david@fromorbit.com>
> ---


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
