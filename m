Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 560CB7F37
	for <xfs@oss.sgi.com>; Sat, 22 Jun 2013 12:26:45 -0500 (CDT)
Message-ID: <51C5DE52.7040108@sgi.com>
Date: Sat, 22 Jun 2013 12:26:42 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 07/60] xfs: Introduce ordered log vector support
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-8-git-send-email-david@fromorbit.com>
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

On 06/18/13 23:50, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> And "ordered log vector" is a log vector that is used for
> tracking a log item through the CIL and into the AIL as part of the
> log checkpointing. These ordered log vectors are special in that
> they are not written to to journal in any way, and are not accounted
> to the checkpoint being written.
>
> The reason for this behaviour is to allow operations to attach items
> to transactions and have them follow the normal transactional
> lifecycle without actually having to write them to the journal. This
> allows logging of items that track high level logical changes and
> writing them to the log, while the physical items being modified
> pass through into the AIL and pin the tail of the log (and therefore
> the logical item in the log) until all the modified items are
> physically written to disk.
>
> IOWs, it allows us to write metadata without physically logging
> every individual change but still maintain the full transactional
> integrity guarantees we currently have w.r.t. crash recovery.
>
> This change modifies some of the CIL item insertion loops, as
> ordered log vectors introduce some new constraints as they don't
> track any data. One advantage of this change is that it combines
> two log vector chain walks into a single pass, so there is less
> overhead in the transaction commit pass as well. It also kills some
> unused code in the log vector walk loop when committing the CIL.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_log.c     |   21 +++++++++++---
>   fs/xfs/xfs_log.h     |    2 ++
>   fs/xfs/xfs_log_cil.c |   75 ++++++++++++++++++++++++++++++++++----------------
>   3 files changed, 70 insertions(+), 28 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c

...

> @@ -2236,13 +2240,21 @@ xlog_write(
>   		 * This loop writes out as many regions as can fit in the amount
>   		 * of space which was allocated by xlog_state_get_iclog_space().
>   		 */
> -		while (lv&&  index<  lv->lv_niovecs) {
> -			struct xfs_log_iovec	*reg =&vecp[index];
> +		while (lv&&  (!lv->lv_niovecs || index<  lv->lv_niovecs)) {


Be paranoid and make sure the log vector with no vectors owner is really 
a "ordered" entry?

Reviewed-by: Mark Tinguely <tinguely@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
