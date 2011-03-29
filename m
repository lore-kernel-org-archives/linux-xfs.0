Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2T2pwEM200227 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 21:51:59 -0500
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id B2654385259
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 19:55:07 -0700 (PDT)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with SMTP id pSggvtIVgxUxokmh for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2011 19:55:07 -0700 (PDT)
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 1CE983EE0BC
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 11:55:05 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 0067945DE6B
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 11:55:05 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id DEA3A45DE6A
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 11:55:04 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id D33311DB8038
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 11:55:04 +0900 (JST)
Received: from m106.s.css.fujitsu.com (m106.s.css.fujitsu.com [10.240.81.146])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id A20291DB802C
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 11:55:04 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Very aggressive memory reclaim
In-Reply-To: <BANLkTimHPFMUOCFAruF5J4OMHSkZsMsAgA@mail.gmail.com>
References: <20110328215344.GC3008@dastard>
	<BANLkTimHPFMUOCFAruF5J4OMHSkZsMsAgA@mail.gmail.com>
Message-Id: <20110329115546.C08C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Date: Tue, 29 Mar 2011 11:55:03 +0900 (JST)
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
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, John Lepikhin <johnlepikhin@gmail.com>, kosaki.motohiro@jp.fujitsu.com

> Recently, We had a similar issue.
> http://www.spinics.net/lists/linux-mm/msg12243.html
> But it seems to not merge. I don't know why since I didn't follow up the thread.
> Maybe Cced guys can help you.
> 
> Is it a sudden big cache drop at the moment or accumulated small cache
> drop for long time?
> What's your zones' size?
> 
> Please attach the result of cat /proc/zoneinfo for others.

If my remember is correct, 2.6.38 is included Mel's anti agressive 
reclaim patch. And original report seems to be using 2.6.37.x. 

John, can you try 2.6.38?



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
