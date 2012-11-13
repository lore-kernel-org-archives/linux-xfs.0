Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADLGeHO152109 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 15:16:40 -0600
Message-ID: <50A2B92F.80303@sgi.com>
Date: Tue, 13 Nov 2012 15:18:39 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/32] xfs: use btree block initialisation functions in
	growfs
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1352721264-3700-7-git-send-email-david@fromorbit.com>
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

On 11/12/2012 05:53 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Factor xfs_btree_init_block() to be independent of the btree cursor,
> and use the function to initialise btree blocks in the growfs code.
> This makes adding support for different format btree blocks simple.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>   fs/xfs/xfs_btree.c |   33 ++++++++++++++++++++++++---------
>   fs/xfs/xfs_btree.h |   11 +++++++++++
>   fs/xfs/xfs_fsops.c |   37 +++++++++++++------------------------
>   3 files changed, 48 insertions(+), 33 deletions(-)
>

Looks good.

Reviewed-by Rich Johnston <rjohnston@sgi.com>

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
