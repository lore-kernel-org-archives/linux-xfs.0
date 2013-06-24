Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C59B77F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 13:55:57 -0500 (CDT)
Message-ID: <51C89638.9010405@sgi.com>
Date: Mon, 24 Jun 2013 13:55:52 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 12/60] xfs: Use inode create transaction
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-13-git-send-email-david@fromorbit.com>
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
> Replace the use of buffer based logging of inode initialisation,
> uses the new logical form to describe the range to be initialised
> in recovery. We continue to "log" the inode buffers to push them
> into the AIL and ensure that the inode create transaction is not
> removed from the log before the inode buffers are written to disk.
>
> Update the transaction identifier and reservations to match the
> changed implementation.
>
> Signed-off-by: Dave Chinner<david@fromorbit.com>
> ---

Looks good. Nice feature.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
