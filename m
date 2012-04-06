Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q36HgV4N028162 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 12:42:31 -0500
Message-ID: <4F7F2B04.7020509@sgi.com>
Date: Fri, 06 Apr 2012 12:42:28 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] shutdown hang fix (was Re: [PATCH 2/2] xfs: avoid
	shutdown hang in xlog_wait())
References: <1332467263-12985-1-git-send-email-david@fromorbit.com>
	<1332467263-12985-3-git-send-email-david@fromorbit.com>
	<20120324170302.GB21708@infradead.org>
	<20120324224648.GF5091@dastard>
	<20120325112801.GA7157@infradead.org>
	<20120327094547.GZ5091@dastard>
In-Reply-To: <20120327094547.GZ5091@dastard>
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

On 03/27/12 04:45, Dave Chinner wrote:
>
> xfs: pass shutdown method into xfs_trans_ail_delete_bulk
>
> From: Dave Chinner<dchinner@redhat.com>
>
> xfs_trans_ail_delete_bulk() can be called from different contexts so
> if the item is not in the AIL we need different shutdown for each
> context.  Pass in the shutdown method needed so the correct action
> can be taken.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
