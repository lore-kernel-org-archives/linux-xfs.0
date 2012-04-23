Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3NFhCZl207636 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 10:43:12 -0500
Message-ID: <4F95788D.2040101@sgi.com>
Date: Mon, 23 Apr 2012 10:43:09 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 28/37] xfs: move xfsagino_t to xfs_types.h
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-29-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-29-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/23/12 00:58, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Untangle the header file includes a bit by moving the definition of
> xfs_agino_t to xfs_types.h. This removes the dependency that xfs_ag.h has on
> xfs_inum.h, meaning we don't need to include xfs_inum.h everywhere we include
> xfs_ag.h.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
