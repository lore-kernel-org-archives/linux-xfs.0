Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5L5Rp7j230650 for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 00:27:51 -0500
Received: from fgwmail5.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D49E21EBA2
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 22:27:50 -0700 (PDT)
Received: from fgwmail5.fujitsu.co.jp (fgwmail5.fujitsu.co.jp [192.51.44.35])
	by cuda.sgi.com with ESMTP id q0GdA8qO2raTM9Ni for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2011 22:27:50 -0700 (PDT)
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id F34CB3EE0C1
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 14:27:47 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id D5DBD45DE72
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 14:27:47 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id B638B45DE69
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 14:27:47 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id AA4311DB802C
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 14:27:47 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.240.81.133])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 73336E08003
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 14:27:47 +0900 (JST)
Message-ID: <4E002BD0.3000003@jp.fujitsu.com>
Date: Tue, 21 Jun 2011 14:27:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/12] vmscan: reduce wind up shrinker->nr when shrinker
	can't do work
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
	<1306998067-27659-4-git-send-email-david@fromorbit.com>
	<4DFE997C.2060805@jp.fujitsu.com> <20110621050914.GO32466@dastard>
In-Reply-To: <20110621050914.GO32466@dastard>
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

>> I mean, currently some mm folks plan to enhance shrinker. So,
>> sharing benchmark may help to avoid an accidental regression.
> 
> I predict that I will have some bug reporting to do in future. ;)

Ok, I have no objection. thanks.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
