Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3PIZuQv224012 for <xfs@oss.sgi.com>; Wed, 25 Apr 2012 13:35:56 -0500
Message-ID: <4F98440B.6060007@sgi.com>
Date: Wed, 25 Apr 2012 13:35:55 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 37/37] xfs: make XBF_MAPPED the default behaviour
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-38-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-38-git-send-email-david@fromorbit.com>
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
> Rather than specifying XBF_MAPPED for almost all buffers, introduce
> XBF_UNMAPPED for the couple of users that use unmapped buffers.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_buf.c         |   28 +++++++++++++---------------
>   fs/xfs/xfs_buf.h         |    4 ++--
>   fs/xfs/xfs_fsops.c       |   10 +++++-----
>   fs/xfs/xfs_inode.c       |    1 +
>   fs/xfs/xfs_log_recover.c |    4 ++--
>   fs/xfs/xfs_trans_buf.c   |    6 ------
>   fs/xfs/xfs_vnodeops.c    |    3 +--
>   7 files changed, 24 insertions(+), 32 deletions(-)
>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
