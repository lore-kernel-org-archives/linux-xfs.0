Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1LFI6kf189445 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 09:18:07 -0600
Message-ID: <4F43B5AC.9080500@sgi.com>
Date: Tue, 21 Feb 2012 09:18:04 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 12/12] xfs: split and cleanup xfs_log_reserve
References: <20120220023119.435889631@bombadil.infradead.org>
	<20120220023154.252855704@bombadil.infradead.org>
In-Reply-To: <20120220023154.252855704@bombadil.infradead.org>
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

On 02/19/12 20:31, Christoph Hellwig wrote:
> Split the log regrant case out of xfs_log_reserve into a separate function,
> and merge xlog_grant_log_space and xlog_regrant_write_log_space into their
> respective callers.  Also replace the XFS_LOG_PERM_RESERV flag, which easily
> got misused before the previous cleanups with a simple boolean parameter.
>
> Reviewed-by: Ben Myers<bpm@sgi.com>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
> ---
>   fs/xfs/xfs_log.c   |  198 ++++++++++++++++++++++++-----------------------------
>   fs/xfs/xfs_log.h   |    1
>   fs/xfs/xfs_trace.h |    1
>   fs/xfs/xfs_trans.c |   17 +++-
>   4 files changed, 103 insertions(+), 114 deletions(-)

Sorry for the omission. The clean up looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
