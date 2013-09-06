Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5872B7F50
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 13:54:59 -0500 (CDT)
Message-ID: <522A2502.8090606@sgi.com>
Date: Fri, 06 Sep 2013 13:54:58 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 52/55] xfs: btree block LSN escaping to disk uninitialised
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-53-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-53-git-send-email-david@fromorbit.com>
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

On 09/04/13 17:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> When testing LSN ordering code for v5 superblocks, it was discovered
> that the the LSN embedded in the generic btree blocks was
> occasionally uninitialised. These values didn't get written to disk
> by metadata writeback - they got written by previous transactions in
> log recovery.
>
> The issue is here that the when the block is first allocated and
> initialised, the LSN field was not initialised - it gets overwritten
> before IO is issued on the buffer - but the value that is logged by
> transactions that modify the header before it is written to disk
> (and initialised) contain garbage. Hence the first recovery of the
> buffer will stamp garbage into the LSN field, and that can cause
> subsequent transactions to not replay correctly.
>
> The fix is simply to initialise the bb_lsn field to zero when we
> initialise the block for the first time.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good, same as kernel commit b58fa554.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
