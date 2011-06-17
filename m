Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5H3a68c089656 for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 22:36:07 -0500
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8D2EC9C5
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 20:36:03 -0700 (PDT)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id tTZPIJHJIYlqb4qH for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2011 20:36:03 -0700 (PDT)
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 5962A3EE0BD
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 12:36:01 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 3F06445DF3B
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 12:36:01 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 17DD845DF45
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 12:36:01 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 0A5D71DB803E
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 12:36:01 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.240.81.145])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id CC9BE1DB8037
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 12:36:00 +0900 (JST)
Message-ID: <4DFACB8A.2020008@jp.fujitsu.com>
Date: Fri, 17 Jun 2011 12:35:38 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/12] Per superblock cache reclaim
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
	<20110616113321.GA22422@infradead.org>
In-Reply-To: <20110616113321.GA22422@infradead.org>
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
To: hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

(2011/06/16 20:33), Christoph Hellwig wrote:
> Can we get some comments from the MM folks for patches 1-3?  Those look
> like some pretty urgent fixes for really dumb shrinker behaviour.

Yeah, I'm reviewing today. I'm sorry delayed it. So, generically they are
pretty good to me. thanks Dave. So, I have a few minor comments and I'll post
it when my review is finished. (Maybe some hour later).


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
