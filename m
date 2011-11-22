Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM9jBgv133054 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 03:45:11 -0600
Received: from fgwmail5.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9779215822D1
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 01:45:10 -0800 (PST)
Received: from fgwmail5.fujitsu.co.jp (fgwmail5.fujitsu.co.jp [192.51.44.35])
	by cuda.sgi.com with ESMTP id 1rTBGOdC6aOylVQd for
	<xfs@oss.sgi.com>; Tue, 22 Nov 2011 01:45:10 -0800 (PST)
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 5A9F73EE0C0
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 18:45:08 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 43D1145DE59
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 18:45:08 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 2B68B45DE58
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 18:45:08 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 1D5881DB8042
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 18:45:08 +0900 (JST)
Received: from m107.s.css.fujitsu.com (m107.s.css.fujitsu.com [10.240.81.147])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id DE7FB1DB8046
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 18:45:07 +0900 (JST)
Message-ID: <4ECB6F16.5090002@jp.fujitsu.com>
Date: Tue, 22 Nov 2011 18:44:54 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] 198, 240: check presence of aiodio_sparce2
References: <4ECB3DCA.5000509@jp.fujitsu.com> <20111122093316.GB8098@dastard>
In-Reply-To: <20111122093316.GB8098@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

(2011/11/22 18:33), Dave Chinner wrote:
> Good idea, but given this check is now repeated in multiple places,
> wrapping it in a "_require_aiodio" helper function is probably in
> order.

Good point.
OK, I'll make a patch to implement the "_require_aiodio" helper.

Thanks,
H.Seto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
