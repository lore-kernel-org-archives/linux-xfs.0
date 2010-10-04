Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9491Ae2054614 for <xfs@oss.sgi.com>; Mon, 4 Oct 2010 04:01:10 -0500
Message-ID: <4CA997DF.5030008@kernel.org>
Date: Mon, 04 Oct 2010 11:01:19 +0200
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Subject: Re: -mm: xfs lockdep warning
References: <201009161546.16909.ruirui.r.yang@tieto.com>	<20100917005227.GJ24409@dastard>	<20100920191355.GA28443@infradead.org>
	<AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>
In-Reply-To: <AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>
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
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Yang Ruirui <ruirui.r.yang@tieto.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>, Andrew Morton <akpm@linux-foundation.org>

Hello,

On 09/25/2010 03:08 PM, Torsten Kaiser wrote:
> [adding Tejun Heo, because I'm partly blaming his workqueues]

:-) Sorry about the delay.  I was away the last week.

> After that I enabled lockdep and retried the same update: This time no
> hang, only the same lockdep report that Yang Ruirui had.
> 
> So I'm currently at a loss how I should continue from here. The XFS
> false positive drowns any other lockdep problems, but XFS had some
> hang problems with the new workqueues. (Personally I had no other hang
> with earlier 2.6.36-rcs)

If workqueue lockdep annotations are triggering spuriously, just nuke
all lockdep annotations in workqueue.c.  Currently the annotations are
the same as before and trigger even when an actual deadlock won't
happen anymore around flushes (but then again all the current users
should be operating under the same constraints as before).  I'm
looking into how to improve the lockdep annotations but in the end it
might be best to leave it as it is.  I'll try to analyze the warnings.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
