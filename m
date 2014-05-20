Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1AD917F54
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 00:25:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EBBA98F8049
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 22:25:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GPLD3mZf1dg6AiPE for <xfs@oss.sgi.com>;
	Mon, 19 May 2014 22:25:07 -0700 (PDT)
Date: Tue, 20 May 2014 15:24:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
Message-ID: <20140520052452.GG18954@dastard>
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
	<20140520004449.GE18954@dastard>
	<201405200354.s4K3sTUx057458@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201405200354.s4K3sTUx057458@www262.sakura.ne.jp>
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
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com

On Tue, May 20, 2014 at 12:54:29PM +0900, Tetsuo Handa wrote:
> Dave Chinner wrote:
> > So, XFS should be passing kswapd context to the workqueue allocation
> > context. The patch below does this.
> > 
> > Tetsuo-san, when it comes to problems involving XFS, you should
> > really CC xfs@oss.sgi.com because very few people really know how
> > XFS works and even fewer still know how it is supposed to interact
> > with memory reclaim....
> 
> Thank you for the patch, but ...
> 
>   #define PF_KSWAPD       0x00040000      /* I am kswapd */
> 
>   static inline int current_is_kswapd(void)
>   {
>   	return current->flags & PF_KSWAPD;
>   }

> I think ((char) (current->flags & 0x00040000)) == 0.
> Your patch wants
> 
>   -args->kswapd = current_is_kswapd();
>   +args->kswapd = (current_is_kswapd() != 0);

Thanks for pointing that out, but I think:

-static inline int current_is_kswapd(void)
+static inline bool current_is_kswapd(void)

is a better solution. It can only be true or false.

But regardless, I need to change the boolean options in that XFS
structure to be, well, booleans.

Cheers,

dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
