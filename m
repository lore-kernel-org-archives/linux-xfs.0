Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3HHskYc093454 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 12:54:46 -0500
Message-ID: <4F8DAE64.9060605@sgi.com>
Date: Tue, 17 Apr 2012 12:54:44 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/18] xfs: Do background CIL flushes via a workqueue
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-4-git-send-email-david@fromorbit.com>
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

On 04/13/12 07:10, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Doing background CIL flushes adds significant latency to whatever
> async transaction that triggers it. To avoid blocking async
> transactions on things like waiting for log buffer IO to complete,
> move the CIL push off into a workqueue.  By moving the push work
> into a workqueue, we remove all the latency that the commit adds
> from the foreground transaction commit path. This also means that
> single threaded workloads won't do the CIL push procssing, leaving
> them more CPU to do more async transactions.
>
> To do this, we need to keep track of the sequence number we have
> pushed work for. This avoids having many transaction commits
> attempting to schedule work for the same sequence, and ensures that
> we only ever have one push (background or forced) in progress at a
> time. It also means that we don't need to take the CIL lock in write
> mode to check for potential background push races, which reduces
> lock contention.
>
> To avoid potential issues with "smart" IO schedulers, don't use the
> workqueue for log force triggered flushes. Instead, do them directly
> so that the log IO is done directly by the process issuing the log
> force and so doesn't get stuck on IO elevator queue idling
> incorrectly delaying the log IO from the workqueue.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Makes sense.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
