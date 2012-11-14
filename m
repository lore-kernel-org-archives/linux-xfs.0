Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAEML1rL179223 for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 16:21:01 -0600
Message-ID: <50A419C7.7060403@sgi.com>
Date: Wed, 14 Nov 2012 16:23:03 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 28/32 V2] xfs: add pre-write metadata buffer verifier
	callbacks
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-29-git-send-email-david@fromorbit.com>
	<20121114065231.GF1710@dastard>
In-Reply-To: <20121114065231.GF1710@dastard>
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

On 11/14/12 00:52, Dave Chinner wrote:
> xfs: add pre-write metadata buffer verifier callbacks
>
> From: Dave Chinner<dchinner@redhat.com>
>
> These verifiers are essentially the same code as the read verifiers,
> but do not require ioend processing. Hence factor the read verifier
> functions and add a new write verifier wrapper that is used as the
> callback.
>
> This is done as one large patch for all verifiers rather than one
> patch per verifier as the change is largely mechanical. This
> includes hooking up the write verifier via the read verifier
> function.
>
> Hooking up the write verifier for buffers obtained via
> xfs_trans_get_buf() will be done in a separate patch as that touches
> code in many different places rather than just the verifier
> functions.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
> V2: fold in quotacheck dquot verifier changes.
>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
