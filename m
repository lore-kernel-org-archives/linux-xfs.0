Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 000297F3F
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 06:45:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D09508F8052
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 04:45:54 -0700 (PDT)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id K6Wxye0T4U4qQGA5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 May 2014 04:45:51 -0700 (PDT)
Subject: Re: [PATCH] mm/vmscan: Do not block forever atshrink_inactive_list().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140520004449.GE18954@dastard>
	<20140519225915.3370328d.akpm@linux-foundation.org>
	<20140520063024.GH18954@dastard>
	<201405202358.ADF10119.SMOFOQLFtOVHJF@I-love.SAKURA.ne.jp>
	<6B2BA408B38BA1478B473C31C3D2074E31D59D8673@SV-EXCHANGE1.Corp.FC.LOCAL>
In-Reply-To: <6B2BA408B38BA1478B473C31C3D2074E31D59D8673@SV-EXCHANGE1.Corp.FC.LOCAL>
Message-Id: <201405262045.CDG95893.HLFFOSFMQOVOJt@I-love.SAKURA.ne.jp>
Date: Mon, 26 May 2014 20:45:11 +0900
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
To: Motohiro.Kosaki@us.fujitsu.com, david@fromorbit.com, riel@redhat.com
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com

Tetsuo Handa wrote:
> Dave, if you are OK with this updated patch, please let me know commit ID of your patch.

I overlooked that too_many_isolated() in mm/vmscan.c already has

  if (current_is_kswapd())
    return 0;

lines. Therefore, it turned out that my patch is irrelevant to XFS issue.
Does patch shown below make sense?

Regards.
----------
>From e133aadd65df3d8622efced3443888ed3e60327b Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 26 May 2014 20:37:12 +0900
Subject: [PATCH] mm/vmscan: Do not throttle when hibernation_mode != 0.

In shrink_inactive_list(), we do not insert delay at

  if (!sc->hibernation_mode && !current_is_kswapd())
    wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);

if sc->hibernation_mode != 0.
Follow the same reason, we should not insert delay at

  while (unlikely(too_many_isolated(zone, file, sc))) {
    congestion_wait(BLK_RW_ASYNC, HZ/10);

    /* We are about to die and free our memory. Return now. */
    if (fatal_signal_pending(current))
      return SWAP_CLUSTER_MAX;
  }

if sc->hibernation_mode != 0.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 mm/vmscan.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 32c661d..89c42ca 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1362,6 +1362,9 @@ static int too_many_isolated(struct zone *zone, int file,
 	if (current_is_kswapd())
 		return 0;
 
+	if (sc->hibernation_mode)
+		return 0;
+
 	if (!global_reclaim(sc))
 		return 0;
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
