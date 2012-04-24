Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3OIBLmO094944 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 13:11:26 -0500
Message-ID: <4F96ECC6.7070605@sgi.com>
Date: Tue, 24 Apr 2012 13:11:18 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 30/37] xfs: clean up busy extent naming
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-31-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-31-git-send-email-david@fromorbit.com>
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
> Now that the busy extent tracking has been moved out of the
> allocation files, clean up the namespace it uses to
> "xfs_extent_busy" rather than a mix of "xfs_busy" and
> "xfs_alloc_busy".
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Other than the STATIC on xfs_extend_busy_trim() leaving an undefined
routine in the xfs.ko, it looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
