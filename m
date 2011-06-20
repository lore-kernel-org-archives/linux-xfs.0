Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5K4Ud4M114161 for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 23:30:41 -0500
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CA18166C0F1
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 21:30:38 -0700 (PDT)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id BOjGaryYEwuk8bfV for
	<xfs@oss.sgi.com>; Sun, 19 Jun 2011 21:30:38 -0700 (PDT)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id BEB0C3EE0C0
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 13:30:36 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 6FCD845DE8D
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 13:30:36 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 593A045DE67
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 13:30:36 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 4D6371DB8037
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 13:30:36 +0900 (JST)
Received: from m106.s.css.fujitsu.com (m106.s.css.fujitsu.com [10.240.81.146])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id D62161DB8038
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 13:30:35 +0900 (JST)
Message-ID: <4DFECCE5.5030409@jp.fujitsu.com>
Date: Mon, 20 Jun 2011 13:30:29 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/12] vmscan: shrinker->nr updates race and go wrong
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
	<1306998067-27659-3-git-send-email-david@fromorbit.com>
	<4DFE987E.1070900@jp.fujitsu.com> <20110620012531.GN561@dastard>
In-Reply-To: <20110620012531.GN561@dastard>
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
To: david@fromorbit.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

>> Looks great fix. Please remove tracepoint change from this patch and send it
>> to -stable. iow, I expect I'll ack your next spin.
> 
> I don't believe such a change belongs in -stable. This code has been
> buggy for many years and as I mentioned it actually makes existing
> bad shrinker behaviour worse. I don't test stable kernels, so I've
> got no idea what side effects it will have outside of this series.
> I'm extremely hesitant to change VM behaviour in stable kernels
> without having tested first, so I'm not going to push it for stable
> kernels.

Ok, I have no strong opinion.



> 
> If you want it in stable kernels, then you can always let
> stable@kernel.org know once the commits are in the mainline tree and
> you've tested them...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
