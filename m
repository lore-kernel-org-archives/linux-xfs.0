Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OIAYAq061524 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 12:10:34 -0600
Message-ID: <4F1EF419.6020806@sgi.com>
Date: Tue, 24 Jan 2012 12:10:33 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 09/12] xfs: share code for grant head waiting
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141435.111380168@bombadil.infradead.org>
In-Reply-To: <20111212141435.111380168@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 01/-10/63 13:59, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
> ---
>   fs/xfs/xfs_log.c   |   63 +++++++++++++++--------------------------------------
>   fs/xfs/xfs_trace.h |    2 -
>   2 files changed, 18 insertions(+), 47 deletions(-)
>
> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2011-12-11 21:28:57.128011556 +0100
> +++ xfs/fs/xfs/xfs_log.c	2011-12-11 21:31:10.580621915 +0100
> @@ -221,12 +221,13 @@ xlog_writeq_wake(
>   }
>
>   STATIC int
> -xlog_reserveq_wait(
> +xlog_grant_head_wait(

...

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
