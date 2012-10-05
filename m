Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95DQUfd048722 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 08:26:30 -0500
Message-ID: <506EE04F.9010508@sgi.com>
Date: Fri, 05 Oct 2012 08:27:43 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: introduce XFS_BMAPI_STACK_SWITCH
References: <1349399219-13024-1-git-send-email-david@fromorbit.com>
	<1349399219-13024-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1349399219-13024-2-git-send-email-david@fromorbit.com>
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

On 10/04/12 20:06, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Certain allocation paths through xfs_bmapi_write() are in situations
> where we have limited stack available. These are almost always in
> the buffered IO writeback path when convertion delayed allocation
> extents to real extents.
>
> The current stack switch occurs for userdata allocations, which
> means we also do stack switches for preallocation, direct IO and
> unwritten extent conversion, even those these call chains have never
> been implicated in a stack overrun.
>
> Hence, let's target just the single stack overun offended for stack
> switches. To do that, introduce a XFS_BMAPI_STACK_SWITCH flag that
> the caller can pass xfs_bmapi_write() to indicate it should switch
> stacks if it needs to do allocation.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
