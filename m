Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A9237CBF
	for <xfs@oss.sgi.com>; Wed,  5 Jun 2013 08:13:29 -0500 (CDT)
Message-ID: <51AF3977.1030104@sgi.com>
Date: Wed, 05 Jun 2013 08:13:27 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfs: fix log recovery transaction item reordering
References: <1370398150-12084-1-git-send-email-david@fromorbit.com>
	<1370398150-12084-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1370398150-12084-2-git-send-email-david@fromorbit.com>
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

On 06/04/13 21:09, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> There are several constraints that inode allocation and unlink
> logging impose on log recovery. These all stem from the fact that
> inode alloc/unlink are logged in buffers, but all other inode
> changes are logged in inode items. Hence there are ordering
> constraints that recovery must follow to ensure the correct result
> occurs.
>
> As it turns out, this ordering has been working mostly by chance
> than good management. The existing code moves all buffers except
> cancelled buffers to the head of the list, and everything else to
> the tail of the list. The problem with this is that is interleaves
> inode items with the buffer cancellation items, and hence whether
> the inode item in an cancelled buffer gets replayed is essentially
> left to chance.
>
> Further, this ordering causes problems for log recovery when inode
> CRCs are enabled. It typically replays the inode unlink buffer long before
> it replays the inode core changes, and so the CRC recorded in an
> unlink buffer is going to be invalid and hence any attempt to
> validate the inode in the buffer is going to fail. Hence we really
> need to enforce the ordering that the inode alloc/unlink code has
> expected log recovery to have since inode chunk de-allocation was
> introduced back in 2003...
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
