Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBM2K6pT145530 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 20:20:06 -0600
Subject: Re: [PATCH 03/34] lib: percpu counter add unless less than
	functionality
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1292916570-25015-4-git-send-email-david@fromorbit.com>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
	<1292916570-25015-4-git-send-email-david@fromorbit.com>
Date: Tue, 21 Dec 2010 20:20:14 -0600
Message-ID: <1292984414.2408.357.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2010-12-21 at 18:28 +1100, Dave Chinner wrote: 
> From: Dave Chinner <dchinner@redhat.com>
> 
> To use the generic percpu counter infrastructure for counters that
> require conditional addition based on a threshold value we need
> special handling of the counter. Further, the caller needs to know
> the status of the conditional addition to determine what action to
> take depending on whether the addition occurred or not.  Examples of
> this sort of usage are resource counters that cannot go below zero
> (e.g. filesystem free blocks).
> 
> To allow XFS to replace it's complex roll-your-own per-cpu
> superblock counters, a single generic conditional function is
> required: percpu_counter_add_unless_lt(). This will add the amount
> to the counter unless the result would be less than the given
> threshold. A caller supplied threshold is required because XFS does
> not necessarily use the same threshold for every counter.
> 
> percpu_counter_add_unless_lt() attempts to minimise counter lock
> traversals by only taking the counter lock when the threshold is
> within the error range of the current counter value. Hence when the
> threshold is not within the counter error range, the counter will
> still have the same scalability characteristics as the normal
> percpu_counter_add() function.
> 
> Adding this functionality to the generic percpu counters allows us
> to remove the much more complex and less efficient XFS percpu
> counter code (~700 lines of code) and replace it with generic
> percpu counters.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I want to look at this one more closely again in the
morning, but for now I'll just mention one nit, and
one easily fixed problem.

					-Alex

. . .

> + * Add @amount to @fdc if and only if result of addition is greater than or
                     ^^^  should be fbc

> +EXPORT_SYMBOL(percpu_counter_add_unless_lt);
> +

This has to be:
    EXPORT_SYMBOL(__percpu_counter_add_unless_lt);
(with leading underscores).



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
