Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 95AC17F5E
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 00:59:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7A02630407A
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 22:59:43 -0700 (PDT)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
	[140.211.169.12]) by cuda.sgi.com with ESMTP id
	u3XWPbPzSXtuT7eN for <xfs@oss.sgi.com>;
	Mon, 19 May 2014 22:59:37 -0700 (PDT)
Date: Mon, 19 May 2014 22:59:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
Message-Id: <20140519225915.3370328d.akpm@linux-foundation.org>
In-Reply-To: <20140520004449.GE18954@dastard>
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
	<20140520004449.GE18954@dastard>
Mime-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: riel@redhat.com, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com

On Tue, 20 May 2014 10:44:49 +1000 Dave Chinner <david@fromorbit.com> wrote:

> @@ -258,14 +258,23 @@ xfs_bmapi_allocate_worker(
>  	struct xfs_bmalloca	*args = container_of(work,
>  						struct xfs_bmalloca, work);
>  	unsigned long		pflags;
> +	unsigned long		new_pflags = PF_FSTRANS;
>  
> -	/* we are in a transaction context here */
> -	current_set_flags_nested(&pflags, PF_FSTRANS);
> +	/*
> +	 * we are in a transaction context here, but may also be doing work
> +	 * in kswapd context, and hence we may need to inherit that state
> +	 * temporarily to ensure that we don't block waiting for memory reclaim
> +	 * in any way.
> +	 */
> +	if (args->kswapd)
> +		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;

So current_is_kswapd() returns true for a thread which is not kswapd. 
That's a bit smelly.

Should this thread really be incrementing KSWAPD_INODESTEAL instead of
PGINODESTEAL, for example?  current_is_kswapd() does a range of things,
only one(?) of which you actually want.

It would be cleaner to create a new PF_ flag to select just that
behavior.  That's a better model than telling the world "I am magic and
special".

But we're awfully close to running out of PF_ space and I don't know if
this ugly justifies consuming a flag.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
