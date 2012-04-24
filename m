Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3OJi6kb105564 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 14:44:06 -0500
Message-ID: <4F970286.9090400@sgi.com>
Date: Tue, 24 Apr 2012 14:44:06 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 34/37] xfs: clean up xfs_bit.h includes
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-35-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-35-git-send-email-david@fromorbit.com>
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

On 04/23/12 00:59, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> With the removal of xfs_rw.h and other changes over time, xfs_bit.h
> is being included in many files that don't actually need it. Clean
> up the includes as necessary.
>
> Also move the only-used-once xfs_ialloc_find_free() static inline
> function out of a header file that is widely included to reduce
> the number of needless dependencies on xfs_bit.h.
>
> Reviewed-by: Dave Chinner<dchinner@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
