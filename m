Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6191C7F4E
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 16:43:24 -0500 (CDT)
Date: Thu, 15 Aug 2013 16:43:23 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: ***** SUSPECTED SPAM ***** [PATCH 50/50] xfs: use reference
	counts to free clean buffer items
Message-ID: <20130815214323.GN12719@sgi.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<1376304611-22994-51-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1376304611-22994-51-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 12, 2013 at 08:50:11PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When a transaction is cancelled and the buffer log item is clean in
> the transaction, the buffer log item is unconditionally freed. If
> the log item is in the AIL, however, this leads to a use after free
> condition as the item still has other users.
> 
> In this case, xfs_buf_item_relse() should only be called on clean
> buffer items if the reference count has dropped to zero. This
> ensures only the last user frees the item.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
