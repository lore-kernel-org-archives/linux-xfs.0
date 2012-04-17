Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3HIg6ca096089 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 13:42:06 -0500
Message-ID: <4F8DB97B.30100@sgi.com>
Date: Tue, 17 Apr 2012 13:42:03 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC]xfs: using GFP_NOFS for blkdev_issue_flush
References: <4F8BC112.9090508@fusionio.com> <4F8BC30D.5040601@kernel.org>
In-Reply-To: <4F8BC30D.5040601@kernel.org>
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
To: Shaohua Li <shli@kernel.org>
Cc: xfs@oss.sgi.com

On 04/16/12 01:58, Shaohua Li wrote:

> flush request is issued in transaction commit code path usually, so
> looks using
> GFP_KERNEL to allocate memory for flush request bio falls into the classic
> deadlock issue (memory reclaim recursion). Use GFP_NOFS to avoid recursion
> from reclaim context. Per Dave Chinner, there is only blkdev_issue_flush
> might
> be buggy here. But using GFP_NOFS by default for all calls should not
> matter.
>
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---


Looks good.


Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
