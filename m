Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 602F27F53
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 22:56:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2AACAC009
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 20:56:00 -0700 (PDT)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id JFeqXRF3QJbsiEUR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 May 2014 20:55:58 -0700 (PDT)
Message-Id: <201405200354.s4K3sTUx057458@www262.sakura.ne.jp>
Subject: Re: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Date: Tue, 20 May 2014 12:54:29 +0900
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
	<20140520004449.GE18954@dastard>
In-Reply-To: <20140520004449.GE18954@dastard>
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
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com

Dave Chinner wrote:
> So, XFS should be passing kswapd context to the workqueue allocation
> context. The patch below does this.
> 
> Tetsuo-san, when it comes to problems involving XFS, you should
> really CC xfs@oss.sgi.com because very few people really know how
> XFS works and even fewer still know how it is supposed to interact
> with memory reclaim....

Thank you for the patch, but ...

  #define PF_KSWAPD       0x00040000      /* I am kswapd */

  static inline int current_is_kswapd(void)
  {
  	return current->flags & PF_KSWAPD;
  }

I think ((char) (current->flags & 0x00040000)) == 0.
Your patch wants

  -args->kswapd = current_is_kswapd();
  +args->kswapd = (current_is_kswapd() != 0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
